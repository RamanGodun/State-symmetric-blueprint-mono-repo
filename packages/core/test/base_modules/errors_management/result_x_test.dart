// Tests use const constructors extensively for immutable objects
// ignore_for_file: prefer_const_constructors

/// Tests for `ResultX` extension (`Either<Failure, T>`)
///
/// This test follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - match() method with logging
/// - getOrElse() fallback
/// - failureMessage getter
/// - mapRightX() transformation
/// - mapLeftX() transformation
/// - isUnauthorizedFailure checker
/// - emitStates() state management
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResultX', () {
    group('match()', () {
      test('executes onFailure for Left and returns same Either', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Network error'),
        );
        Failure? capturedFailure;

        // Act
        final returned = result.match(
          onFailure: (f) => capturedFailure = f,
          onSuccess: (_) {},
        );

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.message, equals('Network error'));
        expect(identical(returned, result), isTrue);
      });

      test('executes onSuccess for Right and returns same Either', () {
        // Arrange
        const result = Right<Failure, int>(42);
        int? capturedValue;

        // Act
        final returned = result.match(
          onFailure: (_) {},
          onSuccess: (v) => capturedValue = v,
        );

        // Assert
        expect(capturedValue, equals(42));
        expect(identical(returned, result), isTrue);
      });

      test('can be chained after match', () {
        // Arrange
        const result = Right<Failure, int>(10);

        // Act
        final doubled = result
            .match(
              onFailure: (_) {},
              onSuccess: (v) => v,
            )
            .mapRightX((v) => v * 2);

        // Assert
        expect(doubled.rightOrNull, equals(20));
      });

      test('uses successTag for logging', () {
        // Arrange
        const result = Right<Failure, String>('data');

        // Act & Assert - just verify it doesn't throw
        expect(
          () => result.match(
            onFailure: (_) {},
            onSuccess: (_) {},
            successTag: 'API_CALL',
          ),
          returnsNormally,
        );
      });

      test('handles null success tag', () {
        // Arrange
        const result = Right<Failure, String>('data');

        // Act & Assert
        expect(
          () => result.match(
            onFailure: (_) {},
            onSuccess: (_) {},
          ),
          returnsNormally,
        );
      });
    });

    group('getOrElse()', () {
      test('returns value for Right', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        final value = result.getOrElse(0);

        // Assert
        expect(value, equals(42));
      });

      test('returns fallback for Left', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final value = result.getOrElse(0);

        // Assert
        expect(value, equals(0));
      });

      test('preserves type of fallback', () {
        // Arrange
        const result = Left<Failure, String>(
          Failure(type: UnknownFailureType()),
        );

        // Act
        final value = result.getOrElse('default');

        // Assert
        expect(value, isA<String>());
        expect(value, equals('default'));
      });

      test('handles complex types', () {
        // Arrange
        final result = Left<Failure, Map<String, int>>(
          const Failure(type: ApiFailureType()),
        );

        // Act
        final value = result.getOrElse({'default': 0});

        // Assert
        expect(value, equals({'default': 0}));
      });

      test('handles null as fallback', () {
        // Arrange
        const result = Left<Failure, String?>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final value = result.getOrElse(null);

        // Assert
        expect(value, isNull);
      });
    });

    group('failureMessage', () {
      test('returns message for Left with message', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(
            type: NetworkFailureType(),
            message: 'Connection timeout',
          ),
        );

        // Act
        final message = result.failureMessage;

        // Assert
        expect(message, equals('Connection timeout'));
      });

      test('returns null for Left without message', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final message = result.failureMessage;

        // Assert
        expect(message, isNull);
      });

      test('returns null for Right', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        final message = result.failureMessage;

        // Assert
        expect(message, isNull);
      });

      test('handles empty message', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: ''),
        );

        // Act
        final message = result.failureMessage;

        // Assert
        expect(message, equals(''));
        expect(message, isEmpty);
      });
    });

    group('mapRightX()', () {
      test('transforms Right value', () {
        // Arrange
        const result = Right<Failure, int>(10);

        // Act
        final doubled = result.mapRightX((v) => v * 2);

        // Assert
        expect(doubled.rightOrNull, equals(20));
      });

      test('preserves Left unchanged', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );

        // Act
        final mapped = result.mapRightX((v) => v * 2);

        // Assert
        expect(mapped.isLeft, isTrue);
        expect(mapped.leftOrNull?.message, equals('Error'));
      });

      test('can transform to different type', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        final transformed = result.mapRightX((v) => 'Value: $v');

        // Assert
        expect(transformed, isA<Either<Failure, String>>());
        expect(transformed.rightOrNull, equals('Value: 42'));
      });

      test('can chain multiple mapRightX calls', () {
        // Arrange
        const result = Right<Failure, int>(5);

        // Act
        final transformed = result
            .mapRightX((v) => v * 2) // 10
            .mapRightX((v) => v + 5) // 15
            .mapRightX((v) => v.toString()); // "15"

        // Assert
        expect(transformed.rightOrNull, equals('15'));
      });

      test('handles complex transformations', () {
        // Arrange
        const result = Right<Failure, String>('hello');

        // Act
        final transformed = result.mapRightX(
          (v) => {
            'original': v,
            'length': v.length,
            'uppercase': v.toUpperCase(),
          },
        );

        // Assert
        final map = transformed.rightOrNull;
        expect(map?['original'], equals('hello'));
        expect(map?['length'], equals(5));
        expect(map?['uppercase'], equals('HELLO'));
      });
    });

    group('mapLeftX()', () {
      test('transforms Left failure', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );

        // Act
        final transformed = result.mapLeftX(
          (f) => Failure(
            type: f.type,
            message: 'Transformed: ${f.message}',
          ),
        );

        // Assert
        expect(transformed.isLeft, isTrue);
        expect(
          transformed.leftOrNull?.message,
          equals('Transformed: Error'),
        );
      });

      test('preserves Right unchanged', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        final mapped = result.mapLeftX(
          (f) => Failure(
            type: f.type,
            message: 'Should not be called',
          ),
        );

        // Assert
        expect(mapped.isRight, isTrue);
        expect(mapped.rightOrNull, equals(42));
      });

      test('can change failure type', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final transformed = result.mapLeftX(
          (f) => Failure(
            type: const ApiFailureType(),
            message: 'Converted to API error',
          ),
        );

        // Assert
        expect(transformed.leftOrNull?.type, isA<ApiFailureType>());
        expect(
          transformed.leftOrNull?.message,
          equals('Converted to API error'),
        );
      });

      test('can chain mapLeftX calls', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );

        // Act
        final transformed = result
            .mapLeftX(
              (f) => Failure(type: f.type, message: 'Step1: ${f.message}'),
            )
            .mapLeftX(
              (f) => Failure(type: f.type, message: 'Step2: ${f.message}'),
            );

        // Assert
        expect(
          transformed.leftOrNull?.message,
          equals('Step2: Step1: Error'),
        );
      });
    });

    group('isUnauthorizedFailure', () {
      test('returns true for unauthorized failure', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: UnauthorizedFailureType()),
        );

        // Act
        final isUnauthorized = result.isUnauthorizedFailure;

        // Assert
        expect(isUnauthorized, isTrue);
      });

      test('returns false for other failure types', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final isUnauthorized = result.isUnauthorizedFailure;

        // Assert
        expect(isUnauthorized, isFalse);
      });

      test('returns false for Right', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        final isUnauthorized = result.isUnauthorizedFailure;

        // Assert
        expect(isUnauthorized, isFalse);
      });

      test('checks by safeCode UNAUTHORIZED', () {
        // Arrange
        const result1 = Left<Failure, int>(
          Failure(type: UnauthorizedFailureType()),
        );
        // When statusCode is provided, safeCode returns statusCode, not type.code
        const result2 = Left<Failure, int>(
          Failure(type: UnauthorizedFailureType(), statusCode: 401),
        );

        // Assert
        expect(result1.isUnauthorizedFailure, isTrue);
        // result2 has safeCode='401' not 'UNAUTHORIZED', so it's not detected
        expect(result2.isUnauthorizedFailure, isFalse);
      });
    });

    group('emitStates()', () {
      test('calls emitLoading then emitFailure for Left', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType(), message: 'Error'),
        );
        var loadingCalled = false;
        Failure? emittedFailure;

        // Act
        result.emitStates(
          emitLoading: () => loadingCalled = true,
          emitFailure: (f) => emittedFailure = f,
          emitSuccess: (_) {},
        );

        // Assert
        expect(loadingCalled, isTrue);
        expect(emittedFailure, isNotNull);
        expect(emittedFailure?.message, equals('Error'));
      });

      test('calls emitLoading then emitSuccess for Right', () {
        // Arrange
        const result = Right<Failure, int>(42);
        var loadingCalled = false;
        int? emittedValue;

        // Act
        result.emitStates(
          emitLoading: () => loadingCalled = true,
          emitFailure: (_) {},
          emitSuccess: (v) => emittedValue = v,
        );

        // Assert
        expect(loadingCalled, isTrue);
        expect(emittedValue, equals(42));
      });

      test('works without emitLoading callback', () {
        // Arrange
        const result = Right<Failure, String>('data');
        String? emittedValue;

        // Act
        result.emitStates(
          emitFailure: (_) {},
          emitSuccess: (v) => emittedValue = v,
        );

        // Assert
        expect(emittedValue, equals('data'));
      });

      test('emits in correct order: loading -> failure', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        final calls = <String>[];

        // Act
        result.emitStates(
          emitLoading: () => calls.add('loading'),
          emitFailure: (_) => calls.add('failure'),
          emitSuccess: (_) => calls.add('success'),
        );

        // Assert
        expect(calls, equals(['loading', 'failure']));
      });

      test('emits in correct order: loading -> success', () {
        // Arrange
        const result = Right<Failure, int>(42);
        final calls = <String>[];

        // Act
        result.emitStates(
          emitLoading: () => calls.add('loading'),
          emitFailure: (_) => calls.add('failure'),
          emitSuccess: (_) => calls.add('success'),
        );

        // Assert
        expect(calls, equals(['loading', 'success']));
      });
    });

    group('real-world scenarios', () {
      test('API call with fallback value', () {
        // Arrange
        const result = Left<Failure, List<String>>(
          Failure(type: NetworkFailureType(), message: 'Offline'),
        );

        // Act
        final data = result.getOrElse([]);

        // Assert
        expect(data, isEmpty);
      });

      test('transform API response data', () {
        // Arrange
        final result = Right<Failure, Map<String, dynamic>>(const {
          'id': 1,
          'name': 'User',
        });

        // Act
        final userId = result.mapRightX((data) => data['id'] as int);

        // Assert
        expect(userId.rightOrNull, equals(1));
      });

      test('check unauthorized and redirect to login', () {
        // Arrange
        // Don't provide statusCode so safeCode returns type.code 'UNAUTHORIZED'
        const result = Left<Failure, dynamic>(
          Failure(type: UnauthorizedFailureType()),
        );

        // Act
        final shouldRedirect = result.isUnauthorizedFailure;

        // Assert
        expect(shouldRedirect, isTrue);
      });

      test('emit loading and success states to BLoC', () {
        // Arrange
        const result = Right<Failure, List<String>>(['item1', 'item2']);
        final states = <String>[];

        // Act
        result.emitStates(
          emitLoading: () => states.add('loading'),
          emitFailure: (_) => states.add('error'),
          emitSuccess: (data) => states.add('loaded: ${data.length} items'),
        );

        // Assert
        expect(states, equals(['loading', 'loaded: 2 items']));
      });

      test('extract error message for UI display', () {
        // Arrange
        const result = Left<Failure, dynamic>(
          Failure(
            type: ApiFailureType(),
            message: 'Server is unavailable',
          ),
        );

        // Act
        final message = result.failureMessage ?? 'Unknown error';

        // Assert
        expect(message, equals('Server is unavailable'));
      });

      test('chain transformations for data processing', () {
        // Arrange
        const result = Right<Failure, String>('  hello world  ');

        // Act
        final processed = result
            .mapRightX((s) => s.trim())
            .mapRightX((s) => s.toUpperCase())
            .mapRightX((s) => s.split(' '))
            .mapRightX((list) => list.length);

        // Assert
        expect(processed.rightOrNull, equals(2));
      });
    });

    group('composition', () {
      test('combines match with mapRightX', () {
        // Arrange
        const result = Right<Failure, int>(10);
        int? matchedValue;

        // Act
        final transformed = result
            .match(
              onFailure: (_) {},
              onSuccess: (v) => matchedValue = v,
            )
            .mapRightX((v) => v * 3);

        // Assert
        expect(matchedValue, equals(10));
        expect(transformed.rightOrNull, equals(30));
      });

      test('combines getOrElse with further processing', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final value = result.getOrElse(0);
        final processed = value + 10;

        // Assert
        expect(processed, equals(10));
      });

      test('uses isUnauthorizedFailure for conditional flow', () {
        // Arrange
        const result = Left<Failure, dynamic>(
          Failure(type: UnauthorizedFailureType()),
        );

        // Act
        final action = result.isUnauthorizedFailure
            ? 'redirect_to_login'
            : 'show_error';

        // Assert
        expect(action, equals('redirect_to_login'));
      });
    });

    group('edge cases', () {
      test('handles transformation that returns null', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        final transformed = result.mapRightX<int?>((_) => null);

        // Assert
        expect(transformed.rightOrNull, isNull);
      });

      test('handles zero value in Right', () {
        // Arrange
        const result = Right<Failure, int>(0);

        // Act
        final value = result.getOrElse(100);

        // Assert
        expect(value, equals(0));
      });

      test('handles false value in Right', () {
        // Arrange
        const result = Right<Failure, bool>(false);

        // Act
        final value = result.getOrElse(true);

        // Assert
        expect(value, equals(false));
      });

      test('handles empty collection in Right', () {
        // Arrange
        final result = Right<Failure, List<int>>(const []);

        // Act
        final value = result.getOrElse([1, 2, 3]);

        // Assert
        expect(value, isEmpty);
      });
    });
  });
}
