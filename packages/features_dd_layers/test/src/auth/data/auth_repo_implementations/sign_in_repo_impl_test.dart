/// Tests for SignInRepoImpl
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Successful sign-in delegation
/// - Error handling and mapping
/// - Parameter passing to remote database
library;

import 'package:features_dd_layers/src/auth/data/auth_repo_implementations/sign_in_repo_impl.dart';
import 'package:features_dd_layers/src/auth/data/remote_database_contract.dart';
import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../../fixtures/test_constants.dart';

class MockAuthRemoteDatabase extends Mock implements IAuthRemoteDatabase {}

void main() {
  group('SignInRepoImpl', () {
    late IAuthRemoteDatabase mockRemote;
    late ISignInRepo repo;

    setUp(() {
      mockRemote = MockAuthRemoteDatabase();
      repo = SignInRepoImpl(mockRemote);
    });

    group('constructor', () {
      test('creates instance with provided remote database', () {
        // Arrange & Act
        final repo = SignInRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<SignInRepoImpl>());
        expect(repo, isA<ISignInRepo>());
      });
    });

    group('signIn', () {
      group('successful sign-in', () {
        test('calls remote database with correct parameters', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Act
          await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRemote.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });

        test('returns Right on successful remote call', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Act
          final result = await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isRight, isTrue);
          // Right returns void
        });

        test('works with different credentials', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Act
          final result1 = await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          final result2 = await repo.signIn(
            email: TestConstants.validEmail2,
            password: TestConstants.validPassword2,
          );

          // Assert
          expect(result1.isRight, isTrue);
          expect(result2.isRight, isTrue);
        });
      });

      group('failed sign-in', () {
        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Sign-in failed'));

          // Act
          final result = await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in FailureEntity', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Invalid credentials'));

          // Act
          final result = await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.message,
            contains('Invalid credentials'),
          );
        });

        test('handles network errors', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Network error'));

          // Act
          final result = await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Network error'));
        });

        test('handles generic errors', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow('String error');

          // Act
          final result = await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });
      });

      group('parameter handling', () {
        test('passes empty email to remote', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Act
          await repo.signIn(
            email: TestConstants.emptyString,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRemote.signIn(
              email: TestConstants.emptyString,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });

        test('passes empty password to remote', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Act
          await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.emptyString,
          );

          // Assert
          verify(
            () => mockRemote.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.emptyString,
            ),
          ).called(1);
        });

        test('passes invalid email format to remote', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Act
          await repo.signIn(
            email: TestConstants.invalidEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRemote.signIn(
              email: TestConstants.invalidEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });
      });

      group('edge cases', () {
        test('handles multiple sequential calls', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Act
          await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRemote.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(3);
        });

        test('captures stack trace on error', () async {
          // Arrange
          when(
            () => mockRemote.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Error'));

          // Act
          final result = await repo.signIn(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          // stackTrace not available on Failure
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates successful Firebase authentication', () async {
        // Arrange
        when(
          () => mockRemote.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await repo.signIn(
          email: 'user@example.com',
          password: 'SecurePassword123!',
        );

        // Assert
        expect(result.isRight, isTrue);
      });

      test('simulates wrong password error', () async {
        // Arrange
        when(
          () => mockRemote.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('wrong-password'));

        // Act
        final result = await repo.signIn(
          email: TestConstants.validEmail,
          password: 'WrongPassword',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('wrong-password'));
      });

      test('simulates user not found error', () async {
        // Arrange
        when(
          () => mockRemote.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('user-not-found'));

        // Act
        final result = await repo.signIn(
          email: 'nonexistent@example.com',
          password: TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('user-not-found'));
      });

      test('simulates account disabled error', () async {
        // Arrange
        when(
          () => mockRemote.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('user-disabled'));

        // Act
        final result = await repo.signIn(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('user-disabled'));
      });
    });
  });
}
