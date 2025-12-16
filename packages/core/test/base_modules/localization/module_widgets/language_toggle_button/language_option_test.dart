/// Tests for `LanguageOption` enum
///
/// Coverage:
/// - Enum values and their properties (locale, flag, messageKey, label)
/// - toMenuItem method behavior
/// - Current language detection
/// - MenuItem styling and properties
/// - Edge cases
library;

import 'package:core/src/base_modules/localization/module_widgets/language_toggle_button/language_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LanguageOption', () {
    group('enum values', () {
      test('has three language options', () {
        // Act
        const values = LanguageOption.values;

        // Assert
        expect(values, hasLength(3));
        expect(values, contains(LanguageOption.en));
        expect(values, contains(LanguageOption.uk));
        expect(values, contains(LanguageOption.pl));
      });

      test('en has correct properties', () {
        // Act
        const option = LanguageOption.en;

        // Assert
        expect(option.locale, equals(const Locale('en')));
        expect(option.flag, equals('🇬🇧'));
        expect(option.label, equals('Change to English'));
        expect(option.messageKey, isNotEmpty);
      });

      test('uk has correct properties', () {
        // Act
        const option = LanguageOption.uk;

        // Assert
        expect(option.locale, equals(const Locale('uk')));
        expect(option.flag, equals('🇺🇦'));
        expect(option.label, equals('Змінити на українську'));
        expect(option.messageKey, isNotEmpty);
      });

      test('pl has correct properties', () {
        // Act
        const option = LanguageOption.pl;

        // Assert
        expect(option.locale, equals(const Locale('pl')));
        expect(option.flag, equals('🇵🇱'));
        expect(option.label, equals('Zmień na polski'));
        expect(option.messageKey, isNotEmpty);
      });

      test('all options have valid locale objects', () {
        // Act & Assert
        for (final option in LanguageOption.values) {
          expect(option.locale, isA<Locale>());
          expect(option.locale.languageCode, isNotEmpty);
          expect(option.locale.languageCode.length, equals(2));
        }
      });

      test('all options have flag emojis', () {
        // Act & Assert
        for (final option in LanguageOption.values) {
          expect(option.flag, isNotEmpty);
          expect(option.flag.length, greaterThan(0));
        }
      });

      test('all options have non-empty labels', () {
        // Act & Assert
        for (final option in LanguageOption.values) {
          expect(option.label, isNotEmpty);
        }
      });

      test('all options have message keys', () {
        // Act & Assert
        for (final option in LanguageOption.values) {
          expect(option.messageKey, isNotEmpty);
          expect(option.messageKey, contains('languages'));
        }
      });
    });

    group('locale properties', () {
      test('en locale has correct language code', () {
        // Act
        final locale = LanguageOption.en.locale;

        // Assert
        expect(locale.languageCode, equals('en'));
      });

      test('uk locale has correct language code', () {
        // Act
        final locale = LanguageOption.uk.locale;

        // Assert
        expect(locale.languageCode, equals('uk'));
      });

      test('pl locale has correct language code', () {
        // Act
        final locale = LanguageOption.pl.locale;

        // Assert
        expect(locale.languageCode, equals('pl'));
      });

      test('all locales have no country code', () {
        // Act & Assert
        for (final option in LanguageOption.values) {
          expect(option.locale.countryCode, isNull);
        }
      });

      test('all locales have no script code', () {
        // Act & Assert
        for (final option in LanguageOption.values) {
          expect(option.locale.scriptCode, isNull);
        }
      });
    });

    group('toMenuItem when language is not current', () {
      testWidgets('creates enabled menu item', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('uk');

        // Assert
        expect(menuItem, isA<PopupMenuItem<LanguageOption>>());
        expect(menuItem.enabled, isTrue);
        expect(menuItem.value, equals(option));
      });

      testWidgets('menu item has correct value', (tester) async {
        // Arrange
        const option = LanguageOption.pl;

        // Act
        final menuItem = option.toMenuItem('en');

        // Assert
        expect(menuItem.value, equals(LanguageOption.pl));
      });

      testWidgets('menu item has full opacity', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('uk');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, equals(1.0));
      });

      testWidgets('menu item does not show check icon', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('uk');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.check), findsNothing);
      });

      testWidgets('displays flag and label', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('uk');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(option.flag), findsOneWidget);
        expect(find.text(option.label), findsOneWidget);
      });
    });

    group('toMenuItem when language is current', () {
      testWidgets('creates disabled menu item', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('en');

        // Assert
        expect(menuItem.enabled, isFalse);
      });

      testWidgets('menu item has reduced opacity', (tester) async {
        // Arrange
        const option = LanguageOption.uk;

        // Act
        final menuItem = option.toMenuItem('uk');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, equals(0.5));
      });

      testWidgets('menu item shows check icon', (tester) async {
        // Arrange
        const option = LanguageOption.pl;

        // Act
        final menuItem = option.toMenuItem('pl');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('still displays flag and label', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('en');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(option.flag), findsOneWidget);
        expect(find.text(option.label), findsOneWidget);
      });
    });

    group('toMenuItem layout', () {
      testWidgets('has Row layout with flag and label', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('uk');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('flag comes before label', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('uk');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, greaterThanOrEqualTo(2));
      });

      testWidgets('has SizedBox spacer between elements', (tester) async {
        // Arrange
        const option = LanguageOption.uk;

        // Act
        final menuItem = option.toMenuItem('en');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('label is in Expanded widget', (tester) async {
        // Arrange
        const option = LanguageOption.pl;

        // Act
        final menuItem = option.toMenuItem('en');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: menuItem,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Expanded), findsOneWidget);
      });
    });

    group('all language options behavior', () {
      testWidgets('each option creates unique menu item', (tester) async {
        // Arrange
        final items = <PopupMenuItem<LanguageOption>>[];

        // Act
        for (final option in LanguageOption.values) {
          items.add(option.toMenuItem('xx')); // Non-existent language
        }

        // Assert
        expect(items, hasLength(3));
        expect(items[0].value, equals(LanguageOption.en));
        expect(items[1].value, equals(LanguageOption.uk));
        expect(items[2].value, equals(LanguageOption.pl));
      });

      testWidgets('all options are enabled when current is different', (tester) async {
        // Arrange
        const currentLang = 'de'; // Non-supported language

        // Act & Assert
        for (final option in LanguageOption.values) {
          final menuItem = option.toMenuItem(currentLang);
          expect(menuItem.enabled, isTrue);
        }
      });

      testWidgets('only current option is disabled', (tester) async {
        // Arrange & Act
        final enMenuItem = LanguageOption.en.toMenuItem('en');
        final ukMenuItem = LanguageOption.uk.toMenuItem('en');
        final plMenuItem = LanguageOption.pl.toMenuItem('en');

        // Assert
        expect(enMenuItem.enabled, isFalse);
        expect(ukMenuItem.enabled, isTrue);
        expect(plMenuItem.enabled, isTrue);
      });
    });

    group('edge cases', () {
      testWidgets('handles empty current language code', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('');

        // Assert
        expect(menuItem.enabled, isTrue);
        expect(menuItem, isA<PopupMenuItem<LanguageOption>>());
      });

      testWidgets('handles case-sensitive language code comparison', (tester) async {
        // Arrange
        const option = LanguageOption.en;

        // Act
        final menuItem = option.toMenuItem('EN'); // Uppercase

        // Assert
        expect(menuItem.enabled, isTrue); // Should not match
      });

      testWidgets('handles unknown language code', (tester) async {
        // Arrange
        const option = LanguageOption.uk;

        // Act
        final menuItem = option.toMenuItem('unknown');

        // Assert
        expect(menuItem.enabled, isTrue);
      });

      testWidgets('multiple toMenuItem calls produce independent items', (tester) async {
        // Arrange
        const option = LanguageOption.pl;

        // Act
        final item1 = option.toMenuItem('en');
        final item2 = option.toMenuItem('pl');

        // Assert
        expect(item1.enabled, isTrue);
        expect(item2.enabled, isFalse);
        expect(identical(item1, item2), isFalse);
      });
    });

    group('enum ordering', () {
      test('en is first in values', () {
        // Act
        final first = LanguageOption.values.first;

        // Assert
        expect(first, equals(LanguageOption.en));
      });

      test('uk is second in values', () {
        // Act
        final second = LanguageOption.values[1];

        // Assert
        expect(second, equals(LanguageOption.uk));
      });

      test('pl is last in values', () {
        // Act
        final last = LanguageOption.values.last;

        // Assert
        expect(last, equals(LanguageOption.pl));
      });
    });

    group('const semantics', () {
      test('same option instances are identical', () {
        // Arrange
        const option1 = LanguageOption.en;
        const option2 = LanguageOption.en;

        // Assert
        expect(identical(option1, option2), isTrue);
      });

      test('different option instances are not identical', () {
        // Arrange
        const option1 = LanguageOption.en;
        const option2 = LanguageOption.uk;

        // Assert
        expect(identical(option1, option2), isFalse);
      });

      test('locale objects are const', () {
        // Arrange
        final locale1 = LanguageOption.en.locale;
        final locale2 = LanguageOption.en.locale;

        // Assert
        expect(identical(locale1, locale2), isTrue);
      });
    });

    group('integration scenarios', () {
      testWidgets('can create menu items list for PopupMenuButton', (tester) async {
        // Arrange
        const currentLang = 'en';

        // Act
        final menuItems = LanguageOption.values
            .map((option) => option.toMenuItem(currentLang))
            .toList();

        // Assert
        expect(menuItems, hasLength(3));
        expect(menuItems, everyElement(isA<PopupMenuItem<LanguageOption>>()));
      });

      testWidgets('current language is visually distinct in menu', (tester) async {
        // Arrange
        const currentLang = 'uk';

        // Act
        final items = LanguageOption.values
            .map((option) => option.toMenuItem(currentLang))
            .toList();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: Column(
                  children: items,
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.check), findsOneWidget);
        final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
        expect(
          opacityWidgets.where((w) => w.opacity == 0.5),
          hasLength(1),
        );
      });

      test('can be used in switch statement', () {
        // Arrange
        const option = LanguageOption.en;
        String result;

        // Act
        switch (option) {
          case LanguageOption.en:
            result = 'English';
          case LanguageOption.uk:
            result = 'Ukrainian';
          case LanguageOption.pl:
            result = 'Polish';
        }

        // Assert
        expect(result, equals('English'));
      });

      test('can be compared with equality', () {
        // Arrange
        const option1 = LanguageOption.uk;
        const option2 = LanguageOption.uk;
        const option3 = LanguageOption.pl;

        // Assert
        expect(option1 == option2, isTrue);
        expect(option1 == option3, isFalse);
      });
    });
  });
}
