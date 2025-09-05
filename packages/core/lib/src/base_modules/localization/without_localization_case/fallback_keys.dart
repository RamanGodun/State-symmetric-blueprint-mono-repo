// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'dart:collection' show UnmodifiableMapView;
import 'package:core/src/base_modules/localization/core_of_module/init_localization.dart'
    show AppLocalizer;

/// 🧭 [LocalesFallbackMapper] — centralized fallback translation resolver
/// ✅ Used when localization module (EasyLocalization) is **not initialized**
/// ✅ Acts as a mini key-value dictionary to resolve known failure keys
/// ✅ Complements [AppLocalizer] in "headless" fallback mode
//
abstract final class LocalesFallbackMapper {
  ///------------------------------------
  LocalesFallbackMapper._();
  //

  /// 🗺️ Immutable fallback map of translation keys → hardcoded localized messages
  static final UnmodifiableMapView<String, String> _fallbackMap =
      UnmodifiableMapView(<String, String>{
        //
        'failure.auth.unauthorized': FallbackKeysForErrors.unauthorized,
        'failure.firebase.generic': FallbackKeysForErrors.firebaseGeneric,
        'failure.format.error': FallbackKeysForErrors.formatError,
        'failure.network.no_connection': FallbackKeysForErrors.noInternet,
        'failure.network.timeout': FallbackKeysForErrors.timeout,
        'failure.plugin.missing': FallbackKeysForErrors.pluginMissing,
        'failure.unknown': FallbackKeysForErrors.unexpected,
        // 🧩 Add more fallback keys as needed
        //...
      });

  /// 📦 Resolves a translation key to a fallback message (or returns key itself)
  static String resolveFallback(String key) => _fallbackMap[key] ?? key;

  //
}

////

////

/// 🧩 [FallbackKeysForErrors] — fallback keys when localization is not used.
/// ✅ Serves as simple storage of UI fallback strings.
//
abstract final class FallbackKeysForErrors {
  ///------------------------------------
  const FallbackKeysForErrors._();
  //

  /// ⚠️ Overlay + Failure error messages
  static const unexpected = 'Something went wrong';
  static const noInternet = 'No internet connection';
  static const timeout = 'Request timeout. Try again.';
  static const unauthorized = 'Access denied. Please log in.';
  static const firebaseGeneric = 'A Firebase error occurred.';
  static const formatError = 'Invalid data format received.';
  static const pluginMissing = 'Required plugin is missing';

  //
}
