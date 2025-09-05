// packages/core/lib/base_modules/design_system.dart
// ignore_for_file: directives_ordering

// 🖌️ Barrel file: Design System
// Provides a unified entry point for theming, typography, UI constants, and design widgets.
//
// 📦 Contents:
//  • Core theme configs & caching
//  • Typography factories & text themes
//  • Design constants (colors, spacing, icons, etc.)
//  • Utility widgets (blur, barriers, inherited props)
//  • Box decorations for Android/iOS
//  • Theme extensions & switchers

// ─── Module Core: theme configuration & caching ──────────────
export 'package:core/src/base_modules/ui_design/module_core/app_theme_preferences.dart';
export 'package:core/src/base_modules/ui_design/module_core/theme__variants.dart';
export 'package:core/src/base_modules/ui_design/module_core/theme_cache_mixin.dart';

// ─── Text Theme: font families, parsers, factories ───────────
export 'package:core/src/base_modules/ui_design/text_theme/text_theme_factory.dart';

// ─── UI Constants: design tokens ─────────────────────────────
// _app_constants.dart may contain internal constants, but is exported here for flexibility
export 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart';
export 'package:core/src/base_modules/ui_design/ui_constants/app_colors.dart';

// ─── Utility Widgets ─────────────────────────────────────────
export 'package:core/src/base_modules/ui_design/widgets_and_utils/barrier_filter.dart';
export 'package:core/src/base_modules/ui_design/widgets_and_utils/blur_wrapper.dart';

// ─── Box Decorations (platform-specific design tokens) ───────
// _box_decorations_factory.dart is exported to allow extension
export 'package:core/src/base_modules/ui_design/widgets_and_utils/box_decorations/_box_decorations_factory.dart';

// ─── Theme Extensions (helpers on ThemeData, TextStyle, etc.) ─
export 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/text_style_x.dart';
export 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_mode_x.dart';
export 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';

// ─── Inherited Props (theme injection) ───────────────────────
export 'package:core/src/base_modules/ui_design/widgets_and_utils/theme_props_inherited_w.dart';

// ─── Theme Switchers (UI controls for switching themes) ──────
export 'package:core/src/base_modules/ui_design/widgets_and_utils/theme_switchers/theme_picker.dart';
export 'package:core/src/base_modules/ui_design/widgets_and_utils/theme_switchers/theme_toggler_icon.dart';
