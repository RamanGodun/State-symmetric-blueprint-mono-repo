// Tests use const constructors extensively for immutable objects
// ignore_for_file: prefer_const_constructors

/// Tests for `ResultFutureX` extension (`Future<Either<Failure, T>>`)
///
/// Coverage:
/// - matchAsync() with async callbacks
/// - getOrElse() for fallback values
/// - failureMessageOrNull() for extracting messages
/// - onFailure() handler
/// - mapRightAsync() async transformations
/// - flatMapAsync() async chaining
/// - recover() fallback logic
/// - retry() with multiple attempts
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('ResultFutureX', () {
    group('matchAsync()', () {
      test('executes onFailure for Future<Left>', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType(), message: 'Network error'),
          ),
        );
        Failure? capturedFailure;

        // Act
        await future.matchAsync(
          onFailure: (f) async {
            capturedFailure = f;
          },
          onSuccess: (_) async {},
        );

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.message, equals('Network error'));
        expect(capturedFailure?.type, isA<NetworkFailureType>());
      });

      test('executes onSuccess for Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));
        int? capturedValue;

        // Act
        await future.matchAsync(
          onFailure: (_) async {},
          onSuccess: (v) async {
            capturedValue = v;
          },
        );

        // Assert
        expect(capturedValue, equals(42));
      });

      test('uses custom successTag for logging', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>('data'));
        var called = false;

        // Act
        await future.matchAsync(
          onFailure: (_) async {},
          onSuccess: (_) async {
            called = true;
          },
          successTag: 'CUSTOM_TAG',
        );

        // Assert
        expect(called, isTrue);
      });

      test('handles async onFailure callback', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: ApiFailureType(), message: 'API error'),
          ),
        );
        final results = <String>[];

        // Act
        await future.matchAsync(
          onFailure: (f) async {
            results.add('start');
            await Future<void>.delayed(Duration(milliseconds: 10));
            results.add('end');
          },
          onSuccess: (_) async {},
        );

        // Assert
        expect(results, equals(['start', 'end']));
      });

      test('handles async onSuccess callback', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(100));
        final results = <String>[];

        // Act
        await future.matchAsync(
          onFailure: (_) async {},
          onSuccess: (_) async {
            results.add('start');
            await Future<void>.delayed(Duration(milliseconds: 10));
            results.add('end');
          },
        );

        // Assert
        expect(results, equals(['start', 'end']));
      });
    });

    group('getOrElse()', () {
      test('returns Right value for Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final result = await future.getOrElse(0);

        // Assert
        expect(result, equals(42));
      });

      test('returns fallback for Future<Left>', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType()),
          ),
        );

        // Act
        final result = await future.getOrElse(99);

        // Assert
        expect(result, equals(99));
      });

      test('works with String values', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, String>(Failure(type: ApiFailureType())),
        );

        // Act
        final result = await future.getOrElse('default');

        // Assert
        expect(result, equals('default'));
      });

      test('works with complex types', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, List<int>>(Failure(type: CacheFailureType())),
        );

        // Act
        final result = await future.getOrElse([1, 2, 3]);

        // Assert
        expect(result, equals([1, 2, 3]));
      });
    });

    group('failureMessageOrNull()', () {
      test('returns message for Future<Left>', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType(), message: 'Connection failed'),
          ),
        );

        // Act
        final message = await future.failureMessageOrNull();

        // Assert
        expect(message, equals('Connection failed'));
      });

      test('returns null for Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final message = await future.failureMessageOrNull();

        // Assert
        expect(message, isNull);
      });

      test('returns null message when Failure has no message', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: UnknownFailureType())),
        );

        // Act
        final message = await future.failureMessageOrNull();

        // Assert
        expect(message, isNull);
      });
    });

    group('onFailure()', () {
      test('executes handler for Future<Left>', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType(), message: 'Error'),
          ),
        );
        Failure? capturedFailure;

        // Act
        final handler = await future.onFailure((f) {
          capturedFailure = f;
        });

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.message, equals('Error'));
        expect(handler, isA<ResultHandlerAsync<int>>());
      });

      test('does not execute handler for Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));
        var called = false;

        // Act
        final handler = await future.onFailure((_) {
          called = true;
        });

        // Assert
        expect(called, isFalse);
        expect(handler, isA<ResultHandlerAsync<int>>());
      });

      test('handles async callback', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: ApiFailureType())),
        );
        final results = <String>[];

        // Act
        await future.onFailure((f) async {
          results.add('processing');
          await Future<void>.delayed(Duration(milliseconds: 5));
          results.add('done');
        });

        // Assert
        expect(results, equals(['processing', 'done']));
      });

      test('returns ResultHandlerAsync for chaining', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );

        // Act
        final handler = await future.onFailure((_) {});

        // Assert
        expect(handler, isA<ResultHandlerAsync<int>>());
      });
    });

    group('mapRightAsync()', () {
      test('transforms Right value with async function', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(21));

        // Act
        final result = await future.mapRightAsync((v) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          return v * 2;
        });

        // Assert
        expect(result.rightOrNull, equals(42));
      });

      test('does not transform Left value', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType(), message: 'Error'),
          ),
        );

        // Act
        final result = await future.mapRightAsync((v) async => v * 2);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, equals('Error'));
      });

      test('can change type during transformation', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final result = await future.mapRightAsync((v) async => v.toString());

        // Assert
        expect(result.rightOrNull, equals('42'));
        expect(result.rightOrNull, isA<String>());
      });

      test('handles complex async transformations', () async {
        // Arrange
        final future = Future.value(
          const Right<Failure, String>('hello'),
        );

        // Act
        final result = await future.mapRightAsync((v) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          return {
            'original': v,
            'uppercase': v.toUpperCase(),
            'length': v.length,
          };
        });

        // Assert
        final map = result.rightOrNull;
        expect(map?['original'], equals('hello'));
        expect(map?['uppercase'], equals('HELLO'));
        expect(map?['length'], equals(5));
      });
    });

    group('flatMapAsync()', () {
      test('chains async transformation returning Either', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(10));

        // Act
        final result = await future.flatMapAsync((v) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          if (v > 5) {
            return Right<Failure, String>('Valid: $v');
          } else {
            return const Left<Failure, String>(
              Failure(type: UnknownFailureType()),
            );
          }
        });

        // Assert
        expect(result.rightOrNull, equals('Valid: 10'));
      });

      test('propagates Left from original Future', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType(), message: 'Original error'),
          ),
        );

        // Act
        final result = await future.flatMapAsync(
          (v) async => Right<Failure, String>('Value: $v'),
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, equals('Original error'));
      });

      test('can return Left from transformation', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(3));

        // Act
        final result = await future.flatMapAsync((v) async {
          if (v < 5) {
            return const Left<Failure, String>(
              Failure(type: ApiFailureType(), message: 'Too small'),
            );
          }
          return Right<Failure, String>('OK: $v');
        });

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, equals('Too small'));
      });

      test('handles multiple async flatMap chains', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(5));

        // Act
        final result = await future
            .flatMapAsync(
              (v) async => Right<Failure, int>(v * 2),
            )
            .flatMapAsync(
              (v) async => Right<Failure, String>('Result: $v'),
            );

        // Assert
        expect(result.rightOrNull, equals('Result: 10'));
      });
    });

    group('recover()', () {
      test('recovers from Left with fallback value', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType()),
          ),
        );

        // Act
        final result = await future.recover((f) => 99);

        // Assert
        expect(result.rightOrNull, equals(99));
        expect(result.isRight, isTrue);
      });

      test('does not modify Right value', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final result = await future.recover((f) => 99);

        // Assert
        expect(result.rightOrNull, equals(42));
      });

      test('handles async recovery function', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: CacheFailureType())),
        );

        // Act
        final result = await future.recover((f) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          return 100;
        });

        // Assert
        expect(result.rightOrNull, equals(100));
      });

      test('can access failure data during recovery', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: ApiFailureType(), statusCode: 404),
          ),
        );

        // Act
        final result = await future.recover((f) => f.statusCode ?? 0);

        // Assert
        expect(result.rightOrNull, equals(404));
      });
    });

    group('retry()', () {
      test('succeeds on first attempt', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));
        var attempts = 0;

        // Act
        final result = await future.retry(
          task: () async {
            attempts++;
            return const Right<Failure, int>(42);
          },
        );

        // Assert
        expect(result.rightOrNull, equals(42));
        expect(attempts, equals(1));
      });

      test('retries up to maxAttempts times', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );
        var attempts = 0;

        // Act
        final result = await future.retry(
          task: () async {
            attempts++;
            return const Left<Failure, int>(
              Failure(type: NetworkFailureType()),
            );
          },
          maxAttempts: 3,
          delay: Duration(milliseconds: 10),
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(attempts, equals(3));
      });

      test('succeeds on second attempt', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );
        var attempts = 0;

        // Act
        final result = await future.retry(
          task: () async {
            attempts++;
            if (attempts < 2) {
              return const Left<Failure, int>(
                Failure(type: NetworkFailureType()),
              );
            }
            return const Right<Failure, int>(42);
          },
          maxAttempts: 3,
          delay: Duration(milliseconds: 5),
        );

        // Assert
        expect(result.rightOrNull, equals(42));
        expect(attempts, equals(2));
      });

      test('uses custom delay between retries', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );
        final timestamps = <DateTime>[];

        // Act
        await future.retry(
          task: () async {
            timestamps.add(DateTime.now());
            return const Left<Failure, int>(
              Failure(type: NetworkFailureType()),
            );
          },
          maxAttempts: 2,
          delay: Duration(milliseconds: 50),
        );

        // Assert
        expect(timestamps.length, equals(2));
        if (timestamps.length == 2) {
          final diff = timestamps[1].difference(timestamps[0]);
          expect(diff.inMilliseconds, greaterThanOrEqualTo(45));
        }
      });

      test('stops retrying after success', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );
        var attempts = 0;

        // Act
        final result = await future.retry(
          task: () async {
            attempts++;
            if (attempts == 2) {
              return const Right<Failure, int>(100);
            }
            return const Left<Failure, int>(
              Failure(type: NetworkFailureType()),
            );
          },
          maxAttempts: 5,
          delay: Duration(milliseconds: 5),
        );

        // Assert
        expect(result.rightOrNull, equals(100));
        expect(
          attempts,
          equals(2),
        ); // Should stop at attempt 2, not continue to 5
      });
    });

    group('edge cases', () {
      test('handles null in Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int?>(null));

        // Act
        final result = await future.getOrElse(0);

        // Assert
        // getOrElse uses ?? operator, so null value triggers fallback
        expect(result, equals(0));
      });

      test('handles empty string in Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>(''));

        // Act
        final result = await future.getOrElse('default');

        // Assert
        expect(result, equals(''));
      });

      test('handles zero in Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(0));

        // Act
        final result = await future.getOrElse(99);

        // Assert
        expect(result, equals(0));
      });

      test('handles false in Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, bool>(false));

        // Act
        final result = await future.getOrElse(true);

        // Assert
        expect(result, equals(false));
      });

      test('handles empty collection in Future<Right>', () async {
        // Arrange
        final future = Future.value(const Right<Failure, List<int>>([]));

        // Act
        final result = await future.getOrElse([1, 2, 3]);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('real-world scenarios', () {
      test('fetch data from API with retry', () async {
        // Arrange
        var attempts = 0;

        // Act
        final result =
            await Future.value(
              const Left<Failure, String>(Failure(type: NetworkFailureType())),
            ).retry(
              task: () async {
                attempts++;
                if (attempts < 3) {
                  return const Left<Failure, String>(
                    Failure(type: NetworkFailureType()),
                  );
                }
                return const Right<Failure, String>('API data');
              },
              maxAttempts: 5,
              delay: Duration(milliseconds: 10),
            );

        // Assert
        expect(result.rightOrNull, equals('API data'));
        expect(attempts, equals(3));
      });

      test('transform API response asynchronously', () async {
        // Arrange
        final future = Future.value(
          const Right<Failure, Map<String, dynamic>>({
            'id': 1,
            'name': 'User',
          }),
        );

        // Act
        final result = await future.mapRightAsync((data) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          return data['id'] as int;
        });

        // Assert
        expect(result.rightOrNull, equals(1));
      });

      test('recover from cache failure with network request', () async {
        // Arrange
        final cacheResult = Future.value(
          const Left<Failure, String>(
            Failure(type: CacheFailureType(), message: 'Cache miss'),
          ),
        );

        // Act
        final result = await cacheResult.recover((f) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          return 'Data from network';
        });

        // Assert
        expect(result.rightOrNull, equals('Data from network'));
      });

      test('chain multiple async operations', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(5));

        // Act
        final result = await future
            .mapRightAsync((v) async => v * 2)
            .flatMapAsync(
              (v) async => Right<Failure, String>('Value: $v'),
            )
            .mapRightAsync(
              (s) async => s.toUpperCase(),
            );

        // Assert
        expect(result.rightOrNull, equals('VALUE: 10'));
      });

      test('handle network timeout with fallback', () async {
        // Arrange
        final networkRequest = Future.value(
          const Left<Failure, List<String>>(
            Failure(type: NetworkTimeoutFailureType()),
          ),
        );

        // Act
        final result = await networkRequest
            .recover((f) => ['cached1', 'cached2'])
            .mapRightAsync((items) async => items.length);

        // Assert
        expect(result.rightOrNull, equals(2));
      });
    });

    group('composition', () {
      test('combines getOrElse with mapRightAsync', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(10));

        // Act
        final transformed = await future.mapRightAsync((v) async => v * 2);
        final result = transformed.getOrElse(0);

        // Assert
        expect(result, equals(20));
      });

      test('chains onFailure with recover', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType(), message: 'Connection lost'),
          ),
        );
        String? errorMessage;

        // Act
        await future.onFailure((f) {
          errorMessage = f.message;
        });
        final recovered = await future.recover((f) => 99);

        // Assert
        expect(errorMessage, equals('Connection lost'));
        expect(recovered.rightOrNull, equals(99));
      });

      test('uses failureMessageOrNull after matchAsync', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: ApiFailureType(), message: 'API error'),
          ),
        );

        // Act
        await future.matchAsync(
          onFailure: (_) async {},
          onSuccess: (_) async {},
        );
        final message = await future.failureMessageOrNull();

        // Assert
        expect(message, equals('API error'));
      });
    });
  });
}
