import 'package:core/src/base_modules/localization/utils/localization_logger.dart';
import 'package:core/src/base_modules/localization/without_localization_case/fallback_keys.dart';

/// 🌍 [AppLocalizer] — Singleton for global translation resolution.
///   ✅ Centralizes all translation lookups for the app.
///   ✅ Provides safe fallback if no translation is found.
///   ✅ Supports both EasyLocalization and fallback-only modes.
///   ✅ Used in widgets, validation, and any string localization flow.
//
abstract final class AppLocalizer {
  ///-----------------------------

  static String Function(String key)? _resolver;

  /// 🌐 Resolves a translation key or returns fallback
  static String translateSafely(String key, {String? fallback}) {
    final value = _resolver?.call(key);
    final resolved = value == null || value == key;
    if (resolved) {
      LocalizationLogger.fallbackUsed(key, fallback ?? key);
      return fallback ?? key;
    }
    return value;
  }

  /// 🧩 Initializes the resolver (once)
  static void init({required String Function(String key) resolver}) {
    if (_resolver != null) return; // ⛔ prevent double initialization
    _resolver = resolver;
  }

  /// ✅ Use this instead of [AppLocalizer.init] when EasyLocalization is not available
  /// 🔁 All missing keys will fall back to [LocalesFallbackMapper]
  static void initWithFallback() {
    AppLocalizer.init(
      resolver: LocalesFallbackMapper.resolveFallback,
    );
  }

  /// 🔁 Forcefully overrides the resolver (used in testing or switching at runtime)
  // We intentionally keep a method-style API for symmetry with `init`
  // and to avoid breaking existing call sites in the demo.
  // ignore: use_setters_to_change_properties
  static void forceInit({required String Function(String key) resolver}) {
    _resolver = resolver;
  }

  /// 🧪 Internal check (used in debug/tests)
  static bool get isInitialized => _resolver != null;

  //
}
