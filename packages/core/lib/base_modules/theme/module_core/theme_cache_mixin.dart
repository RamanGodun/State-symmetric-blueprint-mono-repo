import 'package:core/base_modules/theme/module_core/theme_variants.dart'
    show ThemeVariantX, ThemeVariantsEnum;
import 'package:core/base_modules/theme/text_theme/text_theme_factory.dart';
import 'package:flutter/material.dart' show ThemeData;

/// 🧩 [ThemeCacheMixin] — Caches ThemeData by (ThemeTypes, FontFamily) pair
//
mixin ThemeCacheMixin {
  static final _cache = <(ThemeVariantsEnum, AppFontFamily), ThemeData>{};

  /// Returns cached [ThemeData] or builds and caches it if missing
  ThemeData cachedTheme(ThemeVariantsEnum theme, AppFontFamily font) {
    final key = (theme, font);
    return _cache.putIfAbsent(key, () => theme.build(font: font));
  }

  /// Optional:
  static void clearThemeCache() => _cache.clear();

  //
}
