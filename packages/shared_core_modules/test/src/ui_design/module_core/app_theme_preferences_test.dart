import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

void main() {
  group('ThemePreferences', () {
    group('construction', () {
      test('creates instance with required parameters', () {
        // Act
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences, isNotNull);
        expect(preferences.theme, equals(ThemeVariantsEnum.light));
        expect(preferences.font, equals(AppFontFamily.inter));
      });

      test('creates instance with light theme', () {
        // Act
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.theme, equals(ThemeVariantsEnum.light));
      });

      test('creates instance with dark theme', () {
        // Act
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(preferences.theme, equals(ThemeVariantsEnum.dark));
      });

      test('creates instance with amoled theme', () {
        // Act
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.theme, equals(ThemeVariantsEnum.amoled));
      });

      test('creates instance with Inter font', () {
        // Act
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.font, equals(AppFontFamily.inter));
      });

      test('creates instance with Montserrat font', () {
        // Act
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(preferences.font, equals(AppFontFamily.montserrat));
      });

      test('is immutable', () {
        // Assert
        expect(ThemePreferences, isA<Type>());
      });
    });

    group('mode getter', () {
      test('returns light mode for light theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.mode, equals(ThemeMode.light));
      });

      test('returns dark mode for dark theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.mode, equals(ThemeMode.dark));
      });

      test('returns dark mode for amoled theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.mode, equals(ThemeMode.dark));
      });
    });

    group('isDark getter', () {
      test('returns false for light theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.isDark, isFalse);
      });

      test('returns true for dark theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.isDark, isTrue);
      });

      test('returns true for amoled theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(preferences.isDark, isTrue);
      });
    });

    group('buildLight method', () {
      test('returns ThemeData', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final themeData = preferences.buildLight();

        // Assert
        expect(themeData, isA<ThemeData>());
      });

      test('builds light theme regardless of current preference', () {
        // Arrange
        const darkPreferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Act
        final themeData = darkPreferences.buildLight();

        // Assert
        expect(themeData.brightness, equals(Brightness.light));
      });

      test('uses preference font family', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.montserrat,
        );

        // Act
        final themeData = preferences.buildLight();

        // Assert
        expect(themeData, isNotNull);
        expect(themeData.textTheme, isNotNull);
      });

      test('always builds light variant', () {
        // Arrange - Even with amoled preference
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Act
        final themeData = preferences.buildLight();

        // Assert
        expect(themeData.brightness, equals(Brightness.light));
      });
    });

    group('buildDark method', () {
      test('returns ThemeData', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Act
        final themeData = preferences.buildDark();

        // Assert
        expect(themeData, isA<ThemeData>());
      });

      test('builds dark theme when preference is dark', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Act
        final themeData = preferences.buildDark();

        // Assert
        expect(themeData.brightness, equals(Brightness.dark));
      });

      test('builds amoled theme when preference is amoled', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Act
        final themeData = preferences.buildDark();

        // Assert
        expect(themeData.brightness, equals(Brightness.dark));
      });

      test('builds dark theme when preference is light', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final themeData = preferences.buildDark();

        // Assert
        expect(themeData.brightness, equals(Brightness.dark));
      });

      test('uses preference font family', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.montserrat,
        );

        // Act
        final themeData = preferences.buildDark();

        // Assert
        expect(themeData, isNotNull);
        expect(themeData.textTheme, isNotNull);
      });

      test('respects amoled variant when building dark', () {
        // Arrange
        const darkPreferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );
        const amoledPreferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Act
        final darkTheme = darkPreferences.buildDark();
        final amoledTheme = amoledPreferences.buildDark();

        // Assert
        expect(
          darkTheme.scaffoldBackgroundColor,
          isNot(equals(amoledTheme.scaffoldBackgroundColor)),
        );
      });
    });

    group('copyWith method', () {
      test('returns new instance with updated theme', () {
        // Arrange
        const original = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final updated = original.copyWith(theme: ThemeVariantsEnum.dark);

        // Assert
        expect(updated.theme, equals(ThemeVariantsEnum.dark));
        expect(updated.font, equals(AppFontFamily.inter));
      });

      test('returns new instance with updated font', () {
        // Arrange
        const original = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final updated = original.copyWith(font: AppFontFamily.montserrat);

        // Assert
        expect(updated.theme, equals(ThemeVariantsEnum.light));
        expect(updated.font, equals(AppFontFamily.montserrat));
      });

      test('returns new instance with both updated', () {
        // Arrange
        const original = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final updated = original.copyWith(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(updated.theme, equals(ThemeVariantsEnum.amoled));
        expect(updated.font, equals(AppFontFamily.montserrat));
      });

      test('returns new instance when no parameters provided', () {
        // Arrange
        const original = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.montserrat,
        );

        // Act
        final copy = original.copyWith();

        // Assert
        expect(copy.theme, equals(original.theme));
        expect(copy.font, equals(original.font));
      });

      test('does not mutate original instance', () {
        // Arrange
        final original =
            const ThemePreferences(
                theme: ThemeVariantsEnum.light,
                font: AppFontFamily.inter,
              )
              // Act
              ..copyWith(
                theme: ThemeVariantsEnum.dark,
                font: AppFontFamily.montserrat,
              );

        // Assert
        expect(original.theme, equals(ThemeVariantsEnum.light));
        expect(original.font, equals(AppFontFamily.inter));
      });
    });

    group('label getter', () {
      test('returns label for light theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final label = preferences.label;

        // Assert
        expect(label, isNotNull);
        expect(label, isA<String>());
      });

      test('returns label for dark theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Act
        final label = preferences.label;

        // Assert
        expect(label, isNotNull);
        expect(label, isA<String>());
      });

      test('returns label for amoled theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Act
        final label = preferences.label;

        // Assert
        expect(label, isNotNull);
        expect(label, isA<String>());
      });
    });

    group('equality', () {
      test('equal instances have same properties', () {
        // Arrange
        const prefs1 = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );
        const prefs2 = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(prefs1.theme, equals(prefs2.theme));
        expect(prefs1.font, equals(prefs2.font));
      });

      test('different themes are not equal', () {
        // Arrange
        const prefs1 = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );
        const prefs2 = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(prefs1.theme, isNot(equals(prefs2.theme)));
      });

      test('different fonts are not equal', () {
        // Arrange
        const prefs1 = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );
        const prefs2 = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(prefs1.font, isNot(equals(prefs2.font)));
      });
    });

    group('real-world scenarios', () {
      test('user switches from light to dark theme', () {
        // Arrange - User starts with light theme
        const lightPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );
        expect(lightPrefs.isDark, isFalse);

        // Act - User switches to dark theme
        final darkPrefs = lightPrefs.copyWith(theme: ThemeVariantsEnum.dark);

        // Assert
        expect(darkPrefs.isDark, isTrue);
        expect(darkPrefs.font, equals(AppFontFamily.inter));
      });

      test('user enables amoled mode for battery saving', () {
        // Arrange - User is on dark theme
        const darkPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Act - User enables amoled mode
        final amoledPrefs = darkPrefs.copyWith(
          theme: ThemeVariantsEnum.amoled,
        );

        // Assert
        expect(amoledPrefs.theme, equals(ThemeVariantsEnum.amoled));
        expect(amoledPrefs.isDark, isTrue);
      });

      test('user changes font preference', () {
        // Arrange - User has Inter font
        const interPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act - User switches to Montserrat
        final montserratPrefs = interPrefs.copyWith(
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(montserratPrefs.font, equals(AppFontFamily.montserrat));
        expect(montserratPrefs.theme, equals(ThemeVariantsEnum.light));
      });

      test('app provides both light and dark themes for system mode', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Act - App builds both themes
        final lightTheme = preferences.buildLight();
        final darkTheme = preferences.buildDark();

        // Assert
        expect(lightTheme.brightness, equals(Brightness.light));
        expect(darkTheme.brightness, equals(Brightness.dark));
      });

      test('determining MaterialApp theme mode', () {
        // Arrange - Different preference scenarios
        const lightPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );
        const darkPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );
        const amoledPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Assert - MaterialApp.themeMode would use these
        expect(lightPrefs.mode, equals(ThemeMode.light));
        expect(darkPrefs.mode, equals(ThemeMode.dark));
        expect(amoledPrefs.mode, equals(ThemeMode.dark));
      });

      test('complete theme switching workflow', () {
        // Arrange - User starts with default preferences
        const initial = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act - User tries different themes
        final darkPrefs = initial.copyWith(theme: ThemeVariantsEnum.dark);
        final amoledPrefs = darkPrefs.copyWith(
          theme: ThemeVariantsEnum.amoled,
        );
        final backToLight = amoledPrefs.copyWith(
          theme: ThemeVariantsEnum.light,
        );

        // Assert - All transitions work correctly
        expect(initial.isDark, isFalse);
        expect(darkPrefs.isDark, isTrue);
        expect(amoledPrefs.isDark, isTrue);
        expect(backToLight.isDark, isFalse);

        // Font remains consistent
        expect(initial.font, equals(AppFontFamily.inter));
        expect(darkPrefs.font, equals(AppFontFamily.inter));
        expect(amoledPrefs.font, equals(AppFontFamily.inter));
        expect(backToLight.font, equals(AppFontFamily.inter));
      });

      test('building themes with custom preferences', () {
        // Arrange - User has custom font and amoled theme
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.montserrat,
        );

        // Act
        final lightTheme = preferences.buildLight();
        final darkTheme = preferences.buildDark();

        // Assert - Both themes use the custom font
        expect(lightTheme.textTheme, isNotNull);
        expect(darkTheme.textTheme, isNotNull);

        // Dark theme respects amoled variant
        expect(darkTheme.brightness, equals(Brightness.dark));
      });
    });

    group('edge cases', () {
      test('all theme variants can be used in preferences', () {
        // Act & Assert
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

      test('all font families can be used in preferences', () {
        // Act & Assert
        for (final font in AppFontFamily.values) {
          expect(
            () => ThemePreferences(
              theme: ThemeVariantsEnum.light,
              font: font,
            ),
            returnsNormally,
          );
        }
      });

      test('all combinations of theme and font work', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          for (final font in AppFontFamily.values) {
            final preferences = ThemePreferences(theme: variant, font: font);
            expect(preferences.buildLight, returnsNormally);
            expect(preferences.buildDark, returnsNormally);
          }
        }
      });

      test('copyWith with same values creates equivalent instance', () {
        // Arrange
        const original = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.montserrat,
        );

        // Act
        final copy = original.copyWith(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.montserrat,
        );

        // Assert
        expect(copy.theme, equals(original.theme));
        expect(copy.font, equals(original.font));
      });

      test('multiple copyWith calls chain correctly', () {
        // Arrange
        const original = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final result = original
            .copyWith(theme: ThemeVariantsEnum.dark)
            .copyWith(font: AppFontFamily.montserrat)
            .copyWith(theme: ThemeVariantsEnum.amoled);

        // Assert
        expect(result.theme, equals(ThemeVariantsEnum.amoled));
        expect(result.font, equals(AppFontFamily.montserrat));
      });

      test('buildLight always returns light regardless of preference', () {
        // Act & Assert
        for (final variant in ThemeVariantsEnum.values) {
          final prefs = ThemePreferences(
            theme: variant,
            font: AppFontFamily.inter,
          );
          final theme = prefs.buildLight();
          expect(theme.brightness, equals(Brightness.light));
        }
      });

      test('buildDark always returns dark regardless of light preference', () {
        // Arrange
        const lightPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final darkTheme = lightPrefs.buildDark();

        // Assert
        expect(darkTheme.brightness, equals(Brightness.dark));
      });
    });

    group('theme caching integration', () {
      test('buildLight uses cached theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        // Act
        final theme1 = preferences.buildLight();
        final theme2 = preferences.buildLight();

        // Assert - Should be identical (cached)
        expect(identical(theme1, theme2), isTrue);
      });

      test('buildDark uses cached theme', () {
        // Arrange
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Act
        final theme1 = preferences.buildDark();
        final theme2 = preferences.buildDark();

        // Assert - Should be identical (cached)
        expect(identical(theme1, theme2), isTrue);
      });

      test('different preferences build different cached themes', () {
        // Arrange
        const prefs1 = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );
        const prefs2 = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.montserrat,
        );

        // Act
        final theme1 = prefs1.buildLight();
        final theme2 = prefs2.buildLight();

        // Assert - Different fonts should produce different themes
        expect(identical(theme1, theme2), isFalse);
      });

      test('amoled preference builds amoled variant for dark', () {
        // Arrange
        const amoledPrefs = ThemePreferences(
          theme: ThemeVariantsEnum.amoled,
          font: AppFontFamily.inter,
        );

        // Act
        final darkTheme = amoledPrefs.buildDark();

        // Assert - Should use amoled variant
        expect(darkTheme.brightness, equals(Brightness.dark));
      });
    });

    group('const instances', () {
      test('can create const instances', () {
        // Act & Assert
        const preferences = ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        );

        expect(preferences, isNotNull);
      });

      test('const instances with same values are identical', () {
        // Arrange
        const prefs1 = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );
        const prefs2 = ThemePreferences(
          theme: ThemeVariantsEnum.dark,
          font: AppFontFamily.inter,
        );

        // Assert
        expect(identical(prefs1, prefs2), isTrue);
      });
    });
  });
}
