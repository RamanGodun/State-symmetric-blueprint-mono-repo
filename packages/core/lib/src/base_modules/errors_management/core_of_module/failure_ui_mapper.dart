import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';
import 'package:core/src/base_modules/errors_management/core_of_module/failure_ui_entity.dart';
import 'package:core/src/base_modules/errors_management/extensible_part/failure_extensions/failure_icons_x.dart';
import 'package:core/src/base_modules/localization/core_of_module/init_localization.dart'
    show AppLocalizer;
import 'package:core/src/base_modules/localization/utils/localization_logger.dart'
    show LocalizationLogger;

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
