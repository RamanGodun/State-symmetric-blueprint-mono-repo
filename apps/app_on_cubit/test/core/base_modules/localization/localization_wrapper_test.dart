/// Tests for LocalizationWrapper
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
///
/// Coverage:
/// - Supported locales configuration
/// - Translation paths configuration
/// - Fallback locale configuration
/// - Package name configuration
/// - Static constants validation
library;

import 'dart:ui' show Locale;

import 'package:app_on_cubit/core/base_modules/localization/localization_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalizationWrapper', () {
    group('supportedLocales', () {
      test('contains English locale', () {
        // Arrange & Act
        const locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales, contains(const Locale('en')));
      });

      test('contains Ukrainian locale', () {
        // Arrange & Act
        const locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales, contains(const Locale('uk')));
      });

      test('contains Polish locale', () {
        // Arrange & Act
        const locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales, contains(const Locale('pl')));
      });

      test('has exactly three supported locales', () {
        // Arrange & Act
        const locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales.length, equals(3));
      });

      test('all locales are valid Locale objects', () {
        // Arrange & Act
        const locales = LocalizationWrapper.supportedLocales;

        // Assert
        for (final locale in locales) {
          expect(locale, isA<Locale>());
          expect(locale.languageCode, isNotEmpty);
        }
      });
    });

    group('appTranslationsPath', () {
      test('has correct value', () {
        // Arrange & Act
        const path = LocalizationWrapper.appTranslationsPath;

        // Assert
        expect(path, equals('assets/translations'));
        expect(path, isA<String>());
        expect(path, isNotEmpty);
      });

      test('points to assets directory', () {
        // Arrange & Act
        const path = LocalizationWrapper.appTranslationsPath;

        // Assert
        expect(path, startsWith('assets'));
      });
    });

    group('corePackageName', () {
      test('has correct value', () {
        // Arrange & Act
        const packageName = LocalizationWrapper.corePackageName;

        // Assert
        expect(packageName, equals('shared_core_modules'));
        expect(packageName, isA<String>());
        expect(packageName, isNotEmpty);
      });
    });

    group('fallbackLocale', () {
      test('is English locale', () {
        // Arrange & Act
        const fallback = LocalizationWrapper.fallbackLocale;

        // Assert
        expect(fallback, equals(const Locale('en')));
        expect(fallback.languageCode, equals('en'));
      });

      test('is included in supported locales', () {
        // Arrange & Act
        const fallback = LocalizationWrapper.fallbackLocale;
        const supported = LocalizationWrapper.supportedLocales;

        // Assert
        expect(supported, contains(fallback));
      });

      test('is a valid Locale object', () {
        // Arrange & Act
        const fallback = LocalizationWrapper.fallbackLocale;

        // Assert
        expect(fallback, isA<Locale>());
        expect(fallback.languageCode, isNotEmpty);
      });
    });

    group('configuration consistency', () {
      test('fallback locale is in supported locales', () {
        // Arrange
        const fallback = LocalizationWrapper.fallbackLocale;
        const supported = LocalizationWrapper.supportedLocales;

        // Assert
        expect(
          supported.contains(fallback),
          isTrue,
          reason: 'Fallback locale should be in the list of supported locales',
        );
      });

      test('all supported locales are unique', () {
        // Arrange
        const locales = LocalizationWrapper.supportedLocales;

        // Act
        final uniqueLocales = locales.toSet();

        // Assert
        expect(
          uniqueLocales.length,
          equals(locales.length),
          reason: 'All supported locales should be unique',
        );
      });

      test('supported locales have valid language codes', () {
        // Arrange
        const locales = LocalizationWrapper.supportedLocales;
        const validCodes = ['en', 'uk', 'pl'];

        // Act & Assert
        for (final locale in locales) {
          expect(
            validCodes.contains(locale.languageCode),
            isTrue,
            reason:
                'Locale ${locale.languageCode} should be in valid codes list',
          );
        }
      });
    });
  });
}
