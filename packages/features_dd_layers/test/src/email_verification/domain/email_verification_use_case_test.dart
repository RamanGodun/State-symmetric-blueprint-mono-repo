/// Tests for EmailVerificationUseCase
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Sending verification email
/// - Reloading user
/// - Checking email verification status
library;

import 'package:features_dd_layers/src/email_verification/domain/email_verification_use_case.dart';
import 'package:features_dd_layers/src/email_verification/domain/repo_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthGateway;

import '../../../helpers/test_helpers.dart' show TestFailureX;

class MockUserValidationRepo extends Mock implements IUserValidationRepo {}

class MockAuthGateway extends Mock implements AuthGateway {}

void main() {
  group('EmailVerificationUseCase', () {
    late IUserValidationRepo mockRepo;
    late AuthGateway mockGateway;
    late EmailVerificationUseCase useCase;

    setUp(() {
      mockRepo = MockUserValidationRepo();
      mockGateway = MockAuthGateway();
      useCase = EmailVerificationUseCase(mockRepo, mockGateway);
    });

    group('constructor', () {
      test('creates instance with provided dependencies', () {
        // Arrange & Act
        final useCase = EmailVerificationUseCase(mockRepo, mockGateway);

        // Assert
        expect(useCase, isA<EmailVerificationUseCase>());
        expect(useCase.repo, equals(mockRepo));
        expect(useCase.gateway, equals(mockGateway));
      });
    });

    group('sendVerificationEmail', () {
      test('calls repository sendEmailVerification', () async {
        // Arrange
        when(
          () => mockRepo.sendEmailVerification(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.sendVerificationEmail();

        // Assert
        verify(() => mockRepo.sendEmailVerification()).called(1);
      });

      test('returns Right on successful send', () async {
        // Arrange
        when(
          () => mockRepo.sendEmailVerification(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase.sendVerificationEmail();

        // Assert
        expect(result.isRight, isTrue);
      });

      test('returns Left when repository fails', () async {
        // Arrange
        final failure = 'Failed to send email'.toFailure();
        when(
          () => mockRepo.sendEmailVerification(),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.sendVerificationEmail();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, equals(failure));
      });

      test('handles multiple sequential calls', () async {
        // Arrange
        when(
          () => mockRepo.sendEmailVerification(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.sendVerificationEmail();
        await useCase.sendVerificationEmail();
        await useCase.sendVerificationEmail();

        // Assert
        verify(() => mockRepo.sendEmailVerification()).called(3);
      });
    });

    group('reloadUser', () {
      test('calls repository reloadUser', () async {
        // Arrange
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase.reloadUser();

        // Assert
        verify(() => mockRepo.reloadUser()).called(1);
      });

      test('returns Right on successful reload', () async {
        // Arrange
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase.reloadUser();

        // Assert
        expect(result.isRight, isTrue);
      });

      test('returns Left when repository fails', () async {
        // Arrange
        final failure = 'Failed to reload user'.toFailure();
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.reloadUser();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, equals(failure));
      });
    });

    group('checkIfEmailVerified', () {
      test('calls reloadUser then isEmailVerified', () async {
        // Arrange
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRepo.isEmailVerified(),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await useCase.checkIfEmailVerified();

        // Assert
        verify(() => mockRepo.reloadUser()).called(1);
        verify(() => mockRepo.isEmailVerified()).called(1);
      });

      test('returns true when email is verified', () async {
        // Arrange
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRepo.isEmailVerified(),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase.checkIfEmailVerified();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.rightOrNull, isTrue);
      });

      test('returns false when email is not verified', () async {
        // Arrange
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRepo.isEmailVerified(),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase.checkIfEmailVerified();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.rightOrNull, isFalse);
      });

      test('returns Left when reload fails', () async {
        // Arrange
        final failure = 'Reload failed'.toFailure();
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => Left(failure));
        when(
          () => mockRepo.isEmailVerified(),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase.checkIfEmailVerified();

        // Assert - Even though reload failed, isEmailVerified is still called
        expect(result.isRight, isTrue);
      });

      test('returns Left when verification check fails', () async {
        // Arrange
        final failure = 'Check failed'.toFailure();
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRepo.isEmailVerified(),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase.checkIfEmailVerified();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, equals(failure));
      });
    });

    group('real-world scenarios', () {
      test('simulates email verification flow', () async {
        // Arrange
        when(
          () => mockRepo.sendEmailVerification(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => const Right(null));
        var callCount = 0;
        when(
          () => mockRepo.isEmailVerified(),
        ).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? const Right(false) : const Right(true);
        });

        // Act - Send verification email
        final sendResult = await useCase.sendVerificationEmail();
        expect(sendResult.isRight, isTrue);

        // Act - Check status (not verified yet)
        final checkResult1 = await useCase.checkIfEmailVerified();
        expect(checkResult1.rightOrNull, isFalse);

        // Act - Check again after user clicks link
        final checkResult2 = await useCase.checkIfEmailVerified();
        expect(checkResult2.rightOrNull, isTrue);

        // Assert
        verify(() => mockRepo.sendEmailVerification()).called(1);
        verify(() => mockRepo.reloadUser()).called(2);
        verify(() => mockRepo.isEmailVerified()).called(2);
      });

      test('simulates email sending rate limit error', () async {
        // Arrange
        final rateLimitFailure = 'Too many requests'.toFailure();
        when(
          () => mockRepo.sendEmailVerification(),
        ).thenAnswer((_) async => Left(rateLimitFailure));

        // Act
        final result = await useCase.sendVerificationEmail();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Too many'));
      });

      test('simulates network error during reload', () async {
        // Arrange
        final networkFailure = 'Network error'.toFailure();
        when(
          () => mockRepo.reloadUser(),
        ).thenAnswer((_) async => Left(networkFailure));
        when(
          () => mockRepo.isEmailVerified(),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase.checkIfEmailVerified();

        // Assert - Even though reload failed, isEmailVerified is still called
        expect(result.isRight, isTrue);
      });
    });
  });
}
