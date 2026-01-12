/// Tests for SignInCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Successful sign-in flow
/// - Failed sign-in flow
/// - State reset functionality
/// - Debouncer protection
library;

import 'package:app_on_cubit/features/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/presentation_layer_shared.dart';

class MockSignInRepo extends Mock implements ISignInRepo {}

void main() {
  group('SignInCubit', () {
    late MockSignInRepo mockRepo;
    late SignInUseCase signInUseCase;

    setUp(() {
      mockRepo = MockSignInRepo();
      signInUseCase = SignInUseCase(mockRepo);
    });

    test('initial state is SubmissionFlowInitialState', () {
      // Arrange & Act
      final cubit = SignInCubit(signInUseCase);

      // Assert
      expect(cubit.state, isA<SubmissionFlowInitialState>());
      expect(cubit.state, equals(const SubmissionFlowInitialState()));

      cubit.close();
    });

    group('signin', () {
      blocTest<SignInCubit, SubmissionFlowStateModel>(
        'emits [Loading, Success] when sign in succeeds',
        build: () {
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(null));
          return SignInCubit(signInUseCase);
        },
        act: (cubit) =>
            cubit.signin(email: 'test@example.com', password: 'password123'),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionSuccessState>(),
        ],
        verify: (_) {
          verify(
            () => mockRepo.signIn(
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);
        },
      );

      blocTest<SignInCubit, SubmissionFlowStateModel>(
        'emits [Loading, Error] when sign in fails',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Invalid credentials',
          );
          when(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Left(failure));
          return SignInCubit(signInUseCase);
        },
        act: (cubit) =>
            cubit.signin(email: 'test@example.com', password: 'wrong'),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          isA<ButtonSubmissionLoadingState>(),
          isA<ButtonSubmissionErrorState>(),
        ],
        verify: (_) {
          verify(
            () => mockRepo.signIn(email: 'test@example.com', password: 'wrong'),
          ).called(1);
        },
      );

      blocTest<SignInCubit, SubmissionFlowStateModel>(
        'does not emit new state when already loading',
        build: () => SignInCubit(signInUseCase),
        seed: () => const ButtonSubmissionLoadingState(),
        act: (cubit) =>
            cubit.signin(email: 'test@example.com', password: 'password123'),
        wait: const Duration(milliseconds: 700),
        expect: () => <SubmissionFlowStateModel>[],
        verify: (_) {
          verifyNever(
            () => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          );
        },
      );
    });

    group('resetState', () {
      blocTest<SignInCubit, SubmissionFlowStateModel>(
        'resets state to initial from loading state',
        build: () => SignInCubit(signInUseCase),
        seed: () => const ButtonSubmissionLoadingState(),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<SubmissionFlowInitialState>(),
        ],
      );

      blocTest<SignInCubit, SubmissionFlowStateModel>(
        'resets state to initial from success state',
        build: () => SignInCubit(signInUseCase),
        seed: () => const ButtonSubmissionSuccessState(),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<SubmissionFlowInitialState>(),
        ],
      );

      blocTest<SignInCubit, SubmissionFlowStateModel>(
        'resets state to initial from error state',
        build: () {
          const Failure(
            type: NetworkFailureType(),
            message: 'Test error',
          );
          return SignInCubit(signInUseCase);
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
        final cubit = SignInCubit(signInUseCase);

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
