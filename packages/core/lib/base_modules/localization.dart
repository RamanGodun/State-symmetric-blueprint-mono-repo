/// 🌍 Localization Module — barrel exports
// ignore_for_file: combinators_ordering, directives_ordering
library;

//
// ─── CORE API (init + wrapper) ────────────────────────────────────────────────
//
export '../src/base_modules/localization/core_of_module/init_localization.dart'
    show AppLocalizer;
export '../src/base_modules/localization/core_of_module/localization_wrapper.dart'
    show LocalizationWrapper;

//
// ─── GENERATED (keys/loader) ─────────────────────────────────────────────────
//  Use only LocaleKeys in app code; CodegenLoader is used by LocalizationWrapper.
export '../src/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
export '../src/base_modules/localization/generated/codegen_loader.g.dart'
    show CodegenLoader;

//
// ─── MODULE WIDGETS ──────────────────────────────────────────────────────────
//
export '../src/base_modules/localization/module_widgets/text_widget.dart'
    show TextWidget, TextType;
export '../src/base_modules/localization/module_widgets/language_toggle_button/language_option.dart'
    show LanguageOption;
export '../src/base_modules/localization/module_widgets/language_toggle_button/toggle_button.dart'
    show LanguageToggleButton;

//
// ─── UTILS & FALLBACKS ───────────────────────────────────────────────────────
//
export '../src/base_modules/localization/utils/localization_logger.dart'
    show LocalizationLogger;
export '../src/base_modules/localization/without_localization_case/app_strings.dart'
    show AppStrings;
export '../src/base_modules/localization/without_localization_case/fallback_keys.dart'
    show LocalesFallbackMapper, FallbackKeysForErrors;

/// Generated
export '../src/base_modules/localization/generated/locale_keys.g.dart';
