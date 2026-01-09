import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show FailureIconX;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show AppLocalizer, LocalizationLogger;
import 'package:shared_core_modules/src/errors_management/core_of_module/failure_entity.dart'
    show Failure;
import 'package:shared_core_modules/src/errors_management/core_of_module/failure_ui_entity.dart'
    show FailureUIEntity;

/// ✅ [FailureToUIEntityX] — Maps domain-level [Failure] to a presentational [FailureUIEntity]
/// ✅ Provides safe localization fallback and diagnostics logging
/// ✅ Ensures consistent UI rendering with localized text, error code, and icon
//
extension FailureToUIEntityX on Failure {
  ///
  FailureUIEntity toUIEntity() {
    final hasTranslation = type.translationKey.isNotEmpty;
    final hasMessage = message?.isNotEmpty ?? false;

    /// 🧩 Resolved text with localization and fallback
    final resolvedText = switch ((hasTranslation, hasMessage)) {
      (true, true) => AppLocalizer.translateSafely(
        type.translationKey,
        fallback: message,
      ),
      (true, false) => AppLocalizer.translateSafely(type.translationKey),
      (false, true) => message!,
      _ => type.code,
    };

    if (hasTranslation && resolvedText == message) {
      LocalizationLogger.fallbackUsed(type.translationKey, message!);
    }

    return FailureUIEntity(
      localizedMessage: resolvedText,
      formattedCode: safeCode,
      icon: type.icon,
    );
  }
}
