/// Tests for SignUpUseCase
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Successful sign-up
/// - Repository error handling
/// - Parameter passing (name, email, password)
library;

import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart';
import 'package:features_dd_layers/src/auth/domain/use_cases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../../fixtures/test_constants.dart';
import '../../../../helpers/test_helpers.dart';

class MockSignUpRepo extends Mock implements ISignUpRepo {}

void main() {
  group('SignUpUseCase', () {
    late ISignUpRepo mockRepo;
    late SignUpUseCase useCase;

    setUp(() {
      mockRepo = MockSignUpRepo();
      useCase = SignUpUseCase(mockRepo);
    });

    group('constructor', () {
      test('creates instance with provided repository', () {
        // Arrange & Act
        final useCase = SignUpUseCase(mockRepo);

        // Assert
        expect(useCase, isA<SignUpUseCase>());
        expect(useCase.repo, equals(mockRepo));
      });
    });

    group('call', () {
      group('successful sign-up', () {
        test('calls repository with correct parameters', () async {
          // Arrange
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            name: 'Test User',
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRepo.signup(
              name: 'Test User',
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });

        test('returns Right on successful sign-up', () async {
          // Arrange
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(
            name: 'John Doe',
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isRight, isTrue);
          // Right returns void
        });

        test('works with different valid credentials', () async {
          // Arrange
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result1 = await useCase(
            name: 'User One',
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          final result2 = await useCase(
            name: 'User Two',
            email: TestConstants.validEmail2,
            password: TestConstants.validPassword2,
          );

          // Assert
          expect(result1.isRight, isTrue);
          expect(result2.isRight, isTrue);
        });
      });

      group('failed sign-up', () {
        test('returns Left when repository fails', () async {
          // Arrange
          final failure = 'Sign-up failed'.toFailure();
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            name: 'Test User',
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, equals(failure));
        });

        test('handles email already in use error', () async {
          // Arrange
          final failure = 'Email already in use'.toFailure();
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            name: 'Test User',
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('already in use'));
        });

        test('handles weak password error', () async {
          // Arrange
          final failure = 'Password is too weak'.toFailure();
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            name: 'Test User',
            email: TestConstants.validEmail,
            password: TestConstants.weakPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('weak'));
        });

        test('handles network errors', () async {
          // Arrange
          final failure = 'Network error'.toFailure();
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            name: 'Test User',
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Network'));
        });
      });

      group('parameter validation', () {
        test('passes empty name to repository', () async {
          // Arrange
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            name: TestConstants.emptyString,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRepo.signup(
              name: TestConstants.emptyString,
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });

        test('passes all empty parameters to repository', () async {
          // Arrange
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            name: TestConstants.emptyString,
            email: TestConstants.emptyString,
            password: TestConstants.emptyString,
          );

          // Assert
          verify(
            () => mockRepo.signup(
              name: TestConstants.emptyString,
              email: TestConstants.emptyString,
              password: TestConstants.emptyString,
            ),
          ).called(1);
        });

        test('passes long name to repository', () async {
          // Arrange
          final longName = 'A' * 100;
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            name: longName,
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRepo.signup(
              name: longName,
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });
      });

      group('edge cases', () {
        test('handles multiple sequential calls', () async {
          // Arrange
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            name: 'User 1',
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          await useCase(
            name: 'User 2',
            email: TestConstants.validEmail2,
            password: TestConstants.validPassword2,
          );

          // Assert
          verify(
            () => mockRepo.signup(
              name: 'User 1',
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
          verify(
            () => mockRepo.signup(
              name: 'User 2',
              email: TestConstants.validEmail2,
              password: TestConstants.validPassword2,
            ),
          ).called(1);
        });

        test('handles concurrent calls', () async {
          // Arrange
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async {
              await wait(TestConstants.shortDelayMs);
              return const Right(null);
            },
          );

          // Act
          final futures = [
            useCase(
              name: 'User 1',
              email: 'user1@example.com',
              password: 'Password1!',
            ),
            useCase(
              name: 'User 2',
              email: 'user2@example.com',
              password: 'Password2!',
            ),
            useCase(
              name: 'User 3',
              email: 'user3@example.com',
              password: 'Password3!',
            ),
          ];
          final results = await futures.awaitAll();

          // Assert
          expect(results.length, equals(3));
          for (final result in results) {
            expect(result.isRight, isTrue);
          }
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates successful user registration', () async {
        // Arrange
        when(
          () => mockRepo.signup(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'SecurePassword123!',
        );

        // Assert
        expect(result.isRight, isTrue);
      });

      test('simulates duplicate email scenario', () async {
        // Arrange
        final failure = 'The email address is already in use'.toFailure();
        when(
          () => mockRepo.signup(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase(
          name: 'John Doe',
          email: 'existing@example.com',
          password: TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('already in use'));
      });

      test('simulates special characters in name', () async {
        // Arrange
        when(
          () => mockRepo.signup(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          name: "François O'Brien-Smith",
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Assert
        expect(result.isRight, isTrue);
        verify(
          () => mockRepo.signup(
            name: "François O'Brien-Smith",
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          ),
        ).called(1);
      });
    });
  });
}
