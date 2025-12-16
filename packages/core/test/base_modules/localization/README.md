# Localization Module Tests

Comprehensive test coverage for the localization module following Very Good Ventures (VGV) testing standards.

## Test Files

### Core Module Tests

#### `core_of_module/init_localization_test.dart` (593 lines)
Tests for `AppLocalizer` singleton:
- Initialization methods (init, initWithFallback, forceInit)
- Translation resolution with `translateSafely`
- Fallback handling mechanisms
- State management (isInitialized)
- Integration with LocalesFallbackMapper
- Edge cases with special characters and unicode
- Real-world scenarios

#### `core_of_module/localization_wrapper_test.dart` (377 lines)
Tests for `LocalizationWrapper` static utility:
- Supported locales configuration
- Localization path constant
- Fallback locale setup
- EasyLocalization widget configuration
- Integration with MaterialApp
- Locale validation

### Widget Tests

#### `module_widgets/language_toggle_button/language_option_test.dart` (603 lines)
Tests for `LanguageOption` enum:
- All enum values (en, uk, pl)
- Locale properties and metadata
- `toMenuItem` method behavior
- Current language detection
- Menu item styling (enabled/disabled states)
- Layout and visual indicators
- Edge cases

#### `module_widgets/language_toggle_button/toggle_button_test.dart` (425 lines)
Tests for `LanguageToggleButton` widget:
- Widget rendering and structure
- PopupMenuButton configuration
- Menu opening/closing behavior
- Current language detection
- Language selection handling
- Integration with EasyLocalization context
- Accessibility features

#### `module_widgets/text_widget_test.dart` (696 lines)
Tests for `TextWidget`:
- Construction with all parameters
- All TextType variants (displayLarge, headlineMedium, bodySmall, etc.)
- Localization resolution integration
- Custom styling overrides (color, font, alignment)
- Overflow and maxLines handling
- Multi-line text support
- Edge cases with unicode, special characters
- Integration scenarios

### Utility Tests

#### `utils/localization_logger_test.dart` (504 lines)
Tests for `LocalizationLogger` utility:
- `missingKey` logging
- `fallbackUsed` logging
- debugPrint integration
- Log format consistency
- Edge cases with special characters and unicode
- Multiple call scenarios

#### `utils/string_x_test.dart` (485 lines)
Tests for `TranslateNullableKey` extension:
- `translateOrNull` getter behavior
- Null safety handling
- Integration with AppLocalizer
- Type safety verification
- Collection operations (map, where)
- Real-world validation scenarios

#### `utils/text_from_string_x_test.dart` (681 lines)
Tests for `GetTextWidget` extension:
- `from` method with all parameters
- TextWidget creation
- All TextType variants
- Parameter passing and defaults
- Fluent API usage
- Integration with TextWidget
- Collection operations

### Fallback System Tests

#### `without_localization_case/fallback_keys_test.dart` (553 lines)
Tests for `LocalesFallbackMapper` and `FallbackKeysForErrors`:
- `resolveFallback` method
- All mapped failure keys
- FallbackKeysForErrors constants
- Unknown key handling
- Case sensitivity
- Integration between mapper and constants

## Total Coverage

- **Total Lines**: 4,917
- **Test Files**: 9
- **Test Groups**: 150+
- **Individual Tests**: 500+

## Test Standards

All tests follow VGV best practices:

### Structure
- Clear test organization with `group` blocks
- Descriptive test names in active voice
- Arrange-Act-Assert pattern
- Comprehensive coverage documentation at file level

### Coverage Areas
- **Happy path**: Normal operation scenarios
- **Edge cases**: Empty strings, unicode, special characters, very long inputs
- **Null safety**: Proper handling of nullable types
- **Error scenarios**: Invalid inputs, missing keys
- **Integration**: Component interaction testing
- **Real-world scenarios**: Practical usage examples
- **Type safety**: Compile-time and runtime type checking
- **Immutability**: State consistency verification
- **Collections**: List, Set, Map operations
- **Const semantics**: Compile-time constant verification

### Testing Patterns
- Use of `setUp` for test initialization
- Proper cleanup with `debugPrintOverride = null`
- Widget testing with `MaterialApp` wrapper
- Mock resolvers for AppLocalizer
- Comprehensive assertion messages

## Running Tests

To run all localization tests:

```bash
# Run all localization module tests
flutter test test/src/base_modules/localization/

# Run specific test file
flutter test test/src/base_modules/localization/core_of_module/init_localization_test.dart

# Run with coverage
flutter test --coverage test/src/base_modules/localization/
```

## Coverage Goals

Each test file aims for:
- ✅ 100% line coverage
- ✅ 100% branch coverage
- ✅ Edge case coverage
- ✅ Integration testing
- ✅ Real-world scenario validation

## Test Maintenance

When modifying the localization module:
1. Update corresponding test files
2. Add tests for new functionality
3. Ensure all tests pass
4. Maintain 100% coverage
5. Follow VGV naming conventions
6. Document new test scenarios
