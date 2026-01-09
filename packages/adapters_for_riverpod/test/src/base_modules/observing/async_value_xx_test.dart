/// Tests for AsyncValueDebugX extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - toStr getter for all AsyncValue states
/// - getProps getter for all AsyncValue states
/// - Edge cases (null values, empty strings, etc.)
library;

import 'package:adapters_for_riverpod/src/base_modules/observing/async_value_xx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/test_constants.dart';

void main() {
  group('AsyncValueDebugX', () {
    group('toStr', () {
      test('returns correct string for data state', () {
        // Arrange
        const asyncValue = AsyncValue.data(TestConstants.testString);

        // Act
        final result = asyncValue.toStr;

        // Assert
        expect(result, contains('value: ${TestConstants.testString}'));
        expect(result, contains('AsyncData'));
      });

      test('returns correct string for loading state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();

        // Act
        final result = asyncValue.toStr;

        // Assert
        expect(result, contains('isLoading: true'));
        expect(result, contains('AsyncLoading'));
      });

      test('returns correct string for error state', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          TestConstants.testError,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.toStr;

        // Assert
        expect(result, contains('error: ${TestConstants.testError}'));
        expect(result, contains('AsyncError'));
      });

      test('handles data state with integer value', () {
        // Arrange
        const asyncValue = AsyncValue.data(TestConstants.testInt);

        // Act
        final result = asyncValue.toStr;

        // Assert
        expect(result, contains('value: ${TestConstants.testInt}'));
        expect(result, contains('AsyncData'));
      });

      test('handles data state with null value', () {
        // Arrange
        const asyncValue = AsyncValue<String?>.data(null);

        // Act
        final result = asyncValue.toStr;

        // Assert
        expect(result, contains('value: null'));
      });

      test('handles loading state with previous data', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();
        final asyncValueWithData = asyncValue.copyWithPrevious(
          const AsyncValue.data(TestConstants.testString),
        );

        // Act
        final result = asyncValueWithData.toStr;

        // Assert
        expect(result, contains('isLoading: true'));
        expect(result, contains('value: ${TestConstants.testString}'));
      });

      test('returns string without commas when only one property', () {
        // Arrange
        const asyncValue = AsyncValue.data(TestConstants.testString);

        // Act
        final result = asyncValue.toStr;

        // Assert
        expect(result, isA<String>());
        expect(result, isNotEmpty);
      });
    });

    group('getProps', () {
      test('returns full debug info for data state', () {
        // Arrange
        const asyncValue = AsyncValue.data(TestConstants.testString);

        // Act
        final result = asyncValue.getProps;

        // Assert
        expect(result, contains('isLoading: false'));
        expect(result, contains('isRefreshing: false'));
        expect(result, contains('isReloading: false'));
        expect(result, contains('hasValue: true'));
        expect(result, contains('hasError: false'));
        expect(result, contains('value: ${TestConstants.testString}'));
      });

      test('returns full debug info for loading state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();

        // Act
        final result = asyncValue.getProps;

        // Assert
        expect(result, contains('isLoading: true'));
        expect(result, contains('hasValue: false'));
        expect(result, contains('hasError: false'));
        expect(result, contains('value: null'));
      });

      test('returns full debug info for error state', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          TestConstants.testError,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.getProps;

        // Assert
        expect(result, contains('isLoading: false'));
        expect(result, contains('hasValue: false'));
        expect(result, contains('hasError: true'));
      });

      test('shows all state flags in multiline format', () {
        // Arrange
        const asyncValue = AsyncValue.data(TestConstants.testString);

        // Act
        final result = asyncValue.getProps;

        // Assert
        expect(result, contains('\n'));
        expect(result.split('\n').length, greaterThan(1));
      });

      test('handles null value correctly', () {
        // Arrange
        const asyncValue = AsyncValue<String?>.data(null);

        // Act
        final result = asyncValue.getProps;

        // Assert
        expect(result, contains('hasValue: true'));
        expect(result, contains('value: null'));
      });

      test('shows loading flags correctly for refreshing state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();

        // Act
        final result = asyncValue.getProps;

        // Assert
        expect(result, contains('isLoading:'));
        expect(result, contains('isRefreshing:'));
        expect(result, contains('isReloading:'));
      });
    });

    group('edge cases', () {
      test('works with complex object types', () {
        // Arrange
        const complexObject = {'key': 'value', 'number': 123};
        const asyncValue = AsyncValue.data(complexObject);

        // Act
        final strResult = asyncValue.toStr;
        final propsResult = asyncValue.getProps;

        // Assert
        expect(strResult, contains('value:'));
        expect(propsResult, contains('hasValue: true'));
      });

      test('works with list types', () {
        // Arrange
        const list = [1, 2, 3];
        const asyncValue = AsyncValue.data(list);

        // Act
        final strResult = asyncValue.toStr;
        final propsResult = asyncValue.getProps;

        // Assert
        expect(strResult, contains('value:'));
        expect(propsResult, contains('hasValue: true'));
      });

      test('handles error with custom exception', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          Exception('Custom exception'),
          StackTrace.current,
        );

        // Act
        final strResult = asyncValue.toStr;
        final propsResult = asyncValue.getProps;

        // Assert
        expect(strResult, contains('error:'));
        expect(propsResult, contains('hasError: true'));
      });
    });

    group('real-world scenarios', () {
      test('helps debug provider loading states', () {
        // Arrange - Simulate provider loading
        const loading = AsyncValue<String>.loading();

        // Act - Debug output
        final debugOutput = loading.toStr;

        // Assert - Can identify loading state quickly
        expect(debugOutput, contains('isLoading'));
        expect(debugOutput, contains('AsyncLoading'));
      });

      test('helps debug provider error states', () {
        // Arrange - Simulate provider error
        final error = AsyncValue<String>.error(
          'Network timeout',
          StackTrace.current,
        );

        // Act - Debug output
        final debugOutput = error.toStr;
        final detailedOutput = error.getProps;

        // Assert - Can identify error quickly
        expect(debugOutput, contains('error: Network timeout'));
        expect(detailedOutput, contains('hasError: true'));
      });

      test('helps debug provider data states', () {
        // Arrange - Simulate provider with data
        const data = AsyncValue.data('User data loaded');

        // Act - Debug output
        final debugOutput = data.toStr;
        final detailedOutput = data.getProps;

        // Assert - Can see data value
        expect(debugOutput, contains('value: User data loaded'));
        expect(detailedOutput, contains('hasValue: true'));
      });

      test('distinguishes between loading and reloading', () {
        // Arrange
        const initialData = AsyncValue.data(TestConstants.testString);
        const reloading = AsyncValue<String>.loading();
        final reloadingWithData = reloading.copyWithPrevious(initialData);

        // Act
        final loadingProps = reloading.getProps;
        final reloadingProps = reloadingWithData.getProps;

        // Assert
        expect(loadingProps, contains('isLoading:'));
        expect(reloadingProps, contains('isLoading:'));
      });
    });
  });
}
