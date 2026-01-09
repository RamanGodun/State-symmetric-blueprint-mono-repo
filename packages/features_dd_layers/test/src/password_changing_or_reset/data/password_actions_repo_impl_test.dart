/// Tests for PasswordRepoImpl
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Password change functionality
/// - Password reset link sending
/// - Error handling for both operations
/// - Parameter passing and validation
library;

import 'package:features_dd_layers/src/password_changing_or_reset/data/password_actions_repo_impl.dart';
import 'package:features_dd_layers/src/password_changing_or_reset/data/remote_database_contract.dart';
import 'package:features_dd_layers/src/password_changing_or_reset/domain/repo_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../fixtures/test_constants.dart';

class MockPasswordRemoteDatabase extends Mock
    implements IPasswordRemoteDatabase {}

void main() {
  group('PasswordRepoImpl', () {
    late IPasswordRemoteDatabase mockRemote;
    late IPasswordRepo repo;

    setUp(() {
      mockRemote = MockPasswordRemoteDatabase();
      repo = PasswordRepoImpl(mockRemote);
    });

    group('constructor', () {
      test('creates instance with provided remote database', () {
        // Arrange & Act
        final repo = PasswordRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<PasswordRepoImpl>());
        expect(repo, isA<IPasswordRepo>());
      });
    });

    group('changePassword', () {
      group('successful password change', () {
        test('calls remote changePassword method', () async {
          // Arrange
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          await repo.changePassword(TestConstants.validPassword);

          // Assert
          verify(
            () => mockRemote.changePassword(TestConstants.validPassword),
          ).called(1);
        });

        test('returns Right on successful password change', () async {
          // Arrange
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          final result = await repo.changePassword(TestConstants.validPassword);

          // Assert
          expect(result.isRight, isTrue);
        });

        test('passes correct password to remote database', () async {
          // Arrange
          const newPassword = 'NewSecurePassword123!';
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          await repo.changePassword(newPassword);

          // Assert
          verify(() => mockRemote.changePassword(newPassword)).called(1);
        });

        test('can change password multiple times', () async {
          // Arrange
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          await repo.changePassword('Password1!');
          await repo.changePassword('Password2!');
          await repo.changePassword('Password3!');

          // Assert
          verify(() => mockRemote.changePassword(any())).called(3);
        });

        test('works with different password formats', () async {
          // Arrange
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          final result1 = await repo.changePassword('Simple123');
          final result2 = await repo.changePassword('Complex!@#123ABC');
          final result3 = await repo.changePassword('VeryLongPassword123!@#');

          // Assert
          expect(result1.isRight, isTrue);
          expect(result2.isRight, isTrue);
          expect(result3.isRight, isTrue);
        });
      });

      group('failed password change', () {
        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.changePassword(any()),
          ).thenThrow(Exception('Password change failed'));

          // Act
          final result = await repo.changePassword(TestConstants.validPassword);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.changePassword(any()),
          ).thenThrow(Exception('weak-password'));

          // Act
          final result = await repo.changePassword('weak');

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('weak-password'));
        });

        test('handles requires-recent-login error', () async {
          // Arrange
          when(
            () => mockRemote.changePassword(any()),
          ).thenThrow(Exception('requires-recent-login'));

          // Act
          final result = await repo.changePassword(TestConstants.validPassword);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('requires-recent-login'));
        });

        test('handles user-not-found error', () async {
          // Arrange
          when(
            () => mockRemote.changePassword(any()),
          ).thenThrow(Exception('user-not-found'));

          // Act
          final result = await repo.changePassword(TestConstants.validPassword);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('user-not-found'));
        });

        test('handles network errors', () async {
          // Arrange
          when(
            () => mockRemote.changePassword(any()),
          ).thenThrow(Exception('network-request-failed'));

          // Act
          final result = await repo.changePassword(TestConstants.validPassword);

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.message,
            contains('network-request-failed'),
          );
        });

        test('handles generic errors', () async {
          // Arrange
          when(
            () => mockRemote.changePassword(any()),
          ).thenThrow('String error');

          // Act
          final result = await repo.changePassword(TestConstants.validPassword);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });
      });

      group('edge cases', () {
        test('handles empty password', () async {
          // Arrange
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          await repo.changePassword(TestConstants.emptyString);

          // Assert
          verify(
            () => mockRemote.changePassword(TestConstants.emptyString),
          ).called(1);
        });

        test('handles very long password', () async {
          // Arrange
          final longPassword = 'A' * 1000;
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          await repo.changePassword(longPassword);

          // Assert
          verify(() => mockRemote.changePassword(longPassword)).called(1);
        });

        test('handles password with special characters', () async {
          // Arrange
          const specialPassword = r'!@#$%^&*()_+-=[]{}|;:,.<>?/~`';
          when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

          // Act
          await repo.changePassword(specialPassword);

          // Assert
          verify(() => mockRemote.changePassword(specialPassword)).called(1);
        });
      });
    });

    group('sendResetLink', () {
      group('successful reset link sending', () {
        test('calls remote sendResetLink method', () async {
          // Arrange
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          await repo.sendResetLink(TestConstants.validEmail);

          // Assert
          verify(
            () => mockRemote.sendResetLink(TestConstants.validEmail),
          ).called(1);
        });

        test('returns Right on successful reset link send', () async {
          // Arrange
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          final result = await repo.sendResetLink(TestConstants.validEmail);

          // Assert
          expect(result.isRight, isTrue);
        });

        test('passes correct email to remote database', () async {
          // Arrange
          const email = 'user@example.com';
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          await repo.sendResetLink(email);

          // Assert
          verify(() => mockRemote.sendResetLink(email)).called(1);
        });

        test('can send reset link multiple times', () async {
          // Arrange
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          await repo.sendResetLink('user1@example.com');
          await repo.sendResetLink('user2@example.com');

          // Assert
          verify(() => mockRemote.sendResetLink(any())).called(2);
        });

        test('works with different email formats', () async {
          // Arrange
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          final result1 = await repo.sendResetLink('simple@test.com');
          final result2 = await repo.sendResetLink(
            'complex.name+tag@domain.co.uk',
          );
          final result3 = await repo.sendResetLink(
            'user@subdomain.example.com',
          );

          // Assert
          expect(result1.isRight, isTrue);
          expect(result2.isRight, isTrue);
          expect(result3.isRight, isTrue);
        });
      });

      group('failed reset link sending', () {
        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.sendResetLink(any()),
          ).thenThrow(Exception('Reset link send failed'));

          // Act
          final result = await repo.sendResetLink(TestConstants.validEmail);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.sendResetLink(any()),
          ).thenThrow(Exception('user-not-found'));

          // Act
          final result = await repo.sendResetLink('nonexistent@example.com');

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('user-not-found'));
        });

        test('handles invalid-email error', () async {
          // Arrange
          when(
            () => mockRemote.sendResetLink(any()),
          ).thenThrow(Exception('invalid-email'));

          // Act
          final result = await repo.sendResetLink(TestConstants.invalidEmail);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('invalid-email'));
        });

        test('handles too-many-requests error', () async {
          // Arrange
          when(
            () => mockRemote.sendResetLink(any()),
          ).thenThrow(Exception('too-many-requests'));

          // Act
          final result = await repo.sendResetLink(TestConstants.validEmail);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('too-many-requests'));
        });

        test('handles network errors', () async {
          // Arrange
          when(
            () => mockRemote.sendResetLink(any()),
          ).thenThrow(Exception('network-request-failed'));

          // Act
          final result = await repo.sendResetLink(TestConstants.validEmail);

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.message,
            contains('network-request-failed'),
          );
        });

        test('handles generic errors', () async {
          // Arrange
          when(() => mockRemote.sendResetLink(any())).thenThrow('String error');

          // Act
          final result = await repo.sendResetLink(TestConstants.validEmail);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });
      });

      group('edge cases', () {
        test('handles empty email', () async {
          // Arrange
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          await repo.sendResetLink(TestConstants.emptyString);

          // Assert
          verify(
            () => mockRemote.sendResetLink(TestConstants.emptyString),
          ).called(1);
        });

        test('handles very long email', () async {
          // Arrange
          final longEmail = '${'a' * 100}@example.com';
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          await repo.sendResetLink(longEmail);

          // Assert
          verify(() => mockRemote.sendResetLink(longEmail)).called(1);
        });

        test('handles email with special characters', () async {
          // Arrange
          const specialEmail = 'user+tag@example.com';
          when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

          // Act
          await repo.sendResetLink(specialEmail);

          // Assert
          verify(() => mockRemote.sendResetLink(specialEmail)).called(1);
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates complete password reset flow', () async {
        // Arrange
        when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});

        // Act - User requests reset link
        final sendResult = await repo.sendResetLink(TestConstants.validEmail);

        // Assert
        expect(sendResult.isRight, isTrue);
        verify(
          () => mockRemote.sendResetLink(TestConstants.validEmail),
        ).called(1);
      });

      test('simulates complete password change flow', () async {
        // Arrange
        when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

        // Act - User changes password after authentication
        final changeResult = await repo.changePassword('NewSecurePassword123!');

        // Assert
        expect(changeResult.isRight, isTrue);
        verify(
          () => mockRemote.changePassword('NewSecurePassword123!'),
        ).called(1);
      });

      test('simulates requires-recent-login then reauthentication', () async {
        // Arrange
        var attempts = 0;
        when(() => mockRemote.changePassword(any())).thenAnswer((_) async {
          attempts++;
          if (attempts == 1) {
            throw Exception('requires-recent-login');
          }
        });

        // Act - First attempt fails
        final firstAttempt = await repo.changePassword('NewSecurePassword123!');

        // User reauthenticates (external action)

        // Act - Second attempt succeeds
        final secondAttempt = await repo.changePassword(
          'NewSecurePassword123!',
        );

        // Assert
        expect(firstAttempt.isLeft, isTrue);
        expect(
          firstAttempt.leftOrNull?.message,
          contains('requires-recent-login'),
        );
        expect(secondAttempt.isRight, isTrue);
      });

      test('simulates too-many-requests for reset link', () async {
        // Arrange
        when(
          () => mockRemote.sendResetLink(any()),
        ).thenThrow(Exception('too-many-requests'));

        // Act
        final result = await repo.sendResetLink(TestConstants.validEmail);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('too-many-requests'));
      });

      test('simulates password change with weak password', () async {
        // Arrange
        when(
          () => mockRemote.changePassword(any()),
        ).thenThrow(Exception('weak-password'));

        // Act
        final result = await repo.changePassword('123');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('weak-password'));
      });

      test('simulates user not found during reset', () async {
        // Arrange
        when(
          () => mockRemote.sendResetLink(any()),
        ).thenThrow(Exception('user-not-found'));

        // Act
        final result = await repo.sendResetLink('nonexistent@example.com');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('user-not-found'));
      });
    });

    group('combined operations', () {
      test('can perform both operations independently', () async {
        // Arrange
        when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});
        when(() => mockRemote.changePassword(any())).thenAnswer((_) async {});

        // Act
        final resetResult = await repo.sendResetLink(TestConstants.validEmail);
        final changeResult = await repo.changePassword(
          TestConstants.validPassword,
        );

        // Assert
        expect(resetResult.isRight, isTrue);
        expect(changeResult.isRight, isTrue);
        verify(
          () => mockRemote.sendResetLink(TestConstants.validEmail),
        ).called(1);
        verify(
          () => mockRemote.changePassword(TestConstants.validPassword),
        ).called(1);
      });

      test('handles mixed success and failure states', () async {
        // Arrange
        when(() => mockRemote.sendResetLink(any())).thenAnswer((_) async {});
        when(
          () => mockRemote.changePassword(any()),
        ).thenThrow(Exception('Error'));

        // Act
        final resetResult = await repo.sendResetLink(TestConstants.validEmail);
        final changeResult = await repo.changePassword(
          TestConstants.validPassword,
        );

        // Assert
        expect(resetResult.isRight, isTrue);
        expect(changeResult.isLeft, isTrue);
      });
    });
  });
}
