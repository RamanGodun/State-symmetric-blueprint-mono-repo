/// Tests for AsyncStateIntrospectionRiverpodX extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - failureOrNull getter
/// - isLoadingFast, hasValueFast, hasErrorFast flags
/// - isRefreshingFast, isReloadingFast flags
/// - whenUI method with preserveDataOnRefresh
library;

import 'package:adapters_for_riverpod/src/shared_presentation/async_state_model/async_state_introspection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('AsyncStateIntrospectionRiverpodX', () {
    group('failureOrNull', () {
      test('returns null for data state', () {
        // Arrange
        const asyncValue = AsyncValue.data('test');

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNull);
      });

      test('returns null for loading state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNull);
      });

      test('returns Failure when error is Failure', () {
        // Arrange
        const failure = Failure(
          message: 'Test failure',
          type: UnknownFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          failure,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNotNull);
        expect(result, isA<Failure>());
        expect(result?.message, equals('Test failure'));
      });

      test('maps non-Failure exception to Failure', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          Exception('Regular exception'),
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNotNull);
        expect(result, isA<Failure>());
      });
    });

    group('fast flag aliases', () {
      test('isLoadingFast returns true for loading state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();

        // Act & Assert
        expect(asyncValue.isLoadingFast, isTrue);
        expect(asyncValue.isLoadingFast, equals(asyncValue.isLoading));
      });

      test('isLoadingFast returns false for data state', () {
        // Arrange
        const asyncValue = AsyncValue.data('test');

        // Act & Assert
        expect(asyncValue.isLoadingFast, isFalse);
      });

      test('hasValueFast returns true for data state', () {
        // Arrange
        const asyncValue = AsyncValue.data('test');

        // Act & Assert
        expect(asyncValue.hasValueFast, isTrue);
        expect(asyncValue.hasValueFast, equals(asyncValue.hasValue));
      });

      test('hasValueFast returns false for loading state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();

        // Act & Assert
        expect(asyncValue.hasValueFast, isFalse);
      });

      test('hasErrorFast returns true for error state', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          Exception('error'),
          StackTrace.current,
        );

        // Act & Assert
        expect(asyncValue.hasErrorFast, isTrue);
        expect(asyncValue.hasErrorFast, equals(asyncValue.hasError));
      });

      test('hasErrorFast returns false for data state', () {
        // Arrange
        const asyncValue = AsyncValue.data('test');

        // Act & Assert
        expect(asyncValue.hasErrorFast, isFalse);
      });

      test('isRefreshingFast returns true for refreshing state', () {
        // Arrange
        const initial = AsyncValue.data('test');
        const loading = AsyncValue<String>.loading();
        final refreshing = loading.copyWithPrevious(initial);

        // Act & Assert
        expect(refreshing.isRefreshingFast, isTrue);
        expect(refreshing.isRefreshingFast, equals(refreshing.isRefreshing));
      });

      test('isReloadingFast aliases isReloading', () {
        // Arrange
        const loading = AsyncValue<String>.loading();

        // Act & Assert
        expect(loading.isReloadingFast, equals(loading.isReloading));
      });
    });

    group('whenUI', () {
      test('calls loading callback for loading state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();
        var loadingCalled = false;

        // Act
        final result = asyncValue.whenUI(
          loading: () {
            loadingCalled = true;
            return 'loading';
          },
          data: (data) => 'data: $data',
          error: (failure) => 'error: ${failure.message}',
        );

        // Assert
        expect(loadingCalled, isTrue);
        expect(result, equals('loading'));
      });

      test('calls data callback for data state', () {
        // Arrange
        const asyncValue = AsyncValue.data('test value');
        var dataCalled = false;

        // Act
        final result = asyncValue.whenUI(
          loading: () => 'loading',
          data: (data) {
            dataCalled = true;
            return 'data: $data';
          },
          error: (failure) => 'error: ${failure.message}',
        );

        // Assert
        expect(dataCalled, isTrue);
        expect(result, equals('data: test value'));
      });

      test('calls error callback for error state with Failure', () {
        // Arrange
        const failure = Failure(
          message: 'Test error',
          type: UnknownFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          failure,
          StackTrace.current,
        );
        var errorCalled = false;

        // Act
        final result = asyncValue.whenUI(
          loading: () => 'loading',
          data: (data) => 'data: $data',
          error: (f) {
            errorCalled = true;
            return 'error: ${f.message}';
          },
        );

        // Assert
        expect(errorCalled, isTrue);
        expect(result, equals('error: Test error'));
      });

      test('maps non-Failure exception in error callback', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          Exception('Regular exception'),
          StackTrace.current,
        );

        // Act
        final result = asyncValue.whenUI(
          loading: () => 'loading',
          data: (data) => 'data: $data',
          error: (failure) => 'error: ${failure.message}',
        );

        // Assert
        expect(result, contains('error:'));
      });

      test('preserves data during refresh by default', () {
        // Arrange
        const initial = AsyncValue.data('preserved data');
        const loading = AsyncValue<String>.loading();
        final refreshing = loading.copyWithPrevious(initial);

        // Act
        final result = refreshing.whenUI(
          loading: () => 'loading',
          data: (data) => 'data: $data',
          error: (failure) => 'error',
        );

        // Assert
        expect(result, equals('data: preserved data'));
      });

      test('shows loading when preserveDataOnRefresh is false', () {
        // Arrange
        const loading = AsyncValue<String>.loading();

        // Act
        final result = loading.whenUI(
          loading: () => 'loading',
          data: (data) => 'data: $data',
          error: (failure) => 'error',
          preserveDataOnRefresh: false,
        );

        // Assert
        expect(result, equals('loading'));
      });

      test('explicitly enables data preservation', () {
        // Arrange
        const initial = AsyncValue.data('test data');
        const loading = AsyncValue<String>.loading();
        final refreshing = loading.copyWithPrevious(initial);

        // Act
        final result = refreshing.whenUI(
          loading: () => 'loading',
          data: (data) => 'data: $data',
          error: (failure) => 'error',
          preserveDataOnRefresh: true,
        );

        // Assert
        expect(result, equals('data: test data'));
      });
    });

    group('real-world scenarios', () {
      test('handles typical data loading flow', () {
        // Arrange - Start with loading
        const loading = AsyncValue<String>.loading();

        // Act - Check UI state
        final loadingUI = loading.whenUI(
          loading: () => 'Spinner',
          data: (data) => 'Content: $data',
          error: (f) => 'Error: ${f.message}',
        );

        // Arrange - Data loaded
        const data = AsyncValue.data('User profile');

        final dataUI = data.whenUI(
          loading: () => 'Spinner',
          data: (d) => 'Content: $d',
          error: (f) => 'Error: ${f.message}',
        );

        // Assert
        expect(loadingUI, equals('Spinner'));
        expect(dataUI, equals('Content: User profile'));
      });

      test('handles refresh without UI flicker', () {
        // Arrange - Initial data
        const initial = AsyncValue.data('Old data');
        const refresh = AsyncValue<String>.loading();
        final refreshing = refresh.copyWithPrevious(initial);

        // Act - Check UI during refresh
        final ui = refreshing.whenUI(
          loading: () => 'Spinner',
          data: (data) => 'Content: $data',
          error: (f) => 'Error',
        );

        // Assert - Shows old data, not spinner
        expect(ui, equals('Content: Old data'));
      });

      test('handles error state with user-friendly message', () {
        // Arrange
        const failure = Failure(
          message: 'Network connection failed',
          type: NetworkFailureType(),
        );
        final error = AsyncValue<String>.error(failure, StackTrace.current);

        // Act
        final ui = error.whenUI(
          loading: () => 'Loading...',
          data: (data) => data,
          error: (f) => 'Oops! ${f.message}',
        );

        // Assert
        expect(ui, equals('Oops! Network connection failed'));
      });

      test('combines fast flags for complex UI logic', () {
        // Arrange
        const initial = AsyncValue.data('data');
        const refresh = AsyncValue<String>.loading();
        final refreshing = refresh.copyWithPrevious(initial);

        // Act - Complex UI decision
        final showSpinner =
            refreshing.isLoadingFast && !refreshing.hasValueFast;
        final showShimmer = refreshing.isRefreshingFast;
        final showContent = refreshing.hasValueFast;

        // Assert
        expect(showSpinner, isFalse); // Has value
        expect(showShimmer, isTrue); // Is refreshing
        expect(showContent, isTrue); // Has value
      });
    });
  });
}
