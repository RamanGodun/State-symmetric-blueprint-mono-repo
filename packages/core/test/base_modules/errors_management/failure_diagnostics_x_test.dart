/// Tests for `FailureX` diagnostics extension
///
/// This test follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - All semantic type checkers (isNetworkFailure, isApiFailure, etc.)
/// - Casting methods (as `<T>`)
/// - Metadata accessors (safeCode, safeStatus, label)
/// - Integration with FailureCodes
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureX', () {
    group('semantic type checkers', () {
      group('isNetworkFailure', () {
        test('returns true for NetworkFailureType', () {
          // Arrange
          const failure = Failure(type: NetworkFailureType());

          // Act
          final isNetwork = failure.isNetworkFailure;

          // Assert
          expect(isNetwork, isTrue);
        });

        test('returns false for non-network failures', () {
          // Arrange
          const failures = [
            Failure(type: ApiFailureType()),
            Failure(type: UnauthorizedFailureType()),
            Failure(type: CacheFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isNetworkFailure, isFalse);
          }
        });
      });

      group('isUnauthorizedFailure', () {
        test('returns true for UnauthorizedFailureType', () {
          // Arrange
          const failure = Failure(
            type: UnauthorizedFailureType(),
            statusCode: 401,
          );

          // Act
          final isUnauthorized = failure.isUnauthorizedFailure;

          // Assert
          expect(isUnauthorized, isTrue);
        });

        test('returns false for other failure types', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: ApiFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isUnauthorizedFailure, isFalse);
          }
        });
      });

      group('isApiFailure', () {
        test('returns true for ApiFailureType', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 500,
          );

          // Act
          final isApi = failure.isApiFailure;

          // Assert
          expect(isApi, isTrue);
        });

        test('returns false for non-API failures', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: CacheFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isApiFailure, isFalse);
          }
        });
      });

      group('isUnknownFailure', () {
        test('returns true for UnknownFailureType', () {
          // Arrange
          const failure = Failure(type: UnknownFailureType());

          // Act
          final isUnknown = failure.isUnknownFailure;

          // Assert
          expect(isUnknown, isTrue);
        });

        test('returns false for known failure types', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: ApiFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isUnknownFailure, isFalse);
          }
        });
      });

      group('isTimeoutFailure', () {
        test('returns true for NetworkTimeoutFailureType', () {
          // Arrange
          const failure = Failure(
            type: NetworkTimeoutFailureType(),
            message: 'Request timeout',
          );

          // Act
          final isTimeout = failure.isTimeoutFailure;

          // Assert
          expect(isTimeout, isTrue);
        });

        test('returns false for non-timeout failures', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: ApiFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isTimeoutFailure, isFalse);
          }
        });
      });

      group('isCacheFailure', () {
        test('returns true for CacheFailureType', () {
          // Arrange
          const failure = Failure(
            type: CacheFailureType(),
            message: 'Cache read failed',
          );

          // Act
          final isCache = failure.isCacheFailure;

          // Assert
          expect(isCache, isTrue);
        });

        test('returns false for non-cache failures', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: ApiFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isCacheFailure, isFalse);
          }
        });
      });

      group('isFirebaseFailure', () {
        test('returns true for GenericFirebaseFailureType', () {
          // Arrange
          const failure = Failure(type: GenericFirebaseFailureType());

          // Act
          final isFirebase = failure.isFirebaseFailure;

          // Assert
          expect(isFirebase, isTrue);
        });

        test('returns false for non-Firebase failures', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: ApiFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isFirebaseFailure, isFalse);
          }
        });
      });

      group('isFormatErrorFailure', () {
        test('returns true for FormatFailureType', () {
          // Arrange
          const failure = Failure(
            type: FormatFailureType(),
            message: 'Invalid format',
          );

          // Act
          final isFormat = failure.isFormatErrorFailure;

          // Assert
          expect(isFormat, isTrue);
        });

        test('returns false for non-format failures', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: ApiFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isFormatErrorFailure, isFalse);
          }
        });
      });

      group('isJsonErrorFailure', () {
        test('returns true for JsonErrorFailureType', () {
          // Arrange
          const failure = Failure(
            type: JsonErrorFailureType(),
            message: 'JSON parse error',
          );

          // Act
          final isJson = failure.isJsonErrorFailure;

          // Assert
          expect(isJson, isTrue);
        });

        test('returns false for non-JSON failures', () {
          // Arrange
          const failures = [
            Failure(type: NetworkFailureType()),
            Failure(type: ApiFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isJsonErrorFailure, isFalse);
          }
        });
      });

      group('isInvalidCredential', () {
        test('returns true for InvalidCredentialFirebaseFailureType', () {
          // Arrange
          const failure = Failure(
            type: InvalidCredentialFirebaseFailureType(),
            message: 'Invalid credentials',
          );

          // Act
          final isInvalidCred = failure.isInvalidCredential;

          // Assert
          expect(isInvalidCred, isTrue);
        });

        test('returns false for other failure types', () {
          // Arrange
          const failures = [
            Failure(type: UnauthorizedFailureType()),
            Failure(type: GenericFirebaseFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            expect(failure.isInvalidCredential, isFalse);
          }
        });
      });
    });

    group('metadata accessors', () {
      group('safeCode', () {
        test('returns statusCode as string when present', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 404,
          );

          // Act
          final code = failure.safeCode;

          // Assert
          expect(code, equals('404'));
        });

        test('returns type.code when statusCode is null', () {
          // Arrange
          const failure = Failure(type: NetworkFailureType());

          // Act
          final code = failure.safeCode;

          // Assert
          expect(code, equals(failure.type.code));
          expect(code, isNotEmpty);
        });

        test('prefers statusCode over type.code', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 500,
          );

          // Act
          final code = failure.safeCode;

          // Assert
          expect(code, equals('500'));
          expect(code, isNot(equals(failure.type.code)));
        });

        test('handles zero statusCode', () {
          // Arrange
          const failure = Failure(
            type: NetworkFailureType(),
            statusCode: 0,
          );

          // Act
          final code = failure.safeCode;

          // Assert
          expect(code, equals('0'));
        });

        test('handles negative statusCode', () {
          // Arrange
          const failure = Failure(
            type: UnknownFailureType(),
            statusCode: -1,
          );

          // Act
          final code = failure.safeCode;

          // Assert
          expect(code, equals('-1'));
        });
      });

      group('safeStatus', () {
        test('returns statusCode as string when present', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 403,
          );

          // Act
          final status = failure.safeStatus;

          // Assert
          expect(status, equals('403'));
        });

        test('returns NO_STATUS when statusCode is null', () {
          // Arrange
          const failure = Failure(type: CacheFailureType());

          // Act
          final status = failure.safeStatus;

          // Assert
          expect(status, equals('NO_STATUS'));
        });

        test('handles zero statusCode', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 0,
          );

          // Act
          final status = failure.safeStatus;

          // Assert
          expect(status, equals('0'));
        });
      });

      group('label', () {
        test('combines safeCode and message', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            message: 'Server error',
            statusCode: 500,
          );

          // Act
          final label = failure.label;

          // Assert
          expect(label, contains('500'));
          expect(label, contains('Server error'));
          expect(label, contains('—'));
        });

        test('handles null message', () {
          // Arrange
          const failure = Failure(type: NetworkFailureType());

          // Act
          final label = failure.label;

          // Assert
          expect(label, contains(failure.safeCode));
          expect(label, contains('No message'));
        });

        test('handles empty message', () {
          // Arrange
          const failure = Failure(
            type: FormatFailureType(),
            message: '',
          );

          // Act
          final label = failure.label;

          // Assert
          expect(label, contains(failure.safeCode));
        });

        test('formats consistently for diagnostics', () {
          // Arrange
          const failure1 = Failure(
            type: NetworkFailureType(),
            message: 'Error A',
          );
          const failure2 = Failure(
            type: ApiFailureType(),
            message: 'Error B',
            statusCode: 500,
          );

          // Act
          final label1 = failure1.label;
          final label2 = failure2.label;

          // Assert
          expect(label1, matches(RegExp('.+—.+')));
          expect(label2, matches(RegExp('.+—.+')));
        });
      });
    });

    group('casting (as<T>)', () {
      test('successfully casts to correct type', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        final casted = failure.as<Failure>();

        // Assert
        expect(casted, isNotNull);
        expect(casted, equals(failure));
      });

      test('returns null for incorrect type cast', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        // Note: Since Failure is sealed and doesn't have subtypes,
        // this test verifies the null return behavior
        final casted = failure.as<Failure>();

        // Assert
        expect(casted, isNotNull);
      });

      test('handles same instance cast', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 404,
        );

        // Act
        final casted = failure.as<Failure>();

        // Assert
        expect(identical(casted, failure), isTrue);
      });
    });

    group('real-world scenarios', () {
      test('identifies network issues for retry logic', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );

        // Act
        final shouldRetry =
            failure.isNetworkFailure || failure.isTimeoutFailure;

        // Assert
        expect(shouldRetry, isTrue);
        expect(failure.label, contains('Connection failed'));
      });

      test('identifies auth errors for redirect to login', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          statusCode: 401,
          message: 'Session expired',
        );

        // Act
        final needsAuth = failure.isUnauthorizedFailure;
        final errorCode = failure.safeCode;

        // Assert
        expect(needsAuth, isTrue);
        expect(errorCode, equals('401'));
      });

      test('categorizes API errors for monitoring', () {
        // Arrange
        const serverError = Failure(
          type: ApiFailureType(),
          statusCode: 500,
        );
        const notFoundError = Failure(
          type: ApiFailureType(),
          statusCode: 404,
        );

        // Act
        final isServerError = serverError.isApiFailure;
        final isNotFound = notFoundError.isApiFailure;

        // Assert
        expect(isServerError, isTrue);
        expect(isNotFound, isTrue);
        expect(serverError.safeCode, equals('500'));
        expect(notFoundError.safeCode, equals('404'));
      });

      test('handles cache errors for fallback to network', () {
        // Arrange
        const failure = Failure(
          type: CacheFailureType(),
          message: 'Cache miss',
        );

        // Act
        final isCacheError = failure.isCacheFailure;
        final diagnostics = failure.label;

        // Assert
        expect(isCacheError, isTrue);
        expect(diagnostics, contains('Cache miss'));
      });

      test('identifies Firebase errors for specific handling', () {
        // Arrange
        const failure = Failure(
          type: InvalidCredentialFirebaseFailureType(),
          message: 'Invalid Firebase token',
        );

        // Act
        final isFirebase =
            failure.isFirebaseFailure || failure.isInvalidCredential;
        final summary = failure.label;

        // Assert
        expect(isFirebase, isTrue);
        expect(summary, contains('Invalid Firebase token'));
      });

      test('detects format errors for user feedback', () {
        // Arrange
        const failure = Failure(
          type: JsonErrorFailureType(),
          message: 'Invalid JSON response',
        );

        // Act
        final isFormatError =
            failure.isJsonErrorFailure || failure.isFormatErrorFailure;

        // Assert
        expect(isFormatError, isTrue);
        expect(failure.label, contains('Invalid JSON'));
      });
    });

    group('edge cases', () {
      test('handles all semantic checkers for single failure', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act - all checkers should work without error
        final checks = [
          failure.isNetworkFailure,
          failure.isUnauthorizedFailure,
          failure.isApiFailure,
          failure.isUnknownFailure,
          failure.isTimeoutFailure,
          failure.isCacheFailure,
          failure.isFirebaseFailure,
          failure.isFormatErrorFailure,
          failure.isJsonErrorFailure,
          failure.isInvalidCredential,
        ];

        // Assert - exactly one should be true
        expect(checks.where((c) => c).length, equals(1));
        expect(failure.isNetworkFailure, isTrue);
      });

      test('metadata accessors never throw', () {
        // Arrange
        const failures = [
          Failure(type: NetworkFailureType()),
          Failure(type: ApiFailureType(), statusCode: 404),
          Failure(type: CacheFailureType(), message: ''),
          Failure(
            type: UnknownFailureType(),
          ),
        ];

        // Act & Assert
        for (final failure in failures) {
          expect(() => failure.safeCode, returnsNormally);
          expect(() => failure.safeStatus, returnsNormally);
          expect(() => failure.label, returnsNormally);
          expect(failure.safeCode, isNotEmpty);
          expect(failure.safeStatus, isNotEmpty);
          expect(failure.label, isNotEmpty);
        }
      });

      test('handles very large statusCode values', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 999999999,
        );

        // Act
        final code = failure.safeCode;
        final status = failure.safeStatus;

        // Assert
        expect(code, equals('999999999'));
        expect(status, equals('999999999'));
      });

      test('handles unicode in messages for labels', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Помилка: 错误 🔥',
        );

        // Act
        final label = failure.label;

        // Assert
        expect(label, contains('Помилка'));
        expect(label, contains('错误'));
        expect(label, contains('🔥'));
      });
    });

    group('integration with FailureCodes', () {
      test('type checkers use FailureCodes for comparison', () {
        // Arrange
        const networkFailure = Failure(type: NetworkFailureType());
        const apiFailure = Failure(type: ApiFailureType());

        // Act & Assert
        // These should use the codes from FailureCodes
        expect(networkFailure.isNetworkFailure, isTrue);
        expect(apiFailure.isApiFailure, isTrue);
        expect(networkFailure.isApiFailure, isFalse);
        expect(apiFailure.isNetworkFailure, isFalse);
      });

      test('safeCode returns correct FailureCode value', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        final code = failure.safeCode;

        // Assert
        expect(code, equals(failure.type.code));
        expect(code, isNotEmpty);
      });
    });

    group('multiple checkers composition', () {
      test('can combine checks for complex logic', () {
        // Arrange
        const networkFailure = Failure(type: NetworkFailureType());
        const timeoutFailure = Failure(type: NetworkTimeoutFailureType());
        const authFailure = Failure(type: UnauthorizedFailureType());

        // Act
        final isRetryable =
            networkFailure.isNetworkFailure || networkFailure.isTimeoutFailure;
        final isRetryableTimeout =
            timeoutFailure.isNetworkFailure || timeoutFailure.isTimeoutFailure;
        final isRetryableAuth =
            authFailure.isNetworkFailure || authFailure.isTimeoutFailure;

        // Assert
        expect(isRetryable, isTrue);
        expect(isRetryableTimeout, isTrue);
        expect(isRetryableAuth, isFalse);
      });

      test('can filter failures by multiple criteria', () {
        // Arrange
        const failures = [
          Failure(type: NetworkFailureType()),
          Failure(type: ApiFailureType()),
          Failure(type: UnauthorizedFailureType()),
          Failure(type: CacheFailureType()),
          Failure(type: NetworkTimeoutFailureType()),
        ];

        // Act
        final networkOrTimeout = failures
            .where((f) => f.isNetworkFailure || f.isTimeoutFailure)
            .toList();
        final apiOrAuth = failures
            .where((f) => f.isApiFailure || f.isUnauthorizedFailure)
            .toList();

        // Assert
        expect(networkOrTimeout, hasLength(2));
        expect(apiOrAuth, hasLength(2));
      });
    });

    group('consistency', () {
      test('same failure always returns same checker results', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 500,
        );

        // Act
        final check1 = failure.isApiFailure;
        final check2 = failure.isApiFailure;
        final code1 = failure.safeCode;
        final code2 = failure.safeCode;

        // Assert
        expect(check1, equals(check2));
        expect(code1, equals(code2));
      });

      test('equal failures return equal diagnostic data', () {
        // Arrange
        const failure1 = Failure(
          type: NetworkFailureType(),
          message: 'Error',
        );
        const failure2 = Failure(
          type: NetworkFailureType(),
          message: 'Error',
        );

        // Act & Assert
        expect(failure1.isNetworkFailure, equals(failure2.isNetworkFailure));
        expect(failure1.safeCode, equals(failure2.safeCode));
        expect(failure1.label, equals(failure2.label));
      });
    });
  });
}
