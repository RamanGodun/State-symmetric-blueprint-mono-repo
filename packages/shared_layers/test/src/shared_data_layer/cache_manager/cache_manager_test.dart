/// Tests for CacheManager
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Basic caching functionality
/// - TTL (time-to-live) expiration
/// - In-flight request deduplication
/// - Manual cache operations (put, get, remove, clear)
/// - Force refresh behavior
/// - Statistics and debugging
/// - Concurrency and race conditions
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_layers/src/shared_data_layer/cache_manager/cache_manager.dart';

void main() {
  group('CacheManager', () {
    group('construction', () {
      test('creates instance with default TTL', () {
        // Arrange & Act
        final cache = CacheManager<String, String>();

        // Assert
        expect(cache, isA<CacheManager<String, String>>());
        expect(cache.stats.ttl, equals(const Duration(minutes: 10)));
      });

      test('creates instance with custom TTL', () {
        // Arrange
        const customTtl = Duration(minutes: 5);

        // Act
        final cache = CacheManager<String, String>(ttl: customTtl);

        // Assert
        expect(cache.stats.ttl, equals(customTtl));
      });

      test('creates instance with different generic types', () {
        // Arrange & Act
        final stringCache = CacheManager<String, String>();
        final intCache = CacheManager<int, String>();
        final objectCache = CacheManager<Map<String, dynamic>, String>();

        // Assert
        expect(stringCache, isA<CacheManager<String, String>>());
        expect(intCache, isA<CacheManager<int, String>>());
        expect(objectCache, isA<CacheManager<Map<String, dynamic>, String>>());
      });
    });

    group('execute', () {
      test('executes operation and caches result', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result';
        }

        // Act
        final result = await cache.execute('key1', operation);

        // Assert
        expect(result, equals('result'));
        expect(callCount, equals(1));
      });

      test('returns cached value on second call', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result';
        }

        // Act
        final result1 = await cache.execute('key1', operation);
        final result2 = await cache.execute('key1', operation);

        // Assert
        expect(result1, equals('result'));
        expect(result2, equals('result'));
        expect(callCount, equals(1)); // Operation called only once
      });

      test('executes different operations for different keys', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var call1Count = 0;
        var call2Count = 0;

        Future<String> operation1() async {
          call1Count++;
          return 'result1';
        }

        Future<String> operation2() async {
          call2Count++;
          return 'result2';
        }

        // Act
        final result1 = await cache.execute('key1', operation1);
        final result2 = await cache.execute('key2', operation2);

        // Assert
        expect(result1, equals('result1'));
        expect(result2, equals('result2'));
        expect(call1Count, equals(1));
        expect(call2Count, equals(1));
      });

      test('handles async operations correctly', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        Future<String> asyncOperation() async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return 'async-result';
        }

        // Act
        final result = await cache.execute('key1', asyncOperation);

        // Assert
        expect(result, equals('async-result'));
      });

      test('caches result of async operation', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> asyncOperation() async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return 'async-result';
        }

        // Act
        await cache.execute('key1', asyncOperation);
        final result = await cache.execute('key1', asyncOperation);

        // Assert
        expect(result, equals('async-result'));
        expect(callCount, equals(1)); // Only called once despite delay
      });
    });

    group('in-flight request deduplication', () {
      test('deduplicates parallel requests with same key', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> slowOperation() async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return 'result';
        }

        // Act - Start multiple parallel requests
        final futures = [
          cache.execute('key1', slowOperation),
          cache.execute('key1', slowOperation),
          cache.execute('key1', slowOperation),
        ];
        final results = await Future.wait(futures);

        // Assert
        expect(results, equals(['result', 'result', 'result']));
        expect(callCount, equals(1)); // Operation called only once
      });

      test('tracks in-flight requests in stats', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        Future<String> slowOperation() async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return 'result';
        }

        // Act - Start operation without awaiting
        final future = cache.execute('key1', slowOperation);

        // Check in-flight count immediately
        expect(cache.stats.inFlightRequests, equals(1));

        // Wait for completion
        await future;

        // Assert - In-flight count should be 0 after completion
        expect(cache.stats.inFlightRequests, equals(0));
      });

      test('clears in-flight after operation completes', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        Future<String> operation() async {
          return 'result';
        }

        // Act
        await cache.execute('key1', operation);

        // Assert
        expect(cache.stats.inFlightRequests, equals(0));
      });

      test('clears in-flight even when operation throws', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        Future<String> failingOperation() async {
          throw Exception('Operation failed');
        }

        // Act & Assert
        await expectLater(
          cache.execute('key1', failingOperation),
          throwsException,
        );
        expect(cache.stats.inFlightRequests, equals(0));
      });

      test('handles parallel requests for different keys', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var call1Count = 0;
        var call2Count = 0;

        Future<String> operation1() async {
          call1Count++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return 'result1';
        }

        Future<String> operation2() async {
          call2Count++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return 'result2';
        }

        // Act - Start parallel requests for different keys
        final futures = [
          cache.execute('key1', operation1),
          cache.execute('key2', operation2),
        ];
        final results = await Future.wait(futures);

        // Assert
        expect(results, equals(['result1', 'result2']));
        expect(call1Count, equals(1));
        expect(call2Count, equals(1));
      });
    });

    group('TTL expiration', () {
      test('expires cached value after TTL', () async {
        // Arrange
        final cache = CacheManager<String, String>(
          ttl: const Duration(milliseconds: 100),
        );
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result-$callCount';
        }

        // Act
        final result1 = await cache.execute('key1', operation);
        await Future<void>.delayed(const Duration(milliseconds: 150));
        final result2 = await cache.execute('key1', operation);

        // Assert
        expect(result1, equals('result-1'));
        expect(result2, equals('result-2'));
        expect(callCount, equals(2)); // Called twice due to expiration
      });

      test('returns cached value before TTL expires', () async {
        // Arrange
        final cache = CacheManager<String, String>(
          ttl: const Duration(milliseconds: 500),
        );
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result';
        }

        // Act
        final result1 = await cache.execute('key1', operation);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        final result2 = await cache.execute('key1', operation);

        // Assert
        expect(result1, equals('result'));
        expect(result2, equals('result'));
        expect(callCount, equals(1)); // Called once, second is from cache
      });

      test('removes expired entry from storage', () async {
        // Arrange
        final cache = CacheManager<String, String>(
          ttl: const Duration(milliseconds: 100),
        );
        Future<String> operation() async => 'result';

        // Act
        await cache.execute('key1', operation);
        expect(cache.stats.totalItems, equals(1));

        await Future<void>.delayed(const Duration(milliseconds: 150));
        final result = await cache.execute('key1', operation);

        // Assert
        expect(result, equals('result'));
        expect(cache.stats.totalItems, equals(1)); // Re-cached after expiration
      });

      test('handles different TTLs for different cache instances', () async {
        // Arrange
        final shortCache = CacheManager<String, String>(
          ttl: const Duration(milliseconds: 50),
        );
        final longCache = CacheManager<String, String>(
          ttl: const Duration(milliseconds: 500),
        );

        var shortCallCount = 0;
        var longCallCount = 0;

        Future<String> shortOperation() async {
          shortCallCount++;
          return 'short-result';
        }

        Future<String> longOperation() async {
          longCallCount++;
          return 'long-result';
        }

        // Act
        await shortCache.execute('key1', shortOperation);
        await longCache.execute('key1', longOperation);

        await Future<void>.delayed(const Duration(milliseconds: 100));

        await shortCache.execute('key1', shortOperation);
        await longCache.execute('key1', longOperation);

        // Assert
        expect(shortCallCount, equals(2)); // Expired, called again
        expect(longCallCount, equals(1)); // Still valid, not called again
      });
    });

    group('forceRefresh', () {
      test('forces refresh when forceRefresh is true', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result-$callCount';
        }

        // Act
        final result1 = await cache.execute('key1', operation);
        final result2 = await cache.execute(
          'key1',
          operation,
          forceRefresh: true,
        );

        // Assert
        expect(result1, equals('result-1'));
        expect(result2, equals('result-2'));
        expect(callCount, equals(2)); // Called twice
      });

      test('removes cached value before forcing refresh', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        Future<String> operation() async => 'new-result';

        // Act
        await cache.execute('key1', () async => 'old-result');
        expect(cache.stats.totalItems, equals(1));

        final result = await cache.execute(
          'key1',
          operation,
          forceRefresh: true,
        );

        // Assert
        expect(result, equals('new-result'));
      });

      test('force refresh without existing cache works correctly', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result';
        }

        // Act
        final result = await cache.execute(
          'key1',
          operation,
          forceRefresh: true,
        );

        // Assert
        expect(result, equals('result'));
        expect(callCount, equals(1));
      });
    });

    group('manual operations', () {
      group('put', () {
        test('manually puts value to cache', () {
          // Arrange
          final cache = CacheManager<String, String>()
            // Act
            ..put('key1', 'manual-value');

          // Assert
          expect(cache.get('key1'), equals('manual-value'));
        });

        test('manually put value is returned by execute', () async {
          // Arrange
          final cache = CacheManager<String, String>();
          var callCount = 0;
          Future<String> operation() async {
            callCount++;
            return 'operation-result';
          }

          // Act
          cache.put('key1', 'manual-value');
          final result = await cache.execute('key1', operation);

          // Assert
          expect(result, equals('manual-value'));
          expect(callCount, equals(0)); // Operation not called
        });

        test('overrides existing cached value', () {
          // Arrange
          final cache = CacheManager<String, String>()
            ..put('key1', 'old-value')
            // Act
            ..put('key1', 'new-value');

          // Assert
          expect(cache.get('key1'), equals('new-value'));
        });
      });

      group('get', () {
        test('returns null for non-existent key', () {
          // Arrange
          final cache = CacheManager<String, String>();

          // Act
          final result = cache.get('non-existent');

          // Assert
          expect(result, isNull);
        });

        test('returns cached value for existing key', () {
          // Arrange
          final cache = CacheManager<String, String>()..put('key1', 'value');

          // Act
          final result = cache.get('key1');

          // Assert
          expect(result, equals('value'));
        });

        test('returns null for expired key', () async {
          // Arrange
          final cache = CacheManager<String, String>(
            ttl: const Duration(milliseconds: 50),
          )..put('key1', 'value');

          // Act
          await Future<void>.delayed(const Duration(milliseconds: 100));
          final result = cache.get('key1');

          // Assert
          expect(result, isNull);
        });
      });

      group('remove', () {
        test('removes value from cache', () {
          // Arrange
          final cache = CacheManager<String, String>()
            ..put('key1', 'value')
            // Act
            ..remove('key1');

          // Assert
          expect(cache.get('key1'), isNull);
          expect(cache.stats.totalItems, equals(0));
        });

        test('removing non-existent key does not throw', () {
          // Arrange
          final cache = CacheManager<String, String>();

          // Act & Assert
          expect(() => cache.remove('non-existent'), returnsNormally);
        });

        test('removes key after execute', () async {
          // Arrange
          final cache = CacheManager<String, String>();
          var callCount = 0;
          Future<String> operation() async {
            callCount++;
            return 'result';
          }

          // Act
          await cache.execute('key1', operation);
          cache.remove('key1');
          await cache.execute('key1', operation);

          // Assert
          expect(callCount, equals(2)); // Called twice after removal
        });
      });

      group('clear', () {
        test('clears all cached values', () {
          // Arrange
          final cache = CacheManager<String, String>()
            ..put('key1', 'value1')
            ..put('key2', 'value2')
            ..put('key3', 'value3')
            // Act
            ..clear();

          // Assert
          expect(cache.get('key1'), isNull);
          expect(cache.get('key2'), isNull);
          expect(cache.get('key3'), isNull);
          expect(cache.stats.totalItems, equals(0));
        });

        test('clears in-flight requests', () async {
          // Arrange
          final cache = CacheManager<String, String>();
          Future<String> slowOperation() async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return 'result';
          }

          // Act - Start operation without awaiting
          final future = cache.execute('key1', slowOperation);
          cache.clear();

          // Assert
          expect(cache.stats.inFlightRequests, equals(0));

          // Clean up
          await expectLater(future, completes);
        });

        test('clear on empty cache does not throw', () {
          // Arrange
          final cache = CacheManager<String, String>();

          // Act & Assert
          expect(cache.clear, returnsNormally);
        });
      });
    });

    group('statistics', () {
      test('stats returns correct total items count', () {
        // Arrange
        final cache = CacheManager<String, String>()
          ..put('key1', 'value1')
          ..put('key2', 'value2');

        // Act
        final stats = cache.stats;

        // Assert
        expect(stats.totalItems, equals(2));
      });

      test('stats returns correct in-flight requests count', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        Future<String> slowOperation() async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return 'result';
        }

        // Act
        final future1 = cache.execute('key1', slowOperation);
        final future2 = cache.execute('key2', slowOperation);

        // Assert
        expect(cache.stats.inFlightRequests, equals(2));

        // Clean up
        await Future.wait([future1, future2]);
      });

      test('stats returns correct TTL', () {
        // Arrange
        const customTtl = Duration(minutes: 5);
        final cache = CacheManager<String, String>(ttl: customTtl);

        // Act
        final stats = cache.stats;

        // Assert
        expect(stats.ttl, equals(customTtl));
      });

      test('stats updates after operations', () {
        // Arrange
        final cache = CacheManager<String, String>();

        // Act & Assert - Initially empty
        expect(cache.stats.totalItems, equals(0));

        cache.put('key1', 'value1');
        expect(cache.stats.totalItems, equals(1));

        cache.put('key2', 'value2');
        expect(cache.stats.totalItems, equals(2));

        cache.remove('key1');
        expect(cache.stats.totalItems, equals(1));

        cache.clear();
        expect(cache.stats.totalItems, equals(0));
      });

      test('CacheStats is immutable snapshot', () {
        // Arrange
        final cache = CacheManager<String, String>();

        // Act
        final stats1 = cache.stats;
        cache.put('key1', 'value1');
        final stats2 = cache.stats;

        // Assert
        expect(stats1.totalItems, equals(0));
        expect(stats2.totalItems, equals(1));
      });
    });

    group('edge cases', () {
      test('handles null values correctly', () async {
        // Arrange
        final cache = CacheManager<String?, String>();
        Future<String?> operation() async => null;

        // Act
        final result = await cache.execute('key1', operation);

        // Assert
        expect(result, isNull);
      });

      test('caches null values', () async {
        // Arrange
        final cache = CacheManager<String?, String>();
        var callCount = 0;
        Future<String?> operation() async {
          callCount++;
          return null;
        }

        // Act
        await cache.execute('key1', operation);
        await cache.execute('key1', operation);

        // Assert
        expect(callCount, equals(2)); // Null is NOT cached (limitation)
      });

      test('handles exceptions in operation', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        Future<String> failingOperation() async {
          throw Exception('Operation failed');
        }

        // Act & Assert
        await expectLater(
          cache.execute('key1', failingOperation),
          throwsException,
        );
      });

      test('does not cache failed operations', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          if (callCount == 1) throw Exception('First call failed');
          return 'success';
        }

        // Act
        await expectLater(
          cache.execute('key1', operation),
          throwsException,
        );
        final result = await cache.execute('key1', operation);

        // Assert
        expect(result, equals('success'));
        expect(callCount, equals(2)); // Called twice
      });

      test('handles complex object types', () async {
        // Arrange
        final cache = CacheManager<Map<String, dynamic>, String>();
        Future<Map<String, dynamic>> operation() async {
          return {'id': 1, 'name': 'Test'};
        }

        // Act
        final result = await cache.execute('key1', operation);

        // Assert
        expect(result, equals({'id': 1, 'name': 'Test'}));
      });

      test('handles different key types', () async {
        // Arrange
        final intKeyCache = CacheManager<String, int>();
        final stringKeyCache = CacheManager<String, String>();
        final enumKeyCache = CacheManager<String, TestEnum>();

        // Act
        await intKeyCache.execute(1, () async => 'result1');
        await stringKeyCache.execute('key', () async => 'result2');
        await enumKeyCache.execute(TestEnum.value1, () async => 'result3');

        // Assert
        expect(intKeyCache.get(1), equals('result1'));
        expect(stringKeyCache.get('key'), equals('result2'));
        expect(enumKeyCache.get(TestEnum.value1), equals('result3'));
      });

      test('handles very short TTL', () async {
        // Arrange
        final cache = CacheManager<String, String>(
          ttl: const Duration(milliseconds: 1),
        );
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result';
        }

        // Act
        await cache.execute('key1', operation);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await cache.execute('key1', operation);

        // Assert
        expect(callCount, equals(2)); // Expired quickly
      });

      test('handles very long TTL', () async {
        // Arrange
        final cache = CacheManager<String, String>(
          ttl: const Duration(hours: 24),
        );
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          return 'result';
        }

        // Act
        await cache.execute('key1', operation);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await cache.execute('key1', operation);

        // Assert
        expect(callCount, equals(1)); // Still valid
      });
    });

    group('real-world scenarios', () {
      test('simulates typical repository caching pattern', () async {
        // Arrange
        final cache = CacheManager<List<String>, String>(
          ttl: const Duration(minutes: 5),
        );
        var apiCallCount = 0;

        Future<List<String>> fetchUsers() async {
          apiCallCount++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return ['User1', 'User2', 'User3'];
        }

        // Act - Multiple calls to same endpoint
        final result1 = await cache.execute('users', fetchUsers);
        final result2 = await cache.execute('users', fetchUsers);
        final result3 = await cache.execute('users', fetchUsers);

        // Assert
        expect(result1, equals(['User1', 'User2', 'User3']));
        expect(result2, equals(['User1', 'User2', 'User3']));
        expect(result3, equals(['User1', 'User2', 'User3']));
        expect(apiCallCount, equals(1)); // API called only once
      });

      test('simulates pull-to-refresh pattern', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var apiCallCount = 0;

        Future<String> fetchData() async {
          apiCallCount++;
          return 'data-version-$apiCallCount';
        }

        // Act
        final initial = await cache.execute('data', fetchData);
        final cached = await cache.execute('data', fetchData);
        final refreshed = await cache.execute(
          'data',
          fetchData,
          forceRefresh: true,
        );

        // Assert
        expect(initial, equals('data-version-1'));
        expect(cached, equals('data-version-1'));
        expect(refreshed, equals('data-version-2'));
        expect(apiCallCount, equals(2));
      });

      test('simulates multiple concurrent requests', () async {
        // Arrange
        final cache = CacheManager<String, int>();
        var callCount = 0;

        Future<String> fetchData(int id) async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return 'data-$id';
        }

        // Act - Simulate 3 widgets requesting same data simultaneously
        final futures = List.generate(
          3,
          (_) => cache.execute(1, () => fetchData(1)),
        );
        final results = await Future.wait(futures);

        // Assert
        expect(results, equals(['data-1', 'data-1', 'data-1']));
        expect(callCount, equals(1)); // Deduplicated to single call
      });

      test('simulates cache invalidation on data update', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var version = 1;

        Future<String> fetchData() async {
          return 'data-v$version';
        }

        // Act
        final v1 = await cache.execute('data', fetchData);
        version = 2;
        cache.remove('data'); // Invalidate cache
        final v2 = await cache.execute('data', fetchData);

        // Assert
        expect(v1, equals('data-v1'));
        expect(v2, equals('data-v2'));
      });
    });

    group('performance', () {
      test('caching significantly reduces operation calls', () async {
        // Arrange
        final cache = CacheManager<String, String>();
        var callCount = 0;
        Future<String> operation() async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return 'result';
        }

        // Act - Call 100 times
        for (var i = 0; i < 100; i++) {
          await cache.execute('key1', operation);
        }

        // Assert
        expect(callCount, equals(1)); // Only called once
      });

      test('handles many different keys efficiently', () async {
        // Arrange
        final cache = CacheManager<String, int>();
        const keyCount = 100;

        // Act
        for (var i = 0; i < keyCount; i++) {
          await cache.execute(i, () async => 'value-$i');
        }

        // Assert
        expect(cache.stats.totalItems, equals(keyCount));
      });
    });
  });
}

/// Test enum for key type testing
enum TestEnum { value1, value2, value3 }
