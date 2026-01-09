import 'package:flutter/material.dart' show ThemeData;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

/// 🧩 [ThemeCacheMixin] — Caches ThemeData by (ThemeTypes, FontFamily) pair
//
mixin ThemeCacheMixin {
  //
  /// Runtime salt for tokens
  static int _tokensVersion = 0;
  static final _cache = <(ThemeVariantsEnum, AppFontFamily, int), ThemeData>{};

  /// Invalidates all keys without clearing the map explicitly
  static void bumpTokensVersion() {
    _tokensVersion++;
  }

  /// Returns cached [ThemeData] or builds and caches it if missing
  ThemeData cachedTheme(ThemeVariantsEnum theme, AppFontFamily font) {
    final key = (theme, font, _tokensVersion);
    return _cache.putIfAbsent(key, () => theme.build(font: font));
  }

  /// Optional:
  static void clearThemeCache() => _cache.clear();

  //
}

////

/*
e.g. after dynamic seed fetched or user toggles high-contrast mode:

ThemeCacheMixin.bumpTokensVersion();

 */
