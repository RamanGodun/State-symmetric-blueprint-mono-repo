import 'dart:async' show unawaited;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        EdgeInsets,
        Icon,
        PopupMenuButton,
        StatelessWidget,
        Widget;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show ContextXForOverlays;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppIcons, ThemeXOnContext, WidgetPaddingX;
import 'package:shared_core_modules/src/localization/module_widgets/language_toggle_button/language_option.dart';

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
        unawaited(
          context.setLocale(option.locale).then((_) {
            //
            // 🌟 Show overlay with correct message and icon
            showBanner(
              message: option.messageKey.tr(),
              icon: AppIcons.language,
            );
          }),
        );

        //
      },
    );
  }
}
