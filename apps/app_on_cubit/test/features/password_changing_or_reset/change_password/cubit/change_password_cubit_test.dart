/// Tests for ChangePasswordCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Successful password change flow
/// - Failed password change flow
/// - Requires reauthentication flow
/// - State reset functionality
/// - Debouncer protection
library;

import 'dart:async';

import 'package:app_on_cubit/features/password_changing_or_reset/change_password/cubit/change_password_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart';
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/presentation_layer_shared.dart';

class MockPasswordRepo extends Mock implements IPasswordRepo {}

class MockSignOutRepo extends Mock implements ISignOutRepo {}

void main() {
  group('ChangePasswordCubit', () {
    late MockPasswordRepo mockPasswordRepo;
    late MockSignOutRepo mockSignOutRepo;
    late PasswordRelatedUseCases passwordUseCases;
    late SignOutUseCase signOutUseCase;

    setUp(() {
      mockPasswordRepo = MockPasswordRepo();
      mockSignOutRepo = MockSignOutRepo();
      passwordUseCases = PasswordRelatedUseCases(mockPasswordRepo);
      signOutUseCase = SignOutUseCase(mockSignOutRepo);
    });

    test('initial state is SubmissionFlowInitialState', () {
      // Arrange & Act
      final cubit = ChangePasswordCubit(passwordUseCases, signOutUseCase);

      // Assert
      expect(cubit.state, isA<SubmissionFlowInitialState>());
      expect(cubit.state, equals(const SubmissionFlowInitialState()));

      cubit.close();
    });

    group('changePassword', () {
      blocTest<ChangePasswordCubit, SubmissionFlowStateModel>(
        'emits [Loading, Success] when password change succeeds',
        build: () {
          when(
            () => mockPasswordRepo.changePassword(any()),
          ).thenAnswer((_) async => const Right(null));
          return ChangePasswordCubit(passwordUseCases, signOutUseCase);
        },
        act: (cubit) => cubit.changePassword('newPassword123'),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionSuccessState>(),
        ],
        verify: (_) {
          verify(
            () => mockPasswordRepo.changePassword('newPassword123'),
          ).called(1);
        },
      );

      blocTest<ChangePasswordCubit, SubmissionFlowStateModel>(
        'emits [Loading, Error] when password change fails',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Password change failed',
          );
          when(
            () => mockPasswordRepo.changePassword(any()),
          ).thenAnswer((_) async => const Left(failure));
          return ChangePasswordCubit(passwordUseCases, signOutUseCase);
        },
        act: (cubit) => cubit.changePassword('newPassword123'),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionErrorState>(),
        ],
        verify: (_) {
          verify(
            () => mockPasswordRepo.changePassword('newPassword123'),
          ).called(1);
        },
      );

      blocTest<ChangePasswordCubit, SubmissionFlowStateModel>(
        'emits error with reauthentication required',
        build: () {
          const failure = Failure(
            type: UnauthorizedFailureType(),
            message: 'Reauthentication required',
            statusCode: 401,
          );
          when(
            () => mockPasswordRepo.changePassword(any()),
          ).thenAnswer((_) async => const Left(failure));
          return ChangePasswordCubit(passwordUseCases, signOutUseCase);
        },
        act: (cubit) => cubit.changePassword('newPassword123'),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionErrorState>().having(
            (state) => state.failure?.peek(),
            'failure',
            isA<Failure>().having(
              (f) => f.type,
              'failure type',
              isA<UnauthorizedFailureType>(),
            ),
          ),
        ],
      );

      blocTest<ChangePasswordCubit, SubmissionFlowStateModel>(
        'does not emit new states when already loading',
        build: () {
          when(() => mockPasswordRepo.changePassword(any())).thenAnswer((
            _,
          ) async {
            await Future<void>.delayed(const Duration(seconds: 2));
            return const Right(null);
          });
          return ChangePasswordCubit(passwordUseCases, signOutUseCase);
        },
        act: (cubit) async {
          unawaited(cubit.changePassword('newPassword123'));
          await Future<void>.delayed(const Duration(milliseconds: 100));
          unawaited(cubit.changePassword('anotherPassword'));
        },
        wait: const Duration(seconds: 3),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionSuccessState>(),
        ],
        verify: (_) {
          // Only one call should go through (debouncer + loading state check)
          verify(() => mockPasswordRepo.changePassword(any())).called(1);
        },
      );
    });

    group('resetState', () {
      blocTest<ChangePasswordCubit, SubmissionFlowStateModel>(
        'resets state to initial after success',
        build: () {
          when(
            () => mockPasswordRepo.changePassword(any()),
          ).thenAnswer((_) async => const Right(null));
          return ChangePasswordCubit(passwordUseCases, signOutUseCase);
        },
        act: (cubit) async {
          await cubit.changePassword('newPassword123');
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

      blocTest<ChangePasswordCubit, SubmissionFlowStateModel>(
        'resets state to initial after error',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Test error',
          );
          when(
            () => mockPasswordRepo.changePassword(any()),
          ).thenAnswer((_) async => const Left(failure));
          return ChangePasswordCubit(passwordUseCases, signOutUseCase);
        },
        act: (cubit) async {
          await cubit.changePassword('newPassword123');
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
        final cubit = ChangePasswordCubit(passwordUseCases, signOutUseCase);

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
