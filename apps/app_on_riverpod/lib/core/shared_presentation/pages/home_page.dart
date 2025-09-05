import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:core/base_modules/localization.dart'
    show LocaleKeys, TextType, TextWidget;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/ui_design.dart' show AppSpacing;
import 'package:core/shared_layers/presentation.dart' show CustomAppBar;
import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🏠 [HomePage] — the main landing screen after login.
/// Displays a toggle for theme switching and navigates to profile/settings.
//
final class HomePage extends ConsumerWidget {
  ///----------------------------------
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return Scaffold(
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
