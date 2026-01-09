import 'package:flutter/material.dart' show ThemeData, ThemeMode, immutable;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

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

  /// Returns dark [ThemeData] using cache
  ThemeData buildDark() {
    final variant = theme == ThemeVariantsEnum.amoled
        ? ThemeVariantsEnum.amoled
        : ThemeVariantsEnum.dark;
    return cachedTheme(variant, font);
  }

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
