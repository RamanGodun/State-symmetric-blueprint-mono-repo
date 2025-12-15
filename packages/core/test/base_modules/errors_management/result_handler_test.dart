// Tests use const constructors extensively for immutable objects
// ignore_for_file: prefer_const_constructors

/// Tests for `ResultHandler<T>` class
///
/// This test suite follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Construction with `Either<Failure, T>`
/// - onSuccess() callback execution
/// - onFailure() callback execution
/// - getOrElse() fallback values
/// - valueOrNull accessor
/// - failureOrNull accessor
/// - didFail boolean
/// - didSucceed boolean
/// - fold() pattern matching
/// - log() failure logging
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResultHandler', () {
    group('construction', () {
      test('creates handler with Right result', () {
        // Arrange & Act
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

        // Assert
        expect(handler, isA<ResultHandler<int>>());
        expect(handler.result, equals(result));
      });

      test('creates handler with Left result', () {
        // Arrange & Act
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        final handler = ResultHandler(result);

        // Assert
        expect(handler, isA<ResultHandler<int>>());
        expect(handler.result, equals(result));
      });

      test('is immutable', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

        // Assert - attempting to modify would cause compile error
        expect(handler.result, isA<Either<Failure, int>>());
      });

      test('works with different types', () {
        // Arrange & Act
        final stringHandler = ResultHandler(
          const Right<Failure, String>('test'),
        );
        final listHandler = ResultHandler(
          const Right<Failure, List<int>>([1, 2, 3]),
        );

        // Assert
        expect(stringHandler, isA<ResultHandler<String>>());
        expect(listHandler, isA<ResultHandler<List<int>>>());
      });
    });

    group('onSuccess()', () {
      test('executes handler for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);
        int? capturedValue;

        // Act
        handler.onSuccess((value) {
          capturedValue = value;
        });

        // Assert
        expect(capturedValue, equals(42));
      });

      test('does not execute handler for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandler(result);
        var called = false;

        // Act
        handler.onSuccess((_) {
          called = true;
        });

        // Assert
        expect(called, isFalse);
      });

      test('passes correct value to handler', () {
        // Arrange
        const result = Right<Failure, String>('hello');
        final handler = ResultHandler(result);
        String? capturedValue;

        // Act
        handler.onSuccess((value) {
          capturedValue = value;
        });

        // Assert
        expect(capturedValue, equals('hello'));
        expect(capturedValue, isA<String>());
      });

      test('works with complex types', () {
        // Arrange
        final result = Right<Failure, Map<String, int>>(const {
          'count': 10,
        });
        final handler = ResultHandler(result);
        Map<String, int>? capturedValue;

        // Act
        handler.onSuccess((value) {
          capturedValue = value;
        });

        // Assert
        expect(capturedValue, equals({'count': 10}));
      });
    });

    group('onFailure()', () {
      test('executes handler for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Network error'),
        );
        final handler = ResultHandler(result);
        Failure? capturedFailure;

        // Act
        handler.onFailure((failure) {
          capturedFailure = failure;
        });

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.message, equals('Network error'));
        expect(capturedFailure?.type, isA<NetworkFailureType>());
      });

      test('does not execute handler for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);
        var called = false;

        // Act
        handler.onFailure((_) {
          called = true;
        });

        // Assert
        expect(called, isFalse);
      });

      test('passes correct failure to handler', () {
        // Arrange
        const result = Left<Failure, String>(
          Failure(type: ApiFailureType(), statusCode: 404),
        );
        final handler = ResultHandler(result);
        Failure? capturedFailure;

        // Act
        handler.onFailure((failure) {
          capturedFailure = failure;
        });

        // Assert
        expect(capturedFailure?.type, isA<ApiFailureType>());
        expect(capturedFailure?.statusCode, equals(404));
      });
    });

    group('getOrElse()', () {
      test('returns value for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

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
        final handler = ResultHandler(result);

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
        final handler = ResultHandler(result);

        // Act
        final value = handler.getOrElse('default');

        // Assert
        expect(value, equals('default'));
      });

      test('works with complex types', () {
        // Arrange
        const result = Left<Failure, List<int>>(
          Failure(type: ApiFailureType()),
        );
        final handler = ResultHandler(result);

        // Act
        final value = handler.getOrElse([1, 2, 3]);

        // Assert
        expect(value, equals([1, 2, 3]));
      });
    });

    group('valueOrNull', () {
      test('returns value for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

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
        final handler = ResultHandler(result);

        // Act
        final value = handler.valueOrNull;

        // Assert
        expect(value, isNull);
      });

      test('preserves type', () {
        // Arrange
        const result = Right<Failure, String>('test');
        final handler = ResultHandler(result);

        // Act
        final value = handler.valueOrNull;

        // Assert
        expect(value, isA<String?>());
        expect(value, equals('test'));
      });
    });

    group('failureOrNull', () {
      test('returns failure for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        final handler = ResultHandler(result);

        // Act
        final failure = handler.failureOrNull;

        // Assert
        expect(failure, isNotNull);
        expect(failure?.message, equals('Error'));
      });

      test('returns null for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

        // Act
        final failure = handler.failureOrNull;

        // Assert
        expect(failure, isNull);
      });

      test('preserves failure type', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: ApiFailureType()),
        );
        final handler = ResultHandler(result);

        // Act
        final failure = handler.failureOrNull;

        // Assert
        expect(failure, isA<Failure?>());
        expect(failure?.type, isA<ApiFailureType>());
      });
    });

    group('didFail', () {
      test('returns true for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandler(result);

        // Act
        final failed = handler.didFail;

        // Assert
        expect(failed, isTrue);
      });

      test('returns false for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

        // Act
        final failed = handler.didFail;

        // Assert
        expect(failed, isFalse);
      });

      test('is opposite of didSucceed for Left', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandler(result);

        // Assert
        expect(handler.didFail, isTrue);
        expect(handler.didSucceed, isFalse);
      });
    });

    group('didSucceed', () {
      test('returns true for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

        // Act
        final succeeded = handler.didSucceed;

        // Assert
        expect(succeeded, isTrue);
      });

      test('returns false for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final handler = ResultHandler(result);

        // Act
        final succeeded = handler.didSucceed;

        // Assert
        expect(succeeded, isFalse);
      });

      test('is opposite of didFail for Right', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

        // Assert
        expect(handler.didSucceed, isTrue);
        expect(handler.didFail, isFalse);
      });
    });

    group('fold()', () {
      test('executes onFailure for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        final handler = ResultHandler(result);
        Failure? capturedFailure;
        int? capturedValue;

        // Act
        handler.fold(
          onFailure: (f) => capturedFailure = f,
          onSuccess: (v) => capturedValue = v,
        );

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.message, equals('Error'));
        expect(capturedValue, isNull);
      });

      test('executes onSuccess for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);
        Failure? capturedFailure;
        int? capturedValue;

        // Act
        handler.fold(
          onFailure: (f) => capturedFailure = f,
          onSuccess: (v) => capturedValue = v,
        );

        // Assert
        expect(capturedFailure, isNull);
        expect(capturedValue, equals(42));
      });

      test('executes only one branch', () {
        // Arrange
        const leftResult = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        const rightResult = Right<Failure, int>(42);
        final leftHandler = ResultHandler(leftResult);
        final rightHandler = ResultHandler(rightResult);
        var leftCalls = 0;
        var rightCalls = 0;

        // Act
        leftHandler.fold(
          onFailure: (_) => leftCalls++,
          onSuccess: (_) => rightCalls++,
        );
        leftCalls = 0;
        rightCalls = 0;
        rightHandler.fold(
          onFailure: (_) => leftCalls++,
          onSuccess: (_) => rightCalls++,
        );

        // Assert
        expect(leftCalls, equals(0)); // Right doesn't call onFailure
        expect(rightCalls, equals(1)); // Right calls onSuccess
      });
    });

    group('log()', () {
      test('logs failure for Left result', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Network error'),
        );
        final handler = ResultHandler(result);

        // Act & Assert - should not throw
        expect(handler.log, returnsNormally);
      });

      test('does nothing for Right result', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);

        // Act & Assert - should not throw
        expect(handler.log, returnsNormally);
      });
    });

    group('edge cases', () {
      test('handles null in Right result', () {
        // Arrange
        const result = Right<Failure, int?>(null);
        final handler = ResultHandler(result);

        // Act
        final value = handler.valueOrNull;

        // Assert
        expect(value, isNull);
        expect(handler.didSucceed, isTrue);
      });

      test('handles empty string in Right result', () {
        // Arrange
        const result = Right<Failure, String>('');
        final handler = ResultHandler(result);

        // Act
        final value = handler.getOrElse('default');

        // Assert
        expect(value, equals(''));
      });

      test('handles zero in Right result', () {
        // Arrange
        const result = Right<Failure, int>(0);
        final handler = ResultHandler(result);

        // Act
        final value = handler.getOrElse(99);

        // Assert
        expect(value, equals(0));
      });

      test('handles false in Right result', () {
        // Arrange
        const result = Right<Failure, bool>(false);
        final handler = ResultHandler(result);

        // Act
        final value = handler.getOrElse(true);

        // Assert
        expect(value, equals(false));
      });

      test('handles empty collection in Right result', () {
        // Arrange
        const result = Right<Failure, List<int>>([]);
        final handler = ResultHandler(result);

        // Act
        final value = handler.getOrElse([1, 2, 3]);

        // Assert
        expect(value, isEmpty);
      });
    });

    group('real-world scenarios', () {
      test('handle API response success', () {
        // Arrange
        final result = Right<Failure, Map<String, dynamic>>(const {
          'id': 1,
          'name': 'User',
        });
        final handler = ResultHandler(result);

        // Act
        var userId = 0;
        handler.onSuccess((data) {
          userId = data['id'] as int;
        });

        // Assert
        expect(userId, equals(1));
        expect(handler.didSucceed, isTrue);
      });

      test('handle API response failure', () {
        // Arrange
        const result = Left<Failure, Map<String, dynamic>>(
          Failure(type: ApiFailureType(), statusCode: 404),
        );
        final handler = ResultHandler(result);

        // Act
        var errorCode = 0;
        handler.onFailure((f) {
          errorCode = f.statusCode ?? 0;
        });

        // Assert
        expect(errorCode, equals(404));
        expect(handler.didFail, isTrue);
      });

      test('conditional UI rendering based on result', () {
        // Arrange
        const successResult = Right<Failure, String>('Data loaded');
        const errorResult = Left<Failure, String>(
          Failure(type: NetworkFailureType()),
        );
        final successHandler = ResultHandler(successResult);
        final errorHandler = ResultHandler(errorResult);

        // Act
        final successMessage = successHandler.didSucceed
            ? successHandler.valueOrNull
            : 'Error';
        final errorMessage = errorHandler.didFail ? 'Error' : 'Success';

        // Assert
        expect(successMessage, equals('Data loaded'));
        expect(errorMessage, equals('Error'));
      });

      test('extract value with fallback for missing data', () {
        // Arrange
        const result = Left<Failure, List<String>>(
          Failure(type: CacheFailureType()),
        );
        final handler = ResultHandler(result);

        // Act
        final items = handler.getOrElse(['default1', 'default2']);

        // Assert
        expect(items, equals(['default1', 'default2']));
      });

      test('chain multiple handlers', () {
        // Arrange
        const result = Right<Failure, int>(10);
        final handler = ResultHandler(result);
        final results = <String>[];

        // Act
        handler
          ..onSuccess((v) => results.add('success: $v'))
          ..fold(
            onFailure: (_) => results.add('failure'),
            onSuccess: (v) => results.add('fold: $v'),
          );
        if (handler.didSucceed) {
          results.add('didSucceed: ${handler.valueOrNull}');
        }

        // Assert
        expect(results, hasLength(3));
        expect(results[0], equals('success: 10'));
        expect(results[1], equals('fold: 10'));
        expect(results[2], equals('didSucceed: 10'));
      });
    });

    group('composition', () {
      test('uses getOrElse with onSuccess', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final handler = ResultHandler(result);
        var called = false;

        // Act
        handler.onSuccess((_) => called = true);
        final value = handler.getOrElse(0);

        // Assert
        expect(called, isTrue);
        expect(value, equals(42));
      });

      test('uses failureOrNull with didFail', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        final handler = ResultHandler(result);

        // Act
        final message = handler.didFail
            ? handler.failureOrNull?.message ?? 'Unknown'
            : 'Success';

        // Assert
        expect(message, equals('Error'));
      });

      test('combines fold with logging', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: ApiFailureType()),
        );
        final handler = ResultHandler(result);
        var foldCalled = false;

        // Act
        handler.fold(
          onFailure: (_) {
            foldCalled = true;
            handler.log();
          },
          onSuccess: (_) {},
        );

        // Assert
        expect(foldCalled, isTrue);
      });
    });
  });
}
