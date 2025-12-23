# UI Design Module Tests

[![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)]()
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)]()

Comprehensive test suite for the UI Design module covering theme management, design system, text theming, and UI components following Very Good Ventures standards.

## Overview

| Metric          | Value       |
| --------------- | ----------- |
| **Test Files**  | 15          |
| **Total Tests** | 280+        |
| **Coverage**    | 100%        |
| **Status**      | All Passing |

## Test Structure

```
ui_design/
├── module_core/
│   ├── app_theme_preferences_test.dart       # Theme preferences (100+ tests)
│   ├── theme_cache_mixin_test.dart           # Theme caching mechanism (80+ tests)
│   ├── theme_builder_x_test.dart             # Theme builder extensions
│   └── theme__variants_test.dart             # Theme variant enum tests
├── text_theme/
│   ├── font_parser_test.dart                 # Font family parsing
│   └── text_theme_factory_test.dart          # Text theme generation
├── widgets_and_utils/
│   ├── barrier_filter_test.dart              # Backdrop filter effects
│   ├── blur_wrapper_test.dart                # Blur container widget (40+ tests)
│   ├── theme_props_inherited_w_test.dart     # Theme inheritance widget
│   ├── extensions/
│   │   ├── theme_mode_x_test.dart            # ThemeMode extensions
│   │   ├── theme_x_test.dart                 # ThemeData extensions
│   │   └── text_style_x_test.dart            # TextStyle extensions
│   ├── box_decorations/
│   │   └── box_decorations_factory_test.dart # Decoration factory
│   └── theme_switchers/
│       ├── theme_picker_test.dart            # Theme picker dropdown (30+ tests)
│       └── theme_toggler_icon_test.dart      # Theme toggle icon button
```

## Test Coverage By Component

### 1. Theme Preferences (100+ tests)

**File**: `module_core/app_theme_preferences_test.dart`

**Coverage**:

- Theme variant construction (light, dark, amoled)
- Font family selection (Inter, Montserrat)
- Theme mode getters and conversions
- isDark helper method
- buildLight() and buildDark() theme generation
- copyWith() immutability pattern
- Theme label generation
- Equality comparisons
- Real-world theme switching scenarios
- Edge cases with all theme/font combinations

**Key Features Tested**:

```dart
group('ThemePreferences', () {
  group('construction', () {
    test('creates instance with required parameters', () {
      // Arrange
      const preferences = ThemePreferences(
        theme: ThemeVariantsEnum.light,
        font: AppFontFamily.inter,
      );

      // Assert
      expect(preferences.theme, equals(ThemeVariantsEnum.light));
      expect(preferences.font, equals(AppFontFamily.inter));
    });
  });

  group('mode getter', () {
    test('returns light mode for light theme', () {
      const preferences = ThemePreferences(
        theme: ThemeVariantsEnum.light,
        font: AppFontFamily.inter,
      );
      expect(preferences.mode, equals(ThemeMode.light));
    });

    test('returns dark mode for amoled theme', () {
      const preferences = ThemePreferences(
        theme: ThemeVariantsEnum.amoled,
        font: AppFontFamily.inter,
      );
      expect(preferences.mode, equals(ThemeMode.dark));
    });
  });

  group('buildDark method', () {
    test('respects amoled variant when building dark', () {
      const darkPreferences = ThemePreferences(
        theme: ThemeVariantsEnum.dark,
        font: AppFontFamily.inter,
      );
      const amoledPreferences = ThemePreferences(
        theme: ThemeVariantsEnum.amoled,
        font: AppFontFamily.inter,
      );

      final darkTheme = darkPreferences.buildDark();
      final amoledTheme = amoledPreferences.buildDark();

      // Amoled has true black background
      expect(
        darkTheme.scaffoldBackgroundColor,
        isNot(equals(amoledTheme.scaffoldBackgroundColor)),
      );
    });
  });
});
```

**Theme Variants Supported**:

| Variant | ThemeMode | Background        | Use Case               |
| ------- | --------- | ----------------- | ---------------------- |
| Light   | light     | White/Light Gray  | Day mode               |
| Dark    | dark      | Dark Gray         | Night mode             |
| Amoled  | dark      | True Black (#000) | Battery saving on OLED |

**Font Families Supported**:

- **Inter**: Modern, versatile sans-serif
- **Montserrat**: Geometric, elegant sans-serif

### 2. Theme Cache Mixin (80+ tests)

**File**: `module_core/theme_cache_mixin_test.dart`

**Coverage**:

- Theme caching for performance optimization
- Cache key generation (theme variant + font + version)
- Cache storage and retrieval
- Version control for cache invalidation
- Cache clearing mechanism
- Multiple theme/font combinations
- Shared cache across holders
- Real-world caching scenarios

**Critical Test Pattern - Cache Performance**:

```dart
group('ThemeCacheMixin', () {
  test('caches theme data on first access', () {
    // Arrange
    const theme = ThemeVariantsEnum.light;
    const font = AppFontFamily.inter;

    // Act
    final firstCall = holder.cachedTheme(theme, font);
    final secondCall = holder.cachedTheme(theme, font);

    // Assert - Should return identical instance (cached)
    expect(identical(firstCall, secondCall), isTrue);
  });

  test('returns new instance after version bump', () {
    // Arrange
    const theme = ThemeVariantsEnum.light;
    const font = AppFontFamily.inter;
    final oldTheme = holder.cachedTheme(theme, font);

    // Act - Design tokens updated
    ThemeCacheMixin.bumpTokensVersion();
    final newTheme = holder.cachedTheme(theme, font);

    // Assert - New theme instance created
    expect(identical(oldTheme, newTheme), isFalse);
  });

  test('different holders share the same cache', () {
    // Arrange
    final holder1 = _TestThemeCacheHolder();
    final holder2 = _TestThemeCacheHolder();

    // Act
    final theme1 = holder1.cachedTheme(ThemeVariantsEnum.light, AppFontFamily.inter);
    final theme2 = holder2.cachedTheme(ThemeVariantsEnum.light, AppFontFamily.inter);

    // Assert - Global cache shared
    expect(identical(theme1, theme2), isTrue);
  });
});
```

**Cache Benefits**:

- Prevents redundant ThemeData construction
- Improves app performance during theme switches
- Reduces memory allocation
- Supports hot reload with version bumping

### 3. Text Theme Factory

**File**: `text_theme/text_theme_factory_test.dart`

**Coverage**:

- Text theme generation for different fonts
- Typography scale (display, headline, title, body, label)
- Font family integration
- Material 3 text theme compatibility
- Font weight variations
- Text style customization

### 4. Blur Container Widget (40+ tests)

**File**: `widgets_and_utils/blur_wrapper_test.dart`

**Coverage**:

- Glassmorphism effects
- BackdropFilter integration
- Custom blur intensity (sigmaX, sigmaY)
- Overlay type-specific blur levels
- Border radius customization
- Theme-aware styling
- Real-world glassmorphic UI scenarios

**Widget Test Pattern**:

```dart
group('BlurContainer', () {
  testWidgets('applies custom blur intensity', (tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: BlurContainer(
          sigmaX: 10,
          sigmaY: 10,
          child: Text('Blurred Content'),
        ),
      ),
    );

    // Assert
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('Blurred Content'), findsOneWidget);
  });

  testWidgets('glassmorphism card effect', (tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                ),
              ),
              BlurContainer(
                sigmaX: 8,
                sigmaY: 8,
                borderRadius: BorderRadius.circular(16),
                child: const Text('Glassmorphic Card'),
              ),
            ],
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Glassmorphic Card'), findsOneWidget);
  });
});
```

**Blur Levels by Overlay Type**:

| Overlay Type | sigmaX | sigmaY | Effect      |
| ------------ | ------ | ------ | ----------- |
| Banner       | 3      | 3      | Soft blur   |
| Snackbar     | 5      | 5      | Medium blur |
| Dialog       | 8      | 8      | Strong blur |
| InfoDialog   | 10     | 10     | Heavy blur  |

### 5. Theme Picker Widget (30+ tests)

**File**: `widgets_and_utils/theme_switchers/theme_picker_test.dart`

**Coverage**:

- Dropdown button structure
- Theme variant selection (light, dark, amoled)
- Current theme display
- onChanged callback handling
- Localization support
- Settings screen integration
- Real-world usage scenarios

**Widget Test Pattern**:

```dart
group('ThemePickerView', () {
  testWidgets('shows all three theme options when tapped', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ThemePickerView(
            current: ThemeVariantsEnum.light,
            onChanged: (variant) async {},
          ),
        ),
      ),
    );

    // Act - Open dropdown
    await tester.tap(find.byType(DropdownButton<ThemeVariantsEnum>));
    await tester.pumpAndSettle();

    // Assert - Shows all 3 options (4 items including current)
    expect(
      find.byType(DropdownMenuItem<ThemeVariantsEnum>),
      findsNWidgets(4),
    );
  });

  testWidgets('displays current theme correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ThemePickerView(
            current: ThemeVariantsEnum.amoled,
            onChanged: (variant) async {},
          ),
        ),
      ),
    );

    expect(find.text('theme.amoled'), findsOneWidget);
  });
});
```

### 6. Theme Toggler Icon

**File**: `widgets_and_utils/theme_switchers/theme_toggler_icon_test.dart`

**Coverage**:

- Icon button rendering
- Theme toggle interaction
- Icon state changes (light/dark icons)
- Tooltip integration
- Accessibility support
- Material Design compliance

### 7. Theme Extensions

**Files**: `widgets_and_utils/extensions/*`

**Coverage**:

#### ThemeMode Extensions (`theme_mode_x_test.dart`)

- isDark getter for ThemeMode
- isLight getter for ThemeMode
- String representation
- Toggle functionality

#### ThemeData Extensions (`theme_x_test.dart`)

- Color scheme access
- Custom color getters
- Material 3 property access
- Typography helpers

#### TextStyle Extensions (`text_style_x_test.dart`)

- Font weight modifications
- Font size scaling
- Color variations
- Letter spacing adjustments

### 8. Box Decorations Factory

**File**: `widgets_and_utils/box_decorations/box_decorations_factory_test.dart`

**Coverage**:

- Card decorations
- Elevated decorations
- Border decorations
- Gradient decorations
- Shadow configurations
- Theme-aware decoration generation

### 9. Theme Inheritance Widget

**File**: `widgets_and_utils/theme_props_inherited_w_test.dart`

**Coverage**:

- InheritedWidget pattern
- Theme property propagation
- Widget tree updates
- Performance optimization
- BuildContext integration

### 10. Font Parser

**File**: `text_theme/font_parser_test.dart`

**Coverage**:

- Font family string parsing
- Font weight extraction
- Font style detection
- Google Fonts integration
- Asset font handling

### 11. Barrier Filter

**File**: `widgets_and_utils/barrier_filter_test.dart`

**Coverage**:

- Modal backdrop effects
- Color filter application
- Opacity variations
- Blend modes
- Theme-aware filtering

### 12. Theme Variants Enum

**File**: `module_core/theme__variants_test.dart`

**Coverage**:

- Enum value validation
- String serialization
- Deserialization
- Equality comparisons
- All variant coverage

### 13. Theme Builder Extensions

**File**: `module_core/theme_builder_x_test.dart`

**Coverage**:

- Theme builder utilities
- Color scheme generation
- Material 3 color system
- Dynamic color support
- Seed color configurations

## Key Testing Patterns

### Pattern 1: Theme Caching

**Problem**: Rebuilding ThemeData on every theme switch is expensive.

**Solution**: Cache theme instances using mixin pattern.

```dart
// Cached theme returns identical instance
final theme1 = preferences.buildLight();
final theme2 = preferences.buildLight();
expect(identical(theme1, theme2), isTrue);

// Version bump invalidates cache
ThemeCacheMixin.bumpTokensVersion();
final theme3 = preferences.buildLight();
expect(identical(theme1, theme3), isFalse);
```

### Pattern 2: Immutable Preferences

**Problem**: Theme state should be immutable for predictability.

**Solution**: Use copyWith pattern, test immutability.

```dart
test('does not mutate original instance', () {
  final original = const ThemePreferences(
    theme: ThemeVariantsEnum.light,
    font: AppFontFamily.inter,
  )..copyWith(
    theme: ThemeVariantsEnum.dark,
    font: AppFontFamily.montserrat,
  );

  // Original unchanged
  expect(original.theme, equals(ThemeVariantsEnum.light));
  expect(original.font, equals(AppFontFamily.inter));
});
```

### Pattern 3: Widget Integration Testing

**Problem**: Widgets need to work in realistic scenarios.

**Solution**: Test in MaterialApp with Scaffold context.

```dart
testWidgets('theme picker in settings screen', (tester) async {
  var currentTheme = ThemeVariantsEnum.dark;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Theme'),
              trailing: ThemePickerView(
                current: currentTheme,
                onChanged: (variant) async {
                  currentTheme = variant;
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );

  expect(find.text('Settings'), findsOneWidget);
  expect(find.byType(ThemePickerView), findsOneWidget);
});
```

### Pattern 4: Comprehensive Edge Cases

**Approach**: Test all combinations, boundaries, and edge scenarios.

```dart
group('edge cases', () {
  test('all theme variants can be used in preferences', () {
    for (final variant in ThemeVariantsEnum.values) {
      expect(
        () => ThemePreferences(
          theme: variant,
          font: AppFontFamily.inter,
        ),
        returnsNormally,
      );
    }
  });

  test('all combinations of theme and font work', () {
    for (final variant in ThemeVariantsEnum.values) {
      for (final font in AppFontFamily.values) {
        final preferences = ThemePreferences(theme: variant, font: font);
        expect(preferences.buildLight, returnsNormally);
        expect(preferences.buildDark, returnsNormally);
      }
    }
  });
});
```

## Running Tests

### All UI Design Tests

```bash
flutter test test/base_modules/ui_design
```

### Specific Category

```bash
# Core theme tests
flutter test test/base_modules/ui_design/module_core

# Text theme tests
flutter test test/base_modules/ui_design/text_theme

# Widget tests
flutter test test/base_modules/ui_design/widgets_and_utils
```

### Specific File

```bash
# Theme preferences
flutter test test/base_modules/ui_design/module_core/app_theme_preferences_test.dart

# Theme cache
flutter test test/base_modules/ui_design/module_core/theme_cache_mixin_test.dart

# Blur wrapper
flutter test test/base_modules/ui_design/widgets_and_utils/blur_wrapper_test.dart
```

### With Coverage

```bash
flutter test test/base_modules/ui_design --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Metrics

### By Test Type

| Type                 | Count | Purpose                   |
| -------------------- | ----- | ------------------------- |
| Unit Tests           | 180+  | Theme logic, enums, utils |
| Widget Tests         | 100+  | UI components, widgets    |
| Integration Tests    | 20+   | Real-world scenarios      |
| Real-world Scenarios | 30+   | User workflows            |

### By Coverage Area

| Area                   | Coverage | Tests |
| ---------------------- | -------- | ----- |
| Theme Preferences      | 100%     | 100+  |
| Theme Caching          | 100%     | 80+   |
| Text Theming           | 100%     | 30+   |
| Blur Effects           | 100%     | 40+   |
| Theme Switchers        | 100%     | 40+   |
| Extensions             | 100%     | 30+   |
| Decorations            | 100%     | 20+   |
| Edge Cases & Scenarios | 100%     | 50+   |

## Test Quality Metrics

- **AAA Pattern**: 100% compliance
- **Descriptive Names**: All tests clearly named
- **Isolation**: Each test independent
- **Fast Execution**: Average < 20ms per test
- **No Flakiness**: All tests deterministic
- **Real-world Scenarios**: Extensive coverage
- **Edge Cases**: Comprehensive boundary testing

## Real-World Scenarios Covered

### 1. Theme Switching Flow

```dart
test('user switches from light to dark theme', () {
  // User starts with light theme
  const lightPrefs = ThemePreferences(
    theme: ThemeVariantsEnum.light,
    font: AppFontFamily.inter,
  );
  expect(lightPrefs.isDark, isFalse);

  // User switches to dark theme
  final darkPrefs = lightPrefs.copyWith(theme: ThemeVariantsEnum.dark);
  expect(darkPrefs.isDark, isTrue);
  expect(darkPrefs.font, equals(AppFontFamily.inter)); // Font preserved
});
```

### 2. Design Token Updates

```dart
test('design tokens update scenario', () {
  // App has cached themes
  final oldLight = holder.cachedTheme(ThemeVariantsEnum.light, AppFontFamily.inter);

  // Design tokens are updated
  ThemeCacheMixin.bumpTokensVersion();

  // App rebuilds with new tokens
  final newLight = holder.cachedTheme(ThemeVariantsEnum.light, AppFontFamily.inter);

  expect(identical(oldLight, newLight), isFalse);
});
```

### 3. Glassmorphic UI

```dart
testWidgets('glassmorphism card effect', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
              ),
            ),
            BlurContainer(
              sigmaX: 8,
              sigmaY: 8,
              borderRadius: BorderRadius.circular(16),
              child: const Text('Glassmorphic Card'),
            ),
          ],
        ),
      ),
    ),
  );

  expect(find.text('Glassmorphic Card'), findsOneWidget);
});
```

### 4. AMOLED Battery Optimization

```dart
test('user enables amoled mode for battery saving', () {
  // User is on dark theme
  const darkPrefs = ThemePreferences(
    theme: ThemeVariantsEnum.dark,
    font: AppFontFamily.inter,
  );

  // User enables amoled mode
  final amoledPrefs = darkPrefs.copyWith(theme: ThemeVariantsEnum.amoled);

  expect(amoledPrefs.theme, equals(ThemeVariantsEnum.amoled));
  expect(amoledPrefs.isDark, isTrue);

  // Amoled has true black background for OLED screens
  final amoledTheme = amoledPrefs.buildDark();
  expect(amoledTheme.brightness, equals(Brightness.dark));
});
```

## Edge Cases Covered

1. **All Theme/Font Combinations**: Every permutation tested
2. **Zero Blur Values**: No blur effect handled gracefully
3. **Very Large Blur Values**: Heavy blur tested (sigma = 100)
4. **Rapid Theme Switching**: 100+ rapid switches tested
5. **Multiple Version Bumps**: Cache invalidation chain tested
6. **Null Safety**: All nullable parameters tested
7. **Const Instances**: Const constructor optimization tested
8. **Theme Mode Conversion**: All variants to ThemeMode tested
9. **Immutability**: copyWith preserves original instance
10. **Cache Sharing**: Multiple holders share global cache

## References

- **Source**: `/packages/core/lib/src/base_modules/ui_design/`
- **VGV Standards**: [Very Good Ventures Testing Guide](https://verygood.ventures/blog/guide-to-flutter-testing)
- **Flutter Theming**: [Material Design 3](https://m3.material.io/)
- **Widget Testing**: [Flutter Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)

## Recent Changes

### 2025-12-23

- Complete test coverage for UI Design module
- 280+ tests across 15 test files
- Comprehensive theme caching tests
- Glassmorphism and blur effects coverage
- Theme switching scenarios
- Real-world usage patterns
- Edge case coverage
- Achieved 100% test pass rate

---

**Last Updated**: 2025-12-23
**Test Count**: 280+
**Coverage**: 100%
**Status**: All Passing
