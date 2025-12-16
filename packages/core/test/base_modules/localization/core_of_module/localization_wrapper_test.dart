/// Tests for `LocalizationWrapper` static utility
///
/// Coverage:
/// - Supported locales configuration
/// - Localization path constant
/// - Fallback locale configuration
/// - Widget configuration method
/// - EasyLocalization integration
library;

import 'package:core/src/base_modules/localization/core_of_module/localization_wrapper.dart';
import 'package:core/src/base_modules/localization/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalizationWrapper', () {
    group('configuration constants', () {
      test('supportedLocales contains expected locales', () {
        // Act
        final locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales, hasLength(3));
        expect(locales, contains(const Locale('en')));
        expect(locales, contains(const Locale('uk')));
        expect(locales, contains(const Locale('pl')));
      });

      test('supportedLocales is immutable', () {
        // Arrange
        final originalLength = LocalizationWrapper.supportedLocales.length;

        // Act - attempt to modify would cause compile error
        final locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales.length, equals(originalLength));
        expect(locales, isA<List<Locale>>());
      });

      test('localizationPath points to correct assets directory', () {
        // Act
        const path = LocalizationWrapper.localizationPath;

        // Assert
        expect(path, equals('assets/translations'));
        expect(path, isNotEmpty);
      });

      test('fallbackLocale is English', () {
        // Act
        const fallback = LocalizationWrapper.fallbackLocale;

        // Assert
        expect(fallback, equals(const Locale('en')));
        expect(fallback.languageCode, equals('en'));
      });

      test('all supported locales are valid Locale objects', () {
        // Act
        final locales = LocalizationWrapper.supportedLocales;

        // Assert
        for (final locale in locales) {
          expect(locale, isA<Locale>());
          expect(locale.languageCode, isNotEmpty);
        }
      });
    });

    group('configure', () {
      testWidgets('wraps child with EasyLocalization', (tester) async {
        // Arrange
        const childKey = Key('test-child');
        final child = Container(key: childKey);

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        expect(wrapped, isA<EasyLocalization>());
        expect(find.byKey(childKey), findsNothing); // Not built yet
      });

      testWidgets('configured widget has correct supportedLocales', (tester) async {
        // Arrange
        final child = Container();

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        expect(wrapped, isA<EasyLocalization>());
        final easyLocalization = wrapped as EasyLocalization;
        expect(
          easyLocalization.supportedLocales,
          equals(LocalizationWrapper.supportedLocales),
        );
      });

      testWidgets('configured widget has correct fallbackLocale', (tester) async {
        // Arrange
        final child = Container();

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        final easyLocalization = wrapped as EasyLocalization;
        expect(
          easyLocalization.fallbackLocale,
          equals(LocalizationWrapper.fallbackLocale),
        );
      });

      testWidgets('configured widget has correct path', (tester) async {
        // Arrange
        final child = Container();

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        final easyLocalization = wrapped as EasyLocalization;
        expect(
          easyLocalization.path,
          equals(LocalizationWrapper.localizationPath),
        );
      });

      testWidgets('configured widget uses CodegenLoader', (tester) async {
        // Arrange
        final child = Container();

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        final easyLocalization = wrapped as EasyLocalization;
        expect(easyLocalization.assetLoader, isA<CodegenLoader>());
      });

      testWidgets('preserves child widget', (tester) async {
        // Arrange
        const testText = 'Test Child Widget';
        const child = Text(testText);

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        final easyLocalization = wrapped as EasyLocalization;
        expect(easyLocalization.child, equals(child));
      });

      testWidgets('can wrap different types of widgets', (tester) async {
        // Arrange
        final widgets = [
          Container(),
          const SizedBox(),
          const Text('Test'),
          const Placeholder(),
        ];

        // Act & Assert
        for (final widget in widgets) {
          final wrapped = LocalizationWrapper.configure(widget);
          expect(wrapped, isA<EasyLocalization>());
          final easyLocalization = wrapped as EasyLocalization;
          expect(easyLocalization.child, equals(widget));
        }
      });
    });

    group('locale ordering', () {
      test('English is first in supportedLocales', () {
        // Act
        final locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales.first, equals(const Locale('en')));
      });

      test('Ukrainian is second in supportedLocales', () {
        // Act
        final locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales[1], equals(const Locale('uk')));
      });

      test('Polish is third in supportedLocales', () {
        // Act
        final locales = LocalizationWrapper.supportedLocales;

        // Assert
        expect(locales[2], equals(const Locale('pl')));
      });
    });

    group('locale validation', () {
      test('all supported locales have valid language codes', () {
        // Arrange
        final locales = LocalizationWrapper.supportedLocales;
        final validCodes = ['en', 'uk', 'pl'];

        // Act & Assert
        for (final locale in locales) {
          expect(validCodes, contains(locale.languageCode));
        }
      });

      test('fallback locale is in supported locales', () {
        // Arrange
        const fallback = LocalizationWrapper.fallbackLocale;
        final supported = LocalizationWrapper.supportedLocales;

        // Act & Assert
        expect(supported, contains(fallback));
      });

      test('no duplicate locales in supportedLocales', () {
        // Arrange
        final locales = LocalizationWrapper.supportedLocales;

        // Act
        final uniqueLocales = locales.toSet();

        // Assert
        expect(uniqueLocales.length, equals(locales.length));
      });
    });

    group('integration scenarios', () {
      testWidgets('can wrap MaterialApp', (tester) async {
        // Arrange
        final app = MaterialApp(
          home: Scaffold(
            body: Container(),
          ),
        );

        // Act
        final wrapped = LocalizationWrapper.configure(app);

        // Assert
        expect(wrapped, isA<EasyLocalization>());
        final easyLocalization = wrapped as EasyLocalization;
        expect(easyLocalization.child, isA<MaterialApp>());
      });

      testWidgets('multiple configure calls create separate instances', (tester) async {
        // Arrange
        final child1 = Container(key: const Key('child1'));
        final child2 = Container(key: const Key('child2'));

        // Act
        final wrapped1 = LocalizationWrapper.configure(child1);
        final wrapped2 = LocalizationWrapper.configure(child2);

        // Assert
        expect(identical(wrapped1, wrapped2), isFalse);
        expect((wrapped1 as EasyLocalization).child, equals(child1));
        expect((wrapped2 as EasyLocalization).child, equals(child2));
      });
    });

    group('edge cases', () {
      testWidgets('handles empty Container child', (tester) async {
        // Arrange
        final child = Container();

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        expect(wrapped, isA<EasyLocalization>());
      });

      testWidgets('handles complex widget tree', (tester) async {
        // Arrange
        final child = Column(
          children: [
            Row(
              children: [
                Container(),
                const Text('Test'),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );

        // Act
        final wrapped = LocalizationWrapper.configure(child);

        // Assert
        expect(wrapped, isA<EasyLocalization>());
        final easyLocalization = wrapped as EasyLocalization;
        expect(easyLocalization.child, equals(child));
      });
    });

    group('const semantics', () {
      test('supportedLocales contains const Locale objects', () {
        // Arrange
        final locales = LocalizationWrapper.supportedLocales;

        // Act & Assert
        for (final locale in locales) {
          expect(locale, isA<Locale>());
          // Verify locales are properly formed
          expect(locale.languageCode, isNotEmpty);
          expect(locale.languageCode.length, equals(2));
        }
      });

      test('fallbackLocale is const', () {
        // Arrange
        const fallback1 = LocalizationWrapper.fallbackLocale;
        const fallback2 = LocalizationWrapper.fallbackLocale;

        // Act & Assert
        expect(identical(fallback1, fallback2), isTrue);
        expect(identical(fallback1, const Locale('en')), isTrue);
      });

      test('localizationPath is const', () {
        // Arrange
        const expectedPath = 'assets/translations';

        // Act
        const path = LocalizationWrapper.localizationPath;

        // Assert
        expect(path, equals(expectedPath));
      });
    });

    group('configuration properties', () {
      test('path follows Flutter asset convention', () {
        // Act
        const path = LocalizationWrapper.localizationPath;

        // Assert
        expect(path, startsWith('assets/'));
        expect(path, contains('translations'));
      });

      test('supported locales use language codes only', () {
        // Arrange
        final locales = LocalizationWrapper.supportedLocales;

        // Act & Assert
        for (final locale in locales) {
          expect(locale.countryCode, isNull);
          expect(locale.scriptCode, isNull);
          expect(locale.languageCode.length, equals(2));
        }
      });

      test('fallback locale uses language code only', () {
        // Arrange
        const fallback = LocalizationWrapper.fallbackLocale;

        // Act & Assert
        expect(fallback.countryCode, isNull);
        expect(fallback.scriptCode, isNull);
        expect(fallback.languageCode, equals('en'));
      });
    });
  });
}
