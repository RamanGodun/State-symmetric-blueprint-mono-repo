/// Tests for [AsyncValueForBLoC]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - All state variants (Loading, Data, Error, LoadingWithData, LoadingWithError)
/// - State flags (isLoading, hasValue, hasError, isRefreshing, isReloading)
/// - Accessors (valueOrNull, failureOrNull, requireValue, asData, asError)
/// - Pattern matching (when, maybeWhen, maybeMap)
/// - Transformations (map, whenData, copyWithPrevious)
/// - Equality semantics
library;

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('AsyncValueForBLoC', () {
    group('factory constructors', () {
      test('loading() creates AsyncLoadingForBLoC', () {
        // Act
        const state = AsyncValueForBLoC<int>.loading();

        // Assert
        expect(state, isA<AsyncLoadingForBLoC<int>>());
      });

      test('data() creates AsyncDataForBLoC', () {
        // Act
        const state = AsyncValueForBLoC<int>.data(42);

        // Assert
        expect(state, isA<AsyncDataForBLoC<int>>());
        expect(state.valueOrNull, equals(42));
      });

      test('error() creates AsyncErrorForBLoC', () {
        // Arrange
        const failure = Failure(
          message: 'Test error',
          type: UnknownFailureType(),
        );

        // Act
        const state = AsyncValueForBLoC<int>.error(failure);

        // Assert
        expect(state, isA<AsyncErrorForBLoC<int>>());
        expect(state.failureOrNull, equals(failure));
      });
    });

    group('state flags', () {
      test('isLoading is true for AsyncLoadingForBLoC', () {
        const state = AsyncValueForBLoC<int>.loading();
        expect(state.isLoading, isTrue);
      });

      test('isLoading is true for AsyncLoadingWithDataForBLoC', () {
        const state = AsyncLoadingWithDataForBLoC<int>(42);
        expect(state.isLoading, isTrue);
      });

      test('isLoading is true for AsyncLoadingWithErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncLoadingWithErrorForBLoC<int>(failure);
        expect(state.isLoading, isTrue);
      });

      test('isLoading is false for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.isLoading, isFalse);
      });

      test('isLoading is false for AsyncErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);
        expect(state.isLoading, isFalse);
      });

      test('hasValue is true for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.hasValue, isTrue);
      });

      test('hasValue is true for AsyncLoadingWithDataForBLoC', () {
        const state = AsyncLoadingWithDataForBLoC<int>(42);
        expect(state.hasValue, isTrue);
      });

      test('hasValue is false for AsyncLoadingForBLoC', () {
        const state = AsyncValueForBLoC<int>.loading();
        expect(state.hasValue, isFalse);
      });

      test('hasValue is false for AsyncErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);
        expect(state.hasValue, isFalse);
      });

      test('hasError is true for AsyncErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);
        expect(state.hasError, isTrue);
      });

      test('hasError is true for AsyncLoadingWithErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncLoadingWithErrorForBLoC<int>(failure);
        expect(state.hasError, isTrue);
      });

      test('hasError is false for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.hasError, isFalse);
      });

      test('isRefreshing is true when loading with data', () {
        const state = AsyncLoadingWithDataForBLoC<int>(42);
        expect(state.isRefreshing, isTrue);
        expect(state.isLoading, isTrue);
        expect(state.hasValue, isTrue);
      });

      test('isRefreshing is false when just loading', () {
        const state = AsyncValueForBLoC<int>.loading();
        expect(state.isRefreshing, isFalse);
      });

      test('isReloading is true when loading with error', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncLoadingWithErrorForBLoC<int>(failure);
        expect(state.isReloading, isTrue);
        expect(state.isLoading, isTrue);
        expect(state.hasError, isTrue);
      });

      test('isReloading is false when just loading', () {
        const state = AsyncValueForBLoC<int>.loading();
        expect(state.isReloading, isFalse);
      });
    });

    group('accessors', () {
      test('valueOrNull returns value for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.valueOrNull, equals(42));
      });

      test('valueOrNull returns value for AsyncLoadingWithDataForBLoC', () {
        const state = AsyncLoadingWithDataForBLoC<int>(42);
        expect(state.valueOrNull, equals(42));
      });

      test('valueOrNull returns null for AsyncLoadingForBLoC', () {
        const state = AsyncValueForBLoC<int>.loading();
        expect(state.valueOrNull, isNull);
      });

      test('valueOrNull returns null for AsyncErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);
        expect(state.valueOrNull, isNull);
      });

      test('failureOrNull returns failure for AsyncErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);
        expect(state.failureOrNull, equals(failure));
      });

      test(
        'failureOrNull returns failure for AsyncLoadingWithErrorForBLoC',
        () {
          const failure = Failure(message: 'Error', type: UnknownFailureType());
          const state = AsyncLoadingWithErrorForBLoC<int>(failure);
          expect(state.failureOrNull, equals(failure));
        },
      );

      test('failureOrNull returns null for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.failureOrNull, isNull);
      });

      test('requireValue returns value for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.requireValue, equals(42));
        expect(state.value, equals(42)); // Alias
      });

      test('requireValue throws StateError for AsyncLoadingForBLoC', () {
        const state = AsyncValueForBLoC<int>.loading();
        expect(() => state.requireValue, throwsStateError);
        expect(() => state.value, throwsStateError);
      });

      test('requireValue throws StateError for AsyncErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);
        expect(() => state.requireValue, throwsStateError);
      });

      test('asData returns self for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.asData, isNotNull);
        expect(state.asData?.value, equals(42));
      });

      test('asData returns null for AsyncLoadingForBLoC', () {
        const state = AsyncValueForBLoC<int>.loading();
        expect(state.asData, isNull);
      });

      test('asError returns self for AsyncErrorForBLoC', () {
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);
        expect(state.asError, isNotNull);
        expect(state.asError?.failure, equals(failure));
      });

      test('asError returns null for AsyncDataForBLoC', () {
        const state = AsyncValueForBLoC<int>.data(42);
        expect(state.asError, isNull);
      });
    });

    group('pattern matching - when', () {
      test('when() calls loading for AsyncLoadingForBLoC', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.loading();

        // Act
        final result = state.when(
          loading: () => 'loading',
          data: (v) => 'data: $v',
          error: (f) => 'error: ${f.message}',
        );

        // Assert
        expect(result, equals('loading'));
      });

      test('when() calls data for AsyncDataForBLoC', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.data(42);

        // Act
        final result = state.when(
          loading: () => 'loading',
          data: (v) => 'data: $v',
          error: (f) => 'error: ${f.message}',
        );

        // Assert
        expect(result, equals('data: 42'));
      });

      test('when() calls error for AsyncErrorForBLoC', () {
        // Arrange
        const failure = Failure(message: 'Test', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);

        // Act
        final result = state.when(
          loading: () => 'loading',
          data: (v) => 'data: $v',
          error: (f) => 'error: ${f.message}',
        );

        // Assert
        expect(result, equals('error: Test'));
      });

      test('when() calls loading for AsyncLoadingWithDataForBLoC', () {
        // Arrange
        const state = AsyncLoadingWithDataForBLoC<int>(42);

        // Act
        final result = state.when(
          loading: () => 'loading',
          data: (v) => 'data: $v',
          error: (f) => 'error',
        );

        // Assert
        expect(result, equals('loading'));
      });
    });

    group('pattern matching - maybeWhen', () {
      test('maybeWhen calls orElse when no handlers provided', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.data(42);

        // Act
        final result = state.maybeWhen(orElse: () => 'fallback');

        // Assert
        expect(result, equals('fallback'));
      });

      test('maybeWhen calls specific handler when provided', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.data(42);

        // Act
        final result = state.maybeWhen(
          data: (v) => 'data: $v',
          orElse: () => 'fallback',
        );

        // Assert
        expect(result, equals('data: 42'));
      });
    });

    group('pattern matching - maybeMap', () {
      test('maybeMap calls specific handler for AsyncDataForBLoC', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.data(42);

        // Act
        final result = state.maybeMap(
          data: (s) => 'data: ${s.value}',
          orElse: () => 'fallback',
        );

        // Assert
        expect(result, equals('data: 42'));
      });

      test('maybeMap calls loadingWithData handler', () {
        // Arrange
        const state = AsyncLoadingWithDataForBLoC<int>(42);

        // Act
        final result = state.maybeMap(
          loadingWithData: (s) => 'refreshing: ${s.previousValue}',
          orElse: () => 'fallback',
        );

        // Assert
        expect(result, equals('refreshing: 42'));
      });

      test('maybeMap calls loadingWithError handler', () {
        // Arrange
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncLoadingWithErrorForBLoC<int>(failure);

        // Act
        final result = state.maybeMap(
          loadingWithError: (s) => 'reloading: ${s.previousFailure.message}',
          orElse: () => 'fallback',
        );

        // Assert
        expect(result, equals('reloading: Error'));
      });

      test('maybeMap calls orElse when no handler matches', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.loading();

        // Act
        final result = state.maybeMap(
          data: (s) => 'data',
          orElse: () => 'fallback',
        );

        // Assert
        expect(result, equals('fallback'));
      });
    });

    group('transformations - map', () {
      test('map transforms data value', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.data(42);

        // Act
        final result = state.map((v) => v * 2);

        // Assert
        expect(result, isA<AsyncDataForBLoC<int>>());
        expect(result.valueOrNull, equals(84));
      });

      test('map preserves loading state', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.loading();

        // Act
        final result = state.map((v) => v * 2);

        // Assert
        expect(result, isA<AsyncLoadingForBLoC<int>>());
      });

      test('map preserves error state', () {
        // Arrange
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncValueForBLoC<int>.error(failure);

        // Act
        final result = state.map((v) => v * 2);

        // Assert
        expect(result, isA<AsyncErrorForBLoC<int>>());
        expect(result.failureOrNull, equals(failure));
      });
    });

    group('transformations - whenData', () {
      test('whenData transforms data and preserves type', () {
        // Arrange
        const state = AsyncValueForBLoC<int>.data(42);

        // Act
        final result = state.whenData((v) => v.toString());

        // Assert
        expect(result, isA<AsyncDataForBLoC<String>>());
        expect(result.valueOrNull, equals('42'));
      });

      test('whenData preserves LoadingWithData variant', () {
        // Arrange
        const state = AsyncLoadingWithDataForBLoC<int>(42);

        // Act
        final result = state.whenData((v) => v.toString());

        // Assert
        expect(result, isA<AsyncLoadingWithDataForBLoC<String>>());
        expect(result.valueOrNull, equals('42'));
        expect(result.isRefreshing, isTrue);
      });

      test('whenData preserves LoadingWithError variant', () {
        // Arrange
        const failure = Failure(message: 'Error', type: UnknownFailureType());
        const state = AsyncLoadingWithErrorForBLoC<int>(failure);

        // Act
        final result = state.whenData((v) => v.toString());

        // Assert
        expect(result, isA<AsyncLoadingWithErrorForBLoC<String>>());
        expect(result.failureOrNull, equals(failure));
      });
    });

    group('transformations - copyWithPrevious', () {
      test('copyWithPrevious creates LoadingWithData from Loading + Data', () {
        // Arrange
        const loading = AsyncValueForBLoC<int>.loading();
        const previousData = AsyncValueForBLoC<int>.data(42);

        // Act
        final result = loading.copyWithPrevious(previousData);

        // Assert
        expect(result, isA<AsyncLoadingWithDataForBLoC<int>>());
        expect(result.valueOrNull, equals(42));
        expect(result.isRefreshing, isTrue);
      });

      test(
        'copyWithPrevious creates LoadingWithError from Loading + Error',
        () {
          // Arrange
          const loading = AsyncValueForBLoC<int>.loading();
          const failure = Failure(message: 'Error', type: UnknownFailureType());
          const previousError = AsyncValueForBLoC<int>.error(failure);

          // Act
          final result = loading.copyWithPrevious(previousError);

          // Assert
          expect(result, isA<AsyncLoadingWithErrorForBLoC<int>>());
          expect(result.failureOrNull, equals(failure));
          expect(result.isReloading, isTrue);
        },
      );

      test('copyWithPrevious returns self for non-loading states', () {
        // Arrange
        const data = AsyncValueForBLoC<int>.data(42);
        const previousData = AsyncValueForBLoC<int>.data(100);

        // Act
        final result = data.copyWithPrevious(previousData);

        // Assert
        expect(result, equals(data));
      });

      test('copyWithPrevious preserves LoadingWithData', () {
        // Arrange
        const loading = AsyncValueForBLoC<int>.loading();
        const previousLoadingWithData = AsyncLoadingWithDataForBLoC<int>(42);

        // Act
        final result = loading.copyWithPrevious(previousLoadingWithData);

        // Assert
        expect(result, isA<AsyncLoadingWithDataForBLoC<int>>());
        expect(result.valueOrNull, equals(42));
      });
    });

    group('equality', () {
      test('AsyncLoadingForBLoC instances are equal', () {
        const state1 = AsyncValueForBLoC<int>.loading();
        const state2 = AsyncValueForBLoC<int>.loading();

        expect(state1, equals(state2));
      });

      test('AsyncDataForBLoC instances with same value are equal', () {
        const state1 = AsyncValueForBLoC<int>.data(42);
        const state2 = AsyncValueForBLoC<int>.data(42);

        expect(state1, equals(state2));
      });

      test(
        'AsyncDataForBLoC instances with different values are not equal',
        () {
          const state1 = AsyncValueForBLoC<int>.data(42);
          const state2 = AsyncValueForBLoC<int>.data(100);

          expect(state1, isNot(equals(state2)));
        },
      );

      test('AsyncErrorForBLoC instances with same failure are equal', () {
        const failure1 = Failure(message: 'Error', type: UnknownFailureType());
        const failure2 = Failure(message: 'Error', type: UnknownFailureType());
        const state1 = AsyncValueForBLoC<int>.error(failure1);
        const state2 = AsyncValueForBLoC<int>.error(failure2);

        expect(state1, equals(state2));
      });

      test(
        'AsyncLoadingWithDataForBLoC instances with same value are equal',
        () {
          const state1 = AsyncLoadingWithDataForBLoC<int>(42);
          const state2 = AsyncLoadingWithDataForBLoC<int>(42);

          expect(state1, equals(state2));
        },
      );
    });

    group('real-world scenarios', () {
      test('typical loading → data flow', () {
        // Simulate typical async operation
        final states = <AsyncValueForBLoC<String>>[
          const AsyncValueForBLoC.loading(),
        ]
        // Initial loading
        ;
        expect(states.last.isLoading, isTrue);

        // Data received
        states.add(const AsyncValueForBLoC.data('result'));
        expect(states.last.hasValue, isTrue);
        expect(states.last.valueOrNull, equals('result'));
      });

      test('refresh scenario with copyWithPrevious', () {
        // Initial data
        const initial = AsyncValueForBLoC<String>.data('old data');

        // Start refresh
        final refreshing = const AsyncValueForBLoC<String>.loading()
            .copyWithPrevious(initial);

        expect(refreshing.isRefreshing, isTrue);
        expect(refreshing.valueOrNull, equals('old data')); // Shows old data

        // New data arrives
        const updated = AsyncValueForBLoC<String>.data('new data');
        expect(updated.valueOrNull, equals('new data'));
      });

      test('retry scenario after error', () {
        // Initial error
        const failure = Failure(
          message: 'Network error',
          type: NetworkFailureType(),
        );
        const error = AsyncValueForBLoC<int>.error(failure);

        // Start retry
        final retrying = const AsyncValueForBLoC<int>.loading()
            .copyWithPrevious(error);

        expect(retrying.isReloading, isTrue);
        expect(retrying.failureOrNull?.message, equals('Network error'));

        // Success after retry
        const success = AsyncValueForBLoC<int>.data(42);
        expect(success.hasValue, isTrue);
      });
    });
  });
}
