/// Tests for IUserValidationRepoImpl
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Email verification sending
/// - User reload functionality
/// - Email verification status checking
/// - Error handling for all operations
library;

import 'package:features_dd_layers/public_api/email_verification/email_verification.dart';
import 'package:features_dd_layers/src/email_verification/data/email_verification_repo_impl.dart';
import 'package:features_dd_layers/src/email_verification/data/remote_database_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

class MockUserValidationRemoteDataSource extends Mock
    implements IUserValidationRemoteDataSource {}

void main() {
  group('IUserValidationRepoImpl', () {
    late IUserValidationRemoteDataSource mockRemote;
    late IUserValidationRepo repo;

    setUp(() {
      mockRemote = MockUserValidationRemoteDataSource();
      repo = IUserValidationRepoImpl(mockRemote);
    });

    group('constructor', () {
      test('creates instance with provided remote data source', () {
        // Arrange & Act
        final repo = IUserValidationRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<IUserValidationRepoImpl>());
        expect(repo, isA<IUserValidationRepo>());
      });
    });

    group('sendEmailVerification', () {
      group('successful verification email sending', () {
        test('calls remote sendVerificationEmail method', () async {
          // Arrange
          when(
            () => mockRemote.sendVerificationEmail(),
          ).thenAnswer((_) async {});

          // Act
          await repo.sendEmailVerification();

          // Assert
          verify(() => mockRemote.sendVerificationEmail()).called(1);
        });

        test('returns Right on successful email send', () async {
          // Arrange
          when(
            () => mockRemote.sendVerificationEmail(),
          ).thenAnswer((_) async {});

          // Act
          final result = await repo.sendEmailVerification();

          // Assert
          expect(result.isRight, isTrue);
        });

        test('can send verification email multiple times', () async {
          // Arrange
          when(
            () => mockRemote.sendVerificationEmail(),
          ).thenAnswer((_) async {});

          // Act
          await repo.sendEmailVerification();
          await repo.sendEmailVerification();
          await repo.sendEmailVerification();

          // Assert
          verify(() => mockRemote.sendVerificationEmail()).called(3);
        });
      });

      group('failed verification email sending', () {
        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.sendVerificationEmail(),
          ).thenThrow(Exception('Email send failed'));

          // Act
          final result = await repo.sendEmailVerification();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.sendVerificationEmail(),
          ).thenThrow(Exception('User not authenticated'));

          // Act
          final result = await repo.sendEmailVerification();

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.message,
            contains('User not authenticated'),
          );
        });

        test('handles network errors', () async {
          // Arrange
          when(
            () => mockRemote.sendVerificationEmail(),
          ).thenThrow(Exception('Network unavailable'));

          // Act
          final result = await repo.sendEmailVerification();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Network unavailable'));
        });

        test('handles too-many-requests errors', () async {
          // Arrange
          when(
            () => mockRemote.sendVerificationEmail(),
          ).thenThrow(Exception('too-many-requests'));

          // Act
          final result = await repo.sendEmailVerification();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('too-many-requests'));
        });
      });
    });

    group('reloadUser', () {
      group('successful user reload', () {
        test('calls remote reloadUser method', () async {
          // Arrange
          when(() => mockRemote.reloadUser()).thenAnswer((_) async {});

          // Act
          await repo.reloadUser();

          // Assert
          verify(() => mockRemote.reloadUser()).called(1);
        });

        test('returns Right on successful reload', () async {
          // Arrange
          when(() => mockRemote.reloadUser()).thenAnswer((_) async {});

          // Act
          final result = await repo.reloadUser();

          // Assert
          expect(result.isRight, isTrue);
        });

        test('can reload user multiple times', () async {
          // Arrange
          when(() => mockRemote.reloadUser()).thenAnswer((_) async {});

          // Act
          await repo.reloadUser();
          await repo.reloadUser();

          // Assert
          verify(() => mockRemote.reloadUser()).called(2);
        });
      });

      group('failed user reload', () {
        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.reloadUser(),
          ).thenThrow(Exception('Reload failed'));

          // Act
          final result = await repo.reloadUser();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.reloadUser(),
          ).thenThrow(Exception('User not found'));

          // Act
          final result = await repo.reloadUser();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('User not found'));
        });

        test('handles network errors during reload', () async {
          // Arrange
          when(
            () => mockRemote.reloadUser(),
          ).thenThrow(Exception('Connection timeout'));

          // Act
          final result = await repo.reloadUser();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Connection timeout'));
        });
      });
    });

    group('isEmailVerified', () {
      group('successful verification status check', () {
        test('calls remote isEmailVerified getter', () async {
          // Arrange
          when(() => mockRemote.isEmailVerified()).thenReturn(true);

          // Act
          await repo.isEmailVerified();

          // Assert
          verify(() => mockRemote.isEmailVerified()).called(1);
        });

        test('returns Right with true when email is verified', () async {
          // Arrange
          when(() => mockRemote.isEmailVerified()).thenReturn(true);

          // Act
          final result = await repo.isEmailVerified();

          // Assert
          expect(result.isRight, isTrue);
          expect(result.rightOrNull, isTrue);
        });

        test('returns Right with false when email is not verified', () async {
          // Arrange
          when(() => mockRemote.isEmailVerified()).thenReturn(false);

          // Act
          final result = await repo.isEmailVerified();

          // Assert
          expect(result.isRight, isTrue);
          expect(result.rightOrNull, isFalse);
        });

        test('can check verification status multiple times', () async {
          // Arrange
          when(() => mockRemote.isEmailVerified()).thenReturn(false);

          // Act
          await repo.isEmailVerified();
          await repo.isEmailVerified();
          await repo.isEmailVerified();

          // Assert
          verify(() => mockRemote.isEmailVerified()).called(3);
        });

        test('reflects changes in verification status', () async {
          // Arrange
          var callCount = 0;
          when(() => mockRemote.isEmailVerified()).thenAnswer((_) {
            callCount++;
            return callCount > 1; // False first time, true after
          });

          // Act
          final result1 = await repo.isEmailVerified();
          final result2 = await repo.isEmailVerified();

          // Assert
          expect(result1.rightOrNull, isFalse);
          expect(result2.rightOrNull, isTrue);
        });
      });

      group('failed verification status check', () {
        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.isEmailVerified(),
          ).thenThrow(Exception('Status check failed'));

          // Act
          final result = await repo.isEmailVerified();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.isEmailVerified(),
          ).thenThrow(Exception('User session expired'));

          // Act
          final result = await repo.isEmailVerified();

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.message,
            contains('User session expired'),
          );
        });

        test('handles network errors during status check', () async {
          // Arrange
          when(
            () => mockRemote.isEmailVerified(),
          ).thenThrow(Exception('No internet connection'));

          // Act
          final result = await repo.isEmailVerified();

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.message,
            contains('No internet connection'),
          );
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates complete email verification flow', () async {
        // Arrange
        var emailVerified = false;

        when(() => mockRemote.sendVerificationEmail()).thenAnswer((_) async {});
        when(() => mockRemote.reloadUser()).thenAnswer((_) async {});
        when(
          () => mockRemote.isEmailVerified(),
        ).thenAnswer((_) => emailVerified);

        // Act - Check initial status
        final initialStatus = await repo.isEmailVerified();

        // Act - Send verification email
        final sendResult = await repo.sendEmailVerification();

        // Simulate user clicking verification link (external action)
        emailVerified = true;

        // Act - Reload user to fetch updated status
        final reloadResult = await repo.reloadUser();

        // Act - Check final status
        final finalStatus = await repo.isEmailVerified();

        // Assert
        expect(initialStatus.rightOrNull, isFalse);
        expect(sendResult.isRight, isTrue);
        expect(reloadResult.isRight, isTrue);
        expect(finalStatus.rightOrNull, isTrue);

        verify(() => mockRemote.sendVerificationEmail()).called(1);
        verify(() => mockRemote.reloadUser()).called(1);
        verify(() => mockRemote.isEmailVerified()).called(2);
      });

      test('simulates failed verification email send with retry', () async {
        // Arrange
        var attempts = 0;
        when(() => mockRemote.sendVerificationEmail()).thenAnswer((_) async {
          attempts++;
          if (attempts == 1) {
            throw Exception('Network error');
          }
        });

        // Act - First attempt fails
        final firstAttempt = await repo.sendEmailVerification();

        // Act - Second attempt succeeds
        final secondAttempt = await repo.sendEmailVerification();

        // Assert
        expect(firstAttempt.isLeft, isTrue);
        expect(secondAttempt.isRight, isTrue);
        verify(() => mockRemote.sendVerificationEmail()).called(2);
      });

      test('simulates checking status before and after reload', () async {
        // Arrange
        var reloadCalled = false;

        when(
          () => mockRemote.isEmailVerified(),
        ).thenAnswer((_) => reloadCalled);
        when(() => mockRemote.reloadUser()).thenAnswer((_) async {
          reloadCalled = true;
        });

        // Act
        final statusBeforeReload = await repo.isEmailVerified();
        await repo.reloadUser();
        final statusAfterReload = await repo.isEmailVerified();

        // Assert
        expect(statusBeforeReload.rightOrNull, isFalse);
        expect(statusAfterReload.rightOrNull, isTrue);
      });

      test('simulates too-many-requests error handling', () async {
        // Arrange
        when(
          () => mockRemote.sendVerificationEmail(),
        ).thenThrow(Exception('too-many-requests'));

        // Act
        final result = await repo.sendEmailVerification();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('too-many-requests'));
      });
    });

    group('edge cases', () {
      test('handles rapid consecutive verification checks', () async {
        // Arrange
        when(() => mockRemote.isEmailVerified()).thenReturn(true);

        // Act
        final results = await Future.wait([
          repo.isEmailVerified(),
          repo.isEmailVerified(),
          repo.isEmailVerified(),
          repo.isEmailVerified(),
          repo.isEmailVerified(),
        ]);

        // Assert
        for (final result in results) {
          expect(result.isRight, isTrue);
          expect(result.rightOrNull, isTrue);
        }
      });

      test('handles rapid consecutive reload calls', () async {
        // Arrange
        when(() => mockRemote.reloadUser()).thenAnswer((_) async {});

        // Act
        final results = await Future.wait([
          repo.reloadUser(),
          repo.reloadUser(),
          repo.reloadUser(),
        ]);

        // Assert
        for (final result in results) {
          expect(result.isRight, isTrue);
        }
        verify(() => mockRemote.reloadUser()).called(3);
      });

      test('handles generic errors', () async {
        // Arrange
        when(
          () => mockRemote.sendVerificationEmail(),
        ).thenThrow('String error');

        // Act
        final result = await repo.sendEmailVerification();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<Failure>());
      });
    });
  });
}
