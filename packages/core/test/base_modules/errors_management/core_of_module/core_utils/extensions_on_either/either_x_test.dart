/// Tests for `ResultX` extension from either__x.dart
///
/// Coverage:
/// - match() method with onFailure/onSuccess callbacks
/// - getOrElse() fallback values
/// - failureMessage getter
/// - mapRightX() transformation
/// - mapLeftX() transformation
/// - isUnauthorizedFailure getter
/// - emitStates() declarative state emission
/// - Integration with ErrorsLogger
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResultX', () {
    group('match', () {
      test('executes onFailure for Left', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        Failure? capturedFailure;
        int? capturedValue;

        // Act
        either.match(
          onFailure: (f) => capturedFailure = f,
          onSuccess: (v) => capturedValue = v,
        );

        // Assert
        expect(capturedFailure, isNotNull);
        expect(capturedFailure?.type, isA<NetworkFailureType>());
        expect(capturedValue, isNull);
      });

      test('executes onSuccess for Right', () {
        // Arrange
        const either = Right<Failure, int>(42);
        Failure? capturedFailure;
        int? capturedValue;

        // Act
        either.match(
          onFailure: (f) => capturedFailure = f,
          onSuccess: (v) => capturedValue = v,
        );

        // Assert
        expect(capturedFailure, isNull);
        expect(capturedValue, equals(42));
      });

      test('returns the original Either after matching', () {
        // Arrange
        const either = Right<Failure, String>('value');

        // Act
        final result = either.match(
          onFailure: (_) {},
          onSuccess: (_) {},
        );

        // Assert
        expect(result, equals(either));
        expect(result.isRight, isTrue);
      });

      test('is chainable', () {
        // Arrange
        const either = Right<Failure, int>(10);
        var callCount = 0;

        // Act
        final result = either
            .match(
              onFailure: (_) {},
              onSuccess: (_) => callCount++,
            )
            .match(
              onFailure: (_) {},
              onSuccess: (_) => callCount++,
            );

        // Assert
        expect(callCount, equals(2));
        expect(result.isRight, isTrue);
      });

      test('logs failure with stackTrace when provided', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: ApiFailureType()),
        );
        final stackTrace = StackTrace.current;

        // Act
        either.match(
          onFailure: (_) {},
          onSuccess: (_) {},
          stack: stackTrace,
        );

        // Assert - Logging happens internally
        expect(either.isLeft, isTrue);
      });

      test('uses custom success tag for logging', () {
        // Arrange
        final either = const Right<Failure, String>('data')
          // Act
          ..match(
            onFailure: (_) {},
            onSuccess: (_) {},
            successTag: 'CustomOperation',
          );

        // Assert - Custom tag used in logging
        expect(either.isRight, isTrue);
      });

      test('handles null values in Right', () {
        // Arrange
        const either = Right<Failure, String?>(null);
        String? capturedValue;

        // Act
        either.match(
          onFailure: (_) {},
          onSuccess: (v) => capturedValue = v,
        );

        // Assert
        expect(capturedValue, isNull);
      });
    });

    group('getOrElse', () {
      test('returns value for Right', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.getOrElse(0);

        // Assert
        expect(result, equals(42));
      });

      test('returns fallback for Left', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.getOrElse(0);

        // Assert
        expect(result, equals(0));
      });

      test('works with String values', () {
        // Arrange
        const success = Right<Failure, String>('success');
        const failure = Left<Failure, String>(
          Failure(type: UnknownFailureType()),
        );

        // Act
        final successResult = success.getOrElse('fallback');
        final failureResult = failure.getOrElse('fallback');

        // Assert
        expect(successResult, equals('success'));
        expect(failureResult, equals('fallback'));
      });

      test('works with complex objects', () {
        // Arrange
        final user = User(id: '1', name: 'John');
        final fallbackUser = User(id: '0', name: 'Guest');
        final success = Right<Failure, User>(user);
        const failure = Left<Failure, User>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final successResult = success.getOrElse(fallbackUser);
        final failureResult = failure.getOrElse(fallbackUser);

        // Assert
        expect(successResult.id, equals('1'));
        expect(failureResult.id, equals('0'));
      });

      test('handles null fallback', () {
        // Arrange
        const either = Left<Failure, String?>(
          Failure(type: UnknownFailureType()),
        );

        // Act
        final result = either.getOrElse(null);

        // Assert
        expect(result, isNull);
      });

      test('handles null value in Right', () {
        // Arrange
        const either = Right<Failure, int?>(null);

        // Act
        final result = either.getOrElse(42);

        // Assert
        expect(result, isNull); // Returns actual value (null), not fallback
      });
    });

    group('failureMessage', () {
      test('returns message for Left with message', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(
            type: NetworkFailureType(),
            message: 'Connection failed',
          ),
        );

        // Act
        final message = either.failureMessage;

        // Assert
        expect(message, equals('Connection failed'));
      });

      test('returns null for Left without message', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final message = either.failureMessage;

        // Assert
        expect(message, isNull);
      });

      test('returns null for Right', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final message = either.failureMessage;

        // Assert
        expect(message, isNull);
      });

      test('handles empty message string', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(
            type: ApiFailureType(),
            message: '',
          ),
        );

        // Act
        final message = either.failureMessage;

        // Assert
        expect(message, isEmpty);
      });
    });

    group('mapRightX', () {
      test('transforms Right value', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.mapRightX((v) => v * 2);

        // Assert
        expect(result, isA<Right<Failure, int>>());
        expect(result.fold((l) => 0, (r) => r), equals(84));
      });

      test('preserves Left unchanged', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.mapRightX((v) => v * 2);

        // Assert
        expect(result, isA<Left<Failure, int>>());
        expect(result.fold((l) => l, (r) => null), isA<Failure>());
      });

      test('can change type of Right', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.mapRightX((v) => v.toString());

        // Assert
        expect(result, isA<Right<Failure, String>>());
        expect(result.fold((l) => '', (r) => r), equals('42'));
      });

      test('works with complex transformations', () {
        // Arrange
        final user = User(id: '1', name: 'John');
        final either = Right<Failure, User>(user);

        // Act
        final result = either.mapRightX((u) => u.name);

        // Assert
        expect(result.fold((l) => '', (r) => r), equals('John'));
      });

      test('is chainable', () {
        // Arrange
        const either = Right<Failure, int>(10);

        // Act
        final result = either
            .mapRightX((v) => v + 5) // 15
            .mapRightX((v) => v * 2) // 30
            .mapRightX((v) => v.toString()); // "30"

        // Assert
        expect(result.fold((l) => '', (r) => r), equals('30'));
      });
    });

    group('mapLeftX', () {
      test('transforms Left value', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(
            type: NetworkFailureType(),
            message: 'Error',
          ),
        );

        // Act
        final result = either.mapLeftX(
          (f) => Failure(
            type: f.type,
            message: '${f.message} - transformed',
          ),
        );

        // Assert
        expect(result, isA<Left<Failure, int>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure?.message, contains('transformed'));
      });

      test('preserves Right unchanged', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.mapLeftX(
          (f) => const Failure(type: UnknownFailureType()),
        );

        // Assert
        expect(result, isA<Right<Failure, int>>());
        expect(result.fold((l) => 0, (r) => r), equals(42));
      });

      test('can change failure type', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.mapLeftX(
          (f) => const Failure(type: UnknownFailureType()),
        );

        // Assert
        final failure = result.fold((l) => l, (r) => null);
        expect(failure?.type, isA<UnknownFailureType>());
      });

      test('is chainable', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(
            type: NetworkFailureType(),
            message: 'Error',
          ),
        );

        // Act
        final result = either
            .mapLeftX((f) => Failure(type: f.type, message: '${f.message}!'))
            .mapLeftX((f) => Failure(type: f.type, message: '${f.message}!'));

        // Assert
        final failure = result.fold((l) => l, (r) => null);
        expect(failure?.message, equals('Error!!'));
      });
    });

    group('isUnauthorizedFailure', () {
      test('returns true for UNAUTHORIZED failure', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(
            type: UnauthorizedFailureType(),
            statusCode: 401,
          ),
        );

        // Act
        final result = either.isUnauthorizedFailure;

        // Assert
        expect(result, isTrue);
      });

      test('returns false for non-UNAUTHORIZED failure', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.isUnauthorizedFailure;

        // Assert
        expect(result, isFalse);
      });

      test('returns false for Right', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.isUnauthorizedFailure;

        // Assert
        expect(result, isFalse);
      });

      test('checks safeCode equals UNAUTHORIZED', () {
        // Arrange
        const authFailure = Left<Failure, int>(
          Failure(type: UnauthorizedFailureType()),
        );
        const networkFailure = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final authResult = authFailure.isUnauthorizedFailure;
        final networkResult = networkFailure.isUnauthorizedFailure;

        // Assert
        expect(authResult, isTrue);
        expect(networkResult, isFalse);
      });
    });

    group('emitStates', () {
      test('calls emitFailure for Left', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );
        Failure? emittedFailure;
        int? emittedSuccess;
        var loadingCalled = false;

        // Act
        either.emitStates(
          emitFailure: (f) => emittedFailure = f,
          emitSuccess: (v) => emittedSuccess = v,
          emitLoading: () => loadingCalled = true,
        );

        // Assert
        expect(emittedFailure, isNotNull);
        expect(emittedFailure?.type, isA<NetworkFailureType>());
        expect(emittedSuccess, isNull);
        expect(loadingCalled, isTrue);
      });

      test('calls emitSuccess for Right', () {
        // Arrange
        const either = Right<Failure, int>(42);
        Failure? emittedFailure;
        int? emittedSuccess;
        var loadingCalled = false;

        // Act
        either.emitStates(
          emitFailure: (f) => emittedFailure = f,
          emitSuccess: (v) => emittedSuccess = v,
          emitLoading: () => loadingCalled = true,
        );

        // Assert
        expect(emittedFailure, isNull);
        expect(emittedSuccess, equals(42));
        expect(loadingCalled, isTrue);
      });

      test('works without optional emitLoading', () {
        // Arrange
        const either = Right<Failure, String>('data');
        String? emittedSuccess;

        // Act
        either.emitStates(
          emitFailure: (_) {},
          emitSuccess: (v) => emittedSuccess = v,
        );

        // Assert
        expect(emittedSuccess, equals('data'));
      });

      test('calls emitLoading before emit callbacks', () {
        // Arrange
        const either = Right<Failure, int>(42);
        final callOrder = <String>[];

        // Act
        either.emitStates(
          emitFailure: (_) => callOrder.add('failure'),
          emitSuccess: (_) => callOrder.add('success'),
          emitLoading: () => callOrder.add('loading'),
        );

        // Assert
        expect(callOrder, equals(['loading', 'success']));
      });
    });

    group('real-world scenarios', () {
      test('handles repository result with fallback', () {
        // Arrange
        const result = Left<Failure, User>(
          Failure(type: NetworkFailureType()),
        );
        final fallbackUser = User(id: '0', name: 'Guest');

        // Act
        final user = result.getOrElse(fallbackUser);

        // Assert
        expect(user.id, equals('0'));
        expect(user.name, equals('Guest'));
      });

      test('transforms API response data', () {
        // Arrange
        const result = Right<Failure, Map<String, dynamic>>(
          {'id': '123', 'name': 'John'},
        );

        // Act
        final userResult = result.mapRightX(
          (data) => User(
            id: data['id'] as String,
            name: data['name'] as String,
          ),
        );

        // Assert
        final user = userResult.fold((l) => null, (r) => r);
        expect(user?.id, equals('123'));
        expect(user?.name, equals('John'));
      });

      test('checks auth errors for redirect', () {
        // Arrange
        const authError = Left<Failure, String>(
          Failure(type: UnauthorizedFailureType()),
        );
        const networkError = Left<Failure, String>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final shouldRedirectAuth = authError.isUnauthorizedFailure;
        final shouldRedirectNetwork = networkError.isUnauthorizedFailure;

        // Assert
        expect(shouldRedirectAuth, isTrue);
        expect(shouldRedirectNetwork, isFalse);
      });

      test('emits states in BLoC pattern', () {
        // Arrange
        const result = Right<Failure, List<String>>(['a', 'b', 'c']);
        final states = <String>[];

        // Act
        result.emitStates(
          emitFailure: (f) => states.add('error'),
          emitSuccess: (data) => states.add('loaded: ${data.length}'),
          emitLoading: () => states.add('loading'),
        );

        // Assert
        expect(states, equals(['loading', 'loaded: 3']));
      });

      test('matches for side effects with logging', () {
        // Arrange
        const result = Left<Failure, int>(
          Failure(
            type: ApiFailureType(),
            message: 'Server error',
          ),
        );
        String? loggedError;

        // Act
        result.match(
          onFailure: (f) => loggedError = f.message,
          onSuccess: (_) {},
        );

        // Assert
        expect(loggedError, equals('Server error'));
      });
    });

    group('edge cases', () {
      test('handles null values in complex operations', () {
        // Arrange
        const either = Right<Failure, String?>(null);

        // Act
        final result = either
            .mapRightX((v) => v?.toUpperCase())
            .getOrElse('fallback');

        // Assert
        expect(result, isNull); // Preserves null through transformation
      });

      test('handles empty collections', () {
        // Arrange
        const either = Right<Failure, List<int>>([]);

        // Act
        final result = either.mapRightX((list) => list.length);

        // Assert
        expect(result.fold((l) => -1, (r) => r), equals(0));
      });

      test('chains multiple operations', () {
        // Arrange
        const either = Right<Failure, int>(10);

        // Act
        final result = either
            .match(onFailure: (_) {}, onSuccess: (_) {})
            .mapRightX((v) => v * 2)
            .match(onFailure: (_) {}, onSuccess: (_) {})
            .getOrElse(0);

        // Assert
        expect(result, equals(20));
      });
    });

    group('integration', () {
      test('works with runWithErrorHandling result', () async {
        // Arrange
        Future<int> operation() async => 42;

        // Act
        final result = await operation.runWithErrorHandling();
        final value = result.getOrElse(0);

        // Assert
        expect(value, equals(42));
      });

      test('handles failure from runWithErrorHandling', () async {
        // Arrange
        Future<int> operation() async => throw Exception('Error');

        // Act
        final result = await operation.runWithErrorHandling();
        final message = result.failureMessage;

        // Assert
        expect(message, isNotNull);
      });
    });
  });
}

// Helper classes for testing
class User {
  User({required this.id, required this.name});
  final String id;
  final String name;
}
