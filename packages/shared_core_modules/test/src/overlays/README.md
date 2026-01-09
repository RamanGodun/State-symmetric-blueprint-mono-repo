# Overlays Module Tests

Comprehensive test coverage for the overlays module following Very Good Ventures (VGV) testing standards.

## Overview

The overlays module provides a sophisticated system for managing UI overlays (dialogs, snackbars, banners) with platform-specific implementations, conflict resolution, priority management, and queue handling.

## Test Coverage Summary

```
Total Test Files: 6
Total Tests: ~220
Test Groups: 36
Lines of Test Code: ~2,500
```

### Core Components

#### 1. Enums (`enums_for_overlay_module_test.dart`)

- **Test Count**: ~45 tests across 7 enum groups
- **Coverage**:
  - `OverlayPriority`: Priority levels (userDriven, normal, high, critical)
  - `OverlayCategory`: Categorization (banner, dialog, snackbar, error)
  - `OverlayDismissPolicy`: Dismissibility (dismissible, persistent)
  - `OverlayReplacePolicy`: Replacement strategies (waitQueue, forceReplace, etc.)
  - `ShowAs`: Presentation types (banner, snackbar, dialog, infoDialog)
  - `OverlayBlurLevel`: Blur intensity (soft, medium, strong)
  - `OverlayWiringScope`: Resolver wiring (contextOnly, globalOnly, both)

#### 2. Platform Mapper (`platform_mapper_test.dart`)

- **Test Count**: ~30 tests across 4 groups
- **Coverage**:
  - Dialog resolution (iOS, Android, fallback platforms)
  - Banner resolution with platform-specific widgets
  - Snackbar resolution with platform detection
  - Parameter passing verification
  - Callback handling
  - Platform consistency checks
- **Key Features Tested**:
  - iOS defaults to Cupertino-style components
  - Android uses Material Design components
  - Unsupported platforms default to iOS widgets
  - All parameters correctly passed to platform widgets

#### 3. Lock Controller (`lock_controller_test.dart`)

- **Test Count**: ~35 tests across 7 groups
- **Coverage**:
  - Lock/unlock lifecycle
  - Overlay activation triggers
  - Fallback timeout mechanism
  - Subscription management
  - Disposal and cleanup
  - Edge cases and rapid state changes
  - Integration scenarios
- **Key Features Tested**:
  - Arms lock after form submission
  - Unlocks when overlay activates
  - Auto-unlocks after fallback duration
  - Proper cleanup prevents memory leaks

#### 4. Policy Resolver (`policy_resolver_test.dart`)

- **Test Count**: ~40 tests across 6 groups
- **Coverage**:
  - Replacement policy logic (forceReplace, forceIfSameCategory, etc.)
  - Priority-based replacement
  - Category-based replacement
  - Wait queue behavior
  - Dismiss policy resolution
  - Debouncer management per category
  - OverlayQueueItem structure
- **Key Features Tested**:
  - `forceReplace`: Always replaces current overlay
  - `forceIfSameCategory`: Replaces if same category
  - `forceIfLowerPriority`: Replaces if higher priority
  - `dropIfSameType`: Prevents duplicate types
  - `waitQueue`: Queues overlay instead of replacing
  - Independent debouncers per category

#### 5. Tap Through Overlay Barrier (`tap_through_overlay_barrier_test.dart`)

- **Test Count**: ~25 tests across 6 groups
- **Coverage**:
  - Passthrough modes (enabled/disabled)
  - Tap event handling
  - Callback behavior
  - Layout and rendering
  - Edge cases (rapid taps, nested handlers)
  - Integration scenarios (banner/dialog use cases)
- **Key Features Tested**:
  - IgnorePointer behavior based on passthrough flag
  - onTapOverlay callback invocation
  - Translucent HitTestBehavior
  - Complex child widget support
  - Dynamic passthrough toggling

#### 6. Global Overlay Handler (`global_overlay_handler_test.dart`)

- **Test Count**: ~30 tests across 7 groups
- **Coverage**:
  - Keyboard dismissal on tap outside
  - Overlay dismissal behavior
  - Flag configuration (dismissKeyboard, dismissOverlay)
  - Layout preservation
  - Edge cases (rapid taps, nested handlers)
  - Integration scenarios (form fields, complex layouts)
- **Key Features Tested**:
  - GestureDetector with translucent behavior
  - Automatic keyboard unfocus
  - Respects dismiss policy before closing overlay
  - Works with scrollable content
  - Preserves gesture detection hierarchy

## Test Statistics

### Coverage Breakdown

| File                                  | Tests | Groups | Lines |
| ------------------------------------- | ----- | ------ | ----- |
| enums_for_overlay_module_test.dart    | ~45   | 7      | ~400  |
| platform_mapper_test.dart             | ~30   | 4      | ~480  |
| lock_controller_test.dart             | ~35   | 7      | ~420  |
| policy_resolver_test.dart             | ~40   | 6      | ~580  |
| tap_through_overlay_barrier_test.dart | ~25   | 6      | ~330  |
| global_overlay_handler_test.dart      | ~30   | 7      | ~300  |

## Testing Patterns

### AAA Pattern (Arrange-Act-Assert)

All tests follow the VGV AAA pattern:

```dart
test('description of behavior', () {
  // Arrange
  final controller = SubmitCompletionLockController(
    overlayWatcher: mockWatcher,
  );

  // Act
  controller.arm();

  // Assert
  expect(controller.isLocked, isTrue);
});
```

### Mock Objects

Tests use mock implementations for dependencies:

```dart
class MockOverlayActivityWatcher implements OverlayActivityWatcher {
  final List<void Function({required bool active})> _listeners = [];

  @override
  void Function() subscribe(
    void Function({required bool active}) listener,
  ) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }
}
```

### Edge Case Coverage

Tests extensively cover edge cases:

- Rapid state changes
- Null callbacks
- Empty values
- Duplicate operations
- Resource cleanup
- Concurrent operations

### Platform Testing

Platform-specific tests use all Flutter target platforms:

```dart
const platforms = [
  TargetPlatform.iOS,
  TargetPlatform.android,
  TargetPlatform.linux,
  TargetPlatform.macOS,
  TargetPlatform.windows,
  TargetPlatform.fuchsia,
];
```

## Key Concepts Tested

### 1. Priority System

- Priority levels determine overlay precedence
- Critical > High > Normal > UserDriven
- Used in conflict resolution

### 2. Conflict Resolution

- Multiple policies control overlay replacement
- Priority-based and category-based strategies
- Queue management for waiting overlays

### 3. Platform Adaptation

- iOS uses Cupertino-style components
- Android uses Material Design components
- Graceful fallback for unsupported platforms

### 4. Lock Mechanism

- Prevents button flicker after submission
- Unlocks on overlay activation
- Fallback timeout for safety
- Proper subscription management

### 5. Debouncing

- Independent debouncers per category
- Prevents rapid re-triggering
- Category-specific durations

## Running Tests

### Run All Overlay Tests

```bash
flutter test packages/core/test/base_modules/overlays/
```

### Run Specific Test File

```bash
flutter test packages/core/test/base_modules/overlays/core/enums_for_overlay_module_test.dart
flutter test packages/core/test/base_modules/overlays/core/platform_mapper_test.dart
flutter test packages/core/test/base_modules/overlays/core/tap_through_overlay_barrier_test.dart
flutter test packages/core/test/base_modules/overlays/core/global_overlay_handler_test.dart
flutter test packages/core/test/base_modules/overlays/utils/lock_controller_test.dart
flutter test packages/core/test/base_modules/overlays/overlays_dispatcher/policy_resolver_test.dart
```

### Run with Coverage

```bash
flutter test --coverage packages/core/test/base_modules/overlays/
```

### Watch Mode

```bash
flutter test --watch packages/core/test/base_modules/overlays/
```

## Test Structure

```
test/base_modules/overlays/
├── README.md
├── core/
│   ├── enums_for_overlay_module_test.dart
│   ├── platform_mapper_test.dart
│   ├── tap_through_overlay_barrier_test.dart
│   └── global_overlay_handler_test.dart
├── utils/
│   └── lock_controller_test.dart
└── overlays_dispatcher/
    └── policy_resolver_test.dart
```

## Dependencies

Tests use the following packages:

- `flutter_test`: Flutter testing framework
- `core/src/base_modules/overlays/*`: Overlay module components
- `core/src/base_modules/animations/*`: Animation engine
- `core/public_api/*`: Public API exports

## Test Quality Standards

### Naming Conventions

- Test names describe exact behavior being tested
- Use clear, descriptive names with active voice
- Group related tests logically

### Test Independence

- Each test is self-contained
- No shared mutable state between tests
- Proper setup and teardown

### Assertions

- Clear, specific assertions
- Use appropriate matchers
- Include reason parameters for complex assertions

### Documentation

- Tests serve as living documentation
- Clear comments explain non-obvious behavior
- Examples demonstrate usage patterns

## Coverage Goals

- ✅ Enum value verification
- ✅ Platform resolution logic
- ✅ Lock/unlock lifecycle
- ✅ Conflict resolution policies
- ✅ Priority comparisons
- ✅ Category matching
- ✅ Edge cases and error handling
- ✅ Resource cleanup and disposal

## Integration with CI/CD

These tests are designed to run in CI/CD pipelines:

- Fast execution (no network/database dependencies)
- Deterministic results
- Clear failure messages
- No flaky tests

## Future Enhancements

Potential areas for additional coverage:

- Widget tests for platform-specific overlay components
- Integration tests for overlay dispatcher
- Performance tests for queue management
- Accessibility tests for overlays

## Notes

- Tests focus on logic and behavior, not UI rendering
- Mock objects simulate external dependencies
- Platform detection uses Flutter's TargetPlatform enum
- Async operations are properly awaited in tests
- Resource cleanup is verified to prevent memory leaks

## Contributing

When adding new tests:

1. Follow VGV AAA pattern
2. Add descriptive test names
3. Cover edge cases
4. Update this README
5. Ensure tests are deterministic
6. Verify cleanup in tearDown
