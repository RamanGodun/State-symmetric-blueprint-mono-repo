/// 🌍 Localization Module — barrel exports
// ignore_for_file: combinators_ordering, directives_ordering
library;

//
// ─── CORE API (init + wrapper) ────────────────────────────────────────────────
//
export 'core_of_module/init_localization.dart' show AppLocalizer;
export 'core_of_module/localization_wrapper.dart' show LocalizationWrapper;

//
// ─── GENERATED (keys/loader) ─────────────────────────────────────────────────
//  Use only LocaleKeys in app code; CodegenLoader is used by LocalizationWrapper.
export 'generated/locale_keys.g.dart' show LocaleKeys;
export 'generated/codegen_loader.g.dart' show CodegenLoader;

//
// ─── MODULE WIDGETS ──────────────────────────────────────────────────────────
//
export 'module_widgets/text_widget.dart' show TextWidget, TextType;
export 'module_widgets/language_toggle_button/language_option.dart'
    show LanguageOption;
export 'module_widgets/language_toggle_button/toggle_button.dart'
    show LanguageToggleButton;

//
// ─── UTILS & FALLBACKS ───────────────────────────────────────────────────────
//
export 'utils/localization_logger.dart' show LocalizationLogger;
export 'without_localization_case/app_strings.dart' show AppStrings;
export 'without_localization_case/fallback_keys.dart'
    show LocalesFallbackMapper, FallbackKeysForErrors;
