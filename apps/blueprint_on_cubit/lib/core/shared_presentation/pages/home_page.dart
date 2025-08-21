import 'package:blueprint_on_cubit/core/base_moduls/navigation/routes/app_routes.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/shared_presentation_layer/shared_widgets/app_bar.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:flutter/material.dart';

/// 🏠 [HomePage] — the main landing screen after login.
/// Displays a toggle for theme switching and navigates to profile/settings.
//
final class HomePage extends StatelessWidget {
  ///---------------------------------------
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: LocaleKeys.pages_home,
          actionWidgets: [_GoToProfilePageButton()],
        ),

        body: Center(
          child: const TextWidget(
            LocaleKeys.pages_home_message,
            TextType.bodyLarge,
            isTextOnFewStrings: true,
          ).withPaddingHorizontal(AppSpacing.l),
        ),
      ),
    );
  }
}

////
////

/// 👤 [_GoToProfilePageButton] — Navigates to profile page when pressed
//
final class _GoToProfilePageButton extends StatelessWidget {
  ///------------------------------------------------
  const _GoToProfilePageButton();

  @override
  Widget build(BuildContext context) {
    //
    return IconButton(
      icon: const Icon(Icons.person_2),
      onPressed: () => context.goPushTo(RoutesNames.profile),
    ).withPaddingRight(AppSpacing.l);
  }
}
