import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

void main() {
  group('ThemeVariantsEnum', () {
    group('enum values', () {
      test('has three variants', () {
        // Assert
        expect(ThemeVariantsEnum.values.length, equals(3));
      });

      test('contains light variant', () {
        // Assert
        expect(
          ThemeVariantsEnum.values,
          contains(ThemeVariantsEnum.light),
        );
      });

      test('contains dark variant', () {
        // Assert
        expect(
          ThemeVariantsEnum.values,
          contains(ThemeVariantsEnum.dark),
        );
      });

      test('contains amoled variant', () {
        // Assert
        expect(
          ThemeVariantsEnum.values,
          contains(ThemeVariantsEnum.amoled),
        );
      });

      test('variants are in correct order', () {
        // Assert
        expect(ThemeVariantsEnum.values[0], equals(ThemeVariantsEnum.light));
        expect(ThemeVariantsEnum.values[1], equals(ThemeVariantsEnum.dark));
        expect(ThemeVariantsEnum.values[2], equals(ThemeVariantsEnum.amoled));
      });
    });

    group('brightness property', () {
      test('light variant has light brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.light.brightness,
          equals(Brightness.light),
        );
      });

      test('dark variant has dark brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.dark.brightness,
          equals(Brightness.dark),
        );
      });

      test('amoled variant has dark brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.amoled.brightness,
          equals(Brightness.dark),
        );
      });
    });

    group('isDark getter', () {
      test('returns false for light variant', () {
        // Assert
        expect(ThemeVariantsEnum.light.isDark, isFalse);
      });

      test('returns true for dark variant', () {
        // Assert
        expect(ThemeVariantsEnum.dark.isDark, isTrue);
      });

      test('returns true for amoled variant', () {
        // Assert
        expect(ThemeVariantsEnum.amoled.isDark, isTrue);
      });
    });

    group('themeMode getter', () {
      test('returns light mode for light variant', () {
        // Assert
        expect(
          ThemeVariantsEnum.light.themeMode,
          equals(ThemeMode.light),
        );
      });

      test('returns dark mode for dark variant', () {
        // Assert
        expect(
          ThemeVariantsEnum.dark.themeMode,
          equals(ThemeMode.dark),
        );
      });

      test('returns dark mode for amoled variant', () {
        // Assert
        expect(
          ThemeVariantsEnum.amoled.themeMode,
          equals(ThemeMode.dark),
        );
      });
    });

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

    group('color properties', () {
      test('light variant has non-null background color', () {
        // Assert
        expect(ThemeVariantsEnum.light.background, isNotNull);
      });

      test('dark variant has non-null background color', () {
        // Assert
        expect(ThemeVariantsEnum.dark.background, isNotNull);
      });

      test('amoled variant has non-null background color', () {
        // Assert
        expect(ThemeVariantsEnum.amoled.background, isNotNull);
      });

      test('light variant has non-null primary color', () {
        // Assert
        expect(ThemeVariantsEnum.light.primaryColor, isNotNull);
      });

      test('dark variant has non-null primary color', () {
        // Assert
        expect(ThemeVariantsEnum.dark.primaryColor, isNotNull);
      });

      test('amoled variant has non-null primary color', () {
        // Assert
        expect(ThemeVariantsEnum.amoled.primaryColor, isNotNull);
      });

      test('light variant has non-null card color', () {
        // Assert
        expect(ThemeVariantsEnum.light.cardColor, isNotNull);
      });

      test('dark variant has non-null card color', () {
        // Assert
        expect(ThemeVariantsEnum.dark.cardColor, isNotNull);
      });

      test('amoled variant has non-null card color', () {
        // Assert
        expect(ThemeVariantsEnum.amoled.cardColor, isNotNull);
      });

      test('light variant has non-null contrast color', () {
        // Assert
        expect(ThemeVariantsEnum.light.contrastColor, isNotNull);
      });

      test('dark variant has non-null contrast color', () {
        // Assert
        expect(ThemeVariantsEnum.dark.contrastColor, isNotNull);
      });

      test('amoled variant has non-null contrast color', () {
        // Assert
        expect(ThemeVariantsEnum.amoled.contrastColor, isNotNull);
      });
    });

    group('colorScheme property', () {
      test('light variant has non-null color scheme', () {
        // Assert
        expect(ThemeVariantsEnum.light.colorScheme, isNotNull);
      });

      test('dark variant has non-null color scheme', () {
        // Assert
        expect(ThemeVariantsEnum.dark.colorScheme, isNotNull);
      });

      test('amoled variant has non-null color scheme', () {
        // Assert
        expect(ThemeVariantsEnum.amoled.colorScheme, isNotNull);
      });

      test('light variant color scheme has correct brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.light.colorScheme.brightness,
          equals(Brightness.light),
        );
      });

      test('dark variant color scheme has correct brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.dark.colorScheme.brightness,
          equals(Brightness.dark),
        );
      });

      test('amoled variant color scheme has correct brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.amoled.colorScheme.brightness,
          equals(Brightness.dark),
        );
      });

      test('color scheme has primary color', () {
        // Assert
        for (final variant in ThemeVariantsEnum.values) {
          expect(variant.colorScheme.primary, isNotNull);
        }
      });

      test('color scheme has onPrimary color', () {
        // Assert
        for (final variant in ThemeVariantsEnum.values) {
          expect(variant.colorScheme.onPrimary, isNotNull);
        }
      });

      test('color scheme has secondary color', () {
        // Assert
        for (final variant in ThemeVariantsEnum.values) {
          expect(variant.colorScheme.secondary, isNotNull);
        }
      });

      test('color scheme has surface color', () {
        // Assert
        for (final variant in ThemeVariantsEnum.values) {
          expect(variant.colorScheme.surface, isNotNull);
        }
      });
    });

    group('build method', () {
      test('builds ThemeData for light variant', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData, isA<ThemeData>());
      });

      test('builds ThemeData for dark variant', () {
        // Act
        final themeData = ThemeVariantsEnum.dark.build();

        // Assert
        expect(themeData, isA<ThemeData>());
      });

      test('builds ThemeData for amoled variant', () {
        // Act
        final themeData = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(themeData, isA<ThemeData>());
      });

      test('builds ThemeData with custom font', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build(
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(themeData, isA<ThemeData>());
      });

      test('builds ThemeData with default Inter font', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData, isA<ThemeData>());
        expect(themeData.textTheme, isNotNull);
      });

      test('built theme uses Material 3', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData.useMaterial3, isTrue);
      });

      test('built theme has correct brightness for light', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData.brightness, equals(Brightness.light));
      });

      test('built theme has correct brightness for dark', () {
        // Act
        final themeData = ThemeVariantsEnum.dark.build();

        // Assert
        expect(themeData.brightness, equals(Brightness.dark));
      });

      test('built theme has correct brightness for amoled', () {
        // Act
        final themeData = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(themeData.brightness, equals(Brightness.dark));
      });

      test('built theme has correct background color', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;

        // Act
        final themeData = variant.build();

        // Assert
        expect(
          themeData.scaffoldBackgroundColor,
          equals(variant.background),
        );
      });

      test('built theme has correct primary color', () {
        // Arrange
        const variant = ThemeVariantsEnum.dark;

        // Act
        final themeData = variant.build();

        // Assert
        expect(themeData.primaryColor, equals(variant.primaryColor));
      });

      test('built theme has color scheme', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData.colorScheme, isNotNull);
      });

      test('built theme has app bar theme', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData.appBarTheme, isNotNull);
        expect(themeData.appBarTheme.elevation, equals(0));
        expect(
          themeData.appBarTheme.backgroundColor,
          equals(Colors.transparent),
        );
      });

      test('built theme has filled button theme', () {
        // Act
        final themeData = ThemeVariantsEnum.dark.build();

        // Assert
        expect(themeData.filledButtonTheme, isNotNull);
      });

      test('built theme has card theme', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData.cardTheme, isNotNull);
        expect(themeData.cardTheme.elevation, equals(0));
      });

      test('built theme has icon theme', () {
        // Act
        final themeData = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(themeData.iconTheme, isNotNull);
        expect(themeData.iconTheme.color, isNotNull);
      });

      test('built theme has divider theme', () {
        // Act
        final themeData = ThemeVariantsEnum.light.build();

        // Assert
        expect(themeData.dividerTheme, isNotNull);
        expect(themeData.dividerTheme.thickness, equals(0.6));
      });

      test('built theme has text theme', () {
        // Act
        final themeData = ThemeVariantsEnum.dark.build();

        // Assert
        expect(themeData.textTheme, isNotNull);
      });

      test('different variants build different themes', () {
        // Act
        final lightTheme = ThemeVariantsEnum.light.build();
        final darkTheme = ThemeVariantsEnum.dark.build();
        final amoledTheme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(lightTheme.brightness, isNot(equals(darkTheme.brightness)));
        expect(
          lightTheme.scaffoldBackgroundColor,
          isNot(equals(darkTheme.scaffoldBackgroundColor)),
        );
        expect(
          darkTheme.scaffoldBackgroundColor,
          isNot(equals(amoledTheme.scaffoldBackgroundColor)),
        );
      });

      test('different fonts build different themes', () {
        // Act
        final interTheme = ThemeVariantsEnum.light.build(
          font: AppFontFamily.inter,
        );
        final montserratTheme = ThemeVariantsEnum.light.build(
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(interTheme, isNot(equals(montserratTheme)));
      });
    });

    group('real-world scenarios', () {
      test('typical theme switching flow', () {
        // Arrange - User starts with light theme
        final lightTheme = ThemeVariantsEnum.light.build();
        expect(lightTheme.brightness, equals(Brightness.light));

        // Act - User switches to dark theme
        final darkTheme = ThemeVariantsEnum.dark.build();

        // Assert
        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(
          lightTheme.scaffoldBackgroundColor,
          isNot(equals(darkTheme.scaffoldBackgroundColor)),
        );
      });

      test('user enables amoled mode for battery saving', () {
        // Arrange - User is on dark theme
        final darkTheme = ThemeVariantsEnum.dark.build();

        // Act - User switches to amoled for deeper blacks
        final amoledTheme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(amoledTheme.brightness, equals(Brightness.dark));
        expect(ThemeVariantsEnum.amoled.isAmoled, isTrue);
        expect(
          darkTheme.scaffoldBackgroundColor,
          isNot(equals(amoledTheme.scaffoldBackgroundColor)),
        );
      });

      test('determining theme mode from variant', () {
        // Act & Assert - Light variant
        expect(
          ThemeVariantsEnum.light.themeMode,
          equals(ThemeMode.light),
        );

        // Dark variant
        expect(
          ThemeVariantsEnum.dark.themeMode,
          equals(ThemeMode.dark),
        );

        // Amoled variant
        expect(
          ThemeVariantsEnum.amoled.themeMode,
          equals(ThemeMode.dark),
        );
      });

      test('user customizes font preference', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;

        // Act - User selects different fonts
        final interTheme = variant.build(font: AppFontFamily.inter);
        final montserratTheme = variant.build(
          font: AppFontFamily.montserrat,
        );

        // Assert - Both are valid themes with same brightness
        expect(interTheme.brightness, equals(montserratTheme.brightness));
        expect(interTheme, isNot(equals(montserratTheme)));
      });

      test('checking if dark mode is enabled', () {
        // Arrange - App needs to know if dark mode features should be enabled
        const lightVariant = ThemeVariantsEnum.light;
        const darkVariant = ThemeVariantsEnum.dark;
        const amoledVariant = ThemeVariantsEnum.amoled;

        // Act & Assert
        expect(lightVariant.isDark, isFalse);
        expect(darkVariant.isDark, isTrue);
        expect(amoledVariant.isDark, isTrue);
      });
    });

    group('edge cases', () {
      test('all variants can be built without errors', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          expect(variant.build, returnsNormally);
        }
      });

      test('all variants can be built with all fonts', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          for (final font in AppFontFamily.values) {
            expect(() => variant.build(font: font), returnsNormally);
          }
        }
      });

      test('all variants have consistent property access', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          expect(variant.brightness, isNotNull);
          expect(variant.background, isNotNull);
          expect(variant.primaryColor, isNotNull);
          expect(variant.cardColor, isNotNull);
          expect(variant.contrastColor, isNotNull);
          expect(variant.colorScheme, isNotNull);
          expect(variant.isDark, isA<bool>());
          expect(variant.themeMode, isA<ThemeMode>());
          expect(variant.isAmoled, isA<bool>());
        }
      });

      test('building theme multiple times returns equal data', () {
        // Arrange
        const variant = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;

        // Act
        final theme1 = variant.build(font: font);
        final theme2 = variant.build(font: font);

        // Assert - Themes should be equal (same configuration)
        expect(theme1.brightness, equals(theme2.brightness));
        expect(
          theme1.scaffoldBackgroundColor,
          equals(theme2.scaffoldBackgroundColor),
        );
        expect(theme1.primaryColor, equals(theme2.primaryColor));
      });

      test('isAmoled is only true for amoled variant', () {
        // Assert
        var amoledCount = 0;
        for (final variant in ThemeVariantsEnum.values) {
          if (variant.isAmoled) {
            amoledCount++;
          }
        }
        expect(amoledCount, equals(1));
      });

      test('exactly one variant is not dark', () {
        // Assert
        var lightCount = 0;
        for (final variant in ThemeVariantsEnum.values) {
          if (!variant.isDark) {
            lightCount++;
          }
        }
        expect(lightCount, equals(1));
      });
    });

    group('theme component properties', () {
      test('amoled theme uses special card color', () {
        // Act
        final amoledTheme = ThemeVariantsEnum.amoled.build();

        // Assert
        expect(amoledTheme.cardTheme.color, isNotNull);
      });

      test('app bar has transparent background for all variants', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          final theme = variant.build();
          expect(
            theme.appBarTheme.backgroundColor,
            equals(Colors.transparent),
          );
        }
      });

      test('app bar has zero elevation for all variants', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          final theme = variant.build();
          expect(theme.appBarTheme.elevation, equals(0));
        }
      });

      test('cards have zero elevation for all variants', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          final theme = variant.build();
          expect(theme.cardTheme.elevation, equals(0));
        }
      });

      test('divider has consistent thickness across variants', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          final theme = variant.build();
          expect(theme.dividerTheme.thickness, equals(0.6));
        }
      });

      test('filled button theme is configured for all variants', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          final theme = variant.build();
          expect(theme.filledButtonTheme, isNotNull);
          expect(theme.filledButtonTheme.style, isNotNull);
        }
      });
    });

    group('variant comparison', () {
      test('light and dark have different brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.light.brightness,
          isNot(equals(ThemeVariantsEnum.dark.brightness)),
        );
      });

      test('dark and amoled have same brightness', () {
        // Assert
        expect(
          ThemeVariantsEnum.dark.brightness,
          equals(ThemeVariantsEnum.amoled.brightness),
        );
      });

      test('all variants have different color schemes', () {
        // Act
        final lightScheme = ThemeVariantsEnum.light.colorScheme;
        final darkScheme = ThemeVariantsEnum.dark.colorScheme;
        final amoledScheme = ThemeVariantsEnum.amoled.colorScheme;

        // Assert
        expect(lightScheme, isNot(equals(darkScheme)));
        expect(darkScheme, isNot(equals(amoledScheme)));
        expect(lightScheme, isNot(equals(amoledScheme)));
      });

      test('all variants have different background colors', () {
        // Act
        final lightBg = ThemeVariantsEnum.light.background;
        final darkBg = ThemeVariantsEnum.dark.background;
        final amoledBg = ThemeVariantsEnum.amoled.background;

        // Assert
        expect(lightBg, isNot(equals(darkBg)));
        expect(darkBg, isNot(equals(amoledBg)));
        expect(lightBg, isNot(equals(amoledBg)));
      });
    });
  });
}
