// packages/core/lib/base_modules/theme/widgets/theme_toggler_icon_view.dart
import 'package:core/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart';
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:flutter/material.dart';

/// 🌗 [ThemeTogglerIconView] — toggles between light and dark mode and shows overlay notification
/// ✅ Supports both Riverpod and Cubit
/// ❌ No direct knowledge of Cubit/Riverpod — only props.
///
final class ThemeTogglerIconView extends StatelessWidget {
  ///--------------------------------------------------
  const ThemeTogglerIconView({
    required this.isDark,
    required this.onToggle,
    super.key,
  });

  /// Current theme state flag: true = dark, false = light
  final bool isDark;

  /// Delegated handler for toggling theme (provided by Cubit/Riverpod wrapper)
  final Future<void> Function() onToggle;

  @override
  Widget build(BuildContext context) {
    /// 🎨 Pick icon based on theme
    final icon = isDark ? AppIcons.lightMode : AppIcons.darkMode;
    final iconColor = context.colorScheme.primary;

    /// to avoid async gaps
    final showUserBanner = context.showUserBanner;

    return IconButton(
      icon: Icon(icon, color: iconColor),

      /// 🕹️ Trigger theme toggle
      onPressed: () async {
        await onToggle();

        /// 🏷️ Compose banner message
        final msgKey = isDark
            ? LocaleKeys.theme_light_enabled
            : LocaleKeys.theme_dark_enabled;

        /// 🌟 Show confirmation banner
        showUserBanner(
          message: AppLocalizer.translateSafely(msgKey),
          icon: icon,
        );
      },
    ).withPaddingRight(AppSpacing.xxxm);
  }
}
