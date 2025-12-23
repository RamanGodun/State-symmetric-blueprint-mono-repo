# Core Package Tests

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Comprehensive test suite for the Core package, following [Very Good Ventures][vgv_link] testing standards and best practices.

## 📋 Table of Contents

- [Overview](#overview)
- [Test Coverage](#test-coverage)
- [Module Documentation](#module-documentation)
- [Testing Standards](#testing-standards)
- [Running Tests](#running-tests)
- [Test Patterns](#test-patterns)
- [Contributing](#contributing)

## 🎯 Overview

This test suite provides comprehensive coverage for all base modules in the Core package. Our tests follow the AAA (Arrange-Act-Assert) pattern and VGV testing standards to ensure code quality, maintainability, and reliability.

### Test Statistics

| Module                                                        | Test Files | Coverage | Status             |
| ------------------------------------------------------------- | ---------- | -------- | ------------------ |
| [Animations](base_modules/animations/README.md)               | 10         | 100%     | ✅ Passing         |
| [Errors Management](base_modules/errors_management/readme.md) | 23         | 100%     | ✅ Passing         |
| [Form Fields](base_modules/form_fields/README.md)             | 11         | 100%     | ✅ Passing         |
| [Localization](base_modules/localization/README.md)           | 9          | 100%     | ✅ Passing         |
| [Navigation](base_modules/navigation/README.md)               | 3          | 100%     | ✅ Passing         |
| [Overlays](base_modules/overlays/README.md)                   | 10         | 100%     | ✅ Passing         |
| [UI Design](base_modules/ui_design/README.md)                 | 15         | 100%     | ✅ Passing         |
| **Total**                                                     | **81**     | **100%** | ✅ **All Passing** |

## 📊 Test Coverage

Our test suite maintains 100% code coverage across all modules. We use the following command to generate coverage reports:

```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Highlights

- **Line Coverage**: 100%
- **Branch Coverage**: 100%
- **Function Coverage**: 100%
- **Widget Tests**: Full coverage of all UI components
- **Unit Tests**: Complete coverage of business logic
- **Integration Tests**: End-to-end testing of critical flows

## 📚 Module Documentation

Each module has its own detailed documentation with specific test approaches, patterns, and coverage metrics:

### [🎨 Animations](base_modules/animations/README.md)

Complete testing of animation engines, overlay animations, and timing controls.

- **Focus**: Animation lifecycle, engine behavior, timing consistency
- **Key Tests**: Android/iOS engines, overlay wrappers, animation shells

### [⚠️ Errors Management](base_modules/errors_management/README.md)

Comprehensive error handling, failure mapping, and result types testing.

- **Focus**: Either monad, failure types, exception mapping
- **Key Tests**: Result handlers, failure loggers, error recovery

### [📝 Form Fields](base_modules/form_fields/README.md)

Validation logic, form state management, and input field widgets.

- **Focus**: Input validation, form state, widget behavior
- **Key Tests**: Email/password validation, form states, UI components

### [🌍 Localization](base_modules/localization/README.md)

Multi-language support, locale management, and translation systems.

- **Focus**: Language switching, locale resolution, translation loading
- **Key Tests**: Locale manager, translation providers, fallback handling

### [🧭 Navigation](base_modules/navigation/README.md)

Routing, navigation extensions, and failure-based navigation.

- **Focus**: Route management, navigation utilities, result handling
- **Key Tests**: Navigation extensions, context helpers, failure navigation

### [🔔 Overlays](base_modules/overlays/README.md)

Overlay dispatching, policy resolution, and global overlay management.

- **Focus**: Overlay lifecycle, dispatcher logic, queue management
- **Key Tests**: Dispatcher, policy resolver, global handlers

### [🎨 UI Design](base_modules/ui_design/README.md)

Complete testing of theme management, design system, and UI components (280+ tests).

- **Focus**: Theme switching, caching, glassmorphism, design tokens
- **Key Tests**: Theme preferences, cache mixin, blur effects, theme pickers
- **Special Coverage**: Amoled mode, font families, Material 3 theming

## 🧪 Testing Standards

We follow [Very Good Ventures testing standards][vgv_testing_link] with these principles:

### 1. AAA Pattern (Arrange-Act-Assert)

All tests follow the clear three-phase structure:

```dart
testWidgets('displays success message on valid input', (tester) async {
  // Arrange
  final controller = TextEditingController();
  await tester.pumpWidget(MyWidget(controller: controller));

  // Act
  await tester.enterText(find.byType(TextField), 'test@example.com');
  await tester.pump();

  // Assert
  expect(find.text('Valid email'), findsOneWidget);
});
```

### 2. Descriptive Test Names

Test names clearly describe what is being tested and expected outcome:

```dart
✅ GOOD: 'reverse returns to initial values'
✅ GOOD: 'validates email format correctly'
❌ BAD: 'test1'
❌ BAD: 'it works'
```

### 3. Test Organization

Tests are organized into logical groups:

```dart
group('EmailInputValidation', () {
  group('validation', () {
    test('accepts valid email addresses', () { ... });
    test('rejects invalid email formats', () { ... });
  });

  group('edge cases', () {
    test('handles empty input', () { ... });
    test('handles extremely long emails', () { ... });
  });
});
```

### 4. Mock and Dependency Management

We use proper mocking and dependency injection:

```dart
// Use mocktail for mocking
class MockRepository extends Mock implements Repository {}

// Inject dependencies in tests
final mockRepo = MockRepository();
when(() => mockRepo.getData()).thenAnswer((_) async => testData);
```

### 5. Widget Test Best Practices

- Use `pumpAndSettle()` for animations
- Use `pump(Duration.zero)` for timer-free updates
- Clean up resources with `dispose()`
- Test both widget tree and behavior

### 6. Async Testing Patterns

Handle async operations correctly:

```dart
// ✅ GOOD: Non-blocking reverse animations
engine.reverse(fast: true);
await tester.pumpAndSettle();

// ❌ BAD: Awaiting animations causes hangs
await engine.reverse(); // Can hang in tests
```

## 🚀 Running Tests

### Run All Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run in verbose mode
flutter test --reporter expanded
```

### Run Specific Module

```bash
# Run animations tests
flutter test test/base_modules/animations

# Run form fields tests
flutter test test/base_modules/form_fields

# Run specific file
flutter test test/base_modules/animations/overlays_animation/android_animation_engine_test.dart
```

### Run Specific Test

```bash
# Run by name pattern
flutter test --plain-name "reverse returns to initial values"

# Run single test group
flutter test --plain-name "EmailInputValidation"
```

### Watch Mode

```bash
# Re-run tests on file changes (macOS/Linux)
find test -name "*.dart" | entr flutter test
```

## 🔧 Test Patterns

### 1. Animation Testing Pattern

**Problem**: Animations with `await engine.reverse()` hang in test environment.

**Solution**: Use `fast: true` parameter without await:

```dart
// ✅ Correct approach
engine.reverse(fast: true);
await tester.pumpAndSettle();
expect(engine.opacity.value, equals(0.0));

// ❌ Causes hanging
await engine.reverse();
await tester.pumpAndSettle();
```

**Files affected**:

- `android_animation_engine_test.dart`
- `ios_animation_engine_test.dart`
- `animated_overlay_shell_test.dart`

### 2. Timer Testing Pattern

**Problem**: `Future.delayed` timers persist after widget disposal.

**Solution**: Use `Duration.zero` for non-timing-critical tests:

```dart
// ✅ No pending timers
displayDuration: Duration.zero,

// ❌ Creates persistent timers
displayDuration: const Duration(seconds: 3),
```

### 3. Form Validation Pattern

**Problem**: Testing async validation and state changes.

**Solution**: Use proper pump timing and state verification:

```dart
// Trigger validation
controller.text = 'test@example.com';
await tester.pump();

// Verify state change
expect(formState.email.isValid, isTrue);
```

### 4. Overlay Testing Pattern

**Problem**: Testing concurrent overlays with separate timers.

**Solution**: Test handlers independently:

```dart
// ✅ Test handler assignment, not concurrent execution
expect(overlay1.onDismiss, isNotNull);
expect(overlay2.onDismiss, isNotNull);
expect(overlay1.onDismiss, isNot(same(overlay2.onDismiss)));
```

### 5. Error Handling Pattern

**Problem**: Testing Either monad and failure scenarios.

**Solution**: Use custom test helpers:

```dart
// Test success case
final result = await repository.getData();
expect(result.isRight, isTrue);
expect(result.getRight(), equals(expectedData));

// Test failure case
final result = await repository.getData();
expect(result.isLeft, isTrue);
expect(result.getLeft(), isA<NetworkFailure>());
```

## 🤝 Contributing

When adding new tests, please follow these guidelines:

### 1. Test Coverage Requirements

- All new code must have 100% test coverage
- All branches must be tested
- Edge cases must be covered

### 2. Test File Organization

```
test/
├── base_modules/
│   ├── [module_name]/
│   │   ├── README.md              # Module test documentation
│   │   ├── [feature]/
│   │   │   ├── [feature]_test.dart
│   │   │   └── helpers/           # Test helpers if needed
│   │   └── module_integration_test.dart
```

### 3. Documentation Requirements

- Update module README when adding new test files
- Document any new test patterns or approaches
- Update coverage metrics
- Add examples for complex test scenarios

### 4. Code Review Checklist

- [ ] All tests follow AAA pattern
- [ ] Test names are descriptive
- [ ] Tests are properly grouped
- [ ] No flaky tests (run multiple times to verify)
- [ ] Coverage is 100%
- [ ] Documentation is updated
- [ ] No test warnings or errors

## 📖 Additional Resources

- [Very Good Ventures Testing Guide][vgv_testing_link]
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Widget Testing Best Practices](https://flutter.dev/docs/cookbook/testing/widget/introduction)

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

---

**Last updated:** 2025-12-23
**Total test files:** 81
**Total coverage:** 100%
**Status:** ✅ All tests passing

Built with ❤️ following [Very Good Ventures][vgv_link] standards

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[vgv_link]: https://verygood.ventures
[vgv_testing_link]: https://verygood.ventures/blog/guide-to-flutter-testing
