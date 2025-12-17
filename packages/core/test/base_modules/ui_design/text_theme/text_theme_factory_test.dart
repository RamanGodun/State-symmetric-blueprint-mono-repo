import 'package:core/src/base_modules/ui_design/text_theme/text_theme_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFontFamily', () {
    group('enum values', () {
      test('has two font families', () {
        // Assert
        expect(AppFontFamily.values.length, equals(2));
      });

      test('contains inter font', () {
        // Assert
        expect(AppFontFamily.values, contains(AppFontFamily.inter));
      });

      test('contains montserrat font', () {
        // Assert
        expect(AppFontFamily.values, contains(AppFontFamily.montserrat));
      });

      test('fonts are in correct order', () {
        // Assert
        expect(AppFontFamily.values[0], equals(AppFontFamily.inter));
        expect(AppFontFamily.values[1], equals(AppFontFamily.montserrat));
      });
    });

    group('value property', () {
      test('Inter has correct value', () {
        // Assert
        expect(AppFontFamily.inter.value, equals('Inter'));
      });

      test('Montserrat has correct value', () {
        // Assert
        expect(AppFontFamily.montserrat.value, equals('Montserrat'));
      });

      test('all fonts have non-empty values', () {
        // Assert
        for (final font in AppFontFamily.values) {
          expect(font.value, isNotEmpty);
        }
      });

      test('all font values are capitalized', () {
        // Assert
        for (final font in AppFontFamily.values) {
          expect(
            font.value[0],
            equals(font.value[0].toUpperCase()),
            reason: '${font.value} is not capitalized',
          );
        }
      });
    });

    group('enum usage', () {
      test('can be used in switch statements', () {
        // Arrange
        const font = AppFontFamily.inter;

        // Act
        final result = switch (font) {
          AppFontFamily.inter => 'Inter font',
          AppFontFamily.montserrat => 'Montserrat font',
        };

        // Assert
        expect(result, equals('Inter font'));
      });

      test('can be compared for equality', () {
        // Assert
        expect(AppFontFamily.inter, equals(AppFontFamily.inter));
        expect(
          AppFontFamily.inter,
          isNot(equals(AppFontFamily.montserrat)),
        );
      });

      test('can be used as map keys', () {
        // Arrange
        final fontMap = {
          AppFontFamily.inter: 'Primary font',
          AppFontFamily.montserrat: 'Accent font',
        };

        // Assert
        expect(fontMap[AppFontFamily.inter], equals('Primary font'));
        expect(fontMap[AppFontFamily.montserrat], equals('Accent font'));
      });
    });
  });

  group('TextThemeFactory', () {
    late ColorScheme lightColorScheme;
    late ColorScheme darkColorScheme;

    setUp(() {
      lightColorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
      );
      darkColorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      );
    });

    group('from method - basic functionality', () {
      test('returns TextTheme', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme, isA<TextTheme>());
      });

      test('creates text theme with all styles defined', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert - Display styles
        expect(textTheme.displayLarge, isNotNull);
        expect(textTheme.displayMedium, isNotNull);
        expect(textTheme.displaySmall, isNotNull);

        // Headline styles
        expect(textTheme.headlineLarge, isNotNull);
        expect(textTheme.headlineMedium, isNotNull);
        expect(textTheme.headlineSmall, isNotNull);

        // Title styles
        expect(textTheme.titleLarge, isNotNull);
        expect(textTheme.titleMedium, isNotNull);
        expect(textTheme.titleSmall, isNotNull);

        // Body styles
        expect(textTheme.bodyLarge, isNotNull);
        expect(textTheme.bodyMedium, isNotNull);
        expect(textTheme.bodySmall, isNotNull);

        // Label styles
        expect(textTheme.labelLarge, isNotNull);
        expect(textTheme.labelMedium, isNotNull);
        expect(textTheme.labelSmall, isNotNull);
      });

      test('uses Inter as default primary font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert - Body text uses Inter
        expect(textTheme.bodyLarge!.fontFamily, equals('Inter'));
        expect(textTheme.bodyMedium!.fontFamily, equals('Inter'));
        expect(textTheme.bodySmall!.fontFamily, equals('Inter'));
      });

      test('uses Montserrat as default accent font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert - Display text uses Montserrat
        expect(textTheme.displayLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.displayMedium!.fontFamily, equals('Montserrat'));
        expect(textTheme.displaySmall!.fontFamily, equals('Montserrat'));
      });

      test('uses colorScheme onSurface color', () {
        // Arrange
        final colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.red,
        );

        // Act
        final textTheme = TextThemeFactory.from(colorScheme);

        // Assert - All text should use onSurface color
        expect(textTheme.bodyLarge!.color, equals(colorScheme.onSurface));
        expect(textTheme.displayLarge!.color, equals(colorScheme.onSurface));
        expect(textTheme.titleLarge!.color, equals(colorScheme.onSurface));
      });
    });

    group('from method - custom fonts', () {
      test('uses custom primary font when provided', () {
        // Act
        final textTheme = TextThemeFactory.from(
          lightColorScheme,
          font: AppFontFamily.montserrat,
        );

        // Assert - Body text uses Montserrat
        expect(textTheme.bodyLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.bodyMedium!.fontFamily, equals('Montserrat'));
        expect(textTheme.bodySmall!.fontFamily, equals('Montserrat'));
      });

      test('uses custom accent font when provided', () {
        // Act
        final textTheme = TextThemeFactory.from(
          lightColorScheme,
          accentFont: AppFontFamily.inter,
        );

        // Assert - Display text uses Inter
        expect(textTheme.displayLarge!.fontFamily, equals('Inter'));
        expect(textTheme.displayMedium!.fontFamily, equals('Inter'));
        expect(textTheme.displaySmall!.fontFamily, equals('Inter'));
      });

      test('uses both custom fonts when provided', () {
        // Act
        final textTheme = TextThemeFactory.from(
          lightColorScheme,
          font: AppFontFamily.montserrat,
          accentFont: AppFontFamily.inter,
        );

        // Assert
        expect(textTheme.bodyLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.displayLarge!.fontFamily, equals('Inter'));
      });
    });

    group('font sizes', () {
      test('display styles have correct sizes', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.displayLarge!.fontSize, equals(57));
        expect(textTheme.displayMedium!.fontSize, equals(45));
        expect(textTheme.displaySmall!.fontSize, equals(35));
      });

      test('headline styles have correct sizes', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.headlineLarge!.fontSize, equals(31));
        expect(textTheme.headlineMedium!.fontSize, equals(27));
        expect(textTheme.headlineSmall!.fontSize, equals(24));
      });

      test('title styles have correct sizes', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.titleLarge!.fontSize, equals(22));
        expect(textTheme.titleMedium!.fontSize, equals(18));
        expect(textTheme.titleSmall!.fontSize, equals(16));
      });

      test('body styles have correct sizes', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.bodyLarge!.fontSize, equals(17));
        expect(textTheme.bodyMedium!.fontSize, equals(15));
        expect(textTheme.bodySmall!.fontSize, equals(13));
      });

      test('label styles have correct sizes', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.labelLarge!.fontSize, equals(14));
        expect(textTheme.labelMedium!.fontSize, equals(12));
        expect(textTheme.labelSmall!.fontSize, equals(11));
      });

      test('sizes decrease from large to small in each category', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert - Display
        expect(
          textTheme.displayLarge!.fontSize! >
              textTheme.displayMedium!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.displayMedium!.fontSize! >
              textTheme.displaySmall!.fontSize!,
          isTrue,
        );

        // Headline
        expect(
          textTheme.headlineLarge!.fontSize! >
              textTheme.headlineMedium!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.headlineMedium!.fontSize! >
              textTheme.headlineSmall!.fontSize!,
          isTrue,
        );

        // Title
        expect(
          textTheme.titleLarge!.fontSize! > textTheme.titleMedium!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.titleMedium!.fontSize! > textTheme.titleSmall!.fontSize!,
          isTrue,
        );

        // Body
        expect(
          textTheme.bodyLarge!.fontSize! > textTheme.bodyMedium!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.bodyMedium!.fontSize! > textTheme.bodySmall!.fontSize!,
          isTrue,
        );

        // Label
        expect(
          textTheme.labelLarge!.fontSize! > textTheme.labelMedium!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.labelMedium!.fontSize! > textTheme.labelSmall!.fontSize!,
          isTrue,
        );
      });
    });

    group('font weights', () {
      test('display styles have w500 weight', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.displayLarge!.fontWeight, equals(FontWeight.w500));
        expect(textTheme.displayMedium!.fontWeight, equals(FontWeight.w500));
        expect(textTheme.displaySmall!.fontWeight, equals(FontWeight.w500));
      });

      test('headline styles have w500 weight', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.headlineLarge!.fontWeight, equals(FontWeight.w500));
        expect(textTheme.headlineMedium!.fontWeight, equals(FontWeight.w500));
        expect(textTheme.headlineSmall!.fontWeight, equals(FontWeight.w500));
      });

      test('title styles have w500 weight', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.titleLarge!.fontWeight, equals(FontWeight.w500));
        expect(textTheme.titleMedium!.fontWeight, equals(FontWeight.w500));
        expect(textTheme.titleSmall!.fontWeight, equals(FontWeight.w500));
      });

      test('body styles have w300 weight', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.bodyLarge!.fontWeight, equals(FontWeight.w300));
        expect(textTheme.bodyMedium!.fontWeight, equals(FontWeight.w300));
        expect(textTheme.bodySmall!.fontWeight, equals(FontWeight.w300));
      });

      test('label styles have w400 weight', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.labelLarge!.fontWeight, equals(FontWeight.w400));
        expect(textTheme.labelMedium!.fontWeight, equals(FontWeight.w400));
        expect(textTheme.labelSmall!.fontWeight, equals(FontWeight.w400));
      });
    });

    group('font family distribution', () {
      test('display styles use accent font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert - Default accent is Montserrat
        expect(textTheme.displayLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.displayMedium!.fontFamily, equals('Montserrat'));
        expect(textTheme.displaySmall!.fontFamily, equals('Montserrat'));
      });

      test('headline styles use accent font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.headlineLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.headlineMedium!.fontFamily, equals('Montserrat'));
        expect(textTheme.headlineSmall!.fontFamily, equals('Montserrat'));
      });

      test('titleLarge uses accent font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.titleLarge!.fontFamily, equals('Montserrat'));
      });

      test('titleMedium and titleSmall use primary font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.titleMedium!.fontFamily, equals('Inter'));
        expect(textTheme.titleSmall!.fontFamily, equals('Inter'));
      });

      test('body styles use primary font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.bodyLarge!.fontFamily, equals('Inter'));
        expect(textTheme.bodyMedium!.fontFamily, equals('Inter'));
        expect(textTheme.bodySmall!.fontFamily, equals('Inter'));
      });

      test('label styles use primary font', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.labelLarge!.fontFamily, equals('Inter'));
        expect(textTheme.labelMedium!.fontFamily, equals('Inter'));
        expect(textTheme.labelSmall!.fontFamily, equals('Inter'));
      });
    });

    group('color scheme integration', () {
      test('works with light color scheme', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(textTheme.bodyLarge!.color, isNotNull);
        expect(textTheme.bodyLarge!.color, equals(lightColorScheme.onSurface));
      });

      test('works with dark color scheme', () {
        // Act
        final textTheme = TextThemeFactory.from(darkColorScheme);

        // Assert
        expect(textTheme.bodyLarge!.color, isNotNull);
        expect(textTheme.bodyLarge!.color, equals(darkColorScheme.onSurface));
      });

      test('all text styles use same color from scheme', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);
        final expectedColor = lightColorScheme.onSurface;

        // Assert
        expect(textTheme.displayLarge!.color, equals(expectedColor));
        expect(textTheme.headlineLarge!.color, equals(expectedColor));
        expect(textTheme.titleLarge!.color, equals(expectedColor));
        expect(textTheme.bodyLarge!.color, equals(expectedColor));
        expect(textTheme.labelLarge!.color, equals(expectedColor));
      });

      test('respects different color schemes', () {
        // Arrange
        final redScheme = ColorScheme.fromSeed(
          seedColor: Colors.red,
        );
        final blueScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
        );

        // Act
        final redTextTheme = TextThemeFactory.from(redScheme);
        final blueTextTheme = TextThemeFactory.from(blueScheme);

        // Assert
        expect(
          redTextTheme.bodyLarge!.color,
          equals(redScheme.onSurface),
        );
        expect(
          blueTextTheme.bodyLarge!.color,
          equals(blueScheme.onSurface),
        );
      });
    });

    group('real-world scenarios', () {
      test('creating theme for light mode app', () {
        // Arrange
        final lightScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
        );

        // Act
        final textTheme = TextThemeFactory.from(lightScheme);

        // Assert
        expect(textTheme.bodyLarge!.fontFamily, equals('Inter'));
        expect(textTheme.displayLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.bodyLarge!.color, equals(lightScheme.onSurface));
      });

      test('creating theme for dark mode app', () {
        // Arrange
        final darkScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

        // Act
        final textTheme = TextThemeFactory.from(darkScheme);

        // Assert
        expect(textTheme.bodyLarge!.fontFamily, equals('Inter'));
        expect(textTheme.displayLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.bodyLarge!.color, equals(darkScheme.onSurface));
      });

      test('user selects Montserrat as primary font', () {
        // Arrange - User preference: Montserrat for everything
        final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);

        // Act
        final textTheme = TextThemeFactory.from(
          scheme,
          font: AppFontFamily.montserrat,
          accentFont: AppFontFamily.montserrat,
        );

        // Assert
        expect(textTheme.bodyLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.displayLarge!.fontFamily, equals('Montserrat'));
        expect(textTheme.titleMedium!.fontFamily, equals('Montserrat'));
      });

      test('creating theme with Inter for all text', () {
        // Arrange - Monospace-like feel with Inter everywhere
        final scheme = ColorScheme.fromSeed(seedColor: Colors.green);

        // Act
        final textTheme = TextThemeFactory.from(
          scheme,
          font: AppFontFamily.inter,
          accentFont: AppFontFamily.inter,
        );

        // Assert
        expect(textTheme.bodyLarge!.fontFamily, equals('Inter'));
        expect(textTheme.displayLarge!.fontFamily, equals('Inter'));
        expect(textTheme.headlineLarge!.fontFamily, equals('Inter'));
      });

      test('building Material app theme', () {
        // Arrange
        final colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.purple,
        );

        // Act
        final textTheme = TextThemeFactory.from(colorScheme);
        final themeData = ThemeData(
          colorScheme: colorScheme,
          textTheme: textTheme,
        );

        // Assert
        expect(themeData.textTheme, equals(textTheme));
        expect(themeData.colorScheme, equals(colorScheme));
      });
    });

    group('edge cases', () {
      test('works with all AppFontFamily combinations', () {
        // Arrange
        const fonts = AppFontFamily.values;

        // Act & Assert
        for (final primaryFont in fonts) {
          for (final accentFont in fonts) {
            expect(
              () => TextThemeFactory.from(
                lightColorScheme,
                font: primaryFont,
                accentFont: accentFont,
              ),
              returnsNormally,
            );
          }
        }
      });

      test('creates consistent theme with same inputs', () {
        // Act
        final theme1 = TextThemeFactory.from(
          lightColorScheme,
          font: AppFontFamily.inter,
          accentFont: AppFontFamily.montserrat,
        );
        final theme2 = TextThemeFactory.from(
          lightColorScheme,
          font: AppFontFamily.inter,
          accentFont: AppFontFamily.montserrat,
        );

        // Assert
        expect(theme1.bodyLarge!.fontSize, equals(theme2.bodyLarge!.fontSize));
        expect(
          theme1.bodyLarge!.fontFamily,
          equals(theme2.bodyLarge!.fontFamily),
        );
        expect(
          theme1.displayLarge!.fontSize,
          equals(theme2.displayLarge!.fontSize),
        );
      });

      test('all text styles have proper properties', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert - Check all 15 text styles
        final allStyles = [
          textTheme.displayLarge,
          textTheme.displayMedium,
          textTheme.displaySmall,
          textTheme.headlineLarge,
          textTheme.headlineMedium,
          textTheme.headlineSmall,
          textTheme.titleLarge,
          textTheme.titleMedium,
          textTheme.titleSmall,
          textTheme.bodyLarge,
          textTheme.bodyMedium,
          textTheme.bodySmall,
          textTheme.labelLarge,
          textTheme.labelMedium,
          textTheme.labelSmall,
        ];

        for (final style in allStyles) {
          expect(style, isNotNull);
          expect(style!.fontFamily, isNotNull);
          expect(style.fontSize, isNotNull);
          expect(style.fontWeight, isNotNull);
          expect(style.color, isNotNull);
        }
      });

      test('different color schemes produce different text themes', () {
        // Arrange
        final scheme1 = ColorScheme.fromSeed(
          seedColor: Colors.red,
        );
        final scheme2 = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

        // Act
        final theme1 = TextThemeFactory.from(scheme1);
        final theme2 = TextThemeFactory.from(scheme2);

        // Assert
        expect(
          theme1.bodyLarge!.color,
          isNot(equals(theme2.bodyLarge!.color)),
        );
      });
    });

    group('type hierarchy', () {
      test('display is largest, label is smallest', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert
        expect(
          textTheme.displayLarge!.fontSize! > textTheme.labelSmall!.fontSize!,
          isTrue,
        );
      });

      test('maintains Material Design 3 type scale', () {
        // Act
        final textTheme = TextThemeFactory.from(lightColorScheme);

        // Assert - Verify type scale hierarchy
        expect(
          textTheme.displayLarge!.fontSize! >
              textTheme.headlineLarge!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.headlineLarge!.fontSize! > textTheme.titleLarge!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.titleLarge!.fontSize! > textTheme.bodyLarge!.fontSize!,
          isTrue,
        );
        expect(
          textTheme.bodyLarge!.fontSize! > textTheme.labelLarge!.fontSize!,
          isTrue,
        );
      });
    });

    group('immutability', () {
      test('factory method does not cache results', () {
        // Act
        final theme1 = TextThemeFactory.from(lightColorScheme);
        final theme2 = TextThemeFactory.from(lightColorScheme);

        // Assert - Should create new instances
        expect(identical(theme1, theme2), isFalse);
      });

      test('different font parameters create different themes', () {
        // Act
        final theme1 = TextThemeFactory.from(
          lightColorScheme,
          font: AppFontFamily.inter,
        );
        final theme2 = TextThemeFactory.from(
          lightColorScheme,
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(
          theme1.bodyLarge!.fontFamily,
          isNot(equals(theme2.bodyLarge!.fontFamily)),
        );
      });
    });
  });
}
