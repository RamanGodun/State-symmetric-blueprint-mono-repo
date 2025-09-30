import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';

/// 🏠 [HomePage] — the main landing screen after login.
/// Displays a toggle for theme switching and navigates to profile/settings.
//
final class HomePage extends StatelessWidget {
  ///----------------------------------
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: const CustomAppBar(
        title: LocaleKeys.pages_home,
        actionWidgets: [_GoToProfilePageButton()],
      ),

      body: Center(
        child: const TextWidget(
          LocaleKeys.pages_home_message,
          TextType.titleMedium,
          isTextOnFewStrings: true,
        ).withPaddingHorizontal(AppSpacing.l),
      ),
    );
  }

  //
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
