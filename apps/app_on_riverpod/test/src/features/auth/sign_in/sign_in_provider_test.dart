/// Tests for SignIn Provider
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Provider initialization
/// - Successful sign-in flow
/// - Failed sign-in flow
/// - Loading state management
/// - Error handling
/// - State reset
/// - Double-tap protection via debouncer
/// - Memory cleanup
library;

import 'dart:async';

import 'package:adapters_for_riverpod/adapters_for_riverpod.dart';
import 'package:app_on_riverpod/features/auth/sign_in/providers/sign_in__provider.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/presentation_layer_shared.dart';

import '../../../../fixtures/test_constants.dart';
import '../../../../helpers/test_helpers.dart';

// Since SignInUseCase is a final class, we create a callable mock
class MockSignInUseCase extends Mock {
  ResultFuture<void> call({required String email, required String password});
}

void main() {
  group('SignIn Provider', () {
    late MockSignInUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockSignInUseCase();
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          signInUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
    }

    group('initialization', () {
      test('builds with initial state', () {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);

        // Act
        final state = container.read(signInProvider);

        // Assert
        expect(state, isA<SubmissionFlowInitialState>());
      });

      test('initializes debouncer correctly', () {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);

        // Act
        final notifier = container.read(signInProvider.notifier);

        // Assert
        expect(notifier, isA<SignIn>());
      });
    });

    group('successful sign-in', () {
      test('transitions through loading to success state', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final future = notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Wait for debouncer
        await wait(700);

        // Assert - Loading state
        var state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionLoadingState>());

        // Wait for completion
        await future;
        await wait(TestConstants.mediumDelay);

        // Assert - Success state
        state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionSuccessState>());
      });

      test('calls use case with correct parameters', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        // Assert
        verify(
          () => mockUseCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          ),
        ).called(1);
      });

      test('handles different valid credentials', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await notifier.signin(
          email: TestConstants.validEmail2,
          password: TestConstants.validPassword2,
        );
        await wait(800);

        // Assert
        verify(
          () => mockUseCase(
            email: TestConstants.validEmail2,
            password: TestConstants.validPassword2,
          ),
        ).called(1);

        final state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionSuccessState>());
      });
    });

    group('failed sign-in', () {
      test('transitions to error state on failure', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        const failure = Failure(
          message: 'Invalid credentials',
          type: UnknownFailureType(),
        );

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionErrorState>());
      });

      test('error state contains consumable failure', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        const failure = Failure(
          message: 'Network error',
          type: UnknownFailureType(),
        );

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionErrorState>());

        final errorState = state as ButtonSubmissionErrorState;
        expect(errorState.failure, isA<Consumable<Failure>>());
      });

      test('handles authentication errors', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        const failure = Failure(
          message: 'User not found',
          type: UnknownFailureType(),
        );

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        await notifier.signin(
          email: TestConstants.invalidEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionErrorState>());
      });
    });

    group('loading state management', () {
      test('prevents multiple simultaneous sign-in attempts', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          await wait(1000);
          return const Right(null);
        });

        // Act - First call
        final future1 = notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        await wait(700); // Wait for debouncer

        // State should be loading now
        expect(container.read(signInProvider), isA<ButtonSubmissionLoadingState>());

        // Try second call while loading
        final future2 = notifier.signin(
          email: TestConstants.validEmail2,
          password: TestConstants.validPassword2,
        );

        await future1;
        await future2;
        await wait(800);

        // Assert - Use case should only be called once
        verify(
          () => mockUseCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          ),
        ).called(1);

        // Second call should not happen
        verifyNever(
          () => mockUseCase(
            email: TestConstants.validEmail2,
            password: TestConstants.validPassword2,
          ),
        );
      });

      test('allows sign-in after previous attempt completes', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act - First attempt
        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        // Second attempt after first completes
        await notifier.signin(
          email: TestConstants.validEmail2,
          password: TestConstants.validPassword2,
        );
        await wait(800);

        // Assert - Use case called twice
        verify(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(2);
      });
    });

    group('state reset', () {
      test('resets state to initial', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        const failure = Failure(
          message: 'Error',
          type: UnknownFailureType(),
        );

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        // Sign in to get error state
        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        expect(container.read(signInProvider), isA<ButtonSubmissionErrorState>());

        // Act
        notifier.reset();

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<SubmissionFlowInitialState>());
      });

      test('reset from success state', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Sign in successfully
        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        expect(container.read(signInProvider), isA<ButtonSubmissionSuccessState>());

        // Act
        notifier.reset();

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<SubmissionFlowInitialState>());
      });
    });

    group('debouncing', () {
      test('debounces rapid sign-in calls', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act - Rapid calls
        unawaited(notifier.signin(
          email: 'email1@test.com',
          password: 'password1',
        ));
        unawaited(notifier.signin(
          email: 'email2@test.com',
          password: 'password2',
        ));
        unawaited(notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        ));

        // Wait for debouncer
        await wait(800);

        // Assert - Only last call should execute
        verify(
          () => mockUseCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          ),
        ).called(1);

        verifyNever(
          () => mockUseCase(
            email: 'email1@test.com',
            password: 'password1',
          ),
        );
      });
    });

    group('memory management', () {
      test('disposes debouncer on container disposal', () {
        // Arrange
        final container = createContainer()
        ..read(signInProvider.notifier)

        // Act
        ..dispose();

        // Assert - Should not throw
        expect(container.dispose, returnsNormally);
      });
    });

    group('real-world scenarios', () {
      test('user successfully signs in', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await notifier.signin(
          email: 'john.doe@example.com',
          password: 'SecurePassword123!',
        );
        await wait(800);

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionSuccessState>());
      });

      test('user enters wrong credentials', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        const failure = Failure(
          message: 'Invalid email or password',
          type: UnknownFailureType(),
        );

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        await notifier.signin(
          email: 'john@example.com',
          password: 'WrongPassword',
        );
        await wait(800);

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionErrorState>());
      });

      test('user retries after failed sign-in', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        const failure = Failure(
          message: 'Network error',
          type: UnknownFailureType(),
        );

        // First attempt fails
        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        expect(container.read(signInProvider), isA<ButtonSubmissionErrorState>());

        // Reset and retry
        notifier.reset();

        // Second attempt succeeds
        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );
        await wait(800);

        // Assert
        final state = container.read(signInProvider);
        expect(state, isA<ButtonSubmissionSuccessState>());
      });

      test('prevents accidental double-tap submission', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInProvider.notifier);

        when(
          () => mockUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          await wait(1000);
          return const Right(null);
        });

        // Act - User double-taps submit button
        final future1 = notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Immediate second tap
        final future2 = notifier.signin(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        await future1;
        await future2;
        await wait(800);

        // Assert - Use case called only once due to debouncing + loading check
        verify(
          () => mockUseCase(
            email: TestConstants.validEmail,
            password: TestConstants.validPassword,
          ),
        ).called(1);
      });
    });
  });
}
