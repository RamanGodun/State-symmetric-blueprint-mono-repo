# Quick Reference Guide - Testing

## 🚀 Common Commands

```bash
# Run all tests
flutter test

# Run all tests (455 passing in ~12 seconds)
flutter test
# ✅ 00:12 +455: All tests passed!

# Run with coverage report
flutter test --coverage

# Run specific test file
flutter test test/src/shared_data_layer/cache_manager/cache_manager_test.dart

# Run tests matching name pattern
flutter test --name "cache"
flutter test --name "debouncer"

# Watch mode (re-run on changes)
flutter test --watch

# Verbose output
flutter test --verbose

# Run in specific platform
flutter test --platform chrome
```

## 📝 Test Template

```dart
/// Tests for [YourComponent]
///
/// VGV Compliance: ✅ AAA pattern, ✅ Descriptive names, ✅ Edge cases
///
/// Coverage: Feature 1, Feature 2, Edge cases, Real-world scenarios
library;

import 'package:flutter_test/flutter_test.dart';
// Import your component

void main() {
  group('YourComponent', () {
    group('construction', () {
      test('creates instance with required parameters', () {
        // Arrange
        const param = 'value';

        // Act
        final instance = YourComponent(param);

        // Assert
        expect(instance.param, equals('value'));
      });
    });

    group('edge cases', () {
      test('handles null input gracefully', () {
        // Arrange
        const input = null;

        // Act
        final result = processInput(input);

        // Assert
        expect(result, isNull);
      });
    });

    group('real-world scenarios', () {
      test('typical usage in production', () {
        // Arrange
        final component = YourComponent(/* ... */);

        // Act
        final result = component.doSomething();

        // Assert
        expect(result, isTrue);
      });
    });
  });
}
```

## 🎯 Common Patterns

### Unit Test (AAA Pattern)

```dart
test('description of behavior', () {
  // Arrange - Setup test data
  const input = 'test';
  final component = MyComponent();

  // Act - Execute the behavior
  final result = component.process(input);

  // Assert - Verify the outcome
  expect(result, equals('expected'));
});
```

### Widget Test

```dart
testWidgets('renders widget correctly', (tester) async {
  // Arrange
  const widget = MyWidget(text: 'Hello');

  // Act
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: widget)),
  );
  await tester.pump(); // NOT pumpAndSettle for loading indicators!

  // Assert
  expect(find.text('Hello'), findsOneWidget);
});
```

### Async Test

```dart
test('handles async operation', () async {
  // Arrange
  final manager = CacheManager<String, String>();

  // Act
  final result = await manager.execute(
    'key',
    () async => 'value',
  );

  // Assert
  expect(result, equals('value'));
});
```

### Exception Test with Zone

```dart
test('handles exceptions properly', () async {
  // Arrange
  Object? caughtError;

  // Act - Use zone to catch unhandled errors
  await runZonedGuarded(() async {
    throwException();
  }, (error, stack) {
    caughtError = error;
  });

  // Assert
  expect(caughtError, isA<Exception>());
});
```

## 🔧 Test Helpers

### WidgetTesterX Extension

```dart
// Pump widget wrapped in MaterialApp
await tester.pumpApp(MyWidget());

// Pump and settle (DON'T use with loading indicators!)
await tester.pumpAppAndSettle(MyWidget());

// Tap by key
await tester.tapByKey('submit-button');

// Enter text by key
await tester.enterTextByKey('email-field', 'test@example.com');
```

### Waiting in Tests

```dart
// Wait 100ms (default)
await wait();

// Wait specific duration
await wait(500); // 500ms
```

### Test Constants

```dart
TestConstants.validEmail      // 'test@example.com'
TestConstants.validName       // 'Test User'
TestConstants.testUserId      // 'user-123'
TestConstants.currencySymbol  // '₴'
TestConstants.shortDelayMs    // 50
TestConstants.mediumDelayMs   // 100
```

## ⚡ Quick Checks

### Before Committing

```bash
# 1. Run all tests
flutter test

# 2. Check for failures
# Should see: "All tests passed!"

# 3. Fix any linting issues
dart fix --apply

# 4. Format code
dart format .
```

### Test Quality Checklist

- [ ] AAA pattern used
- [ ] Descriptive test name (behavior, not implementation)
- [ ] Grouped with `group()`
- [ ] Edge cases included
- [ ] Resources cleaned up (dispose)
- [ ] No `pumpAndSettle()` with loading indicators
- [ ] Async exceptions wrapped in `runZonedGuarded()`

## 🐛 Common Issues & Solutions

### Issue: pumpAndSettle timeout

```dart
// ❌ Wrong - times out with loading indicator
await tester.pumpAndSettle();

// ✅ Correct - use pump for continuous animations
await tester.pump();
```

### Issue: Unhandled async exception

```dart
// ❌ Wrong - exception crashes test
debouncer.run(() => throw Exception());

// ✅ Correct - catch with zone
await runZonedGuarded(() async {
  debouncer.run(() => throw Exception());
}, (error, stack) {
  expect(error, isA<Exception>());
});
```

### Issue: StreamChangeNotifier dispose error

```dart
// ❌ Wrong - can't dispose twice
notifier.dispose();
notifier.dispose(); // Throws FlutterError

// ✅ Correct - dispose once
notifier.dispose();
expect(notifier.dispose, throwsFlutterError);
```

### Issue: Test flakiness

```dart
// ❌ Wrong - race condition
final result = await fetchData();
expect(result, isNotNull);

// ✅ Correct - add appropriate delays
await wait(100);
final result = await fetchData();
expect(result, isNotNull);
```

## 📊 Coverage Goals

| Category     | Current       | Goal           |
| ------------ | ------------- | -------------- |
| Unit Tests   | 70%           | 80%+           |
| Widget Tests | 25%           | 60%+           |
| Integration  | 5%            | 20%+           |
| **Total**    | **455 tests** | **600+ tests** |

## 🎓 VGV Best Practices

✅ **AAA Pattern** - Arrange, Act, Assert
✅ **Descriptive Names** - Describe behavior, not implementation
✅ **Independence** - Tests don't depend on each other
✅ **Fast** - < 15 seconds total execution
✅ **Coverage** - Edge cases, null, boundaries, unicode
✅ **Real-World** - Practical usage scenarios
✅ **Cleanup** - Dispose resources properly
✅ **Documentation** - Test file headers with coverage info

## 📚 Resources

- **Test README**: `test/README.md` - Complete documentation
- **Changelog**: `test/CHANGELOG.md` - Version history
- **Helpers**: `test/helpers/test_helpers.dart` - Utility functions
- **Constants**: `test/fixtures/test_constants.dart` - Test data
- **VGV Guide**: https://verygood.ventures/blog/guide-to-flutter-testing

---

**Last Updated:** 2026-01-02
**Total Tests:** 455+ ✅
**Pass Rate:** 100% 🎉
