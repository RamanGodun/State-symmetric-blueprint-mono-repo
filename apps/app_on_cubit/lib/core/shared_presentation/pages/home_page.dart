import 'package:app_on_cubit/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Center,
        Icon,
        IconButton,
        Icons,
        PopScope,
        Scaffold,
        StatelessWidget,
        Widget;
import 'package:shared_core_modules/public_api/base_modules/navigation.dart'
    show NavigationX;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppSpacing, WidgetPaddingX;
import 'package:shared_widgets/public_api/bars.dart' show CustomAppBar;
import 'package:shared_widgets/public_api/text_widgets.dart'
    show TextType, TextWidget;

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
          title: AppLocaleKeys.pages_home,
          actionWidgets: [_GoToProfilePageButton()],
        ),

        body: Center(
          child: const TextWidget(
            AppLocaleKeys.pages_home_message,
            TextType.titleMedium,
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
