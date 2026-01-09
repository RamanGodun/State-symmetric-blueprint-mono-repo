import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

// Test class that uses the mixin
class _TestThemeCacheHolder with ThemeCacheMixin {}

void main() {
  group('ThemeCacheMixin', () {
    late _TestThemeCacheHolder holder;

    setUp(() {
      holder = _TestThemeCacheHolder();
      // Clear cache before each test to ensure isolation
      ThemeCacheMixin.clearThemeCache();
    });

    tearDown(ThemeCacheMixin.clearThemeCache);

    group('cache storage', () {
      test('caches theme data on first access', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;

        // Act
        final firstCall = holder.cachedTheme(theme, font);
        final secondCall = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(firstCall, secondCall), isTrue);
      });

      test('returns same instance for identical parameters', () {
        // Arrange
        const theme = ThemeVariantsEnum.dark;
        const font = AppFontFamily.montserrat;

        // Act
        final theme1 = holder.cachedTheme(theme, font);
        final theme2 = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(theme1, theme2), isTrue);
      });

      test('caches different themes separately', () {
        // Arrange
        const font = AppFontFamily.inter;

        // Act
        final lightTheme = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final darkTheme = holder.cachedTheme(ThemeVariantsEnum.dark, font);
        final amoledTheme = holder.cachedTheme(ThemeVariantsEnum.amoled, font);

        // Assert
        expect(identical(lightTheme, darkTheme), isFalse);
        expect(identical(lightTheme, amoledTheme), isFalse);
        expect(identical(darkTheme, amoledTheme), isFalse);
      });

      test('caches different fonts separately', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;

        // Act
        final interTheme = holder.cachedTheme(theme, AppFontFamily.inter);
        final montserratTheme = holder.cachedTheme(
          theme,
          AppFontFamily.montserrat,
        );

        // Assert
        expect(identical(interTheme, montserratTheme), isFalse);
      });

      test('caches all combinations of theme and font', () {
        // Arrange
        const themes = ThemeVariantsEnum.values;
        const fonts = AppFontFamily.values;

        // Act & Assert
        for (final theme in themes) {
          for (final font in fonts) {
            final theme1 = holder.cachedTheme(theme, font);
            final theme2 = holder.cachedTheme(theme, font);
            expect(identical(theme1, theme2), isTrue);
          }
        }
      });
    });

    group('version control', () {
      test('returns new instance after version bump', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;
        final oldTheme = holder.cachedTheme(theme, font);

        // Act
        ThemeCacheMixin.bumpTokensVersion();
        final newTheme = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(oldTheme, newTheme), isFalse);
      });

      test('version bump affects all theme variants', () {
        // Arrange
        const font = AppFontFamily.inter;
        final oldLight = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final oldDark = holder.cachedTheme(ThemeVariantsEnum.dark, font);
        final oldAmoled = holder.cachedTheme(ThemeVariantsEnum.amoled, font);

        // Act
        ThemeCacheMixin.bumpTokensVersion();
        final newLight = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final newDark = holder.cachedTheme(ThemeVariantsEnum.dark, font);
        final newAmoled = holder.cachedTheme(ThemeVariantsEnum.amoled, font);

        // Assert
        expect(identical(oldLight, newLight), isFalse);
        expect(identical(oldDark, newDark), isFalse);
        expect(identical(oldAmoled, newAmoled), isFalse);
      });

      test('version bump affects all fonts', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        final oldInter = holder.cachedTheme(theme, AppFontFamily.inter);
        final oldMontserrat = holder.cachedTheme(
          theme,
          AppFontFamily.montserrat,
        );

        // Act
        ThemeCacheMixin.bumpTokensVersion();
        final newInter = holder.cachedTheme(theme, AppFontFamily.inter);
        final newMontserrat = holder.cachedTheme(
          theme,
          AppFontFamily.montserrat,
        );

        // Assert
        expect(identical(oldInter, newInter), isFalse);
        expect(identical(oldMontserrat, newMontserrat), isFalse);
      });

      test('caches new themes after version bump', () {
        // Arrange
        const theme = ThemeVariantsEnum.dark;
        const font = AppFontFamily.inter;
        ThemeCacheMixin.bumpTokensVersion();

        // Act
        final firstCall = holder.cachedTheme(theme, font);
        final secondCall = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(firstCall, secondCall), isTrue);
      });

      test('multiple version bumps create different instances', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;

        // Act
        final theme1 = holder.cachedTheme(theme, font);
        ThemeCacheMixin.bumpTokensVersion();
        final theme2 = holder.cachedTheme(theme, font);
        ThemeCacheMixin.bumpTokensVersion();
        final theme3 = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(theme1, theme2), isFalse);
        expect(identical(theme2, theme3), isFalse);
        expect(identical(theme1, theme3), isFalse);
      });
    });

    group('cache clearing', () {
      test('clearThemeCache removes all cached themes', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;
        final oldTheme = holder.cachedTheme(theme, font);

        // Act
        ThemeCacheMixin.clearThemeCache();
        final newTheme = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(oldTheme, newTheme), isFalse);
      });

      test('clearThemeCache affects all cached entries', () {
        // Arrange
        const font = AppFontFamily.inter;
        final oldLight = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final oldDark = holder.cachedTheme(ThemeVariantsEnum.dark, font);
        final oldAmoled = holder.cachedTheme(ThemeVariantsEnum.amoled, font);

        // Act
        ThemeCacheMixin.clearThemeCache();
        final newLight = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final newDark = holder.cachedTheme(ThemeVariantsEnum.dark, font);
        final newAmoled = holder.cachedTheme(ThemeVariantsEnum.amoled, font);

        // Assert
        expect(identical(oldLight, newLight), isFalse);
        expect(identical(oldDark, newDark), isFalse);
        expect(identical(oldAmoled, newAmoled), isFalse);
      });

      test('can cache themes again after clearing', () {
        // Arrange
        const theme = ThemeVariantsEnum.dark;
        const font = AppFontFamily.montserrat;
        holder.cachedTheme(theme, font);
        ThemeCacheMixin.clearThemeCache();

        // Act
        final firstCall = holder.cachedTheme(theme, font);
        final secondCall = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(firstCall, secondCall), isTrue);
      });
    });

    group('cache key generation', () {
      test('uses theme variant in cache key', () {
        // Arrange
        const font = AppFontFamily.inter;

        // Act
        final light1 = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final light2 = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final dark1 = holder.cachedTheme(ThemeVariantsEnum.dark, font);
        final dark2 = holder.cachedTheme(ThemeVariantsEnum.dark, font);

        // Assert
        expect(identical(light1, light2), isTrue);
        expect(identical(dark1, dark2), isTrue);
        expect(identical(light1, dark1), isFalse);
      });

      test('uses font family in cache key', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;

        // Act
        final inter1 = holder.cachedTheme(theme, AppFontFamily.inter);
        final inter2 = holder.cachedTheme(theme, AppFontFamily.inter);
        final montserrat1 = holder.cachedTheme(theme, AppFontFamily.montserrat);
        final montserrat2 = holder.cachedTheme(theme, AppFontFamily.montserrat);

        // Assert
        expect(identical(inter1, inter2), isTrue);
        expect(identical(montserrat1, montserrat2), isTrue);
        expect(identical(inter1, montserrat1), isFalse);
      });

      test('uses version in cache key', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;

        // Act
        final v1Theme1 = holder.cachedTheme(theme, font);
        final v1Theme2 = holder.cachedTheme(theme, font);

        ThemeCacheMixin.bumpTokensVersion();

        final v2Theme1 = holder.cachedTheme(theme, font);
        final v2Theme2 = holder.cachedTheme(theme, font);

        // Assert
        expect(identical(v1Theme1, v1Theme2), isTrue);
        expect(identical(v2Theme1, v2Theme2), isTrue);
        expect(identical(v1Theme1, v2Theme1), isFalse);
      });
    });

    group('theme data properties', () {
      test('cached theme has correct brightness for light variant', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;

        // Act
        final themeData = holder.cachedTheme(theme, font);

        // Assert
        expect(themeData.brightness, equals(Brightness.light));
      });

      test('cached theme has correct brightness for dark variant', () {
        // Arrange
        const theme = ThemeVariantsEnum.dark;
        const font = AppFontFamily.inter;

        // Act
        final themeData = holder.cachedTheme(theme, font);

        // Assert
        expect(themeData.brightness, equals(Brightness.dark));
      });

      test('cached theme has correct brightness for amoled variant', () {
        // Arrange
        const theme = ThemeVariantsEnum.amoled;
        const font = AppFontFamily.inter;

        // Act
        final themeData = holder.cachedTheme(theme, font);

        // Assert
        expect(themeData.brightness, equals(Brightness.dark));
      });

      test('cached theme uses Material 3', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;

        // Act
        final themeData = holder.cachedTheme(theme, font);

        // Assert
        expect(themeData.useMaterial3, isTrue);
      });
    });

    group('multiple holders', () {
      test('different holders share the same cache', () {
        // Arrange
        final holder1 = _TestThemeCacheHolder();
        final holder2 = _TestThemeCacheHolder();
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;

        // Act
        final theme1 = holder1.cachedTheme(theme, font);
        final theme2 = holder2.cachedTheme(theme, font);

        // Assert
        expect(identical(theme1, theme2), isTrue);
      });

      test('version bump affects all holders', () {
        // Arrange
        final holder1 = _TestThemeCacheHolder();
        final holder2 = _TestThemeCacheHolder();
        const theme = ThemeVariantsEnum.dark;
        const font = AppFontFamily.inter;

        final oldTheme1 = holder1.cachedTheme(theme, font);
        final oldTheme2 = holder2.cachedTheme(theme, font);

        // Act
        ThemeCacheMixin.bumpTokensVersion();

        final newTheme1 = holder1.cachedTheme(theme, font);
        final newTheme2 = holder2.cachedTheme(theme, font);

        // Assert
        expect(identical(oldTheme1, newTheme1), isFalse);
        expect(identical(oldTheme2, newTheme2), isFalse);
        expect(identical(newTheme1, newTheme2), isTrue);
      });

      test('cache clear affects all holders', () {
        // Arrange
        final holder1 = _TestThemeCacheHolder();
        final holder2 = _TestThemeCacheHolder();
        const theme = ThemeVariantsEnum.amoled;
        const font = AppFontFamily.montserrat;

        final oldTheme1 = holder1.cachedTheme(theme, font);
        final oldTheme2 = holder2.cachedTheme(theme, font);

        // Act
        ThemeCacheMixin.clearThemeCache();

        final newTheme1 = holder1.cachedTheme(theme, font);
        final newTheme2 = holder2.cachedTheme(theme, font);

        // Assert
        expect(identical(oldTheme1, newTheme1), isFalse);
        expect(identical(oldTheme2, newTheme2), isFalse);
        expect(identical(newTheme1, newTheme2), isTrue);
      });
    });

    group('real-world scenarios', () {
      test('typical app theme switching flow', () {
        // Arrange
        const font = AppFontFamily.inter;

        // Act - User starts with light theme
        final lightTheme1 = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final lightTheme2 = holder.cachedTheme(ThemeVariantsEnum.light, font);

        // User switches to dark theme
        final darkTheme1 = holder.cachedTheme(ThemeVariantsEnum.dark, font);
        final darkTheme2 = holder.cachedTheme(ThemeVariantsEnum.dark, font);

        // User switches back to light theme
        final lightTheme3 = holder.cachedTheme(ThemeVariantsEnum.light, font);

        // Assert
        expect(identical(lightTheme1, lightTheme2), isTrue);
        expect(identical(darkTheme1, darkTheme2), isTrue);
        expect(identical(lightTheme1, lightTheme3), isTrue);
        expect(identical(lightTheme1, darkTheme1), isFalse);
      });

      test('design tokens update scenario', () {
        // Arrange - App has cached themes
        const font = AppFontFamily.inter;
        final oldLight = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final oldDark = holder.cachedTheme(ThemeVariantsEnum.dark, font);

        // Act - Design tokens are updated
        ThemeCacheMixin.bumpTokensVersion();

        // App rebuilds with new tokens
        final newLight = holder.cachedTheme(ThemeVariantsEnum.light, font);
        final newDark = holder.cachedTheme(ThemeVariantsEnum.dark, font);

        // Assert
        expect(identical(oldLight, newLight), isFalse);
        expect(identical(oldDark, newDark), isFalse);
      });

      test('font change scenario', () {
        // Arrange - User has Inter font selected
        const theme = ThemeVariantsEnum.light;
        final interTheme = holder.cachedTheme(theme, AppFontFamily.inter);

        // Act - User changes to Montserrat font
        final montserratTheme = holder.cachedTheme(
          theme,
          AppFontFamily.montserrat,
        );

        // User switches back to Inter
        final interTheme2 = holder.cachedTheme(theme, AppFontFamily.inter);

        // Assert
        expect(identical(interTheme, interTheme2), isTrue);
        expect(identical(interTheme, montserratTheme), isFalse);
      });

      test('memory management - clearing old themes', () {
        // Arrange - App has been running and cached many themes
        const font = AppFontFamily.inter;
        holder
          ..cachedTheme(ThemeVariantsEnum.light, font)
          ..cachedTheme(ThemeVariantsEnum.dark, font)
          ..cachedTheme(ThemeVariantsEnum.amoled, font);

        // Act - App decides to clear cache for memory management
        ThemeCacheMixin.clearThemeCache();

        // App continues to work normally
        final newTheme = holder.cachedTheme(ThemeVariantsEnum.light, font);

        // Assert - New theme is cached
        final newTheme2 = holder.cachedTheme(ThemeVariantsEnum.light, font);
        expect(identical(newTheme, newTheme2), isTrue);
      });
    });

    group('edge cases', () {
      test('rapid theme switches use cache correctly', () {
        // Arrange
        const font = AppFontFamily.inter;

        // Act - Rapid theme switching
        final themes = <ThemeData>[];
        for (var i = 0; i < 100; i++) {
          final variant =
              ThemeVariantsEnum.values[i % ThemeVariantsEnum.values.length];
          themes.add(holder.cachedTheme(variant, font));
        }

        // Assert - Each variant should have same instance throughout
        for (var i = 0; i < themes.length; i++) {
          final variant =
              ThemeVariantsEnum.values[i % ThemeVariantsEnum.values.length];
          final cachedTheme = holder.cachedTheme(variant, font);
          expect(identical(themes[i], cachedTheme), isTrue);
        }
      });

      test('multiple version bumps in sequence', () {
        // Arrange
        const theme = ThemeVariantsEnum.light;
        const font = AppFontFamily.inter;
        final versions = <ThemeData>[];

        // Act
        for (var i = 0; i < 10; i++) {
          final themeData = holder.cachedTheme(theme, font);
          versions.add(themeData);
          ThemeCacheMixin.bumpTokensVersion();
        }

        // Assert - All versions should be different
        for (var i = 0; i < versions.length; i++) {
          for (var j = i + 1; j < versions.length; j++) {
            expect(identical(versions[i], versions[j]), isFalse);
          }
        }
      });

      test('alternating between cache clear and version bump', () {
        // Arrange
        const theme = ThemeVariantsEnum.dark;
        const font = AppFontFamily.inter;

        // Act & Assert
        final theme1 = holder.cachedTheme(theme, font);

        ThemeCacheMixin.clearThemeCache();
        final theme2 = holder.cachedTheme(theme, font);
        expect(identical(theme1, theme2), isFalse);

        ThemeCacheMixin.bumpTokensVersion();
        final theme3 = holder.cachedTheme(theme, font);
        expect(identical(theme2, theme3), isFalse);

        ThemeCacheMixin.clearThemeCache();
        final theme4 = holder.cachedTheme(theme, font);
        expect(identical(theme3, theme4), isFalse);
      });
    });
  });
}
