/// Tests for SignOutCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Successful sign-out flow
/// - Failed sign-out flow
/// - State reset functionality
library;

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:app_on_cubit/features/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

class MockSignOutRepo extends Mock implements ISignOutRepo {}

void main() {
  group('SignOutCubit', () {
    late MockSignOutRepo mockRepo;
    late SignOutUseCase signOutUseCase;

    setUp(() {
      mockRepo = MockSignOutRepo();
      signOutUseCase = SignOutUseCase(mockRepo);
    });

    test('initial state is AsyncValueForBLoC loading', () {
      // Arrange & Act
      final cubit = SignOutCubit(signOutUseCase);

      // Assert
      expect(cubit.state, isA<AsyncValueForBLoC<void>>());
      expect(cubit.state.isLoading, isTrue);

      cubit.close();
    });

    group('signOut', () {
      blocTest<SignOutCubit, AsyncValueForBLoC<void>>(
        'emits data state when sign out succeeds',
        build: () {
          when(
            () => mockRepo.signOut(),
          ).thenAnswer((_) async => const Right(null));
          return SignOutCubit(signOutUseCase);
        },
        act: (cubit) => cubit.signOut(),
        expect: () => [
          isA<AsyncValueForBLoC<void>>().having(
            (state) => state.isLoading,
            'is loading',
            true,
          ),
          isA<AsyncValueForBLoC<void>>().having(
            (state) => state.hasValue,
            'has value',
            true,
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.signOut()).called(1);
        },
      );

      blocTest<SignOutCubit, AsyncValueForBLoC<void>>(
        'emits error state when sign out fails',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Failed to sign out',
          );
          when(
            () => mockRepo.signOut(),
          ).thenAnswer((_) async => const Left(failure));
          return SignOutCubit(signOutUseCase);
        },
        act: (cubit) => cubit.signOut(),
        expect: () => [
          isA<AsyncValueForBLoC<void>>().having(
            (state) => state.isLoading,
            'is loading',
            true,
          ),
          isA<AsyncValueForBLoC<void>>().having(
            (state) => state.hasError,
            'has error',
            true,
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.signOut()).called(1);
        },
      );
    });

    group('resetState', () {
      blocTest<SignOutCubit, AsyncValueForBLoC<void>>(
        'resets state to loading',
        build: () => SignOutCubit(signOutUseCase),
        seed: () => const AsyncValueForBLoC<void>.data(null),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<AsyncValueForBLoC<void>>().having(
            (state) => state.isLoading,
            'is loading',
            true,
          ),
        ],
      );

      blocTest<SignOutCubit, AsyncValueForBLoC<void>>(
        'resets state from error to loading',
        build: () => SignOutCubit(signOutUseCase),
        seed: () => const AsyncValueForBLoC<void>.error(
          Failure(
            type: NetworkFailureType(),
            message: 'Test error',
          ),
        ),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<AsyncValueForBLoC<void>>().having(
            (state) => state.isLoading,
            'is loading',
            true,
          ),
        ],
      );
    });

    group('close', () {
      test('closes successfully', () async {
        // Arrange
        final cubit = SignOutCubit(signOutUseCase);

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
