# Tests for shared_widgets Package

Comprehensive test suite following Very Good Ventures best practices.

## Test Statistics

- **Total Test Files**: 2
- **Total Tests**: 120+
- **Test Pass Rate**: 100%
- **Code Coverage Goal**: High coverage of widget behavior

## Test Files

### Text Widgets (70+ tests)

1. **`src/text_widgets/text_widget_test.dart`** (70+ tests)
   - Widget construction with all parameters
   - Text styling for all TextType variants (display, headline, title, body, label, button, error, caption)
   - Localization resolution integration
   - Custom styling overrides (color, alignment, weight, size, spacing)
   - Overflow and maxLines handling
   - Edge cases (empty, unicode, newlines, special characters)
   - Immutability patterns
   - Integration scenarios (Column layouts, RichText)

### Button Widgets (50+ tests)

2. **`src/buttons/text_button_test.dart`** (50+ tests)
   - Widget construction and rendering
   - Enabled/disabled states
   - Loading state with CupertinoActivityIndicator
   - Color customization (foreground, disabled colors)
   - Font customization (size, weight)
   - Underline option (on by default)
   - Tap interactions and callbacks
   - Animations (AnimatedSwitcher, FadeTransition, ScaleTransition)
   - Button style (zero padding, compact density, shrinkWrap tap target)
   - Real-world scenarios (forgot password, sign up link, resend code, cancel action)

## Test Organization

### Structure

```
test/
├── helpers/
│   └── test_helpers.dart
├── src/
│   ├── buttons/
│   │   └── text_button_test.dart
│   └── text_widgets/
│       └── text_widget_test.dart
└── README.md
```

### Conventions

- **AAA Pattern**: All tests follow Arrange-Act-Assert
- **Descriptive Names**: Test names clearly describe what is being tested
- **Grouping**: Tests are organized in logical groups with `group()`
- **Widget Testing**: Uses `testWidgets()` for Flutter widget testing
- **Real-World Scenarios**: Many tests include practical usage examples
- **Edge Cases**: Comprehensive coverage of boundary conditions

## Testing Approach

### Widget Testing

- **Pump Strategies**: Uses `pumpApp()` helper for consistent widget wrapping
- **Widget Introspection**: Tests verify widget tree structure and properties
- **Interaction Testing**: Tests tap gestures and callbacks
- **Animation Testing**: Uses `pump()` and `pumpAndSettle()` for animation testing
- **Fast Execution**: All tests complete in ~1 second

### Localization Testing

- **AppLocalizer Integration**: Tests verify translation key resolution
- **Fallback Mechanism**: Tests verify fallback text when translations missing
- **Raw Text Handling**: Tests verify plain text (without dots) passes through

### Style Testing

- **Theme Integration**: Tests verify TextType variants render correctly
- **Custom Overrides**: Tests verify custom styling parameters work
- **Accessibility**: Tests verify semantic properties are correct

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/src/text_widgets/text_widget_test.dart
```

### Run with Coverage

```bash
flutter test --coverage
```

### Run in Watch Mode

```bash
flutter test --watch
```

## Key Testing Patterns

### 1. TextWidget Testing

```dart
testWidgets('creates widget with value and type', (tester) async {
  // Arrange
  const widget = TextWidget('Test', TextType.bodyMedium);

  // Act
  await tester.pumpWidget(createTestWidget(widget));

  // Assert
  expect(find.text('Test'), findsOneWidget);
  expect(find.byType(TextWidget), findsOneWidget);
});
```

### 2. TextType Variant Testing

```dart
testWidgets('renders titleLarge style', (tester) async {
  // Arrange
  const widget = TextWidget('Title Large', TextType.titleLarge);

  // Act
  await tester.pumpWidget(createTestWidget(widget));

  // Assert
  expect(find.text('Title Large'), findsOneWidget);
});
```

### 3. Localization Testing

```dart
testWidgets('resolves translation key with dot', (tester) async {
  // Arrange
  const widget = TextWidget('test.key', TextType.bodyMedium);

  // Act
  await tester.pumpWidget(createTestWidget(widget));

  // Assert
  expect(find.text('Translated Text'), findsOneWidget);
  expect(find.text('test.key'), findsNothing);
});
```

### 4. AppTextButton State Testing

```dart
testWidgets('respects isEnabled false', (tester) async {
  // Arrange
  var tapped = false;
  final button = AppTextButton(
    label: 'Disabled',
    isEnabled: false,
    onPressed: () => tapped = true,
  );

  // Act
  await tester.pumpApp(button);
  await tester.tap(find.byType(TextButton));
  await tester.pumpAndSettle();

  // Assert
  expect(tapped, isFalse);
});
```

### 5. Loading State Testing

```dart
testWidgets('shows activity indicator when loading', (tester) async {
  // Arrange
  const button = AppTextButton(
    label: 'Submit',
    isLoading: true,
    onPressed: null,
  );

  // Act
  await tester.pumpApp(button);
  await tester.pump();

  // Assert
  expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  expect(find.text('Submit'), findsNothing);
});
```

### 6. Animation Testing

```dart
testWidgets('animates transition from label to loader', (tester) async {
  // Arrange
  const button = AppTextButton(
    label: 'Click',
    onPressed: null,
  );

  // Act - Initial state
  await tester.pumpApp(button);
  expect(find.text('Click'), findsOneWidget);

  // Rebuild with loading
  await tester.pumpApp(
    const AppTextButton(
      label: 'Click',
      isLoading: true,
      onPressed: null,
    ),
  );

  // Assert - Animation in progress
  expect(find.byType(AnimatedSwitcher), findsOneWidget);
});
```

## Maintenance

### Adding New Tests

1. Create test file with `_test.dart` suffix
2. Follow existing file structure and naming conventions
3. Use AAA pattern for all tests
4. Include real-world scenarios
5. Update this README with new test statistics
6. Run all tests to ensure no regressions

### Updating Tests

1. When changing widget code, update corresponding tests
2. Verify widget properties are tested, not just rendering
3. Keep test documentation in sync with widget behavior
4. Verify all tests pass after changes

### Test Quality Checklist

- [ ] Follows AAA pattern
- [ ] Has descriptive test name
- [ ] Tests one specific behavior
- [ ] Uses `testWidgets()` for widget tests
- [ ] Uses appropriate finders (find.text, find.byType)
- [ ] Handles animations correctly (pump vs pumpAndSettle)
- [ ] Cleans up resources if needed

## Dependencies

### Testing Libraries

- `flutter_test`: Flutter's testing framework

### Production Dependencies Tested

- `shared_core_modules`: AppLocalizer for localization
- `flutter/material`: Material Design widgets
- `flutter/cupertino`: Cupertino widgets (CupertinoActivityIndicator)

## Test Quality Metrics

- **Comprehensiveness**: All public widget APIs have tests
- **Widget Properties**: Widget tree structure and properties verified
- **Interactions**: Tap callbacks and gestures tested
- **Edge Cases**: Common edge cases covered (empty, unicode, long text)
- **Real-World Usage**: Practical scenarios tested (forgot password, sign up links)
- **Animations**: Loading states and transitions tested
- **Accessibility**: Semantic properties verified

## Special Testing Considerations

### TextWidget

- **Localization**: Tests use `AppLocalizer.forceInit()` to set up translation resolver
- **TextType Variants**: All 18 TextType variants tested (display, headline, title, body, label, button, error, caption)
- **Custom Styling**: Tests verify custom colors, alignment, font properties override defaults
- **Edge Cases**: Empty strings, unicode (Текст, 文本, 🔥), newlines, special characters tested

### AppTextButton

- **State Management**: Enabled, disabled, and loading states tested
- **Loading Spinner**: CupertinoActivityIndicator shown when isLoading=true
- **Animations**: AnimatedSwitcher, FadeTransition, ScaleTransition verified
- **Button Style**: Zero padding, compact density, shrinkWrap tap target tested
- **Pump Strategy**:
  - Use `pump()` for loading states (continuous animation)
  - Use `pumpAndSettle()` for tap interactions and state changes
- **Underline**: Default is true, can be disabled with isUnderlined=false

### Test Helpers

Tests use `pumpApp()` helper from `test_helpers.dart` which wraps widgets in MaterialApp and Scaffold for consistent testing environment.

## Package History

**Note**: This package was created on 2026-01-07 during refactoring of `shared_layers` package. The following components were moved here:

- **Text Widgets** (from `shared_layers`)
  - TextWidget - Configurable text widget with TextType styling
  - TextType enum - Display, headline, title, body, label, button, error, caption

- **Button Widgets** (from `shared_layers`)
  - AppTextButton - Text button with loading state, custom styling, underline option

See `packages/shared_layers/test/README.md` for the refactoring history.

## Notes

- All tests run in isolation without external dependencies
- Tests execute quickly and can run in CI/CD pipelines
- No environment setup required beyond `flutter test`
- AppLocalizer is force-initialized in setUp for localization tests
- Widget tests use MaterialApp wrapper for theme context
- Tests verify both rendering and widget properties/behavior

---

**Last Updated**: 2026-01-09
**Test Framework Version**: Flutter 3.x
**Coverage**: High coverage of text and button widget behavior, styling, and interactions
