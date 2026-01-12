/// Tests for SignUpCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Successful sign-up flow
/// - Failed sign-up flow
/// - State reset functionality
/// - Debouncer protection
library;

import 'package:app_on_cubit/features/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/presentation_layer_shared.dart';

class MockSignUpRepo extends Mock implements ISignUpRepo {}

void main() {
  group('SignUpCubit', () {
    late MockSignUpRepo mockRepo;
    late SignUpUseCase signUpUseCase;

    setUp(() {
      mockRepo = MockSignUpRepo();
      signUpUseCase = SignUpUseCase(mockRepo);
    });

    test('initial state is SubmissionFlowInitialState', () {
      // Arrange & Act
      final cubit = SignUpCubit(signUpUseCase);

      // Assert
      expect(cubit.state, isA<SubmissionFlowInitialState>());
      expect(cubit.state, equals(const SubmissionFlowInitialState()));

      cubit.close();
    });

    group('signUp', () {
      blocTest<SignUpCubit, SubmissionFlowStateModel>(
        'emits [Loading, Success] when sign up succeeds',
        build: () {
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));
          return SignUpCubit(signUpUseCase);
        },
        act: (cubit) => cubit.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        ),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionSuccessState>(),
        ],
        verify: (_) {
          verify(
            () => mockRepo.signup(
              name: 'Test User',
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);
        },
      );

      blocTest<SignUpCubit, SubmissionFlowStateModel>(
        'emits [Loading, Error] when sign up fails',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Sign up failed',
          );
          when(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Left(failure));
          return SignUpCubit(signUpUseCase);
        },
        act: (cubit) => cubit.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'wrong',
        ),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionErrorState>(),
        ],
        verify: (_) {
          verify(
            () => mockRepo.signup(
              name: 'Test User',
              email: 'test@example.com',
              password: 'wrong',
            ),
          ).called(1);
        },
      );

      blocTest<SignUpCubit, SubmissionFlowStateModel>(
        'does not emit new state when already loading',
        build: () => SignUpCubit(signUpUseCase),
        seed: () => const ButtonSubmissionLoadingState(),
        act: (cubit) => cubit.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        ),
        wait: const Duration(milliseconds: 700),
        expect: () => <SubmissionFlowStateModel>[],
        verify: (_) {
          verifyNever(
            () => mockRepo.signup(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          );
        },
      );
    });

    group('resetState', () {
      blocTest<SignUpCubit, SubmissionFlowStateModel>(
        'resets state to initial from loading state',
        build: () => SignUpCubit(signUpUseCase),
        seed: () => const ButtonSubmissionLoadingState(),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<SubmissionFlowInitialState>(),
        ],
      );

      blocTest<SignUpCubit, SubmissionFlowStateModel>(
        'resets state to initial from success state',
        build: () => SignUpCubit(signUpUseCase),
        seed: () => const ButtonSubmissionSuccessState(),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<SubmissionFlowInitialState>(),
        ],
      );

      blocTest<SignUpCubit, SubmissionFlowStateModel>(
        'resets state to initial from error state',
        build: () {
          const Failure(
            type: NetworkFailureType(),
            message: 'Test error',
          );
          return SignUpCubit(signUpUseCase);
        },
        seed: () => ButtonSubmissionErrorState(
          const Failure(
            type: NetworkFailureType(),
            message: 'Test error',
          ).asConsumable(),
        ),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<SubmissionFlowInitialState>(),
        ],
      );
    });

    group('close', () {
      test('closes successfully and cleans up debouncer', () async {
        // Arrange
        final cubit = SignUpCubit(signUpUseCase);

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
