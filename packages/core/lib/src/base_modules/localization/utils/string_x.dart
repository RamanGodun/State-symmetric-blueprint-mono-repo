import 'package:core/src/base_modules/localization/core_of_module/init_localization.dart';

/// 🌐 Extension method on nullable [String] to safely translate localization keys.
/// ✅ Returns `null` if the key is null, otherwise uses [AppLocalizer.translateSafely].

/// This extension is useful in UI components like error labels, where
/// the key may be null and we want to avoid boilerplate null checks.

extension TranslateNullableKey on String? {
  ///------------------------------------
  //
  String? get translateOrNull =>
      this == null ? null : AppLocalizer.translateSafely(this!);
  //
}

/// Example:
/// ```dart
/// String? key = 'form.email_is_invalid';
/// String? translated = key?.trOrNull; // => "Invalid email" or null fallback
/// ```
