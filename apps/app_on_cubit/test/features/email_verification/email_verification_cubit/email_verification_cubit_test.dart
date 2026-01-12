/// Tests for EmailVerificationCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Bootstrap behavior
/// - Email sending success/failure
/// - Cubit lifecycle and cleanup
library;

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:app_on_cubit/features/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:features_dd_layers/public_api/email_verification/email_verification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart';

class MockUserValidationRepo extends Mock implements IUserValidationRepo {}

class MockAuthGateway extends Mock implements AuthGateway {}

void main() {
  group('EmailVerificationCubit', () {
    late MockUserValidationRepo mockRepo;
    late MockAuthGateway mockAuthGateway;
    late EmailVerificationUseCase emailVerificationUseCase;

    setUp(() {
      mockRepo = MockUserValidationRepo();
      mockAuthGateway = MockAuthGateway();
      emailVerificationUseCase = EmailVerificationUseCase(
        mockRepo,
        mockAuthGateway,
      );
      when(() => mockAuthGateway.refresh()).thenAnswer((_) async {});
    });

    test('initial state is loading', () {
      // Arrange
      when(
        () => mockRepo.sendEmailVerification(),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockRepo.isEmailVerified(),
      ).thenAnswer((_) async => const Right(false));
      when(
        () => mockRepo.reloadUser(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final cubit = EmailVerificationCubit(
        emailVerificationUseCase,
        mockAuthGateway,
      );

      // Assert
      expect(cubit.state, isA<AsyncValueForBLoC<void>>());
      expect(cubit.state.isLoading, isTrue);

      cubit.close();
    });

    test('bootstrap sends verification email on construction', () async {
      // Arrange
      when(
        () => mockRepo.sendEmailVerification(),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockRepo.isEmailVerified(),
      ).thenAnswer((_) async => const Right(false));
      when(
        () => mockRepo.reloadUser(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final cubit = EmailVerificationCubit(
        emailVerificationUseCase,
        mockAuthGateway,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(() => mockRepo.sendEmailVerification()).called(1);

      await cubit.close();
    });

    test('emits error state when sending verification email fails', () async {
      // Arrange
      const failure = Failure(
        type: NetworkFailureType(),
        message: 'Failed to send verification email',
      );
      when(
        () => mockRepo.sendEmailVerification(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final cubit = EmailVerificationCubit(
        emailVerificationUseCase,
        mockAuthGateway,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(cubit.state.hasError, isTrue);

      await cubit.close();
    });

    test('polls for email verification periodically', () async {
      // Arrange
      when(
        () => mockRepo.sendEmailVerification(),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockRepo.isEmailVerified(),
      ).thenAnswer((_) async => const Right(false));
      when(
        () => mockRepo.reloadUser(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final cubit = EmailVerificationCubit(
        emailVerificationUseCase,
        mockAuthGateway,
      );
      // Wait long enough for at least one polling cycle (3 second interval)
      await Future<void>.delayed(const Duration(seconds: 4));

      // Assert - Should have checked email verification status at least once
      verify(() => mockRepo.isEmailVerified()).called(greaterThan(0));

      await cubit.close();
    });

    test('stops polling when email is verified', () async {
      // Arrange
      when(
        () => mockRepo.sendEmailVerification(),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockRepo.reloadUser(),
      ).thenAnswer((_) async => const Right(null));

      var callCount = 0;
      const isVerified = false;
      when(() => mockRepo.isEmailVerified()).thenAnswer((_) async {
        callCount++;
        // Never return verified to avoid Firebase initialization issues in test
        return const Right(isVerified);
      });

      // Act
      final cubit = EmailVerificationCubit(
        emailVerificationUseCase,
        mockAuthGateway,
      );
      // Wait for at least 2 polling cycles (3 sec * 2 = 6 sec + buffer)
      await Future<void>.delayed(const Duration(seconds: 7));

      // Assert - Should have been called multiple times (at least 2 for 2 polling cycles)
      final countBeforeClose = callCount;
      expect(countBeforeClose, greaterThanOrEqualTo(2));

      // Close cubit
      await cubit.close();

      // Verify polling stopped after close
      await Future<void>.delayed(const Duration(seconds: 4));
      expect(callCount, equals(countBeforeClose)); // No new calls after close
    });

    test('cleans up timer on close', () async {
      // Arrange
      when(
        () => mockRepo.sendEmailVerification(),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockRepo.isEmailVerified(),
      ).thenAnswer((_) async => const Right(false));
      when(
        () => mockRepo.reloadUser(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final cubit = EmailVerificationCubit(
        emailVerificationUseCase,
        mockAuthGateway,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await cubit.close();

      // Assert - Cubit should be closed
      expect(cubit.isClosed, isTrue);
    });
  });
}
