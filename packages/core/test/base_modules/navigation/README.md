# 🧭 Navigation Module - Test Coverage

Comprehensive test suite for the Navigation module, following Very Good Ventures testing standards.

---

## 📊 Test Coverage Summary

| Metric | Value |
|--------|-------|
| **Test Files** | 3 |
| **Total Lines** | ~950 |
| **Test Groups** | ~25 |
| **Individual Tests** | ~80 |
| **Coverage** | ~95-100% |

---

## 📁 Test Structure

```
navigation/
└── utils/
    └── extensions/
        ├── navigation_x_on_context_test.dart        # Tests for NavigationX extension
        ├── navigation_x_on_failure_test.dart        # Tests for FailureNavigationX extension
        └── result_navigation_x_test.dart            # Tests for Result navigation extensions
```

---

## 🧪 Tested Components

### 1. NavigationX Extension (`navigation_x_on_context_test.dart`)

**File**: `packages/core/lib/src/base_modules/navigation/utils/extensions/navigation_x_on_context.dart`

**Test Coverage**: ~320 lines, ~45 tests

**Tested Methods**:
- `goTo()` - Navigation to named routes
  - ✅ Basic navigation
  - ✅ Path parameters
  - ✅ Query parameters
  - ✅ Error handling with fallback to pageNotFound

- `goPushTo()` - Push routes onto stack
  - ✅ Basic push navigation
  - ✅ Path parameters
  - ✅ Query parameters
  - ✅ Error handling

- `popView()` - Pop current view
  - ✅ Pop from stack
  - ✅ Pop with result value

- `pushTo()` - Push custom widget
  - ✅ Push MaterialPageRoute
  - ✅ Return result from pushed page

- `replaceWith()` - Replace current view
  - ✅ Replace current route
  - ✅ Return result from replacement

- `goIfMounted()` - Conditional navigation
  - ✅ Navigate when context is mounted
  - ✅ Skip navigation when unmounted

- `globalRouterContext` - Get global router context
  - ✅ Return navigatorKey context
  - ✅ Handle errors gracefully

**Test Patterns**:
- Widget testing with `testWidgets`
- GoRouter configuration and routing
- Context-based navigation
- Error handling and fallbacks
- Mounted state validation

---

### 2. FailureNavigationX Extension (`navigation_x_on_failure_test.dart`)

**File**: `packages/core/lib/src/base_modules/navigation/utils/extensions/navigation_x_on_failure.dart`

**Test Coverage**: ~260 lines, ~15 tests

**Tested Methods**:
- `redirectIfUnauthorized()` - Redirect on 401 errors
  - ✅ Call callback on 401 status
  - ✅ Skip callback on other statuses
  - ✅ Return same failure instance
  - ✅ Handle multiple checks
  - ✅ Different status codes (400, 403, 404, 500, etc.)
  - ✅ Network errors
  - ✅ Method chaining
  - ✅ Side effects
  - ✅ Immutability
  - ✅ Exception handling

**Test Patterns**:
- Unit testing with callbacks
- Status code validation
- Failure type checking
- Side effect testing
- Immutability verification

---

### 3. Result Navigation Extensions (`result_navigation_x_test.dart`)

**File**: `packages/core/lib/src/base_modules/navigation/utils/extensions/result_navigation_x.dart`

**Test Coverage**: ~370 lines, ~27 tests

**Tested Extensions**:

#### ResultNavigationExt (Sync)
- `redirectIfSuccess()` - Redirect on successful result
  - ✅ Call navigator on success
  - ✅ Skip navigator on failure
  - ✅ Return same Either instance
  - ✅ Type preservation
  - ✅ Method chaining
  - ✅ Side effects
  - ✅ Complex object types
  - ✅ Multiple calls
  - ✅ Nullable values
  - ✅ Exception propagation

#### ResultFutureNavigationExt (Async)
- `redirectIfSuccess()` - Async redirect on success
  - ✅ Call async navigator on success
  - ✅ Skip navigator on failure
  - ✅ Return correct result
  - ✅ Async navigator support
  - ✅ Type preservation
  - ✅ Async chaining
  - ✅ Async side effects
  - ✅ Delayed futures
  - ✅ Complex async types
  - ✅ Sequential async operations
  - ✅ Sync and async navigators
  - ✅ Nullable async values
  - ✅ Exception handling

**Test Patterns**:
- Either monad testing
- Async/await patterns
- Future handling
- Type safety validation
- Side effect testing

---

## 🎯 Testing Standards

All tests follow **Very Good Ventures (VGV)** standards:

### AAA Pattern
```dart
test('description of what is being tested', () {
  // Arrange - Set up test data and dependencies
  const value = 'test';
  var called = false;

  // Act - Execute the code under test
  final result = value.someMethod(() => called = true);

  // Assert - Verify the outcome
  expect(called, isTrue);
  expect(result, equals(expected));
});
```

### Naming Conventions
- Descriptive test names explaining behavior
- Group related tests together
- Use `group()` for logical organization
- Test names start with action verbs

### Coverage Goals
- All public methods tested
- Edge cases covered
- Error scenarios handled
- Type safety validated
- Immutability verified

---

## 🚀 Running Tests

### Run All Navigation Tests
```bash
flutter test packages/core/test/base_modules/navigation/
```

### Run Specific Test File
```bash
flutter test packages/core/test/base_modules/navigation/utils/extensions/navigation_x_on_context_test.dart
```

### Run with Coverage
```bash
flutter test --coverage packages/core/test/base_modules/navigation/
```

---

## 📝 Test Categories

### Widget Tests
- `navigation_x_on_context_test.dart` - Uses `testWidgets` for routing

### Unit Tests
- `navigation_x_on_failure_test.dart` - Pure unit tests
- `result_navigation_x_test.dart` - Unit tests with async patterns

---

## ✅ Test Quality Checklist

- ✅ All extension methods tested
- ✅ Success paths covered
- ✅ Error paths covered
- ✅ Edge cases handled
- ✅ Type safety verified
- ✅ Immutability checked
- ✅ Side effects tested
- ✅ Async patterns validated
- ✅ Exception handling verified
- ✅ AAA pattern followed
- ✅ Descriptive naming used

---

## 🔧 Dependencies

### Test Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  test: any
  go_router: ^14.0.0
```

### Production Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
```

---

## 📌 Notes

### Inactive Code
The following navigation module components are **commented out** and not currently active:
- `module_core/routes/` - Route definitions (app_routes.dart, route_paths.dart, routes_names.dart)
- `module_core/specific_for_bloc/` - BLoC-specific routing
- `module_core/specific_for_riverpod/` - Riverpod-specific routing

**These components are NOT tested** as they are inactive in the codebase. If they become active, comprehensive tests should be added.

### Active Components
Only the **3 extension files** in `utils/extensions/` are active and fully tested:
- ✅ `navigation_x_on_context.dart`
- ✅ `navigation_x_on_failure.dart`
- ✅ `result_navigation_x.dart`

---

## 🎓 Key Testing Insights

### 1. GoRouter Testing
- Widget tests require full `MaterialApp.router` setup
- Routes must be defined in GoRouter configuration
- Error handling requires `pageNotFound` route

### 2. Context-Based Testing
- Context must be obtained from rendered widgets
- Mounted state affects navigation behavior
- Global context access needs navigatorKey

### 3. Result Testing
- Either monad requires both left (Failure) and right (Success) tests
- Async patterns need `await` in tests
- Future composition requires sequential testing

### 4. Failure Testing
- Status code validation is critical
- Different failure types need separate tests
- Callback behavior must be verified

---

## 📚 Related Documentation

- [Navigation Module README](../../../lib/src/base_modules/navigation/README(navigation).md)
- [Very Good Ventures Testing Guide](https://verygood.ventures/blog/guide-to-flutter-testing)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

---

**Last Updated**: 2025-12-17
**Test Coverage**: ~95-100%
**Total Tests**: ~80
**Status**: ✅ All tests passing
