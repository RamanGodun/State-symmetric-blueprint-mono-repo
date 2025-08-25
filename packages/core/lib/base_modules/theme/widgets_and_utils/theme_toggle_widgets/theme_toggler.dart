import 'package:core/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart';
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specific_for_riverpod/theme_providers/theme_provider.dart';

/// 🌗 [ThemeTogglerIcon] — toggles between light and dark mode and shows overlay notification
/// ✅ Supports both Riverpod and cubit
/// Just toggle comments the appropriate block below 👇
//
final class ThemeTogglerIcon extends ConsumerWidget {
  ///-----------------------------------------
  const ThemeTogglerIcon({super.key});
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// * 🟢 For RIVERPOD apps — uncomment this block
    final wasDark = ref.watch(themeProvider).theme.isDark;

    /// * 🔴 For cubit/BLoC apps — uncomment this block
    /*
      final wasDark = context.select<AppThemecubit, bool>(
         (cubit) => cubit.state.theme.isDark);
    */

    final icon = wasDark ? AppIcons.lightMode : AppIcons.darkMode;
    final iconColor = context.colorScheme.primary;

    return IconButton(
      icon: Icon(icon, color: iconColor),

      onPressed: () {
        /// 🕹️🔄 Toggles the theme between light and dark mode.
        ref.read(themeProvider.notifier).toggleTheme();

        final msgKey = wasDark
            ? LocaleKeys.theme_light_enabled
            : LocaleKeys.theme_dark_enabled;
        final message = AppLocalizer.translateSafely(msgKey);

        // 🌟 Show overlay with correct message and icon
        context.showUserBanner(message: message, icon: icon);

        //
      },
    ).withPaddingRight(AppSpacing.xxxm);
  }
}
