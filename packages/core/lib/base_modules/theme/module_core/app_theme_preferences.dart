import 'package:core/base_modules/theme/module_core/theme_variants.dart';
import 'package:core/base_modules/theme/text_theme/text_theme_factory.dart';
import 'package:core/base_modules/theme/widgets_and_utils/theme_cache_mixin.dart';
import 'package:flutter/material.dart';

/// 🎨 [ThemePreferences] — Lightweight configuration for theme and font
/// ✅ Contains only enums: [ThemeVariantsEnum] and [AppFontFamily]
/// 🚫 Does not hold ThemeData directly to prevent unnecessary rebuilds
//
@immutable
final class ThemePreferences with ThemeCacheMixin {
  ///--------------------------------------------
  const ThemePreferences({required this.theme, required this.font});

  /// Selected theme variant (light, dark, glass, amoled)
  final ThemeVariantsEnum theme;

  /// Selected font family (e.g., Montserrat)
  final AppFontFamily font;

  //

  /// Resolves [ThemeMode] based on current theme
  ThemeMode get mode => theme.isDark ? ThemeMode.dark : ThemeMode.light;

  /// Resolves current theme brightness
  bool get isDark => theme.isDark;

  /// Returns light [ThemeData] using cache
  ThemeData buildLight() => cachedTheme(ThemeVariantsEnum.light, font);
  // ThemeData buildLight() =>
  //     cachedTheme(ThemeVariantsEnum.light, ThemeVariantsEnum.light.font);

  /// Returns dark [ThemeData] using cache
  ThemeData buildDark() => cachedTheme(ThemeVariantsEnum.dark, font);
  // ThemeData buildDark() => cachedTheme(theme, ThemeVariantsEnum.dark.font);
  //

  /// Creates a copy with updated fields
  ThemePreferences copyWith({ThemeVariantsEnum? theme, AppFontFamily? font}) {
    return ThemePreferences(
      theme: theme ?? this.theme,
      font: font ?? this.font,
    );
  }

  /// Human-readable label (e.g. "glass · SFProText")
  String get label => '$theme · ${font.value}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemePreferences &&
          runtimeType == other.runtimeType &&
          theme == other.theme &&
          font == other.font;

  @override
  int get hashCode => Object.hash(theme, font);

  //
}
