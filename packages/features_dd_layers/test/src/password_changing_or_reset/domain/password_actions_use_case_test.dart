/// Tests for PasswordRelatedUseCases
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Password changing
/// - Password reset link sending
/// - Error handling
library;

import 'package:features_dd_layers/src/password_changing_or_reset/domain/password_actions_use_case.dart';
import 'package:features_dd_layers/src/password_changing_or_reset/domain/repo_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../fixtures/test_constants.dart' show TestConstants;
import '../../../helpers/test_helpers.dart' show TestFailureX;

class MockPasswordRepo extends Mock implements IPasswordRepo {}

void main() {
  group('PasswordRelatedUseCases', () {
    late IPasswordRepo mockRepo;
    late PasswordRelatedUseCases useCase;

    setUp(() {
      mockRepo = MockPasswordRepo();
      useCase = PasswordRelatedUseCases(mockRepo);
    });

    group('constructor', () {
      test('creates instance with provided repository', () {
        // Arrange & Act
        final useCase = PasswordRelatedUseCases(mockRepo);

        // Assert
        expect(useCase, isA<PasswordRelatedUseCases>());
        expect(useCase.repo, equals(mockRepo));
      });
    });

    group('callChangePassword', () {
      test('calls repository changePassword with correct parameter', () async {
        // Arrange
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.callChangePassword(TestConstants.validPassword);

        // Assert
        verify(
          () => mockRepo.changePassword(TestConstants.validPassword),
        ).called(1);
      });

      test('returns Right on successful password change', () async {
        // Arrange
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase.callChangePassword(
          TestConstants.validPassword,
        );

        // Assert
        expect(result.isRight, isTrue);
      });

      test('returns Left when repository fails', () async {
        // Arrange
        final failure = 'Password change failed'.toFailure();
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.callChangePassword(
          TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, equals(failure));
      });

      test('handles weak password error', () async {
        // Arrange
        final failure = 'Password is too weak'.toFailure();
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.callChangePassword(
          TestConstants.weakPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('weak'));
      });

      test('passes empty password to repository', () async {
        // Arrange
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.callChangePassword(TestConstants.emptyString);

        // Assert
        verify(
          () => mockRepo.changePassword(TestConstants.emptyString),
        ).called(1);
      });

      test('handles multiple password changes', () async {
        // Arrange
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.callChangePassword('Password1!');
        await useCase.callChangePassword('Password2!');
        await useCase.callChangePassword('Password3!');

        // Assert
        verify(() => mockRepo.changePassword('Password1!')).called(1);
        verify(() => mockRepo.changePassword('Password2!')).called(1);
        verify(() => mockRepo.changePassword('Password3!')).called(1);
      });
    });

    group('callResetPassword', () {
      test('calls repository sendResetLink with correct email', () async {
        // Arrange
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.callResetPassword(TestConstants.validEmail);

        // Assert
        verify(
          () => mockRepo.sendResetLink(TestConstants.validEmail),
        ).called(1);
      });

      test('returns Right on successful reset link send', () async {
        // Arrange
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase.callResetPassword(
          TestConstants.validEmail,
        );

        // Assert
        expect(result.isRight, isTrue);
      });

      test('returns Left when repository fails', () async {
        // Arrange
        final failure = 'Failed to send reset link'.toFailure();
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.callResetPassword(
          TestConstants.validEmail,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, equals(failure));
      });

      test('handles user not found error', () async {
        // Arrange
        final failure = 'User not found'.toFailure();
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.callResetPassword(
          'nonexistent@example.com',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('not found'));
      });

      test('handles invalid email error', () async {
        // Arrange
        final failure = 'Invalid email format'.toFailure();
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.callResetPassword(
          TestConstants.invalidEmail,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Invalid'));
      });

      test('passes empty email to repository', () async {
        // Arrange
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.callResetPassword(TestConstants.emptyString);

        // Assert
        verify(
          () => mockRepo.sendResetLink(TestConstants.emptyString),
        ).called(1);
      });

      test('handles multiple reset requests', () async {
        // Arrange
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.callResetPassword(TestConstants.validEmail);
        await useCase.callResetPassword(TestConstants.validEmail2);

        // Assert
        verify(
          () => mockRepo.sendResetLink(TestConstants.validEmail),
        ).called(1);
        verify(
          () => mockRepo.sendResetLink(TestConstants.validEmail2),
        ).called(1);
      });
    });

    group('real-world scenarios', () {
      test('simulates successful password change flow', () async {
        // Arrange
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase.callChangePassword(
          'NewSecurePassword123!',
        );

        // Assert
        expect(result.isRight, isTrue);
        verify(
          () => mockRepo.changePassword('NewSecurePassword123!'),
        ).called(1);
      });

      test('simulates forgot password flow', () async {
        // Arrange
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase.callResetPassword('user@example.com');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => mockRepo.sendResetLink('user@example.com')).called(1);
      });

      test('simulates password change with weak password rejection', () async {
        // Arrange
        final weakPasswordFailure = 'Password must be at least 6 characters'
            .toFailure();
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => Left(weakPasswordFailure));

        // Act
        final result = await useCase.callChangePassword('123');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('6 characters'));
      });

      test('simulates reset link rate limiting', () async {
        // Arrange
        final rateLimitFailure = 'Too many reset attempts'.toFailure();
        when(
          () => mockRepo.sendResetLink(any()),
        ).thenAnswer((_) async => Left(rateLimitFailure));

        // Act
        final result = await useCase.callResetPassword(
          TestConstants.validEmail,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Too many'));
      });

      test('simulates network error during password change', () async {
        // Arrange
        final networkFailure = 'Network connection failed'.toFailure();
        when(
          () => mockRepo.changePassword(any()),
        ).thenAnswer((_) async => Left(networkFailure));

        // Act
        final result = await useCase.callChangePassword(
          TestConstants.validPassword,
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Network'));
      });

      test('simulates retry after failed password change', () async {
        // Arrange
        var firstCall = true;
        when(() => mockRepo.changePassword(any())).thenAnswer((_) async {
          if (firstCall) {
            firstCall = false;
            return Left('Network error'.toFailure());
          }
          return const Right(null);
        });

        // Act
        final result1 = await useCase.callChangePassword(
          TestConstants.validPassword,
        );
        final result2 = await useCase.callChangePassword(
          TestConstants.validPassword,
        );

        // Assert
        expect(result1.isLeft, isTrue);
        expect(result2.isRight, isTrue);
      });
    });
  });
}
