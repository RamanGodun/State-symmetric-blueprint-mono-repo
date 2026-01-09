import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

void main() {
  group('ThemeModeX', () {
    group('toggle method', () {
      test('toggles from light to dark', () {
        // Arrange
        const mode = ThemeMode.light;

        // Act
        final toggled = mode.toggle();

        // Assert
        expect(toggled, equals(ThemeMode.dark));
      });

      test('toggles from dark to light', () {
        // Arrange
        const mode = ThemeMode.dark;

        // Act
        final toggled = mode.toggle();

        // Assert
        expect(toggled, equals(ThemeMode.light));
      });

      test('system mode toggles to dark', () {
        // Arrange
        const mode = ThemeMode.system;

        // Act
        final toggled = mode.toggle();

        // Assert
        expect(toggled, equals(ThemeMode.dark));
      });

      test('double toggle returns to original for light', () {
        // Arrange
        const mode = ThemeMode.light;

        // Act
        final toggled = mode.toggle().toggle();

        // Assert
        expect(toggled, equals(ThemeMode.light));
      });

      test('double toggle returns to original for dark', () {
        // Arrange
        const mode = ThemeMode.dark;

        // Act
        final toggled = mode.toggle().toggle();

        // Assert
        expect(toggled, equals(ThemeMode.dark));
      });
    });

    group('isLight getter', () {
      test('returns true for light mode', () {
        // Arrange
        const mode = ThemeMode.light;

        // Assert
        expect(mode.isLight, isTrue);
      });

      test('returns false for dark mode', () {
        // Arrange
        const mode = ThemeMode.dark;

        // Assert
        expect(mode.isLight, isFalse);
      });

      test('returns false for system mode', () {
        // Arrange
        const mode = ThemeMode.system;

        // Assert
        expect(mode.isLight, isFalse);
      });
    });

    group('isDark getter', () {
      test('returns true for dark mode', () {
        // Arrange
        const mode = ThemeMode.dark;

        // Assert
        expect(mode.isDark, isTrue);
      });

      test('returns false for light mode', () {
        // Arrange
        const mode = ThemeMode.light;

        // Assert
        expect(mode.isDark, isFalse);
      });

      test('returns false for system mode', () {
        // Arrange
        const mode = ThemeMode.system;

        // Assert
        expect(mode.isDark, isFalse);
      });
    });

    group('isSystem getter', () {
      test('returns true for system mode', () {
        // Arrange
        const mode = ThemeMode.system;

        // Assert
        expect(mode.isSystem, isTrue);
      });

      test('returns false for light mode', () {
        // Arrange
        const mode = ThemeMode.light;

        // Assert
        expect(mode.isSystem, isFalse);
      });

      test('returns false for dark mode', () {
        // Arrange
        const mode = ThemeMode.dark;

        // Assert
        expect(mode.isSystem, isFalse);
      });
    });

    group('real-world scenarios', () {
      test('user toggles theme multiple times', () {
        // Arrange - Start with light theme
        var currentMode = ThemeMode.light;
        expect(currentMode.isLight, isTrue);

        // Act - User taps toggle button
        currentMode = currentMode.toggle();

        // Assert - Now dark
        expect(currentMode.isDark, isTrue);

        // Act - User taps again
        currentMode = currentMode.toggle();

        // Assert - Back to light
        expect(currentMode.isLight, isTrue);
      });

      test('checking theme state before UI decisions', () {
        // Arrange
        const lightMode = ThemeMode.light;
        const darkMode = ThemeMode.dark;

        // Act & Assert - Show different icons based on mode
        if (lightMode.isLight) {
          expect(true, isTrue); // Show moon icon
        }

        if (darkMode.isDark) {
          expect(true, isTrue); // Show sun icon
        }
      });

      test('system theme cannot be toggled to light', () {
        // Arrange
        const mode = ThemeMode.system;

        // Act
        final toggled = mode.toggle();

        // Assert - System mode toggles to dark, not light
        expect(toggled, equals(ThemeMode.dark));
        expect(toggled.isLight, isFalse);
      });
    });

    group('edge cases', () {
      test('all ThemeMode values have distinct is* getters', () {
        // Assert - Light
        expect(ThemeMode.light.isLight, isTrue);
        expect(ThemeMode.light.isDark, isFalse);
        expect(ThemeMode.light.isSystem, isFalse);

        // Dark
        expect(ThemeMode.dark.isLight, isFalse);
        expect(ThemeMode.dark.isDark, isTrue);
        expect(ThemeMode.dark.isSystem, isFalse);

        // System
        expect(ThemeMode.system.isLight, isFalse);
        expect(ThemeMode.system.isDark, isFalse);
        expect(ThemeMode.system.isSystem, isTrue);
      });

      test('exactly one getter is true for each mode', () {
        // Arrange
        const modes = ThemeMode.values;

        // Act & Assert
        for (final mode in modes) {
          final trueCount = [
            mode.isLight,
            mode.isDark,
            mode.isSystem,
          ].where((v) => v).length;
          expect(trueCount, equals(1));
        }
      });

      test('toggle is consistent across all modes', () {
        // Act & Assert
        expect(ThemeMode.light.toggle(), equals(ThemeMode.dark));
        expect(ThemeMode.dark.toggle(), equals(ThemeMode.light));
        expect(ThemeMode.system.toggle(), equals(ThemeMode.dark));
      });
    });

    group('method chaining', () {
      test('can chain toggle calls', () {
        // Arrange
        const mode = ThemeMode.light;

        // Act - Chain multiple toggles
        final result = mode.toggle().toggle().toggle();

        // Assert
        expect(result, equals(ThemeMode.dark));
      });

      test('can use getters after toggle', () {
        // Arrange
        const mode = ThemeMode.light;

        // Act
        final isDarkAfterToggle = mode.toggle().isDark;

        // Assert
        expect(isDarkAfterToggle, isTrue);
      });
    });

    group('consistency', () {
      test('isLight is opposite of isDark for light mode', () {
        // Arrange
        const mode = ThemeMode.light;

        // Assert
        expect(mode.isLight, isNot(equals(mode.isDark)));
      });

      test('isLight is opposite of isDark for dark mode', () {
        // Arrange
        const mode = ThemeMode.dark;

        // Assert
        expect(mode.isLight, isNot(equals(mode.isDark)));
      });

      test('toggle result has opposite light/dark state', () {
        // Arrange
        const lightMode = ThemeMode.light;
        const darkMode = ThemeMode.dark;

        // Act
        final toggledLight = lightMode.toggle();
        final toggledDark = darkMode.toggle();

        // Assert
        expect(lightMode.isLight, isNot(equals(toggledLight.isLight)));
        expect(darkMode.isDark, isNot(equals(toggledDark.isDark)));
      });
    });
  });
}
