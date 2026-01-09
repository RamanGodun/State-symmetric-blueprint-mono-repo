/// Tests for [CubitWithAsyncValue]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Cubit initialization
/// - emitLoading (with/without preserveUi)
/// - emitData
/// - emitFailure
/// - emitFromEither
/// - emitGuarded (success/error/preserveUi)
/// - resetToLoading
/// - Error mapping
/// - Lifecycle management
// ignore_for_file: unreachable_from_main

library;

import 'dart:async';

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

// Test implementation of CubitWithAsyncValue
class TestAsyncCubit extends CubitWithAsyncValue<int> {
  // Custom error mapping for testing
  @override
  Failure mapError(Object error, StackTrace stackTrace) {
    if (error is TestException) {
      return const Failure(
        message: 'Custom mapped error',
        type: UnknownFailureType(),
      );
    }
    return super.mapError(error, stackTrace);
  }
}

class TestException implements Exception {
  const TestException();
}

void main() {
  group('CubitWithAsyncValue', () {
    late TestAsyncCubit cubit;

    setUp(() {
      cubit = TestAsyncCubit();
    });

    tearDown(() {
      unawaited(cubit.close());
    });

    group('initialization', () {
      test('starts with loading state', () {
        expect(cubit.state, isA<AsyncLoadingForBLoC<int>>());
        expect(cubit.state.isLoading, isTrue);
      });
    });

    group('emitLoading', () {
      test('emits pure loading state without preserveUi', () {
        // Arrange
        cubit
          ..emitData(42)
          // Act
          ..emitLoading();

        // Assert
        expect(cubit.state, isA<AsyncLoadingForBLoC<int>>());
        expect(cubit.state.isLoading, isTrue);
        expect(cubit.state.valueOrNull, isNull);
      });

      test('preserves previous data when preserveUi is true', () {
        // Arrange
        cubit
          ..emitData(42)
          // Act
          ..emitLoading(preserveUi: true);

        // Assert
        expect(cubit.state, isA<AsyncLoadingWithDataForBLoC<int>>());
        expect(cubit.state.isRefreshing, isTrue);
        expect(cubit.state.valueOrNull, equals(42));
      });

      test('preserves previous error when preserveUi is true', () {
        // Arrange
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        cubit
          ..emitFailure(failure)
          // Act
          ..emitLoading(preserveUi: true);

        // Assert
        expect(cubit.state, isA<AsyncLoadingWithErrorForBLoC<int>>());
        expect(cubit.state.isReloading, isTrue);
        expect(cubit.state.failureOrNull, equals(failure));
      });

      test('does not emit after cubit is closed', () async {
        // Arrange
        await cubit.close();

        // Act
        cubit.emitLoading();

        // Assert - should not throw
      });
    });

    group('emitData', () {
      test('emits data state with value', () {
        // Act
        cubit.emitData(42);

        // Assert
        expect(cubit.state, isA<AsyncDataForBLoC<int>>());
        expect(cubit.state.hasValue, isTrue);
        expect(cubit.state.valueOrNull, equals(42));
      });

      test('replaces previous loading state', () {
        // Arrange
        cubit
          ..emitLoading()
          // Act
          ..emitData(100);

        // Assert
        expect(cubit.state, isA<AsyncDataForBLoC<int>>());
        expect(cubit.state.valueOrNull, equals(100));
      });

      test('does not emit after cubit is closed', () async {
        // Arrange
        await cubit.close();

        // Act
        cubit.emitData(42);

        // Assert - should not throw
      });
    });

    group('emitFailure', () {
      test('emits error state with failure', () {
        // Arrange
        const failure = Failure(
          message: 'Test failure',
          type: UnknownFailureType(),
        );

        // Act
        cubit.emitFailure(failure);

        // Assert
        expect(cubit.state, isA<AsyncErrorForBLoC<int>>());
        expect(cubit.state.hasError, isTrue);
        expect(cubit.state.failureOrNull, equals(failure));
      });

      test('does not emit after cubit is closed', () async {
        // Arrange
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        await cubit.close();

        // Act
        cubit.emitFailure(failure);

        // Assert - should not throw
      });
    });

    group('emitFromEither', () {
      test('emits data when Either is Right', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        cubit.emitFromEither(result);

        // Assert
        expect(cubit.state, isA<AsyncDataForBLoC<int>>());
        expect(cubit.state.valueOrNull, equals(42));
      });

      test('emits error when Either is Left', () {
        // Arrange
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const result = Left<Failure, int>(failure);

        // Act
        cubit.emitFromEither(result);

        // Assert
        expect(cubit.state, isA<AsyncErrorForBLoC<int>>());
        expect(cubit.state.failureOrNull, equals(failure));
      });

      test('does not emit after cubit is closed', () async {
        // Arrange
        const result = Right<Failure, int>(42);
        await cubit.close();

        // Act
        cubit.emitFromEither(result);

        // Assert - should not throw
      });
    });

    group('emitGuarded', () {
      test('does not emit after close during async operation', () async {
        // Arrange
        final future = cubit.emitGuarded(() async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return 42;
        });

        // Act - Close cubit before operation completes
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await cubit.close();
        await future;

        // Assert - Should not throw
      });
    });

    group('resetToLoading', () {
      test('resets to pure loading state from data', () {
        // Arrange
        cubit
          ..emitData(42)
          // Act
          ..resetToLoading();

        // Assert
        expect(cubit.state, isA<AsyncLoadingForBLoC<int>>());
        expect(cubit.state.valueOrNull, isNull);
      });

      test('resets to pure loading state from error', () {
        // Arrange
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        cubit
          ..emitFailure(failure)
          // Act
          ..resetToLoading();

        // Assert
        expect(cubit.state, isA<AsyncLoadingForBLoC<int>>());
        expect(cubit.state.failureOrNull, isNull);
      });

      test('does not emit after cubit is closed', () async {
        // Arrange
        await cubit.close();

        // Act
        cubit.resetToLoading();

        // Assert - should not throw
      });
    });

    group('real-world scenarios', () {
      test('typical fetch flow', () async {
        // Simulate fetching data from API
        // Start with data state to ensure we see the loading emission
        cubit.emitData(0);

        final states = <AsyncValueForBLoC<int>>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act
        await cubit.emitGuarded(() async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return 42;
        });
        await Future<void>.delayed(Duration.zero); // Flush microtasks

        // Assert - Loading → Data
        expect(states, hasLength(2));
        expect(states[0].isLoading, isTrue);
        expect(states[1].hasValue, isTrue);
      });

      test('refresh scenario with existing data', () async {
        // Initial data
        cubit.emitData(100);

        final states = <AsyncValueForBLoC<int>>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act - Refresh
        await cubit.emitGuarded(
          () async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return 200;
          },
          preserveUi: true,
        );
        await Future<void>.delayed(Duration.zero); // Flush microtasks

        // Assert - Shows old data during refresh
        expect(states, hasLength(2));
        expect(states[0].isRefreshing, isTrue);
        expect(states[0].valueOrNull, equals(100)); // Old data visible
        expect(states[1].valueOrNull, equals(200)); // New data
      });

      test('retry after error', () async {
        // Initial error
        await cubit.emitGuarded(() async => throw Exception('Network error'));

        expect(cubit.state.hasError, isTrue);

        // Act - Retry
        await cubit.emitGuarded(() async => 42);

        // Assert - Success
        expect(cubit.state.hasValue, isTrue);
        expect(cubit.state.valueOrNull, equals(42));
      });

      test('multiple sequential operations', () async {
        // Act - Multiple operations
        await cubit.emitGuarded(() async => 1);
        await cubit.emitGuarded(() async => 2);
        await cubit.emitGuarded(() async => 3);

        // Assert - Final state
        expect(cubit.state.valueOrNull, equals(3));
      });

      test('sign-out scenario (reset to loading)', () async {
        // User is signed in with data
        cubit.emitData(42);
        expect(cubit.state.hasValue, isTrue);

        // Act - User signs out
        cubit.resetToLoading();

        // Assert - Clean state
        expect(cubit.state, isA<AsyncLoadingForBLoC<int>>());
        expect(cubit.state.valueOrNull, isNull);
      });
    });
  });
}
