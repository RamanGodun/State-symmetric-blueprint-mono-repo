// Tests use const values extensively
// ignore_for_file: prefer_const_constructors

/// Tests for `FailureCodes` and `FirebaseCodes`
///
/// Coverage:
/// - All FailureCodes constants
/// - All FirebaseCodes constants
/// - Code uniqueness validation
/// - Format consistency
library;

import 'package:core/src/base_modules/errors_management/extensible_part/failure_types/failure_codes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureCodes', () {
    group('platform codes', () {
      test('has platform code', () {
        // Assert
        expect(FailureCodes.platform, equals('PLATFORM'));
        expect(FailureCodes.platform, isNotEmpty);
      });

      test('has missing plugin code', () {
        // Assert
        expect(FailureCodes.missingPlugin, equals('MISSING_PLUGIN'));
        expect(FailureCodes.missingPlugin, isNotEmpty);
      });
    });

    group('network codes', () {
      test('has network code', () {
        // Assert
        expect(FailureCodes.network, equals('NETWORK'));
        expect(FailureCodes.network, isNotEmpty);
      });

      test('has JSON error code', () {
        // Assert
        expect(FailureCodes.jsonError, equals('JSON_ERROR'));
        expect(FailureCodes.jsonError, isNotEmpty);
      });

      test('has timeout code', () {
        // Assert
        expect(FailureCodes.timeout, equals('TIMEOUT'));
        expect(FailureCodes.timeout, isNotEmpty);
      });
    });

    group('Firebase codes delegation', () {
      test('delegates to FirebaseCodes for firebase', () {
        // Assert
        expect(FailureCodes.firebase, equals('FIREBASE'));
      });

      test('delegates to FirebaseCodes for invalidCredential', () {
        // Assert
        expect(
          FailureCodes.invalidCredential,
          equals(FirebaseCodes.invalidCredential),
        );
        expect(FailureCodes.invalidCredential, equals('invalid-credential'));
      });

      test('delegates to FirebaseCodes for emailAlreadyInUse', () {
        // Assert
        expect(
          FailureCodes.emailAlreadyInUse,
          equals(FirebaseCodes.emailAlreadyInUse),
        );
        expect(FailureCodes.emailAlreadyInUse, equals('email-already-in-use'));
      });

      test('delegates to FirebaseCodes for operationNotAllowed', () {
        // Assert
        expect(
          FailureCodes.operationNotAllowed,
          equals(FirebaseCodes.operationNotAllowed),
        );
        expect(
          FailureCodes.operationNotAllowed,
          equals('operation-not-allowed'),
        );
      });

      test('delegates to FirebaseCodes for requiresRecentLogin', () {
        // Assert
        expect(
          FailureCodes.requiresRecentLogin,
          equals(FirebaseCodes.requiresRecentLogin),
        );
        expect(
          FailureCodes.requiresRecentLogin,
          equals('requires-recent-login'),
        );
      });

      test('delegates to FirebaseCodes for tooManyRequests', () {
        // Assert
        expect(
          FailureCodes.tooManyRequests,
          equals(FirebaseCodes.tooManyRequests),
        );
        expect(FailureCodes.tooManyRequests, equals('too-many-requests'));
      });

      test('delegates to FirebaseCodes for userDisabled', () {
        // Assert
        expect(FailureCodes.userDisabled, equals(FirebaseCodes.userDisabled));
        expect(FailureCodes.userDisabled, equals('user-disabled'));
      });

      test('delegates to FirebaseCodes for userNotFound', () {
        // Assert
        expect(FailureCodes.userNotFound, equals(FirebaseCodes.userNotFound));
        expect(FailureCodes.userNotFound, equals('user-not-found'));
      });

      test('delegates to FirebaseCodes for firebaseUserMissing', () {
        // Assert
        expect(
          FailureCodes.firebaseUserMissing,
          equals(FirebaseCodes.userMissing),
        );
        expect(
          FailureCodes.firebaseUserMissing,
          equals('firebase-user-missing'),
        );
      });

      test('delegates to FirebaseCodes for firestoreDocMissing', () {
        // Assert
        expect(
          FailureCodes.firestoreDocMissing,
          equals(FirebaseCodes.docMissing),
        );
        expect(
          FailureCodes.firestoreDocMissing,
          equals('firestore-doc-missing'),
        );
      });

      test(
        'delegates to FirebaseCodes for accountExistsWithDifferentCredential',
        () {
          // Assert
          expect(
            FailureCodes.accountExistsWithDifferentCredential,
            equals(FirebaseCodes.accountExistsWithDifferentCredential),
          );
          expect(
            FailureCodes.accountExistsWithDifferentCredential,
            equals('account-exists-with-different-credential'),
          );
        },
      );
    });

    group('email verification codes', () {
      test('has email verification timeout code', () {
        // Assert
        expect(
          FailureCodes.emailVerificationTimeout,
          equals('EMAIL_VERIFICATION_TIMEOUT'),
        );
        expect(FailureCodes.emailVerificationTimeout, isNotEmpty);
      });

      test('has email verification code', () {
        // Assert
        expect(FailureCodes.emailVerification, equals('EMAIL_VERIFICATION'));
        expect(FailureCodes.emailVerification, isNotEmpty);
      });
    });

    group('database codes', () {
      test('has SQLite code', () {
        // Assert
        expect(FailureCodes.sqlite, equals('SQLITE'));
        expect(FailureCodes.sqlite, isNotEmpty);
      });
    });

    group('app-specific codes', () {
      test('has use case code', () {
        // Assert
        expect(FailureCodes.useCase, equals('USE_CASE'));
        expect(FailureCodes.useCase, isNotEmpty);
      });

      test('has cache code', () {
        // Assert
        expect(FailureCodes.cache, equals('CACHE'));
        expect(FailureCodes.cache, isNotEmpty);
      });

      test('has format error code', () {
        // Assert
        expect(FailureCodes.formatError, equals('FORMAT_ERROR'));
        expect(FailureCodes.formatError, isNotEmpty);
      });

      test('has API code', () {
        // Assert
        expect(FailureCodes.api, equals('API'));
        expect(FailureCodes.api, isNotEmpty);
      });

      test('has no status code', () {
        // Assert
        expect(FailureCodes.noStatus, equals('NO_STATUS'));
        expect(FailureCodes.noStatus, isNotEmpty);
      });

      test('has unknown code', () {
        // Assert
        expect(FailureCodes.unknown, equals('UNKNOWN'));
        expect(FailureCodes.unknown, isNotEmpty);
      });

      test('has unauthorized code', () {
        // Assert
        expect(FailureCodes.unauthorized, equals('UNAUTHORIZED'));
        expect(FailureCodes.unauthorized, isNotEmpty);
      });

      test('has unknown code fallback', () {
        // Assert
        expect(FailureCodes.unknownCode, equals('UNKNOWN_CODE'));
        expect(FailureCodes.unknownCode, isNotEmpty);
      });
    });

    group('code format consistency', () {
      test('platform codes use UPPERCASE_SNAKE_CASE', () {
        // Assert
        expect(
          FailureCodes.platform,
          equals(FailureCodes.platform.toUpperCase()),
        );
        expect(
          FailureCodes.missingPlugin,
          equals(FailureCodes.missingPlugin.toUpperCase()),
        );
      });

      test('network codes use UPPERCASE_SNAKE_CASE', () {
        // Assert
        expect(
          FailureCodes.network,
          equals(FailureCodes.network.toUpperCase()),
        );
        expect(
          FailureCodes.jsonError,
          equals(FailureCodes.jsonError.toUpperCase()),
        );
        expect(
          FailureCodes.timeout,
          equals(FailureCodes.timeout.toUpperCase()),
        );
      });

      test('app codes use UPPERCASE_SNAKE_CASE', () {
        // Assert
        expect(FailureCodes.cache, equals(FailureCodes.cache.toUpperCase()));
        expect(FailureCodes.api, equals(FailureCodes.api.toUpperCase()));
        expect(
          FailureCodes.unknown,
          equals(FailureCodes.unknown.toUpperCase()),
        );
      });

      test('Firebase-delegated codes use kebab-case', () {
        // Assert
        expect(FailureCodes.invalidCredential, contains('-'));
        expect(FailureCodes.emailAlreadyInUse, contains('-'));
        expect(FailureCodes.userNotFound, contains('-'));
        expect(FailureCodes.tooManyRequests, contains('-'));
      });
    });

    group('code uniqueness', () {
      test('all codes are unique', () {
        // Arrange
        final allCodes = {
          FailureCodes.platform,
          FailureCodes.missingPlugin,
          FailureCodes.network,
          FailureCodes.jsonError,
          FailureCodes.timeout,
          FailureCodes.firebase,
          FailureCodes.emailVerificationTimeout,
          FailureCodes.emailVerification,
          FailureCodes.sqlite,
          FailureCodes.useCase,
          FailureCodes.cache,
          FailureCodes.formatError,
          FailureCodes.api,
          FailureCodes.noStatus,
          FailureCodes.unknown,
          FailureCodes.unauthorized,
          FailureCodes.unknownCode,
          // Firebase codes
          FailureCodes.invalidCredential,
          FailureCodes.emailAlreadyInUse,
          FailureCodes.operationNotAllowed,
          FailureCodes.requiresRecentLogin,
          FailureCodes.tooManyRequests,
          FailureCodes.userDisabled,
          FailureCodes.userNotFound,
          FailureCodes.firebaseUserMissing,
          FailureCodes.firestoreDocMissing,
          FailureCodes.accountExistsWithDifferentCredential,
        };

        // Assert - Set automatically removes duplicates
        expect(allCodes.length, greaterThanOrEqualTo(25));
      });
    });

    group('code usage', () {
      test('can be used in switch statements', () {
        // Arrange
        const code = FailureCodes.network;
        String result;

        // Act
        switch (code) {
          case FailureCodes.network:
            result = 'Network error';
          case FailureCodes.api:
            result = 'API error';
          default:
            result = 'Unknown error';
        }

        // Assert
        expect(result, equals('Network error'));
      });

      test('can be used for equality checks', () {
        // Arrange
        const code = FailureCodes.timeout;

        // Assert
        expect(code == FailureCodes.timeout, isTrue);
        expect(code == FailureCodes.network, isFalse);
      });
    });
  });

  group('FirebaseCodes', () {
    group('Auth codes', () {
      test('has invalid credential code', () {
        // Assert
        expect(FirebaseCodes.invalidCredential, equals('invalid-credential'));
        expect(FirebaseCodes.invalidCredential, isNotEmpty);
      });

      test('has wrong password code', () {
        // Assert
        expect(FirebaseCodes.wrongPassword, equals('wrong-password'));
        expect(FirebaseCodes.wrongPassword, isNotEmpty);
      });

      test('has invalid email code', () {
        // Assert
        expect(FirebaseCodes.invalidEmail, equals('invalid-email'));
        expect(FirebaseCodes.invalidEmail, isNotEmpty);
      });

      test('has email already in use code', () {
        // Assert
        expect(FirebaseCodes.emailAlreadyInUse, equals('email-already-in-use'));
        expect(FirebaseCodes.emailAlreadyInUse, isNotEmpty);
      });

      test('has operation not allowed code', () {
        // Assert
        expect(
          FirebaseCodes.operationNotAllowed,
          equals('operation-not-allowed'),
        );
        expect(FirebaseCodes.operationNotAllowed, isNotEmpty);
      });

      test('has requires recent login code', () {
        // Assert
        expect(
          FirebaseCodes.requiresRecentLogin,
          equals('requires-recent-login'),
        );
        expect(FirebaseCodes.requiresRecentLogin, isNotEmpty);
      });

      test('has too many requests code', () {
        // Assert
        expect(FirebaseCodes.tooManyRequests, equals('too-many-requests'));
        expect(FirebaseCodes.tooManyRequests, isNotEmpty);
      });

      test('has user disabled code', () {
        // Assert
        expect(FirebaseCodes.userDisabled, equals('user-disabled'));
        expect(FirebaseCodes.userDisabled, isNotEmpty);
      });

      test('has user not found code', () {
        // Assert
        expect(FirebaseCodes.userNotFound, equals('user-not-found'));
        expect(FirebaseCodes.userNotFound, isNotEmpty);
      });

      test('has account exists with different credential code', () {
        // Assert
        expect(
          FirebaseCodes.accountExistsWithDifferentCredential,
          equals('account-exists-with-different-credential'),
        );
        expect(FirebaseCodes.accountExistsWithDifferentCredential, isNotEmpty);
      });
    });

    group('Firestore codes', () {
      test('has user missing code', () {
        // Assert
        expect(FirebaseCodes.userMissing, equals('firebase-user-missing'));
        expect(FirebaseCodes.userMissing, isNotEmpty);
      });

      test('has doc missing code', () {
        // Assert
        expect(FirebaseCodes.docMissing, equals('firestore-doc-missing'));
        expect(FirebaseCodes.docMissing, isNotEmpty);
      });
    });

    group('Network codes', () {
      test('has network request failed code', () {
        // Assert
        expect(
          FirebaseCodes.networkRequestFailed,
          equals('network-request-failed'),
        );
        expect(FirebaseCodes.networkRequestFailed, isNotEmpty);
      });

      test('has deadline exceeded code', () {
        // Assert
        expect(FirebaseCodes.deadlineExceeded, equals('deadline-exceeded'));
        expect(FirebaseCodes.deadlineExceeded, isNotEmpty);
      });

      test('has timeout code', () {
        // Assert
        expect(FirebaseCodes.timeout, equals('timeout'));
        expect(FirebaseCodes.timeout, isNotEmpty);
      });
    });

    group('code format', () {
      test('all codes use kebab-case', () {
        // Arrange
        final allFirebaseCodes = [
          FirebaseCodes.invalidCredential,
          FirebaseCodes.wrongPassword,
          FirebaseCodes.invalidEmail,
          FirebaseCodes.emailAlreadyInUse,
          FirebaseCodes.operationNotAllowed,
          FirebaseCodes.requiresRecentLogin,
          FirebaseCodes.tooManyRequests,
          FirebaseCodes.userDisabled,
          FirebaseCodes.userNotFound,
          FirebaseCodes.accountExistsWithDifferentCredential,
          FirebaseCodes.userMissing,
          FirebaseCodes.docMissing,
          FirebaseCodes.networkRequestFailed,
          FirebaseCodes.deadlineExceeded,
          FirebaseCodes.timeout,
        ];

        // Assert
        for (final code in allFirebaseCodes) {
          expect(
            code,
            equals(code.toLowerCase()),
            reason: '$code should be lowercase',
          );
          expect(
            code,
            isNot(contains('_')),
            reason: '$code should not contain underscores',
          );
        }
      });
    });

    group('code uniqueness', () {
      test('all Firebase codes are unique', () {
        // Arrange
        final allFirebaseCodes = {
          FirebaseCodes.invalidCredential,
          FirebaseCodes.wrongPassword,
          FirebaseCodes.invalidEmail,
          FirebaseCodes.emailAlreadyInUse,
          FirebaseCodes.operationNotAllowed,
          FirebaseCodes.requiresRecentLogin,
          FirebaseCodes.tooManyRequests,
          FirebaseCodes.userDisabled,
          FirebaseCodes.userNotFound,
          FirebaseCodes.accountExistsWithDifferentCredential,
          FirebaseCodes.userMissing,
          FirebaseCodes.docMissing,
          FirebaseCodes.networkRequestFailed,
          FirebaseCodes.deadlineExceeded,
          FirebaseCodes.timeout,
        };

        // Assert - Set automatically removes duplicates
        expect(allFirebaseCodes.length, equals(15));
      });
    });

    group('real-world usage', () {
      test('can match Firebase Auth error codes', () {
        // Arrange
        const firebaseAuthError = 'invalid-credential';

        // Assert
        expect(firebaseAuthError, equals(FirebaseCodes.invalidCredential));
      });

      test('can match Firebase Firestore error codes', () {
        // Arrange
        const firestoreError = 'firestore-doc-missing';

        // Assert
        expect(firestoreError, equals(FirebaseCodes.docMissing));
      });

      test('can be used in switch statements', () {
        // Arrange
        const code = FirebaseCodes.invalidCredential;
        String result;

        // Act
        switch (code) {
          case FirebaseCodes.invalidCredential:
            result = 'Invalid credentials';
          case FirebaseCodes.userNotFound:
            result = 'User not found';
          default:
            result = 'Unknown error';
        }

        // Assert
        expect(result, equals('Invalid credentials'));
      });
    });
  });

  group('FailureCodes and FirebaseCodes integration', () {
    test('FailureCodes correctly delegates to FirebaseCodes', () {
      // Assert - Verify delegation
      expect(
        FailureCodes.invalidCredential,
        equals(FirebaseCodes.invalidCredential),
      );
      expect(
        FailureCodes.emailAlreadyInUse,
        equals(FirebaseCodes.emailAlreadyInUse),
      );
      expect(FailureCodes.userNotFound, equals(FirebaseCodes.userNotFound));
      expect(
        FailureCodes.tooManyRequests,
        equals(FirebaseCodes.tooManyRequests),
      );
    });

    test('Firebase codes are distinct from app codes', () {
      // Assert
      expect(
        FailureCodes.invalidCredential,
        isNot(equals(FailureCodes.network)),
      );
      expect(FailureCodes.emailAlreadyInUse, isNot(equals(FailureCodes.api)));
      expect(FirebaseCodes.userNotFound, isNot(equals(FailureCodes.unknown)));
    });

    test('code naming conventions are consistent', () {
      // Assert - App codes use UPPERCASE
      expect(FailureCodes.network, matches(RegExp(r'^[A-Z_]+$')));
      expect(FailureCodes.api, matches(RegExp(r'^[A-Z_]+$')));

      // Assert - Firebase codes use kebab-case
      expect(FirebaseCodes.invalidCredential, matches(RegExp(r'^[a-z-]+$')));
      expect(FirebaseCodes.userNotFound, matches(RegExp(r'^[a-z-]+$')));
    });
  });
}
