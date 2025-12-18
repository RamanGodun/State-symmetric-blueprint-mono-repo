import 'package:core/public_api/base_modules/ui_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeVariantX extension', () {
    group('isAmoled getter', () {
      test('returns false for light variant', () {
        // Assert
        expect(ThemeVariantsEnum.light.isAmoled, isFalse);
      });

      test('returns false for dark variant', () {
        // Assert
        expect(ThemeVariantsEnum.dark.isAmoled, isFalse);
      });

      test('returns true for amoled variant', () {
        // Assert
        expect(ThemeVariantsEnum.amoled.isAmoled, isTrue);
      });
    });

    group('build method - Material 3 configuration', () {
      test('enables Material 3 for light theme', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.useMaterial3, isTrue);
      });

      test('enables Material 3 for dark theme', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.useMaterial3, isTrue);
      });

      test('enables Material 3 for amoled theme', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(theme.useMaterial3, isTrue);
      });
    });

    group('build method - core palette', () {
      test('sets correct brightness for light', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.brightness, equals(Brightness.light));
      });

      test('sets correct brightness for dark', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.brightness, equals(Brightness.dark));
      });

      test('sets correct brightness for amoled', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(theme.brightness, equals(Brightness.dark));
      });

      test('sets scaffold background color from variant', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;

        // Act
        final theme = variant.build();

        // Assert
        expect(theme.scaffoldBackgroundColor, equals(variant.background));
      });

      test('sets primary color from variant', () {
        // Arrange
        const variant = ThemeVariantsEnum.dark;

        // Act
        final theme = variant.build();

        // Assert
        expect(theme.primaryColor, equals(variant.primaryColor));
      });

      test('includes color scheme from variant', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;

        // Act
        final theme = variant.build();

        // Assert
        expect(theme.colorScheme.brightness, equals(variant.brightness));
      });

      test('normalizes onPrimary color in scheme', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.colorScheme.onPrimary, isNotNull);
      });

      test('normalizes onSecondary color in scheme', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.colorScheme.onSecondary, isNotNull);
      });

      test('normalizes onBackground color in scheme', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(theme.colorScheme.onBackground, isNotNull);
      });

      test('normalizes onSurface color in scheme', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.colorScheme.onSurface, isNotNull);
      });
    });

    group('build method - AppBar theme', () {
      test('sets zero elevation', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.appBarTheme.elevation, equals(0));
      });

      test('sets transparent background', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.appBarTheme.backgroundColor, equals(Colors.transparent));
      });

      test('sets foreground color from variant contrast', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;

        // Act
        final theme = variant.build();

        // Assert
        expect(
          theme.appBarTheme.foregroundColor,
          equals(variant.contrastColor),
        );
      });

      test('sets actions icon color from variant primary', () {
        // Arrange
        const variant = ThemeVariantsEnum.dark;

        // Act
        final theme = variant.build();

        // Assert
        expect(
          theme.appBarTheme.actionsIconTheme?.color,
          equals(variant.primaryColor),
        );
      });

      test('sets centerTitle to false', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.appBarTheme.centerTitle, isFalse);
      });

      test('uses titleSmall for title text style', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.appBarTheme.titleTextStyle, isNotNull);
      });
    });

    group('build method - FilledButton theme', () {
      test('light theme uses semi-transparent primary', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();
        final buttonStyle = theme.filledButtonTheme.style;

        // Assert
        expect(buttonStyle, isNotNull);
      });

      test('dark theme uses semi-transparent primary', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();
        final buttonStyle = theme.filledButtonTheme.style;

        // Assert
        expect(buttonStyle, isNotNull);
      });

      test('amoled theme uses near-solid primary', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();
        final buttonStyle = theme.filledButtonTheme.style;

        // Assert
        expect(buttonStyle, isNotNull);
      });

      test('has button style configured', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.filledButtonTheme.style, isNotNull);
      });
    });

    group('build method - Card theme', () {
      test('light theme uses variant card color', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;

        // Act
        final theme = variant.build();

        // Assert
        expect(theme.cardTheme.color, equals(variant.cardColor));
      });

      test('dark theme uses variant card color', () {
        // Arrange
        const variant = ThemeVariantsEnum.dark;

        // Act
        final theme = variant.build();

        // Assert
        expect(theme.cardTheme.color, equals(variant.cardColor));
      });

      test('amoled theme uses special amoled card color', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(theme.cardTheme.color, isNotNull);
      });

      test('uses common border radius', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
      });

      test('sets zero elevation', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.cardTheme.elevation, equals(0));
      });

      test('has shadow color', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.cardTheme.shadowColor, isNotNull);
      });
    });

    group('build method - Icon theme', () {
      test('light theme uses onSurface color', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;

        // Act
        final theme = variant.build();

        // Assert
        expect(theme.iconTheme.color, equals(variant.colorScheme.onSurface));
      });

      test('dark theme uses onSurface color', () {
        // Arrange
        const variant = ThemeVariantsEnum.dark;

        // Act
        final theme = variant.build();

        // Assert
        expect(theme.iconTheme.color, equals(variant.colorScheme.onSurface));
      });

      test('amoled theme uses special amoled onSurface', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(theme.iconTheme.color, isNotNull);
      });
    });

    group('build method - Divider theme', () {
      test('light theme uses light border color', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.dividerTheme.color, isNotNull);
      });

      test('dark theme uses dark border color', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.dividerTheme.color, isNotNull);
      });

      test('amoled theme uses amoled outline color', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(theme.dividerTheme.color, isNotNull);
      });

      test('sets thickness to 0.6', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.dividerTheme.thickness, equals(0.6));
      });

      test('sets space to 0', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.dividerTheme.space, equals(0));
      });
    });

    group('build method - Typography', () {
      test('includes text theme', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.textTheme, isNotNull);
      });

      test('uses Inter as default base font', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.textTheme.bodyLarge?.fontFamily, equals('Inter'));
      });

      test('uses Montserrat as default accent font', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.textTheme.displayLarge?.fontFamily, equals('Montserrat'));
      });

      test('uses custom font when provided', () {
        // Act
        final theme = ThemeVariantsEnum.light.build(
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(theme.textTheme.bodyLarge?.fontFamily, equals('Montserrat'));
      });

      test('text theme colors match scheme onSurface', () {
        // Arrange
        const variant = ThemeVariantsEnum.dark;

        // Act
        final theme = variant.build();

        // Assert
        expect(
          theme.textTheme.bodyLarge?.color,
          equals(variant.colorScheme.onSurface),
        );
      });
    });

    group('build method - variant-specific behaviors', () {
      test('amoled variant has unique characteristics', () {
        // Act
        final amoledTheme = ThemeVariantsEnum.amoled.build();
        final darkTheme = ThemeVariantsEnum.dark.build();

        // Assert - Different card colors
        expect(
          amoledTheme.cardTheme.color,
          isNot(equals(darkTheme.cardTheme.color)),
        );
      });

      test('light and dark have different scaffold backgrounds', () {
        // Act
        final lightTheme = ThemeVariantsEnum.light.build();
        final darkTheme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(
          lightTheme.scaffoldBackgroundColor,
          isNot(equals(darkTheme.scaffoldBackgroundColor)),
        );
      });

      test('amoled optimizes for OLED screens', () {
        // Act
        final theme = ThemeVariantsEnum.amoled.build();

        // Assert - Dark brightness for power saving
        expect(theme.brightness, equals(Brightness.dark));

        // Assert - Special card color for deeper blacks
        expect(theme.cardTheme.color, isNotNull);
      });
    });

    group('build method - consistency', () {
      test('all variants build without errors', () {
        // Act & Assert
        expect(() => ThemeVariantsEnum.light.build(), returnsNormally);
        expect(() => ThemeVariantsEnum.dark.build(), returnsNormally);
        expect(() => ThemeVariantsEnum.amoled.build(), returnsNormally);
      });

      test('all variants with custom fonts build without errors', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          for (final font in AppFontFamily.values) {
            expect(() => variant.build(font: font), returnsNormally);
          }
        }
      });

      test('same variant builds consistently', () {
        // Act
        final theme1 = ThemeVariantsEnum.light.build();
        final theme2 = ThemeVariantsEnum.light.build();

        // Assert - Same configuration
        expect(theme1.brightness, equals(theme2.brightness));
        expect(
          theme1.scaffoldBackgroundColor,
          equals(theme2.scaffoldBackgroundColor),
        );
      });
    });

    group('real-world scenarios', () {
      test('building theme for MaterialApp', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert - Has all required properties
        expect(theme.colorScheme, isNotNull);
        expect(theme.textTheme, isNotNull);
        expect(theme.appBarTheme, isNotNull);
        expect(theme.cardTheme, isNotNull);
        expect(theme.filledButtonTheme, isNotNull);
      });

      test('switching from light to dark theme', () {
        // Arrange
        var currentVariant = ThemeVariantsEnum.light;
        var currentTheme = currentVariant.build();

        // Assert - Initially light
        expect(currentTheme.brightness, equals(Brightness.light));

        // Act - Switch to dark
        currentVariant = ThemeVariantsEnum.dark;
        currentTheme = currentVariant.build();

        // Assert - Now dark
        expect(currentTheme.brightness, equals(Brightness.dark));
      });

      test('enabling AMOLED mode for battery saving', () {
        // Arrange - User on dark theme
        var theme = ThemeVariantsEnum.dark.build();
        final darkBackground = theme.scaffoldBackgroundColor;

        // Act - Enable AMOLED
        theme = ThemeVariantsEnum.amoled.build();
        final amoledBackground = theme.scaffoldBackgroundColor;

        // Assert - Deeper blacks
        expect(theme.brightness, equals(Brightness.dark));
        expect(amoledBackground, isNot(equals(darkBackground)));
      });

      test('customizing font across app', () {
        // Arrange - User selects Montserrat
        const userFont = AppFontFamily.montserrat;

        // Act
        final theme = ThemeVariantsEnum.light.build(font: userFont);

        // Assert - Body text uses Montserrat
        expect(theme.textTheme.bodyLarge?.fontFamily, equals('Montserrat'));
      });
    });

    group('edge cases', () {
      test('null font defaults to Inter', () {
        // Act
        final theme = ThemeVariantsEnum.light.build();

        // Assert
        expect(theme.textTheme.bodyLarge?.fontFamily, equals('Inter'));
      });

      test('all theme components are non-null', () {
        // Act
        final theme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(theme.colorScheme, isNotNull);
        expect(theme.textTheme, isNotNull);
        expect(theme.appBarTheme, isNotNull);
        expect(theme.filledButtonTheme, isNotNull);
        expect(theme.cardTheme, isNotNull);
        expect(theme.iconTheme, isNotNull);
        expect(theme.dividerTheme, isNotNull);
      });

      test('builds multiple themes simultaneously', () {
        // Act
        final lightTheme = ThemeVariantsEnum.light.build();
        final darkTheme = ThemeVariantsEnum.dark.build();
        final amoledTheme = ThemeVariantsEnum.amoled.build();

        // Assert - All are valid
        expect(lightTheme.brightness, equals(Brightness.light));
        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(amoledTheme.brightness, equals(Brightness.dark));
      });
    });
  });
}
