// packages/core/lib/base_modules/theme/widgets/theme_toggler_icon_view.dart
import 'package:flutter/material.dart'
    show BuildContext, Icon, IconButton, StatelessWidget, Widget;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show AppLocalizer, CoreLocaleKeys;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show ContextXForOverlays;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

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
            ? CoreLocaleKeys.theme_light_enabled
            : CoreLocaleKeys.theme_dark_enabled;

        /// 🌟 Show confirmation banner
        showUserBanner(
          message: AppLocalizer.translateSafely(msgKey),
          icon: icon,
        );
      },
    ).withPaddingRight(AppSpacing.xxxm);
  }
}
