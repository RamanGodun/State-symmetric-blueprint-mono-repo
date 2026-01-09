import 'package:flutter/foundation.dart' show debugPrint;

/// 🌐 [LocalizationLogger] – Utility logger for localization-related events.
/// Used for logging missing keys, fallback resolutions, and i18n diagnostics.
//
abstract final class LocalizationLogger {
  //------------------------------------
  const LocalizationLogger._();

  /// 🧭 Logs when a translation key is missing and fallback is used.
  static void missingKey({required String key, required String fallback}) {
    debugPrint('[Localization] 🔍 Missing → "$key". Fallback: "$fallback"');
  }

  /// 💬 Logs when `.tl()` returns a fallback string instead of translation.
  static void fallbackUsed(String key, String fallback) {
    debugPrint('[Localization] 📄 Fallback → "$key" → "$fallback"');
  }

  //
}
