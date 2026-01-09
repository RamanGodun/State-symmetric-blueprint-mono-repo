/// Tests for SignInUseCase
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Successful sign-in
/// - Repository error handling
/// - Parameter passing
library;

import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart';
import 'package:features_dd_layers/src/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../../fixtures/test_constants.dart';
import '../../../../helpers/test_helpers.dart';

class MockSignInRepo extends Mock implements ISignInRepo {}

void main() {
  group('SignInUseCase', () {
    late ISignInRepo mockRepo;
    late SignInUseCase useCase;

    setUp(() {
      mockRepo = MockSignInRepo();
      useCase = SignInUseCase(mockRepo);
    });

    group('constructor', () {
      test('creates instance with provided repository', () {
        // Arrange & Act
        final useCase = SignInUseCase(mockRepo);

        // Assert
        expect(useCase, isA<SignInUseCase>());
        expect(useCase.authRepo, equals(mockRepo));
      });
    });

    group('call', () {
      group('successful sign-in', () {
        test('calls repository with correct parameters', () async {
          // Arrange
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRepo.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });

        test('returns Right on successful sign-in', () async {
          // Arrange
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(
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
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result1 = await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          final result2 = await useCase(
            email: TestConstants.validEmail2,
            password: TestConstants.validPassword2,
          );

          // Assert
          expect(result1.isRight, isTrue);
          expect(result2.isRight, isTrue);
          verify(
            () => mockRepo.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(1);
          verify(
            () => mockRepo.signIn(
              email: TestConstants.validEmail2,
              password: TestConstants.validPassword2,
            ),
          ).called(1);
        });
      });

      group('failed sign-in', () {
        test('returns Left when repository fails', () async {
          // Arrange
          final failure = 'Sign-in failed'.toFailure();
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, equals(failure));
        });

        test('propagates repository error', () async {
          // Arrange
          final failure = 'Invalid credentials'.toFailure();
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            email: TestConstants.invalidEmail,
            password: TestConstants.weakPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, equals('Invalid credentials'));
        });

        test('handles network errors', () async {
          // Arrange
          final failure = 'Network error'.toFailure();
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Network'));
        });

        test('handles authentication errors', () async {
          // Arrange
          final failure = 'User not found'.toFailure();
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, equals('User not found'));
        });
      });

      group('parameter validation', () {
        test('passes empty email to repository', () async {
          // Arrange
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            email: TestConstants.emptyString,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRepo.signIn(
              email: TestConstants.emptyString,
              password: TestConstants.validPassword,
            ),
          ).called(1);
        });

        test('passes empty password to repository', () async {
          // Arrange
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.emptyString,
          );

          // Assert
          verify(
            () => mockRepo.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.emptyString,
            ),
          ).called(1);
        });

        test('passes invalid email format to repository', () async {
          // Arrange
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            email: TestConstants.invalidEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRepo.signIn(
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
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );
          await useCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          );

          // Assert
          verify(
            () => mockRepo.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(3);
        });

        test('handles concurrent calls', () async {
          // Arrange
          when(
            () => mockRepo.signIn(
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
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
            useCase(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
            useCase(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ];
          final results = await futures.awaitAll();

          // Assert
          expect(results.length, equals(3));
          for (final result in results) {
            expect(result.isRight, isTrue);
          }
          verify(
            () => mockRepo.signIn(
              email: TestConstants.validEmail,
              password: TestConstants.validPassword,
            ),
          ).called(3);
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates successful user login flow', () async {
        // Arrange
        when(
          () => mockRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          email: 'john.doe@example.com',
          password: 'SecurePassword123!',
        );

        // Assert
        expect(result.isRight, isTrue);
      });

      test('simulates invalid credentials scenario', () async {
        // Arrange
        final failure = 'Invalid email or password'.toFailure();
        when(
          () => mockRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase(
          email: 'john.doe@example.com',
          password: 'WrongPassword',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Invalid'));
      });

      test('simulates account not found scenario', () async {
        // Arrange
        final failure = 'No user found for that email'.toFailure();
        when(
          () => mockRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase(
          email: 'nonexistent@example.com',
          password: TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('No user found'));
      });
    });
  });
}
