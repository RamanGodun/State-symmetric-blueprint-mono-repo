// Tests use const constructors extensively for immutable objects
// ignore_for_file: prefer_const_constructors

/// Tests for `ResultHandlerAsync<T>` class
///
/// Coverage:
/// - Construction with `Either<Failure, T>`
/// - onSuccessAsync() async callback execution
/// - onFailureAsync() async callback execution
/// - foldAsync() async pattern matching
/// - getOrElse() fallback values
/// - valueOrNull accessor
/// - failureOrNull accessor
/// - logAsync() failure logging
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('ResultHandlerAsync', () {
    group('construction', () {
      test('creates handler with Right result', () {
        // Arrange & Act
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);

        // Assert
        expect(handler, isA<ResultHandlerAsync<int>>());
        expect(handler.result, equals(result));
      });

      test('creates handler with Left result', () {
        // Arrange & Act
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        final handler = ResultHandlerAsync(result);

        // Assert
        expect(handler, isA<ResultHandlerAsync<int>>());
        expect(handler.result, equals(result));
      });

      test('works with different types', () {
        // Arrange & Act
        final stringHandler = ResultHandlerAsync(
          const Right<Failure, String>('test'),
        );
        final listHandler = ResultHandlerAsync(
          const Right<Failure, List<int>>([1, 2, 3]),
        );

        // Assert
        expect(stringHandler, isA<ResultHandlerAsync<String>>());
        expect(listHandler, isA<ResultHandlerAsync<List<int>>>());
      });
    });

    group('onSuccessAsync()', () {
      test('executes async handler for Right result', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);
        int? capturedValue;

        // Act
        final returned = await handler.onSuccessAsync((value) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          capturedValue = value;
        });

        // Assert
        expect(capturedValue, equals(42));
        expect(returned, equals(handler)); // Returns self for chaining
      });

      test('does not execute handler for Left result', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandlerAsync(result);
        var called = false;

        // Act
        await handler.onSuccessAsync((_) async {
          called = true;
        });

        // Assert
        expect(called, isFalse);
      });

      test('handles synchronous callback', () async {
        // Arrange
        const result = Right<Failure, String>('hello');
        final handler = ResultHandlerAsync(result);
        String? capturedValue;

        // Act
        await handler.onSuccessAsync((value) {
          capturedValue = value;
        });

        // Assert
        expect(capturedValue, equals('hello'));
      });

      test('returns self for chaining', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);

        // Act
        final returned = await handler.onSuccessAsync((_) {});

        // Assert
        expect(returned, same(handler));
      });

      test('handles async operations correctly', () async {
        // Arrange
        const result = Right<Failure, int>(10);
        final handler = ResultHandlerAsync(result);
        final operations = <String>[];

        // Act
        await handler.onSuccessAsync((value) async {
          operations.add('start');
          await Future<void>.delayed(Duration(milliseconds: 10));
          operations.add('end');
        });

        // Assert
        expect(operations, equals(['start', 'end']));
      });
    });

    group('onFailureAsync()', () {
      test('executes async handler for Left result', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Network error'),
        );
        final handler = ResultHandlerAsync(result);
        Failure? capturedFailure;

        // Act
        final returned = await handler.onFailureAsync((failure) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          capturedFailure = failure;
        });

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.message, equals('Network error'));
        expect(returned, equals(handler)); // Returns self for chaining
      });

      test('does not execute handler for Right result', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);
        var called = false;

        // Act
        await handler.onFailureAsync((_) async {
          called = true;
        });

        // Assert
        expect(called, isFalse);
      });

      test('handles synchronous callback', () async {
        // Arrange
        const result = Left<Failure, String>(
          Failure(type: ApiFailureType(), statusCode: 404),
        );
        final handler = ResultHandlerAsync(result);
        Failure? capturedFailure;

        // Act
        await handler.onFailureAsync((failure) {
          capturedFailure = failure;
        });

        // Assert
        expect(capturedFailure?.statusCode, equals(404));
      });

      test('returns self for chaining', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final returned = await handler.onFailureAsync((_) {});

        // Assert
        expect(returned, same(handler));
      });

      test('handles async operations correctly', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: ApiFailureType()),
        );
        final handler = ResultHandlerAsync(result);
        final operations = <String>[];

        // Act
        await handler.onFailureAsync((f) async {
          operations.add('start');
          await Future<void>.delayed(Duration(milliseconds: 10));
          operations.add('end');
        });

        // Assert
        expect(operations, equals(['start', 'end']));
      });
    });

    group('foldAsync()', () {
      test('executes onFailure for Left result', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        final handler = ResultHandlerAsync(result);
        Failure? capturedFailure;
        int? capturedValue;

        // Act
        await handler.foldAsync(
          onFailure: (f) async {
            await Future<void>.delayed(Duration(milliseconds: 5));
            capturedFailure = f;
          },
          onSuccess: (v) async {
            capturedValue = v;
          },
        );

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.message, equals('Error'));
        expect(capturedValue, isNull);
      });

      test('executes onSuccess for Right result', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);
        Failure? capturedFailure;
        int? capturedValue;

        // Act
        await handler.foldAsync(
          onFailure: (f) async {
            capturedFailure = f;
          },
          onSuccess: (v) async {
            await Future<void>.delayed(Duration(milliseconds: 5));
            capturedValue = v;
          },
        );

        // Assert
        expect(capturedFailure, isNull);
        expect(capturedValue, equals(42));
      });

      test('handles synchronous callbacks', () async {
        // Arrange
        const result = Right<Failure, String>('test');
        final handler = ResultHandlerAsync(result);
        String? capturedValue;

        // Act
        await handler.foldAsync(
          onFailure: (_) {},
          onSuccess: (v) {
            capturedValue = v;
          },
        );

        // Assert
        expect(capturedValue, equals('test'));
      });

      test('executes only one branch', () async {
        // Arrange
        const leftResult = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        const rightResult = Right<Failure, int>(42);
        final leftHandler = ResultHandlerAsync(leftResult);
        final rightHandler = ResultHandlerAsync(rightResult);
        var leftCalls = 0;
        var rightCalls = 0;

        // Act
        await leftHandler.foldAsync(
          onFailure: (_) async => leftCalls++,
          onSuccess: (_) async => rightCalls++,
        );
        expect(leftCalls, equals(1));
        expect(rightCalls, equals(0));

        leftCalls = 0;
        rightCalls = 0;
        await rightHandler.foldAsync(
          onFailure: (_) async => leftCalls++,
          onSuccess: (_) async => rightCalls++,
        );

        // Assert
        expect(leftCalls, equals(0)); // Right doesn't call onFailure
        expect(rightCalls, equals(1)); // Right calls onSuccess
      });
    });

    group('getOrElse()', () {
      test('returns value for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.getOrElse(0);

        // Assert
        expect(value, equals(42));
      });

      test('returns fallback for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.getOrElse(99);

        // Assert
        expect(value, equals(99));
      });

      test('works with String values', () {
        // Arrange
        const result = Left<Failure, String>(
          Failure(type: CacheFailureType()),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.getOrElse('default');

        // Assert
        expect(value, equals('default'));
      });
    });

    group('valueOrNull', () {
      test('returns value for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.valueOrNull;

        // Assert
        expect(value, equals(42));
      });

      test('returns null for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.valueOrNull;

        // Assert
        expect(value, isNull);
      });
    });

    group('failureOrNull', () {
      test('returns failure for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final failure = handler.failureOrNull;

        // Assert
        expect(failure, isNotNull);
        expect(failure?.message, equals('Error'));
      });

      test('returns null for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);

        // Act
        final failure = handler.failureOrNull;

        // Assert
        expect(failure, isNull);
      });
    });

    group('logAsync()', () {
      test('logs failure for Left result', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Network error'),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final returned = await handler.logAsync();

        // Assert - should not throw
        expect(returned, same(handler)); // Returns self for chaining
      });

      test('does nothing for Right result', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);

        // Act
        final returned = await handler.logAsync();

        // Assert
        expect(returned, same(handler));
      });

      test('returns self for chaining', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: ApiFailureType()),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final returned = await handler.logAsync();

        // Assert
        expect(returned, same(handler));
      });
    });

    group('edge cases', () {
      test('handles null in Right result', () {
        // Arrange
        const result = Right<Failure, int?>(null);
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.valueOrNull;

        // Assert
        expect(value, isNull);
      });

      test('handles empty string in Right result', () {
        // Arrange
        const result = Right<Failure, String>('');
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.getOrElse('default');

        // Assert
        expect(value, equals(''));
      });

      test('handles zero in Right result', () {
        // Arrange
        const result = Right<Failure, int>(0);
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.getOrElse(99);

        // Assert
        expect(value, equals(0));
      });

      test('handles false in Right result', () {
        // Arrange
        const result = Right<Failure, bool>(false);
        final handler = ResultHandlerAsync(result);

        // Act
        final value = handler.getOrElse(true);

        // Assert
        expect(value, equals(false));
      });
    });

    group('real-world scenarios', () {
      test('handle async API call success', () async {
        // Arrange
        final result = Right<Failure, Map<String, dynamic>>(const {
          'id': 1,
          'name': 'User',
        });
        final handler = ResultHandlerAsync(result);

        // Act
        var userId = 0;
        await handler.onSuccessAsync((data) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          userId = data['id'] as int;
        });

        // Assert
        expect(userId, equals(1));
      });

      test('handle async API call failure', () async {
        // Arrange
        const result = Left<Failure, Map<String, dynamic>>(
          Failure(type: ApiFailureType(), statusCode: 404),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        var errorCode = 0;
        await handler.onFailureAsync((f) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          errorCode = f.statusCode ?? 0;
        });

        // Assert
        expect(errorCode, equals(404));
      });

      test('chain async operations', () async {
        // Arrange
        const result = Right<Failure, int>(10);
        final handler = ResultHandlerAsync(result);
        final operations = <String>[];

        // Act
        await handler
            .onSuccessAsync((v) async {
              operations.add('success: $v');
            })
            .then(
              (h) => h.logAsync(),
            )
            .then(
              (h) => h.foldAsync(
                onFailure: (_) async {},
                onSuccess: (v) async {
                  operations.add('fold: $v');
                },
              ),
            );

        // Assert
        expect(operations, hasLength(2));
        expect(operations[0], equals('success: 10'));
        expect(operations[1], equals('fold: 10'));
      });

      test('handle network timeout with async recovery', () async {
        // Arrange
        const result = Left<Failure, List<String>>(
          Failure(type: NetworkTimeoutFailureType()),
        );
        final handler = ResultHandlerAsync(result);

        // Act
        final fallback = handler.getOrElse(['cached1', 'cached2']);
        var logged = false;
        await handler.onFailureAsync((f) async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          logged = true;
        });

        // Assert
        expect(fallback, equals(['cached1', 'cached2']));
        expect(logged, isTrue);
      });
    });

    group('composition', () {
      test('chains onSuccessAsync with logAsync', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);
        var called = false;

        // Act
        await handler
            .onSuccessAsync((_) async {
              called = true;
            })
            .then((h) => h.logAsync());

        // Assert
        expect(called, isTrue);
      });

      test('chains onFailureAsync with logAsync', () async {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandlerAsync(result);
        var called = false;

        // Act
        await handler
            .onFailureAsync((_) async {
              called = true;
            })
            .then((h) => h.logAsync());

        // Assert
        expect(called, isTrue);
      });

      test('uses foldAsync with getOrElse', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandlerAsync(result);
        var foldCalled = false;

        // Act
        await handler.foldAsync(
          onFailure: (_) async {},
          onSuccess: (_) async {
            foldCalled = true;
          },
        );
        final value = handler.getOrElse(0);

        // Assert
        expect(foldCalled, isTrue);
        expect(value, equals(42));
      });
    });
  });
}
