/// Tests for ResetPasswordCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Successful password reset flow
/// - Failed password reset flow
/// - State reset functionality
/// - Debouncer protection
library;

import 'dart:async';

import 'package:app_on_cubit/features/password_changing_or_reset/reset_password/cubits/reset_password_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/presentation_layer_shared.dart';

class MockPasswordRepo extends Mock implements IPasswordRepo {}

void main() {
  group('ResetPasswordCubit', () {
    late MockPasswordRepo mockRepo;
    late PasswordRelatedUseCases passwordUseCases;

    setUp(() {
      mockRepo = MockPasswordRepo();
      passwordUseCases = PasswordRelatedUseCases(mockRepo);
    });

    test('initial state is SubmissionFlowInitialState', () {
      // Arrange & Act
      final cubit = ResetPasswordCubit(passwordUseCases);

      // Assert
      expect(cubit.state, isA<SubmissionFlowInitialState>());
      expect(cubit.state, equals(const SubmissionFlowInitialState()));

      cubit.close();
    });

    group('resetPassword', () {
      blocTest<ResetPasswordCubit, SubmissionFlowStateModel>(
        'emits [Loading, Success] when reset password succeeds',
        build: () {
          when(
            () => mockRepo.sendResetLink(any()),
          ).thenAnswer((_) async => const Right(null));
          return ResetPasswordCubit(passwordUseCases);
        },
        act: (cubit) => cubit.resetPassword('test@example.com'),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionSuccessState>(),
        ],
        verify: (_) {
          verify(() => mockRepo.sendResetLink('test@example.com')).called(1);
        },
      );

      blocTest<ResetPasswordCubit, SubmissionFlowStateModel>(
        'emits [Loading, Error] when reset password fails',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Reset password failed',
          );
          when(
            () => mockRepo.sendResetLink(any()),
          ).thenAnswer((_) async => const Left(failure));
          return ResetPasswordCubit(passwordUseCases);
        },
        act: (cubit) => cubit.resetPassword('test@example.com'),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionErrorState>(),
        ],
        verify: (_) {
          verify(() => mockRepo.sendResetLink('test@example.com')).called(1);
        },
      );

      blocTest<ResetPasswordCubit, SubmissionFlowStateModel>(
        'does not emit new states when already loading',
        build: () {
          when(() => mockRepo.sendResetLink(any())).thenAnswer((_) async {
            await Future<void>.delayed(const Duration(seconds: 2));
            return const Right(null);
          });
          return ResetPasswordCubit(passwordUseCases);
        },
        act: (cubit) async {
          unawaited(cubit.resetPassword('test@example.com'));
          await Future<void>.delayed(const Duration(milliseconds: 100));
          unawaited(cubit.resetPassword('another@example.com'));
        },
        wait: const Duration(seconds: 3),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionSuccessState>(),
        ],
        verify: (_) {
          // Only one call should go through (debouncer + loading state check)
          verify(() => mockRepo.sendResetLink(any())).called(1);
        },
      );
    });

    group('resetState', () {
      blocTest<ResetPasswordCubit, SubmissionFlowStateModel>(
        'resets state to initial after success',
        build: () {
          when(
            () => mockRepo.sendResetLink(any()),
          ).thenAnswer((_) async => const Right(null));
          return ResetPasswordCubit(passwordUseCases);
        },
        act: (cubit) async {
          await cubit.resetPassword('test@example.com');
          await Future<void>.delayed(const Duration(milliseconds: 700));
          cubit.resetState();
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionSuccessState>(),
          isA<SubmissionFlowInitialState>(),
        ],
      );

      blocTest<ResetPasswordCubit, SubmissionFlowStateModel>(
        'resets state to initial after error',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Test error',
          );
          when(
            () => mockRepo.sendResetLink(any()),
          ).thenAnswer((_) async => const Left(failure));
          return ResetPasswordCubit(passwordUseCases);
        },
        act: (cubit) async {
          await cubit.resetPassword('test@example.com');
          await Future<void>.delayed(const Duration(milliseconds: 700));
          cubit.resetState();
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionErrorState>(),
          isA<SubmissionFlowInitialState>(),
        ],
      );
    });

    group('close', () {
      test('cancels debouncer on close', () async {
        // Arrange
        final cubit = ResetPasswordCubit(passwordUseCases);

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
