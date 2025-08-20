import 'package:blueprint_on_qubit/core/base_moduls/navigation/routes/app_routes.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/shared_presentation_layer/shared_widgets/buttons/filled_button.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:flutter/material.dart';

/// 🧭 [PageNotFound] — generic 404 fallback UI for unknown routes
//
final class PageNotFound extends StatelessWidget {
  ///------------------------------------------
  const PageNotFound({required this.errorMessage, super.key});

  ///
  final String errorMessage;

  ///

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
