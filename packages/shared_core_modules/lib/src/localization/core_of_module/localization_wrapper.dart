// ! Example of wrapper, DO NOT delete it!

/*
import 'dart:ui' show Locale;

import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart' show Widget;
import 'package:shared_core_modules/public_api/base_modules/localization.dart' show CodegenLoader;

/// 🌍 [LocalizationWrapper] — Static utility for configuring app-wide localization with EasyLocalization.
///     ✅ Injects all required locale and translation settings.
///     ✅ Used as a single entry-point for wrapping the entire app widget tree.
///     ✅ Ensures consistent locale switching and fallback logic everywhere.
//
abstract final class LocalizationWrapper {
  ///----------------------------------
  LocalizationWrapper._();

  /// 🌐🌍 Supported locales for the app
  static final supportedLocales = [
    const Locale('en'),
    const Locale('uk'),
    const Locale('pl'),
  ];

  /// 🗂️ [localizationPath] — Path to the localization files in assets.
  static const localizationPath = 'assets/translations';

  /// 🏳️ [fallbackLocale] — Fallback locale if no match is found or a translation is missing.
  static const fallbackLocale = Locale('en');

  /// 🏗️ [configure] — Wraps a widget with [EasyLocalization].
  ///     Injects supported locales, fallback locale, translation path, and asset loader.
  ///     Ensures that any widget tree below has full localization context.
  ///     Call this **once** at the top-level (see `[AppLocalizationShell]`).
  static Widget configure(Widget child) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      path: localizationPath,
      fallbackLocale: fallbackLocale,
      assetLoader: const CodegenLoader(),
      child: child,
    );
  }

  //
}

 */
