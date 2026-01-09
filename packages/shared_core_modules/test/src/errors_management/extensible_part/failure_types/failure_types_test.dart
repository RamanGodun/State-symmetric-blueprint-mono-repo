// Tests use const constructors extensively for immutable objects
// ignore_for_file: equal_elements_in_set

/// Tests for all `FailureType` subclasses
///
/// Coverage:
/// - All Network failure types
/// - All Firebase failure types
/// - All Misc failure types
/// - Code and translationKey validation
/// - Equality and immutability
/// - Const semantics
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('FailureType', () {
    group('sealed class properties', () {
      test('is immutable', () {
        // Arrange & Act
        const type = NetworkFailureType();

        // Assert - attempting to modify would cause compile error
        expect(type.code, isA<String>());
        expect(type.translationKey, isA<String>());
      });

      test('all instances have non-empty code', () {
        // Arrange
        final allTypes = [
          const NetworkFailureType(),
          const NetworkTimeoutFailureType(),
          const JsonErrorFailureType(),
          const ApiFailureType(),
          const UnauthorizedFailureType(),
          const UnknownFailureType(),
          const CacheFailureType(),
          const EmailVerificationTimeoutFailureType(),
          const FormatFailureType(),
          const MissingPluginFailureType(),
          const GenericFirebaseFailureType(),
          const InvalidCredentialFirebaseFailureType(),
          const EmailAlreadyInUseFirebaseFailureType(),
          const OperationNotAllowedFirebaseFailureType(),
          const UserDisabledFirebaseFailureType(),
          const UserNotFoundFirebaseFailureType(),
          const RequiresRecentLoginFirebaseFailureType(),
          const UserMissingFirebaseFailureType(),
          const DocMissingFirebaseFailureType(),
          const TooManyRequestsFirebaseFailureType(),
        ];

        // Assert
        for (final type in allTypes) {
          expect(
            type.code,
            isNotEmpty,
            reason: '${type.runtimeType} has empty code',
          );
          expect(
            type.translationKey,
            isNotEmpty,
            reason: '${type.runtimeType} has empty translationKey',
          );
        }
      });

      test('const instances are identical', () {
        // Arrange
        const type1 = NetworkFailureType();
        const type2 = NetworkFailureType();

        // Assert
        expect(identical(type1, type2), isTrue);
      });
    });

    group('Network Failure Types', () {
      group('NetworkFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = NetworkFailureType();

          // Assert
          expect(type, isA<NetworkFailureType>());
          expect(type.code, equals(FailureCodes.network));
          expect(type.translationKey, isNotEmpty);
        });

        test('is const-constructible', () {
          // Arrange & Act
          const type = NetworkFailureType();
          const instance2 = NetworkFailureType();

          // Assert
          expect(identical(type, instance2), isTrue);
        });

        test('has correct code from FailureCodes', () {
          // Arrange
          const type = NetworkFailureType();

          // Assert
          expect(type.code, equals('NETWORK'));
        });
      });

      group('NetworkTimeoutFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = NetworkTimeoutFailureType();

          // Assert
          expect(type, isA<NetworkTimeoutFailureType>());
          expect(type.code, equals(FailureCodes.timeout));
          expect(type.translationKey, isNotEmpty);
        });

        test('has timeout-specific code', () {
          // Arrange
          const type = NetworkTimeoutFailureType();

          // Assert
          expect(type.code, equals('TIMEOUT'));
        });
      });

      group('JsonErrorFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = JsonErrorFailureType();

          // Assert
          expect(type, isA<JsonErrorFailureType>());
          expect(type.code, equals(FailureCodes.jsonError));
          expect(type.translationKey, isNotEmpty);
        });

        test('has JSON error code', () {
          // Arrange
          const type = JsonErrorFailureType();

          // Assert
          expect(type.code, equals('JSON_ERROR'));
        });
      });

      group('ApiFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = ApiFailureType();

          // Assert
          expect(type, isA<ApiFailureType>());
          expect(type.code, equals(FailureCodes.api));
          expect(type.translationKey, isNotEmpty);
        });

        test('has API error code', () {
          // Arrange
          const type = ApiFailureType();

          // Assert
          expect(type.code, equals('API'));
        });
      });

      group('UnauthorizedFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = UnauthorizedFailureType();

          // Assert
          expect(type, isA<UnauthorizedFailureType>());
          expect(type.code, equals(FailureCodes.unauthorized));
          expect(type.translationKey, isNotEmpty);
        });

        test('has unauthorized code', () {
          // Arrange
          const type = UnauthorizedFailureType();

          // Assert
          expect(type.code, equals('UNAUTHORIZED'));
        });
      });
    });

    group('Misc Failure Types', () {
      group('UnknownFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = UnknownFailureType();

          // Assert
          expect(type, isA<UnknownFailureType>());
          expect(type.code, equals(FailureCodes.unknown));
          expect(type.translationKey, isNotEmpty);
        });

        test('has unknown error code', () {
          // Arrange
          const type = UnknownFailureType();

          // Assert
          expect(type.code, equals('UNKNOWN'));
        });
      });

      group('CacheFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = CacheFailureType();

          // Assert
          expect(type, isA<CacheFailureType>());
          expect(type.code, equals(FailureCodes.cache));
          expect(type.translationKey, isNotEmpty);
        });

        test('has cache error code', () {
          // Arrange
          const type = CacheFailureType();

          // Assert
          expect(type.code, equals('CACHE'));
        });
      });

      group('EmailVerificationTimeoutFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = EmailVerificationTimeoutFailureType();

          // Assert
          expect(type, isA<EmailVerificationTimeoutFailureType>());
          expect(type.code, equals(FailureCodes.emailVerificationTimeout));
          expect(type.translationKey, isNotEmpty);
        });

        test('has email verification timeout code', () {
          // Arrange
          const type = EmailVerificationTimeoutFailureType();

          // Assert
          expect(type.code, equals('EMAIL_VERIFICATION_TIMEOUT'));
        });
      });

      group('FormatFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = FormatFailureType();

          // Assert
          expect(type, isA<FormatFailureType>());
          expect(type.code, equals(FailureCodes.formatError));
          expect(type.translationKey, isNotEmpty);
        });

        test('has format error code', () {
          // Arrange
          const type = FormatFailureType();

          // Assert
          expect(type.code, equals('FORMAT_ERROR'));
        });
      });

      group('MissingPluginFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = MissingPluginFailureType();

          // Assert
          expect(type, isA<MissingPluginFailureType>());
          expect(type.code, equals(FailureCodes.missingPlugin));
          expect(type.translationKey, isNotEmpty);
        });

        test('has missing plugin code', () {
          // Arrange
          const type = MissingPluginFailureType();

          // Assert
          expect(type.code, equals('MISSING_PLUGIN'));
        });
      });
    });

    group('Firebase Failure Types', () {
      group('GenericFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = GenericFirebaseFailureType();

          // Assert
          expect(type, isA<GenericFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.firebase));
          expect(type.translationKey, isNotEmpty);
        });

        test('has generic firebase code', () {
          // Arrange
          const type = GenericFirebaseFailureType();

          // Assert
          expect(type.code, equals('FIREBASE'));
        });
      });

      group('InvalidCredentialFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = InvalidCredentialFirebaseFailureType();

          // Assert
          expect(type, isA<InvalidCredentialFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.invalidCredential));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase auth code', () {
          // Arrange
          const type = InvalidCredentialFirebaseFailureType();

          // Assert
          expect(type.code, equals('invalid-credential'));
          expect(type.code, equals(FirebaseCodes.invalidCredential));
        });
      });

      group('EmailAlreadyInUseFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = EmailAlreadyInUseFirebaseFailureType();

          // Assert
          expect(type, isA<EmailAlreadyInUseFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.emailAlreadyInUse));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase auth code', () {
          // Arrange
          const type = EmailAlreadyInUseFirebaseFailureType();

          // Assert
          expect(type.code, equals('email-already-in-use'));
          expect(type.code, equals(FirebaseCodes.emailAlreadyInUse));
        });
      });

      group('OperationNotAllowedFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = OperationNotAllowedFirebaseFailureType();

          // Assert
          expect(type, isA<OperationNotAllowedFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.operationNotAllowed));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase auth code', () {
          // Arrange
          const type = OperationNotAllowedFirebaseFailureType();

          // Assert
          expect(type.code, equals('operation-not-allowed'));
        });
      });

      group('UserDisabledFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = UserDisabledFirebaseFailureType();

          // Assert
          expect(type, isA<UserDisabledFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.userDisabled));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase auth code', () {
          // Arrange
          const type = UserDisabledFirebaseFailureType();

          // Assert
          expect(type.code, equals('user-disabled'));
        });
      });

      group('UserNotFoundFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = UserNotFoundFirebaseFailureType();

          // Assert
          expect(type, isA<UserNotFoundFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.userNotFound));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase auth code', () {
          // Arrange
          const type = UserNotFoundFirebaseFailureType();

          // Assert
          expect(type.code, equals('user-not-found'));
        });
      });

      group('RequiresRecentLoginFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = RequiresRecentLoginFirebaseFailureType();

          // Assert
          expect(type, isA<RequiresRecentLoginFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.requiresRecentLogin));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase auth code', () {
          // Arrange
          const type = RequiresRecentLoginFirebaseFailureType();

          // Assert
          expect(type.code, equals('requires-recent-login'));
        });
      });

      group('UserMissingFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = UserMissingFirebaseFailureType();

          // Assert
          expect(type, isA<UserMissingFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.firebaseUserMissing));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase internal code', () {
          // Arrange
          const type = UserMissingFirebaseFailureType();

          // Assert
          expect(type.code, equals('firebase-user-missing'));
        });
      });

      group('DocMissingFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = DocMissingFirebaseFailureType();

          // Assert
          expect(type, isA<DocMissingFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.firestoreDocMissing));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firestore code', () {
          // Arrange
          const type = DocMissingFirebaseFailureType();

          // Assert
          expect(type.code, equals('firestore-doc-missing'));
        });
      });

      group('TooManyRequestsFirebaseFailureType', () {
        test('creates instance with correct code', () {
          // Arrange & Act
          const type = TooManyRequestsFirebaseFailureType();

          // Assert
          expect(type, isA<TooManyRequestsFirebaseFailureType>());
          expect(type.code, equals(FailureCodes.tooManyRequests));
          expect(type.translationKey, isNotEmpty);
        });

        test('uses Firebase rate limit code', () {
          // Arrange
          const type = TooManyRequestsFirebaseFailureType();

          // Assert
          expect(type.code, equals('too-many-requests'));
        });
      });
    });

    group('type equality', () {
      test('same type instances are equal', () {
        // Arrange
        const type1 = NetworkFailureType();
        const type2 = NetworkFailureType();

        // Assert
        expect(type1, equals(type2));
      });

      test('different type instances are not equal', () {
        // Arrange
        const type1 = NetworkFailureType();
        const type2 = ApiFailureType();

        // Assert
        expect(type1, isNot(equals(type2)));
      });

      test('different Firebase types are not equal', () {
        // Arrange
        const type1 = InvalidCredentialFirebaseFailureType();
        const type2 = EmailAlreadyInUseFirebaseFailureType();

        // Assert
        expect(type1, isNot(equals(type2)));
        expect(type1.code, isNot(equals(type2.code)));
      });
    });

    group('use in collections', () {
      test('can be stored in Set without duplicates', () {
        // Arrange & Act
        final types = {
          const NetworkFailureType(),
          const NetworkFailureType(), // Duplicate
          const ApiFailureType(),
        };

        // Assert
        expect(types, hasLength(2));
      });

      test('can be used as Map keys', () {
        // Arrange & Act
        final map = {
          const NetworkFailureType(): 'Network Error',
          const ApiFailureType(): 'API Error',
        };

        // Assert
        expect(map[const NetworkFailureType()], equals('Network Error'));
        expect(map[const ApiFailureType()], equals('API Error'));
      });

      test('can be stored in const collections', () {
        // Arrange & Act
        const types = [
          NetworkFailureType(),
          ApiFailureType(),
          UnknownFailureType(),
        ];

        // Assert
        expect(types, hasLength(3));
        expect(types[0], isA<NetworkFailureType>());
        expect(types[1], isA<ApiFailureType>());
        expect(types[2], isA<UnknownFailureType>());
      });
    });

    group('code consistency', () {
      test('all Firebase types use Firebase codes', () {
        // Arrange
        const firebaseTypes = [
          InvalidCredentialFirebaseFailureType(),
          EmailAlreadyInUseFirebaseFailureType(),
          OperationNotAllowedFirebaseFailureType(),
          UserDisabledFirebaseFailureType(),
          UserNotFoundFirebaseFailureType(),
          RequiresRecentLoginFirebaseFailureType(),
          TooManyRequestsFirebaseFailureType(),
        ];

        // Assert
        for (final type in firebaseTypes) {
          expect(
            type.code,
            contains('-'),
            reason: '${type.runtimeType} should use kebab-case Firebase code',
          );
        }
      });

      test('all Network types use uppercase codes', () {
        // Arrange
        const networkTypes = [
          NetworkFailureType(),
          NetworkTimeoutFailureType(),
          JsonErrorFailureType(),
          ApiFailureType(),
          UnauthorizedFailureType(),
        ];

        // Assert
        for (final type in networkTypes) {
          expect(
            type.code,
            equals(type.code.toUpperCase()),
            reason: '${type.runtimeType} should use UPPERCASE code',
          );
        }
      });

      test('all Misc types use uppercase codes', () {
        // Arrange
        const miscTypes = [
          UnknownFailureType(),
          CacheFailureType(),
          EmailVerificationTimeoutFailureType(),
          FormatFailureType(),
          MissingPluginFailureType(),
        ];

        // Assert
        for (final type in miscTypes) {
          expect(
            type.code,
            equals(type.code.toUpperCase()),
            reason: '${type.runtimeType} should use UPPERCASE code',
          );
        }
      });
    });

    group('real-world usage', () {
      test('NetworkFailureType for offline scenarios', () {
        // Arrange
        const type = NetworkFailureType();

        // Assert
        expect(type.code, equals('NETWORK'));
        expect(type, isA<FailureType>());
      });

      test('InvalidCredentialFirebaseFailureType for auth errors', () {
        // Arrange
        const type = InvalidCredentialFirebaseFailureType();

        // Assert
        expect(type.code, contains('credential'));
        expect(type, isA<FailureType>());
      });

      test('UnknownFailureType for unexpected errors', () {
        // Arrange
        const type = UnknownFailureType();

        // Assert
        expect(type.code, equals('UNKNOWN'));
        expect(type, isA<FailureType>());
      });

      test('can be used in Failure entity', () {
        // Arrange & Act
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'No internet connection',
        );

        // Assert
        expect(failure.type, isA<NetworkFailureType>());
        expect(failure.type.code, equals('NETWORK'));
      });
    });
  });
}
