import 'dart:ui' show Locale;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' show Widget;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show DualLayerAssetLoader;

/// 🌍 [LocalizationWrapper] — Static utility for configuring app-wide localization with EasyLocalization.
///     ✅ Injects all required locale and translation settings.
///     ✅ Used as a single entry-point for wrapping the entire app widget tree.
///     ✅ Ensures consistent locale switching and fallback logic everywhere.
///     ✅ Dual-layer localization configuration. Configures EasyLocalization to load translations from TWO sources:
///        1. App-specific translations (assets/translations/)
///        2. Core shared translations (packages/shared_core_modules/assets/translations/)
//
abstract final class LocalizationWrapper {
  LocalizationWrapper._();

  /// 🌐 Supported locales for the app
  static const supportedLocales = [
    Locale('en'),
    Locale('uk'),
    Locale('pl'),
  ];

  /// 🗂️ Path to app-specific translation files
  static const appTranslationsPath = 'assets/translations';

  /// 📦 Package name containing core translations
  static const corePackageName = 'shared_core_modules';

  /// 🏳️ Fallback locale if no match is found
  static const fallbackLocale = Locale('en');

  /// 🏗️ [configure] — Wraps a widget with dual-layer [EasyLocalization].
  ///     Injects supported locales, fallback locale, translation path, and asset loader.
  ///     Ensures that any widget tree below has full localization context.
  ///     Call this **once** at the top-level (see `[AppLocalizationShell]`).
  static Widget configure(Widget child) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      path: appTranslationsPath,
      fallbackLocale: fallbackLocale,

      // 🔥 Dual-layer loading: App translations + Core package translations
      assetLoader: const DualLayerAssetLoader(
        appTranslationsPath: appTranslationsPath,
        corePackageName: corePackageName,
      ),

      child: child,
    );
  }
}
