import 'package:core/src/base_modules/localization/module_widgets/language_toggle_button/language_option.dart';
import 'package:core/src/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/src/utils_shared/extensions/extension_on_widget/_widget_x.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// 🌐🌍 [LanguageToggleButton] — macOS-style drop-down with flag + native text

final class LanguageToggleButton extends StatelessWidget {
  ///--------------------------------------------------
  const LanguageToggleButton({super.key});
  //

  @override
  Widget build(BuildContext context) {
    //
    final currentLangCode = context.locale.languageCode;

    return PopupMenuButton<LanguageOption>(
      padding: EdgeInsets.zero,
      icon: Icon(
        AppIcons.language,
        color: context.colorScheme.primary,
      ).withPaddingOnly(right: 20),
      itemBuilder: (_) => LanguageOption.values
          .map((e) => e.toMenuItem(currentLangCode))
          .toList(),

      onSelected: (option) {
        final showBanner = context.showUserBanner;

        //  🌐🌍 Change localization
        context.setLocale(option.locale).then((_) {
          //
          // 🌟 Show overlay with correct message and icon
          showBanner(message: option.messageKey.tr(), icon: AppIcons.language);
        });

        //
      },
    );
  }
}
