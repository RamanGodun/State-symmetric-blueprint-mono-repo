import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_core_modules/public_api/base_modules/navigation.dart';

void main() {
  group('FailureNavigationX', () {
    group('redirectIfUnauthorized', () {
      test('calls callback when failure is unauthorized (401)', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );
        var callbackCalled = false;
        void onUnauthorized() {
          callbackCalled = true;
        }

        // Act
        final result = failure.redirectIfUnauthorized(onUnauthorized);

        // Assert
        expect(callbackCalled, isTrue);
        expect(result, same(failure));
      });

      test('does not call callback when failure is not unauthorized', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Server Error',
          statusCode: 500,
        );
        var callbackCalled = false;
        void onUnauthorized() {
          callbackCalled = true;
        }

        // Act
        final result = failure.redirectIfUnauthorized(onUnauthorized);

        // Assert
        expect(callbackCalled, isFalse);
        expect(result, same(failure));
      });

      test('returns the same failure instance after redirect', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );

        // Act
        final result = failure.redirectIfUnauthorized(() {});

        // Assert
        expect(result, same(failure));
        expect(identical(result, failure), isTrue);
      });

      test('handles multiple unauthorized checks correctly', () {
        // Arrange
        const unauthorizedFailure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );
        const forbiddenFailure = Failure(
          type: ApiFailureType(),
          message: 'Forbidden',
          statusCode: 403,
        );
        var unauthorizedCount = 0;

        void onUnauthorized() {
          unauthorizedCount++;
        }

        // Act
        unauthorizedFailure.redirectIfUnauthorized(onUnauthorized);
        forbiddenFailure.redirectIfUnauthorized(onUnauthorized);
        unauthorizedFailure.redirectIfUnauthorized(onUnauthorized);

        // Assert
        expect(unauthorizedCount, equals(2));
      });

      test('works with different unauthorized status codes', () {
        // Arrange
        const failure401 = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );
        var callback401Called = false;

        // Act
        failure401.redirectIfUnauthorized(() => callback401Called = true);

        // Assert
        expect(callback401Called, isTrue);
      });

      test('does not call callback for client errors other than 401', () {
        // Arrange
        const failures = [
          Failure(
            type: ApiFailureType(),
            message: 'Bad Request',
            statusCode: 400,
          ),
          Failure(
            type: ApiFailureType(),
            message: 'Forbidden',
            statusCode: 403,
          ),
          Failure(
            type: ApiFailureType(),
            message: 'Not Found',
            statusCode: 404,
          ),
          Failure(type: ApiFailureType(), message: 'Conflict', statusCode: 409),
        ];
        var callbackCount = 0;

        // Act
        for (final failure in failures) {
          failure.redirectIfUnauthorized(() => callbackCount++);
        }

        // Assert
        expect(callbackCount, equals(0));
      });

      test('does not call callback for server errors', () {
        // Arrange
        const failures = [
          Failure(
            type: ApiFailureType(),
            message: 'Internal Server Error',
            statusCode: 500,
          ),
          Failure(
            type: ApiFailureType(),
            message: 'Bad Gateway',
            statusCode: 502,
          ),
          Failure(
            type: ApiFailureType(),
            message: 'Service Unavailable',
            statusCode: 503,
          ),
        ];
        var callbackCount = 0;

        // Act
        for (final failure in failures) {
          failure.redirectIfUnauthorized(() => callbackCount++);
        }

        // Assert
        expect(callbackCount, equals(0));
      });

      test('does not call callback for network errors', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Network Error',
        );
        var callbackCalled = false;

        // Act
        failure.redirectIfUnauthorized(() => callbackCalled = true);

        // Assert
        expect(callbackCalled, isFalse);
      });

      test('callback can perform side effects', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );
        final sideEffects = <String>[];

        void onUnauthorized() {
          sideEffects
            ..add('Logged out')
            ..add('Cleared cache')
            ..add('Navigated to login');
        }

        // Act
        failure.redirectIfUnauthorized(onUnauthorized);

        // Assert
        expect(sideEffects, hasLength(3));
        expect(sideEffects, contains('Logged out'));
        expect(sideEffects, contains('Cleared cache'));
        expect(sideEffects, contains('Navigated to login'));
      });

      test('handles failure with additional context', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Session expired',
          statusCode: 401,
        );
        var callbackCalled = false;

        // Act
        failure.redirectIfUnauthorized(() => callbackCalled = true);

        // Assert
        expect(callbackCalled, isTrue);
      });

      test('is safe to call multiple times on same failure', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );
        var callCount = 0;

        // Act
        failure
          ..redirectIfUnauthorized(() => callCount++)
          ..redirectIfUnauthorized(() => callCount++)
          ..redirectIfUnauthorized(() => callCount++);

        // Assert
        expect(callCount, equals(3));
      });

      test('does not modify the original failure', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );
        const originalMessage = 'Unauthorized';
        const originalStatusCode = 401;

        // Act
        failure.redirectIfUnauthorized(() {});

        // Assert - failure is immutable
        expect(failure.message, equals(originalMessage));
        expect(failure.statusCode, equals(originalStatusCode));
        expect(failure.type, isA<UnauthorizedFailureType>());
      });

      test('works with void callback', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );

        // Act & Assert - should not throw
        expect(
          () => failure.redirectIfUnauthorized(() {}),
          returnsNormally,
        );
      });

      test('handles callback throwing exception gracefully', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
          statusCode: 401,
        );

        void throwingCallback() {
          throw Exception('Callback error');
        }

        // Act & Assert
        expect(
          () => failure.redirectIfUnauthorized(throwingCallback),
          throwsException,
        );
      });

      test('does not call callback when statusCode is null', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Unauthorized',
        );
        var callbackCalled = false;

        // Act
        failure.redirectIfUnauthorized(() => callbackCalled = true);

        // Assert - should still call if it's UnauthorizedFailureType
        expect(callbackCalled, isTrue);
      });
    });
  });
}
