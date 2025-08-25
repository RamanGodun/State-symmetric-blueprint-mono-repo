import 'package:core/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart';
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/theme/module_core/theme_variants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specific_for_riverpod/base_modules/theme_providers/theme_provider.dart';

/// 🌗 [ThemePicker] — Allows to pick the theme mode and shows overlay notification
/// Use this widget in both Riverpod or cubit/BLoC apps by toggling the relevant section.
/// Only one block (Riverpod or cubit) should be uncommented at a time.
///
final class ThemePicker extends ConsumerWidget {
  ///--------------------------------------
  const ThemePicker({super.key});
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🟢 RIVERPOD — Uncomment for apps using Riverpod
    final themeConfig = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    /// 🔴 RIVERPOD — Uncomment for apps using cubit/BLoC
    /*
      final themeConfig = context.watch<AppThemecubit>().state;
      final themeNotifier = context.read<AppThemecubit>();
    */

    final locale = Localizations.localeOf(context);

    const variants = [
      ThemeVariantsEnum.light,
      ThemeVariantsEnum.dark,
      ThemeVariantsEnum.amoled,
    ];

    return DropdownButton<ThemeVariantsEnum>(
      key: ValueKey(locale.languageCode),
      value: themeConfig.theme,
      icon: const Icon(Icons.arrow_drop_down),
      underline: const SizedBox(),

      /// 🔄 When user picks a theme
      onChanged: (ThemeVariantsEnum? selected) {
        if (selected == null) return;

        // 🟢 Apply selected theme
        themeNotifier.setTheme(selected);

        // 🏷️ Fetch localized label
        final label = _chosenThemeLabel(context, selected);

        // 🌟 Show overlay banner with confirmation
        context.showUserBanner(message: label, icon: Icons.palette);
      },

      // 🧾 Theme options list
      items: variants
          .map(
            (type) => DropdownMenuItem<ThemeVariantsEnum>(
              value: type,
              child: TextWidget(
                _themeLabel(context, type),
                TextType.titleMedium,
              ),
            ),
          )
          .toList(),
    );
  }

  ////
  ////

  /// 🏷️ Returns localized label for theme in dropdown
  String _themeLabel(BuildContext context, ThemeVariantsEnum type) {
    switch (type) {
      case ThemeVariantsEnum.light:
        return AppLocalizer.translateSafely(LocaleKeys.theme_light);
      case ThemeVariantsEnum.dark:
        return AppLocalizer.translateSafely(LocaleKeys.theme_dark);
      case ThemeVariantsEnum.amoled:
        return AppLocalizer.translateSafely(LocaleKeys.theme_amoled);
    }
  }

  /// 🏷️ Returns localized label for confirmation banner
  String _chosenThemeLabel(BuildContext context, ThemeVariantsEnum type) {
    switch (type) {
      case ThemeVariantsEnum.light:
        return AppLocalizer.translateSafely(LocaleKeys.theme_light_enabled);
      case ThemeVariantsEnum.dark:
        return AppLocalizer.translateSafely(LocaleKeys.theme_dark_enabled);
      case ThemeVariantsEnum.amoled:
        return AppLocalizer.translateSafely(LocaleKeys.theme_amoled_enabled);
    }
  }

  //
}
