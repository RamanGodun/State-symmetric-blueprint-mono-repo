import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:core/base_modules/localization.dart'
    show LocaleKeys, TextType, TextWidget;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/ui_design.dart' show AppSpacing;
import 'package:core/shared_layers/presentation.dart' show CustomFilledButton;
import 'package:core/utils.dart';
import 'package:flutter/material.dart';

/// 🧭 [PageNotFound] — generic 404 fallback UI for unknown routes
//
final class PageNotFound extends StatelessWidget {
  ///------------------------------------------
  const PageNotFound({required this.errorMessage, super.key});
  //
  ///
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.xxxm,
          children: [
            const TextWidget(
              LocaleKeys.errors_page_not_found_title,
              TextType.titleMedium,
            ),

            /// 🧨 Error message or fallback description
            TextWidget(
              errorMessage.isNotEmpty
                  ? errorMessage
                  : LocaleKeys.errors_page_not_found_message,
              TextType.error,
              isTextOnFewStrings: true,
            ),

            /// 🏠 Navigation back to home
            CustomFilledButton(
              onPressed: () => context.goTo(RoutesNames.home),
              label: LocaleKeys.buttons_go_to_home,
            ),
          ],
        ).withPaddingAll(AppSpacing.l),
      ),
    );
  }
}
