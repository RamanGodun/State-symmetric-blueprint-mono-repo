import 'dart:convert' show json;
import 'dart:ui' show Locale;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 🌍 [DualLayerAssetLoader] — Custom AssetLoader that merges translations from two sources.
///     ✅ Loads app-specific translations from `assets/translations/`
///     ✅ Loads core shared translations from `packages/shared_core_modules/assets/translations/`
///     ✅ App translations override core translations if keys conflict
///     ✅ Supports dual-layer localization architecture (CoreLocaleKeys + AppLocaleKeys)
//
final class DualLayerAssetLoader extends AssetLoader {
  ///----------------------------------------------
  const DualLayerAssetLoader({
    required this.appTranslationsPath,
    required this.corePackageName,
  });
  //

  /// 🗂️ Path to app-specific translation files
  final String appTranslationsPath;

  /// 📦 Package name containing core shared translations
  final String corePackageName;

  //

  /// 🔄 [load] — Loads and merges translations from both layers (core + app).
  ///     1. Loads core package translations first
  ///     2. Loads app-specific translations second
  ///     3. Merges them with app translations taking priority
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    //
    final localeStr = locale.toString();

    // 📦 Load core package translations (shared across apps)
    var coreTranslations = <String, dynamic>{};
    try {
      final coreContent = await rootBundle.loadString(
        'packages/$corePackageName/assets/translations/$localeStr.json',
      );
      coreTranslations = json.decode(coreContent) as Map<String, dynamic>;
    } on Exception {
      // Core translations might not exist for all locales - that's okay
    }

    // 📱 Load app-specific translations (override core if needed)
    var appTranslations = <String, dynamic>{};
    try {
      final appContent = await rootBundle.loadString(
        '$appTranslationsPath/$localeStr.json',
      );
      appTranslations = json.decode(appContent) as Map<String, dynamic>;
    } on Exception {
      // App translations might not exist - that's okay
    }

    // 🔀 Merge: app translations override core translations
    return {
      ...coreTranslations,
      ...appTranslations,
    };

    //
  }

  //
}
