import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';
import 'package:core/src/base_modules/navigation/utils/extensions/navigation_x_on_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureNavigationX', () {
    group('redirectIfUnauthorized', () {
      test('calls callback when failure is unauthorized (401)', () {
        // Arrange
        const failure = Failure(
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
          message: 'Unauthorized',
          statusCode: 401,
        );
        const forbiddenFailure = Failure(
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
        const failure401 = Failure(message: 'Unauthorized', statusCode: 401);
        var callback401Called = false;

        // Act
        failure401.redirectIfUnauthorized(() => callback401Called = true);

        // Assert
        expect(callback401Called, isTrue);
      });

      test('does not call callback for client errors other than 401', () {
        // Arrange
        const failures = [
          Failure(message: 'Bad Request', statusCode: 400),
          Failure(message: 'Forbidden', statusCode: 403),
          Failure(message: 'Not Found', statusCode: 404),
          Failure(message: 'Conflict', statusCode: 409),
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
          Failure(message: 'Internal Server Error', statusCode: 500),
          Failure(message: 'Bad Gateway', statusCode: 502),
          Failure(message: 'Service Unavailable', statusCode: 503),
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
          message: 'Network Error',
          tag: FailureTag.networkFailure,
        );
        var callbackCalled = false;

        // Act
        failure.redirectIfUnauthorized(() => callbackCalled = true);

        // Assert
        expect(callbackCalled, isFalse);
      });

      test('can be chained with other operations', () {
        // Arrange
        const failure = Failure(message: 'Unauthorized', statusCode: 401);
        var redirectCalled = false;
        var chainedOperationResult = '';

        // Act
        final result = failure
            .redirectIfUnauthorized(() => redirectCalled = true)
            .copyWith(message: 'Updated message');

        chainedOperationResult = result.message;

        // Assert
        expect(redirectCalled, isTrue);
        expect(chainedOperationResult, equals('Updated message'));
      });

      test('callback can perform side effects', () {
        // Arrange
        const failure = Failure(message: 'Unauthorized', statusCode: 401);
        final sideEffects = <String>[];

        void onUnauthorized() {
          sideEffects..add('Logged out')
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
          message: 'Session expired',
          statusCode: 401,
          tag: FailureTag.serverFailure,
        );
        var callbackCalled = false;

        // Act
        failure.redirectIfUnauthorized(() => callbackCalled = true);

        // Assert
        expect(callbackCalled, isTrue);
      });

      test('is safe to call multiple times on same failure', () {
        // Arrange
        const failure = Failure(message: 'Unauthorized', statusCode: 401);
        var callCount = 0;

        // Act
        failure..redirectIfUnauthorized(() => callCount++)
        ..redirectIfUnauthorized(() => callCount++)
        ..redirectIfUnauthorized(() => callCount++);

        // Assert
        expect(callCount, equals(3));
      });

      test('does not modify the original failure', () {
        // Arrange
        const failure = Failure(
          message: 'Unauthorized',
          statusCode: 401,
          tag: FailureTag.serverFailure,
        );
        const originalMessage = 'Unauthorized';
        const originalStatusCode = 401;
        const originalTag = FailureTag.serverFailure;

        // Act
        failure.redirectIfUnauthorized(() {});

        // Assert - failure is immutable
        expect(failure.message, equals(originalMessage));
        expect(failure.statusCode, equals(originalStatusCode));
        expect(failure.tag, equals(originalTag));
      });

      test('works with void callback', () {
        // Arrange
        const failure = Failure(message: 'Unauthorized', statusCode: 401);

        // Act & Assert - should not throw
        expect(
          () => failure.redirectIfUnauthorized(() {}),
          returnsNormally,
        );
      });

      test('handles callback throwing exception gracefully', () {
        // Arrange
        const failure = Failure(message: 'Unauthorized', statusCode: 401);

        void throwingCallback() {
          throw Exception('Callback error');
        }

        // Act & Assert
        expect(
          () => failure.redirectIfUnauthorized(throwingCallback),
          throwsException,
        );
      });
    });
  });
}
