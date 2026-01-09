/// Tests for SignUpRepoImpl
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Successful sign-up with user creation and data saving
/// - Error handling during sign-up and data saving
/// - DTO creation and mapping
/// - Parameter passing to remote database
library;

import 'package:features_dd_layers/src/auth/data/auth_repo_implementations/sign_up_repo_impl.dart';
import 'package:features_dd_layers/src/auth/data/remote_database_contract.dart';
import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../../fixtures/test_constants.dart';

class MockAuthRemoteDatabase extends Mock implements IAuthRemoteDatabase {}

void main() {
  group('SignUpRepoImpl', () {
    late IAuthRemoteDatabase mockRemote;
    late ISignUpRepo repo;

    setUp(() {
      mockRemote = MockAuthRemoteDatabase();
      repo = SignUpRepoImpl(mockRemote);
    });

    group('constructor', () {
      test('creates instance with provided remote database', () {
        // Arrange & Act
        final repo = SignUpRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<SignUpRepoImpl>());
        expect(repo, isA<ISignUpRepo>());
      });
    });

    group('signup', () {
      group('successful sign-up', () {
        test('calls signUp and saveUserData in sequence', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          when(
            () => mockRemote.saveUserData(
              any(),
              any(),
            ),
          ).thenAnswer((_) async {});

          // Act
          await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRemote.signUp(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);

          verify(
            () => mockRemote.saveUserData(
              TestConstants.testUserId,
              any(),
            ),
          ).called(1);
        });

        test('returns Right on successful sign-up and data save', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          final result = await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isRight, isTrue);
        });

        test('saves user data with correct UID', () async {
          // Arrange
          const expectedUid = 'user-123-abc';

          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => expectedUid);

          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(() => mockRemote.saveUserData(expectedUid, any())).called(1);
        });

        test('creates user data with name and email', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          Map<String, dynamic>? capturedData;
          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((invocation) async {
            capturedData =
                invocation.positionalArguments[1] as Map<String, dynamic>;
          });

          // Act
          await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(capturedData, isNotNull);
          expect(
            capturedData!['name'],
            equals(TestConstants.testUserEntity.name),
          );
          expect(capturedData!['email'], equals(TestConstants.validEmail));
        });

        test('works with different user data', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => 'uid-different');

          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          final result1 = await repo.signup(
            name: 'User One',
            email: 'user1@example.com',
            password: 'Password1!',
          );

          final result2 = await repo.signup(
            name: 'User Two',
            email: 'user2@example.com',
            password: 'Password2!',
          );

          // Assert
          expect(result1.isRight, isTrue);
          expect(result2.isRight, isTrue);
        });
      });

      group('failed sign-up', () {
        test('returns Left when signUp throws exception', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Email already exists'));

          // Act
          final result = await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message from signUp', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Weak password'));

          // Act
          final result = await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: 'weak',
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Weak password'));
        });

        test('returns Left when saveUserData throws exception', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenThrow(Exception('Database error'));

          // Act
          final result = await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Database error'));
        });

        test('does not save data if signUp fails', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Sign-up failed'));

          // Act
          await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verifyNever(() => mockRemote.saveUserData(any(), any()));
        });

        test('handles network errors', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Network error'));

          // Act
          final result = await repo.signup(
            name: TestConstants.testUserEntity.name,
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
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow('String error');

          // Act
          final result = await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });
      });

      group('parameter handling', () {
        test('passes empty name to data creation', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          Map<String, dynamic>? capturedData;
          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((invocation) async {
            capturedData =
                invocation.positionalArguments[1] as Map<String, dynamic>;
          });

          // Act
          await repo.signup(
            name: TestConstants.emptyString,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(capturedData!['name'], equals(TestConstants.emptyString));
        });

        test('passes empty email to signUp', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.emptyString,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRemote.signUp(
              email: TestConstants.emptyString,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });

        test('passes invalid email format to signUp', () async {
          // Arrange
          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          await repo.signup(
            name: TestConstants.testUserEntity.name,
            email: TestConstants.invalidEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRemote.signUp(
              email: TestConstants.invalidEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });
      });

      group('edge cases', () {
        test('handles very long user names', () async {
          // Arrange
          final longName = 'A' * 1000;

          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          Map<String, dynamic>? capturedData;
          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((invocation) async {
            capturedData =
                invocation.positionalArguments[1] as Map<String, dynamic>;
          });

          // Act
          await repo.signup(
            name: longName,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(capturedData!['name'], equals(longName));
        });

        test('handles special characters in name', () async {
          // Arrange
          const specialName = r"John-Doe O'Brien @#$%";

          when(
            () => mockRemote.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => TestConstants.testUserId);

          Map<String, dynamic>? capturedData;
          when(
            () => mockRemote.saveUserData(any(), any()),
          ).thenAnswer((invocation) async {
            capturedData =
                invocation.positionalArguments[1] as Map<String, dynamic>;
          });

          // Act
          await repo.signup(
            name: specialName,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(capturedData!['name'], equals(specialName));
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates successful Firebase user registration', () async {
        // Arrange
        when(
          () => mockRemote.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => 'firebase-uid-12345');

        when(
          () => mockRemote.saveUserData(any(), any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repo.signup(
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'SecurePassword123!',
        );

        // Assert
        expect(result.isRight, isTrue);
        verify(
          () => mockRemote.signUp(
            email: 'john.doe@example.com',
            password: 'SecurePassword123!',
          ),
        ).called(1);
        verify(
          () => mockRemote.saveUserData('firebase-uid-12345', any()),
        ).called(1);
      });

      test('simulates email-already-in-use error', () async {
        // Arrange
        when(
          () => mockRemote.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('email-already-in-use'));

        // Act
        final result = await repo.signup(
          name: TestConstants.testUserEntity.name,
          email: 'existing@example.com',
          password: TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('email-already-in-use'));
      });

      test('simulates weak-password error', () async {
        // Arrange
        when(
          () => mockRemote.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('weak-password'));

        // Act
        final result = await repo.signup(
          name: TestConstants.testUserEntity.name,
          email: TestConstants.validEmail,
          password: '123',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('weak-password'));
      });

      test('simulates Firestore save error after successful auth', () async {
        // Arrange
        when(
          () => mockRemote.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => TestConstants.testUserId);

        when(
          () => mockRemote.saveUserData(any(), any()),
        ).thenThrow(Exception('firestore-permission-denied'));

        // Act
        final result = await repo.signup(
          name: TestConstants.testUserEntity.name,
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(
          result.leftOrNull?.message,
          contains('firestore-permission-denied'),
        );
      });
    });
  });
}
