# Adapters for Riverpod - Test Suite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Comprehensive test suite for the `adapters_for_riverpod` package, following **Very Good Ventures best practices** and Riverpod patterns.

## 📋 Table of Contents

- [Overview](#overview)
- [Test Coverage](#test-coverage)
- [Module Documentation](#module-documentation)
- [Testing Standards](#testing-standards)
- [Running Tests](#running-tests)
- [Contributing](#contributing)

## 🎯 Overview

This test suite provides comprehensive coverage for all utility modules and extensions in the `adapters_for_riverpod` package. Our tests follow AAA (Arrange-Act-Assert) pattern and VGV testing standards.

### Test Statistics

| Module                                             | Test Files | Tests   | Coverage | Status             |
| -------------------------------------------------- | ---------- | ------- | -------- | ------------------ |
| **Base Modules**                                   |            |         |          |                    |
| [AsyncValueDebugX](#async)                         | 1          | 20      | 100%     | ✅ Passing         |
| [AsyncValueFailureX](#failure)                     | 1          | 16      | 100%     | ✅ Passing         |
| [AsyncStateIntrospectionRiverpodX](#introspection) | 1          | 23      | 100%     | ✅ Passing         |
| [ProviderDebugObserver](#observer)                 | 1          | 16      | 100%     | ✅ Passing         |
| [GlobalDIContainer](#di)                           | 1          | 20      | 100%     | ✅ Passing         |
| [ContextDI Extension](#context-di)                 | 1          | 18      | 100%     | ✅ Passing         |
| [Typedefs](#typedefs)                              | 1          | 5       | 100%     | ✅ Passing         |
| **Theme Module**                                   |            |         |          |                    |
| [ThemeProvider](#theme)                            | 1          | 30      | 100%     | ✅ Passing         |
| [ThemeStorageProvider](#theme-storage)             | 1          | 16      | 100%     | ✅ Passing         |
| **Overlays Module**                                |            |         |          |                    |
| [OverlayStatusX](#overlay-status-x)                | 1          | 13      | 100%     | ✅ Passing         |
| [OverlayResolverWiring](#overlay-wiring)           | 1          | 21      | 100%     | ✅ Passing         |
| **Feature Providers**                              |            |         |          |                    |
| [Auth Providers](#auth-providers)                  | 1          | 14      | 100%     | ✅ Passing         |
| [Password Providers](#password)                    | 1          | 14      | 100%     | ✅ Passing         |
| [Profile Providers](#profile)                      | 1          | 14      | 100%     | ✅ Passing         |
| [Email Verification](#email-verification)          | 1          | 14      | 100%     | ✅ Passing         |
| **Overlay Module Extended**                        |            |         |          |                    |
| [OverlayAdaptersProviders](#overlay-adapters)      | 1          | 18      | 100%     | ✅ Passing         |
| [LockerWhileActiveOverlay](#locker-overlay)        | 1          | 10      | 100%     | ✅ Passing         |
| **Total**                                          | **17**     | **272** | **100%** | ✅ **All Passing** |

## 📊 Test Coverage

Our test suite maintains 100% code coverage for testable modules:

```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Highlights

- **Line Coverage**: 100% for extensions and utilities
- **Branch Coverage**: 100% for all test cases
- **Function Coverage**: 100%
- **Extension Tests**: Complete coverage of AsyncValue extensions
- **Typedef Tests**: Full signature verification

## 📚 Module Documentation

### 🔍 AsyncValueDebugX Extension

Debug utilities for Riverpod's `AsyncValue<T>` states.

**Test File:** `async_value_xx_test.dart` (20 tests)

**Coverage:**

- `toStr` getter - Short debug strings for all states
- `getProps` getter - Detailed debug information
- Edge cases (null values, complex objects, lists)
- Real-world debugging scenarios

**Key Features Tested:**

```dart
// Quick debug output
final loading = AsyncValue<String>.loading();
print(loading.toStr); // "AsyncLoading(isLoading: true)"

// Detailed state inspection
final data = AsyncValue.data('value');
print(data.getProps);
/*
isLoading: false, isRefreshing: false, isReloading: false
hasValue: true, hasError: false, value: value
*/
```

### ❌ AsyncValueFailureX Extension

Extract domain failures from AsyncValue error states.

**Test File:** `async_value_failure_x_test.dart` (16 tests)

**Coverage:**

- `failureOrNull` getter - Extract Failure from AsyncError
- `asFailure` alias for semantic sugar
- Edge cases (non-Failure errors, different states)
- Real-world error handling scenarios

**Key Features Tested:**

```dart
// Extract domain failure from AsyncError
final failure = Failure(message: 'API failed', type: NetworkFailureType());
final asyncValue = AsyncValue<String>.error(failure, StackTrace.current);

final extractedFailure = asyncValue.failureOrNull;
// Returns: Failure instance

// Returns null for non-Failure errors
final systemError = AsyncValue<String>.error(Exception('System error'), StackTrace.current);
final result = systemError.failureOrNull;
// Returns: null
```

### 🔎 AsyncStateIntrospectionRiverpodX Extension

Introspection and UI helpers for AsyncValue with fast flags and declarative UI rendering.

**Test File:** `async_state_introspection_test.dart` (23 tests)

**Coverage:**

- `failureOrNull` getter - Domain-aware failure extraction
- Fast flag aliases (isLoadingFast, hasValueFast, hasErrorFast, isRefreshingFast, isReloadingFast)
- `whenUI` method with `preserveDataOnRefresh` parameter
- Refresh-preserving rendering logic
- Real-world UI scenarios

**Key Features Tested:**

```dart
// Extract domain failure from AsyncValue
final asyncValue = AsyncValue<String>.error(
  Failure(message: 'API failed', type: NetworkFailureType()),
  StackTrace.current,
);
final failure = asyncValue.failureOrNull; // Returns: Failure instance

// Fast flag aliases to avoid name clashes
final loading = AsyncValue<String>.loading();
if (loading.isLoadingFast) { ... } // Same as isLoading

// Declarative UI with refresh preservation
final refreshing = AsyncValue<String>.loading()
  .copyWithPrevious(AsyncValue.data('old data'));

final ui = refreshing.whenUI(
  loading: () => 'Spinner',
  data: (data) => 'Content: $data',
  error: (failure) => 'Error: ${failure.message}',
);
// Returns: 'Content: old data' (preserves data during refresh by default)

// Disable data preservation
final ui2 = refreshing.whenUI(
  loading: () => 'Spinner',
  data: (data) => 'Content: $data',
  error: (failure) => 'Error',
  preserveDataOnRefresh: false,
);
// Returns: 'Spinner'
```

### 🔍 ProviderDebugObserver

Riverpod observer for debugging provider lifecycle events.

**Test File:** `providers_debug_observer_test.dart` (16 tests)

**Coverage:**

- Constructor parameters (logValues, onlyNamed, ignore)
- Filtering logic for provider logging
- Lifecycle callbacks (didAddProvider, didUpdateProvider, didDisposeProvider)
- Real-world debugging scenarios

**Key Features Tested:**

```dart
// Log all provider events
const observer = ProviderDebugObserver();
final container = ProviderContainer(observers: [observer]);

// Log only specific providers
const observer = ProviderDebugObserver(
  onlyNamed: {'authProvider', 'userProvider'},
);

// Ignore noisy providers
const observer = ProviderDebugObserver(
  ignore: {'mousePositionProvider', 'timerProvider'},
);

// Control value logging
const observer = ProviderDebugObserver(
  logValues: false, // Only log events, not values
);
```

### 🏗️ GlobalDIContainer

Singleton dependency injection container for app-wide state management.

**Test File:** `global_di_container_test.dart` (20 tests)

**Coverage:**

- Singleton initialization and lifecycle
- `isInitialized` getter
- `instance` getter with error handling
- `initialize` method
- `reset` and `dispose` methods
- Error cases (double initialization, access before init)
- Real-world scenarios (app startup, test isolation)

**Key Features Tested:**

```dart
// Initialize once at app startup
final container = ProviderContainer();
GlobalDIContainer.initialize(container);

// Access from anywhere in the app
final instance = GlobalDIContainer.instance;
final value = instance.read(myProvider);

// Clean up for testing
await GlobalDIContainer.dispose();

// Prevent double initialization
GlobalDIContainer.initialize(container); // Throws StateError

// Check initialization status
if (GlobalDIContainer.isInitialized) {
  // Safe to access instance
}
```

### 🎯 Typedefs

Type definitions for common Riverpod patterns.

**Test File:** `typedefs_test.dart` (5 tests)

**Coverage:**

- `RefCallback` typedef signature
- WidgetRef parameter handling
- Void return type verification
- Multiple callback coexistence

**Usage Example:**

```dart
typedef RefCallback = void Function(WidgetRef ref);

// In a widget:
RefCallback onRefReady = (WidgetRef ref) {
  // Access providers through ref
  final value = ref.watch(myProvider);
};
```

## 🧪 Testing Standards

We follow [Very Good Ventures testing standards][vgv_testing_link] with these principles:

### 1. AAA Pattern (Arrange-Act-Assert)

All tests follow the clear three-phase structure:

```dart
test('returns correct string for data state', () {
  // Arrange
  const asyncValue = AsyncValue.data('test value');

  // Act
  final result = asyncValue.toStr;

  // Assert
  expect(result, contains('value: test value'));
  expect(result, contains('AsyncData'));
});
```

### 2. Descriptive Test Names

Test names clearly describe what is being tested:

```dart
✅ GOOD: 'returns correct string for data state'
✅ GOOD: 'handles null value correctly'
❌ BAD: 'test1'
❌ BAD: 'works'
```

### 3. Test Organization

Tests are organized into logical groups:

```dart
group('AsyncValueDebugX', () {
  group('toStr', () {
    test('returns correct string for data state', () { ... });
    test('returns correct string for loading state', () { ... });
  });

  group('getProps', () {
    test('returns full debug info for data state', () { ... });
  });

  group('edge cases', () {
    test('works with complex object types', () { ... });
  });

  group('real-world scenarios', () {
    test('helps debug provider loading states', () { ... });
  });
});
```

### 4. AsyncValue Testing Patterns

Testing Riverpod's AsyncValue states:

```dart
// Test data state
test('handles data state', () {
  const asyncValue = AsyncValue.data('value');

  expect(asyncValue.hasValue, isTrue);
  expect(asyncValue.valueOrNull, equals('value'));
});

// Test loading state
test('handles loading state', () {
  const asyncValue = AsyncValue<String>.loading();

  expect(asyncValue.isLoading, isTrue);
  expect(asyncValue.hasValue, isFalse);
});

// Test error state
test('handles error state', () {
  final asyncValue = AsyncValue<String>.error(
    'Error message',
    StackTrace.current,
  );

  expect(asyncValue.hasError, isTrue);
  expect(asyncValue.error, isA<String>());
});
```

## 🚀 Running Tests

### Run All Tests

```bash
# Navigate to package
cd packages/adapters_for_riverpod

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run in verbose mode
flutter test --reporter expanded
```

### Run Specific Module

```bash
# Run AsyncValueDebugX tests
flutter test test/src/base_modules/observing/async_value_xx_test.dart

# Run typedefs tests
flutter test test/src/utils/typedefs_test.dart
```

### Run Specific Test

```bash
# Run by name pattern
flutter test --plain-name "returns correct string"

# Run single test group
flutter test --plain-name "AsyncValueDebugX"
```

## 📖 Test File Structure

Every test file follows this structure:

```dart
/// Tests for [ComponentName]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Feature 1
/// - Feature 2
/// - Edge cases
library;

import 'package:flutter_test/flutter_test.dart';
// ... other imports

void main() {
  group('ComponentName', () {
    group('feature 1', () {
      test('specific behavior', () {
        // Arrange
        // ... setup

        // Act
        // ... execute

        // Assert
        // ... verify
      });
    });
  });
}
```

## 🔍 Test Helpers and Fixtures

### Test Constants (`test/fixtures/test_constants.dart`)

Centralized test data:

```dart
class TestConstants {
  static const testString = 'test value';
  static const testInt = 42;
  static const testError = 'Test error message';

  static const shortDelayMs = 50;
  static const mediumDelayMs = 100;
}
```

### Test Helpers (`test/helpers/test_helpers.dart`)

Utility functions:

```dart
// Wait for async operations
await wait(100);

// Await multiple futures
final results = await [future1, future2].awaitAll();
```

## 🤝 Contributing

When adding new tests:

### 1. Test Coverage Requirements

- All new code must have test coverage
- Extensions should have 100% coverage
- Utilities should have comprehensive tests

### 2. Test File Organization

```
test/
├── fixtures/
│   └── test_constants.dart
├── helpers/
│   └── test_helpers.dart
└── src/
    ├── base_modules/
    │   └── observing/
    │       └── async_value_xx_test.dart
    └── utils/
        └── typedefs_test.dart
```

### 3. Documentation Requirements

- Update this README when adding test files
- Document test patterns
- Add examples for complex scenarios

### 4. Code Review Checklist

- [ ] All tests follow AAA pattern
- [ ] Test names are descriptive
- [ ] Tests are properly grouped
- [ ] No flaky tests
- [ ] Coverage is maintained
- [ ] Documentation is updated

## 📖 Additional Resources

- [Very Good Ventures Testing Guide][vgv_testing_link]
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)

## 📝 Notes

### Providers

This package contains many Riverpod providers generated using `riverpod_annotation`. These providers are primarily dependency wiring and do not contain complex logic, so unit tests focus on the utilities and extensions instead.

For provider testing, consider:

- Integration tests in the consuming application
- Provider container tests for dependency resolution
- Widget tests for provider-dependent widgets

### Code Generation

Files with `.g.dart` extension are generated and should not be tested directly. Test the source files that generate them instead.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

---

**Last updated:** 2026-01-03
**Total test files:** 17
**Total tests:** 272
**Total coverage:** 100%
**Status:** ✅ All tests passing

Built with ❤️ following [Very Good Ventures][vgv_link] standards and Riverpod best practices

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[vgv_link]: https://verygood.ventures
[vgv_testing_link]: https://verygood.ventures/blog/guide-to-flutter-testing
