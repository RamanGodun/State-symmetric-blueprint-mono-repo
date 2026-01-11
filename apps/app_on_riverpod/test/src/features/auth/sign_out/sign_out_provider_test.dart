/// Tests for SignOut Provider
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
/// - Successful sign-out flow
/// - Failed sign-out handling
/// - Profile cache clearing
/// - Loading state management
/// - State reset
library;

import 'package:adapters_for_riverpod/adapters_for_riverpod.dart';
import 'package:app_on_riverpod/features/auth/sign_out/sign_out_provider.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart';
import 'package:features_dd_layers/public_api/profile/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../fixtures/test_constants.dart';
import '../../../helpers/test_helpers.dart';

// Since SignOutUseCase is a final class, we create a callable mock
class MockSignOutUseCase extends Mock {
  ResultFuture<void> call();
}

class MockProfileRepo extends Mock implements IProfileRepo {}

void main() {
  group('SignOut Provider', () {
    late MockSignOutUseCase mockUseCase;
    late MockProfileRepo mockProfileRepo;

    setUp(() {
      mockUseCase = MockSignOutUseCase();
      mockProfileRepo = MockProfileRepo();
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          signOutUseCaseProvider.overrideWithValue(mockUseCase as dynamic),
          profileRepoProvider.overrideWithValue(mockProfileRepo),
        ],
      );
    }

    group('initialization', () {
      test('builds with AsyncData(null) state', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);

        // Act
        final future = container.read(signOutProvider.future);
        await wait(TestConstants.shortDelayMs);

        // Assert
        await expectLater(future, completes);
        final state = container.read(signOutProvider);
        expect(state, isA<AsyncData<void>>());
      });
    });

    group('successful sign-out', () {
      test('transitions through loading to success state', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act
        final future = notifier.signOut();
        await wait(TestConstants.shortDelayMs);

        // Assert - Loading state
        var state = container.read(signOutProvider);
        expect(state, isA<AsyncLoading<void>>());

        // Wait for completion
        await future;

        // Assert - Success state
        state = container.read(signOutProvider);
        expect(state, isA<AsyncData<void>>());
      });

      test('calls use case when signing out', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act
        await notifier.signOut();

        // Assert
        verify(() => mockUseCase()).called(1);
      });

      test('clears profile cache on successful sign-out', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act
        await notifier.signOut();

        // Assert
        verify(() => mockProfileRepo.clearCache()).called(1);
      });
    });

    group('failed sign-out', () {
      test('transitions to error state on failure', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        const failure = Failure(
          message: 'Sign-out failed',
          type: UnknownFailureType(),
        );

        when(() => mockUseCase()).thenAnswer((_) async => const Left(failure));

        // Act
        try {
          await notifier.signOut();
        } catch (e) {
          // Expected to throw
        }

        // Assert
        final state = container.read(signOutProvider);
        expect(state, isA<AsyncError<void>>());
      });

      test('does not clear cache on failed sign-out', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        const failure = Failure(
          message: 'Network error',
          type: UnknownFailureType(),
        );

        when(() => mockUseCase()).thenAnswer((_) async => const Left(failure));

        // Act
        try {
          await notifier.signOut();
        } catch (e) {
          // Expected to throw
        }

        // Assert
        verifyNever(() => mockProfileRepo.clearCache());
      });

      test('error contains failure information', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        const failure = Failure(
          message: 'Auth error',
          type: UnknownFailureType(),
        );

        when(() => mockUseCase()).thenAnswer((_) async => const Left(failure));

        // Act
        try {
          await notifier.signOut();
        } catch (e) {
          // Assert
          expect(e, isA<Failure>());
          expect((e as Failure).message, equals('Auth error'));
        }
      });
    });

    group('loading state management', () {
      test('prevents multiple simultaneous sign-out attempts', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async {
          await wait(Duration(milliseconds: 500));
          return const Right(null);
        });
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act - First call
        final future1 = notifier.signOut();
        await wait(TestConstants.shortDelayMs);

        // State should be loading now
        expect(container.read(signOutProvider), isA<AsyncLoading<void>>());

        // Try second call while loading
        final future2 = notifier.signOut();

        await future1;
        await future2;

        // Assert - Use case should only be called once
        verify(() => mockUseCase()).called(1);
      });

      test('allows sign-out after previous attempt completes', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act - First attempt
        await notifier.signOut();

        // Second attempt after first completes
        await notifier.signOut();

        // Assert - Use case called twice
        verify(() => mockUseCase()).called(2);
        verify(() => mockProfileRepo.clearCache()).called(2);
      });
    });

    group('state reset', () {
      test('resets state to AsyncData(null)', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        const failure = Failure(
          message: 'Error',
          type: UnknownFailureType(),
        );

        when(() => mockUseCase()).thenAnswer((_) async => const Left(failure));

        // Sign out to get error state
        try {
          await notifier.signOut();
        } catch (e) {
          // Expected
        }

        expect(container.read(signOutProvider), isA<AsyncError<void>>());

        // Act
        notifier.reset();

        // Assert
        final state = container.read(signOutProvider);
        expect(state, isA<AsyncData<void>>());
      });

      test('reset from success state', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Sign out successfully
        await notifier.signOut();
        expect(container.read(signOutProvider), isA<AsyncData<void>>());

        // Act
        notifier.reset();

        // Assert
        final state = container.read(signOutProvider);
        expect(state, isA<AsyncData<void>>());
      });
    });

    group('real-world scenarios', () {
      test('user successfully signs out', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act
        await notifier.signOut();

        // Assert
        final state = container.read(signOutProvider);
        expect(state, isA<AsyncData<void>>());
        verify(() => mockProfileRepo.clearCache()).called(1);
      });

      test('sign-out fails due to network error', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        const failure = Failure(
          message: 'No internet connection',
          type: UnknownFailureType(),
        );

        when(() => mockUseCase()).thenAnswer((_) async => const Left(failure));

        // Act
        try {
          await notifier.signOut();
        } catch (e) {
          // Expected
        }

        // Assert
        final state = container.read(signOutProvider);
        expect(state, isA<AsyncError<void>>());
        verifyNever(() => mockProfileRepo.clearCache());
      });

      test('user retries after failed sign-out', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        const failure = Failure(
          message: 'Timeout',
          type: UnknownFailureType(),
        );

        // First attempt fails
        when(() => mockUseCase()).thenAnswer((_) async => const Left(failure));

        try {
          await notifier.signOut();
        } catch (e) {
          // Expected
        }

        expect(container.read(signOutProvider), isA<AsyncError<void>>());

        // Reset and retry
        notifier.reset();

        // Second attempt succeeds
        when(() => mockUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act
        await notifier.signOut();

        // Assert
        final state = container.read(signOutProvider);
        expect(state, isA<AsyncData<void>>());
        verify(() => mockProfileRepo.clearCache()).called(1);
      });

      test('prevents accidental double sign-out', () async {
        // Arrange
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(signOutProvider.future);

        final notifier = container.read(signOutProvider.notifier);

        when(() => mockUseCase()).thenAnswer((_) async {
          await wait(Duration(milliseconds: 500));
          return const Right(null);
        });
        when(() => mockProfileRepo.clearCache()).thenReturn(null);

        // Act - User double-taps sign-out button
        final future1 = notifier.signOut();

        // Immediate second tap
        final future2 = notifier.signOut();

        await future1;
        await future2;

        // Assert - Use case called only once
        verify(() => mockUseCase()).called(1);
        verify(() => mockProfileRepo.clearCache()).called(1);
      });
    });
  });
}
