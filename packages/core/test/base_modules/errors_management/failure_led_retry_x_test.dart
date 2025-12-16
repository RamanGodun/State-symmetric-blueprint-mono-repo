/// Tests for `FailureRetryX` and `FailureTypeRetryX` extensions
///
/// Coverage:
/// - FailureRetryX.isRetryable getter
/// - FailureTypeRetryX.isRetryable getter
/// - All FailureType variants retryability
/// - UI integration scenarios
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureRetryX', () {
    group('isRetryable', () {
      test('returns true for NetworkFailureType', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isTrue);
      });

      test('returns true for NetworkTimeoutFailureType', () {
        // Arrange
        const failure = Failure(
          type: NetworkTimeoutFailureType(),
          message: 'Request timeout',
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isTrue);
      });

      test('returns false for ApiFailureType', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Server error',
          statusCode: 500,
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('returns false for UnauthorizedFailureType', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Invalid credentials',
          statusCode: 401,
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('returns false for CacheFailureType', () {
        // Arrange
        const failure = Failure(type: CacheFailureType());

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('returns false for JsonErrorFailureType', () {
        // Arrange
        const failure = Failure(
          type: JsonErrorFailureType(),
          message: 'Failed to parse JSON',
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('returns false for FormatFailureType', () {
        // Arrange
        const failure = Failure(
          type: FormatFailureType(),
          message: 'Invalid format',
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('returns false for UnknownFailureType', () {
        // Arrange
        const failure = Failure(
          type: UnknownFailureType(),
          message: 'Unknown error',
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('returns false for GenericFirebaseFailureType', () {
        // Arrange
        const failure = Failure(type: GenericFirebaseFailureType());

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('returns false for InvalidCredentialFirebaseFailureType', () {
        // Arrange
        const failure = Failure(
          type: InvalidCredentialFirebaseFailureType(),
          message: 'Invalid Firebase credentials',
        );

        // Act
        final isRetryable = failure.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });
    });

    group('delegation to FailureType', () {
      test('delegates to type.isRetryable for network failures', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());
        const type = NetworkFailureType();

        // Act
        final failureRetryable = failure.isRetryable;
        final typeRetryable = type.isRetryable;

        // Assert
        expect(failureRetryable, equals(typeRetryable));
        expect(failureRetryable, isTrue);
      });

      test('delegates to type.isRetryable for non-retryable failures', () {
        // Arrange
        const failure = Failure(type: ApiFailureType());
        const type = ApiFailureType();

        // Act
        final failureRetryable = failure.isRetryable;
        final typeRetryable = type.isRetryable;

        // Assert
        expect(failureRetryable, equals(typeRetryable));
        expect(failureRetryable, isFalse);
      });
    });
  });

  group('FailureTypeRetryX', () {
    group('isRetryable for each FailureType', () {
      test('NetworkFailureType is retryable', () {
        // Arrange
        const type = NetworkFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isTrue);
      });

      test('NetworkTimeoutFailureType is retryable', () {
        // Arrange
        const type = NetworkTimeoutFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isTrue);
      });

      test('ApiFailureType is not retryable', () {
        // Arrange
        const type = ApiFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('UnauthorizedFailureType is not retryable', () {
        // Arrange
        const type = UnauthorizedFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('CacheFailureType is not retryable', () {
        // Arrange
        const type = CacheFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('JsonErrorFailureType is not retryable', () {
        // Arrange
        const type = JsonErrorFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('FormatFailureType is not retryable', () {
        // Arrange
        const type = FormatFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('UnknownFailureType is not retryable', () {
        // Arrange
        const type = UnknownFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('GenericFirebaseFailureType is not retryable', () {
        // Arrange
        const type = GenericFirebaseFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });

      test('InvalidCredentialFirebaseFailureType is not retryable', () {
        // Arrange
        const type = InvalidCredentialFirebaseFailureType();

        // Act
        final isRetryable = type.isRetryable;

        // Assert
        expect(isRetryable, isFalse);
      });
    });

    group('consistency across all types', () {
      test('only network-related failures are retryable', () {
        // Arrange
        final allTypes = [
          const NetworkFailureType(),
          const NetworkTimeoutFailureType(),
          const ApiFailureType(),
          const UnauthorizedFailureType(),
          const CacheFailureType(),
          const JsonErrorFailureType(),
          const FormatFailureType(),
          const UnknownFailureType(),
          const GenericFirebaseFailureType(),
          const InvalidCredentialFirebaseFailureType(),
        ];

        // Act
        final retryableTypes = allTypes.where((t) => t.isRetryable).toList();
        final nonRetryableTypes = allTypes
            .where((t) => !t.isRetryable)
            .toList();

        // Assert
        expect(retryableTypes, hasLength(2)); // Network + Timeout
        expect(nonRetryableTypes, hasLength(8));
        expect(
          retryableTypes.every(
            (t) => t is NetworkFailureType || t is NetworkTimeoutFailureType,
          ),
          isTrue,
        );
      });

      test('all types have defined retryability', () {
        // Arrange
        final allTypes = [
          const NetworkFailureType(),
          const NetworkTimeoutFailureType(),
          const ApiFailureType(),
          const UnauthorizedFailureType(),
          const CacheFailureType(),
          const JsonErrorFailureType(),
          const FormatFailureType(),
          const UnknownFailureType(),
          const GenericFirebaseFailureType(),
          const InvalidCredentialFirebaseFailureType(),
        ];

        // Act & Assert - should not throw
        for (final type in allTypes) {
          expect(type.isRetryable, isA<bool>());
        }
      });
    });
  });

  group('UI integration scenarios', () {
    group('retry button visibility', () {
      test('shows retry button for network failure', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'No internet connection',
        );

        // Act
        final shouldShowRetry = failure.isRetryable;

        // Assert
        expect(shouldShowRetry, isTrue);
      });

      test('shows retry button for timeout failure', () {
        // Arrange
        const failure = Failure(
          type: NetworkTimeoutFailureType(),
          message: 'Request timed out',
        );

        // Act
        final shouldShowRetry = failure.isRetryable;

        // Assert
        expect(shouldShowRetry, isTrue);
      });

      test('hides retry button for authentication failure', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Invalid credentials',
          statusCode: 401,
        );

        // Act
        final shouldShowRetry = failure.isRetryable;

        // Assert
        expect(shouldShowRetry, isFalse);
      });

      test('hides retry button for server error', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Internal server error',
          statusCode: 500,
        );

        // Act
        final shouldShowRetry = failure.isRetryable;

        // Assert
        expect(shouldShowRetry, isFalse);
      });

      test('hides retry button for cache error', () {
        // Arrange
        const failure = Failure(
          type: CacheFailureType(),
          message: 'Cache read failed',
        );

        // Act
        final shouldShowRetry = failure.isRetryable;

        // Assert
        expect(shouldShowRetry, isFalse);
      });
    });

    group('error handling workflows', () {
      test('filters retryable failures for UI display', () {
        // Arrange
        const failures = [
          Failure(type: NetworkFailureType()),
          Failure(type: ApiFailureType(), statusCode: 404),
          Failure(type: NetworkTimeoutFailureType()),
          Failure(type: UnauthorizedFailureType()),
        ];

        // Act
        final retryableFailures = failures.where((f) => f.isRetryable).toList();

        // Assert
        expect(retryableFailures, hasLength(2));
        expect(retryableFailures[0].type, isA<NetworkFailureType>());
        expect(retryableFailures[1].type, isA<NetworkTimeoutFailureType>());
      });

      test('separates permanent from transient failures', () {
        // Arrange
        const failures = [
          Failure(type: NetworkFailureType()),
          Failure(type: CacheFailureType()),
          Failure(type: NetworkTimeoutFailureType()),
          Failure(type: JsonErrorFailureType()),
        ];

        // Act
        final transient = failures.where((f) => f.isRetryable).toList();
        final permanent = failures.where((f) => !f.isRetryable).toList();

        // Assert
        expect(transient, hasLength(2));
        expect(permanent, hasLength(2));
      });

      test('determines if operation should auto-retry', () {
        // Arrange
        const networkFailure = Failure(type: NetworkFailureType());
        const authFailure = Failure(type: UnauthorizedFailureType());

        // Act
        final shouldAutoRetryNetwork = networkFailure.isRetryable;
        final shouldAutoRetryAuth = authFailure.isRetryable;

        // Assert
        expect(shouldAutoRetryNetwork, isTrue);
        expect(shouldAutoRetryAuth, isFalse);
      });
    });

    group('conditional UI rendering', () {
      test('renders retry button based on failure type', () {
        // Arrange
        final testCases = [
          (
            failure: const Failure(type: NetworkFailureType()),
            expectRetry: true,
            label: 'Network error',
          ),
          (
            failure: const Failure(type: NetworkTimeoutFailureType()),
            expectRetry: true,
            label: 'Timeout',
          ),
          (
            failure: const Failure(type: ApiFailureType()),
            expectRetry: false,
            label: 'API error',
          ),
          (
            failure: const Failure(type: UnauthorizedFailureType()),
            expectRetry: false,
            label: 'Auth error',
          ),
          (
            failure: const Failure(type: CacheFailureType()),
            expectRetry: false,
            label: 'Cache error',
          ),
        ];

        // Act & Assert
        for (final testCase in testCases) {
          expect(
            testCase.failure.isRetryable,
            equals(testCase.expectRetry),
            reason: 'Failed for: ${testCase.label}',
          );
        }
      });

      test('generates appropriate UI action based on retryability', () {
        // Arrange
        const retryableFailure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );
        const permanentFailure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Access denied',
        );

        // Act
        final retryAction = retryableFailure.isRetryable ? 'Retry' : 'Dismiss';
        final permanentAction = permanentFailure.isRetryable
            ? 'Retry'
            : 'Dismiss';

        // Assert
        expect(retryAction, equals('Retry'));
        expect(permanentAction, equals('Dismiss'));
      });
    });
  });

  group('edge cases', () {
    test('handles failures with null message', () {
      // Arrange
      const failure = Failure(type: NetworkFailureType());

      // Act
      final isRetryable = failure.isRetryable;

      // Assert
      expect(isRetryable, isTrue);
      expect(failure.message, isNull);
    });

    test('handles failures with null statusCode', () {
      // Arrange
      const failure = Failure(
        type: NetworkTimeoutFailureType(),
        message: 'Timeout',
      );

      // Act
      final isRetryable = failure.isRetryable;

      // Assert
      expect(isRetryable, isTrue);
      expect(failure.statusCode, isNull);
    });

    test('retryability independent of message content', () {
      // Arrange
      const failure1 = Failure(
        type: NetworkFailureType(),
        message: 'Short error',
      );
      final longMessage = 'Very long error message ' * 100;
      final failure2 = Failure(
        type: const NetworkFailureType(),
        message: longMessage,
      );

      // Act
      final retry1 = failure1.isRetryable;
      final retry2 = failure2.isRetryable;

      // Assert
      expect(retry1, equals(retry2));
      expect(retry1, isTrue);
    });

    test('retryability independent of statusCode value', () {
      // Arrange
      const failure1 = Failure(
        type: NetworkFailureType(),
        statusCode: 0,
      );
      const failure2 = Failure(
        type: NetworkFailureType(),
        statusCode: 999,
      );

      // Act
      final retry1 = failure1.isRetryable;
      final retry2 = failure2.isRetryable;

      // Assert
      expect(retry1, equals(retry2));
      expect(retry1, isTrue);
    });
  });

  group('real-world scenarios', () {
    test('mobile app without internet connection', () {
      // Arrange
      const failure = Failure(
        type: NetworkFailureType(),
        message: 'No internet connection',
      );

      // Act
      final canRetry = failure.isRetryable;

      // Assert
      expect(canRetry, isTrue);
    });

    test('API request timeout during slow connection', () {
      // Arrange
      const failure = Failure(
        type: NetworkTimeoutFailureType(),
        message: 'Request timeout after 30s',
      );

      // Act
      final canRetry = failure.isRetryable;

      // Assert
      expect(canRetry, isTrue);
    });

    test('user entered wrong password', () {
      // Arrange
      const failure = Failure(
        type: UnauthorizedFailureType(),
        message: 'Invalid password',
        statusCode: 401,
      );

      // Act
      final canRetry = failure.isRetryable;

      // Assert
      expect(canRetry, isFalse);
    });

    test('server returned 500 internal error', () {
      // Arrange
      const failure = Failure(
        type: ApiFailureType(),
        message: 'Internal server error',
        statusCode: 500,
      );

      // Act
      final canRetry = failure.isRetryable;

      // Assert
      expect(canRetry, isFalse);
    });

    test('local cache corrupted or missing', () {
      // Arrange
      const failure = Failure(
        type: CacheFailureType(),
        message: 'Failed to read cache',
      );

      // Act
      final canRetry = failure.isRetryable;

      // Assert
      expect(canRetry, isFalse);
    });

    test('invalid JSON response from API', () {
      // Arrange
      const failure = Failure(
        type: JsonErrorFailureType(),
        message: 'Expected valid JSON',
      );

      // Act
      final canRetry = failure.isRetryable;

      // Assert
      expect(canRetry, isFalse);
    });

    test('Firebase authentication failed', () {
      // Arrange
      const failure = Failure(
        type: InvalidCredentialFirebaseFailureType(),
        message: 'Firebase auth error',
      );

      // Act
      final canRetry = failure.isRetryable;

      // Assert
      expect(canRetry, isFalse);
    });
  });

  group('type consistency', () {
    test('failure and its type have same retryability', () {
      // Arrange
      final testCases = [
        const NetworkFailureType(),
        const NetworkTimeoutFailureType(),
        const ApiFailureType(),
        const UnauthorizedFailureType(),
        const CacheFailureType(),
      ];

      // Act & Assert
      for (final type in testCases) {
        final failure = Failure(type: type);
        expect(
          failure.isRetryable,
          equals(type.isRetryable),
          reason: 'Mismatch for ${type.runtimeType}',
        );
      }
    });

    test('isRetryable is deterministic for same type', () {
      // Arrange
      const type1 = NetworkFailureType();
      const type2 = NetworkFailureType();

      // Act
      final retry1 = type1.isRetryable;
      final retry2 = type2.isRetryable;

      // Assert
      expect(retry1, equals(retry2));
    });
  });
}
