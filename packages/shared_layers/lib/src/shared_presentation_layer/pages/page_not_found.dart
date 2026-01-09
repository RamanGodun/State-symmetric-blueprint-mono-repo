import 'package:flutter/material.dart'
    show
        BuildContext,
        Center,
        Column,
        Scaffold,
        StatelessWidget,
        VoidCallback,
        Widget;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show CoreLocaleKeys;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppSpacing, WidgetPaddingX;
import 'package:shared_utils/public_api/general_utils.dart'
    show NullableStringX;
import 'package:shared_widgets/public_api/buttons.dart' show CustomFilledButton;
import 'package:shared_widgets/public_api/text_widgets.dart'
    show TextType, TextWidget;

/// 🧭 [PageNotFound] — generic 404 fallback UI for unknown routes
//
final class PageNotFound extends StatelessWidget {
  ///------------------------------------------
  const PageNotFound({
    required this.onGoHome,
    this.errorPageTitle,
    this.errorMessage,
    super.key,
  });

  /// Optional page title override.
  /// If `null` or empty — fallback localization key is used.
  final String? errorPageTitle;

  /// Optional error description.
  /// If `null` or empty — fallback localization key is used.
  final String? errorMessage;

  /// 🏠 Navigation callback (injected from outside)
  /// Keeps widget independent from any navigation solution.
  final VoidCallback onGoHome;

  ///
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          spacing: AppSpacing.xxxm,
          children: [
            TextWidget(_resolvedPageTitle, TextType.titleMedium),

            /// 🧨 Error message or fallback description
            TextWidget(
              _resolvedErrorMessage,
              TextType.error,
              isTextOnFewStrings: true,
            ),

            /// 🏠 Navigation back to home
            CustomFilledButton(
              onPressed: onGoHome,
              label: CoreLocaleKeys.buttons_go_to_home,
            ),
          ],
        ).withPaddingAll(AppSpacing.l),
      ),
    );
  }

  ///------------------------------------------
  /// 🧠 Resolved values
  ///------------------------------------------

  /// Returns provided title or default localization key.
  String get _resolvedPageTitle =>
      errorPageTitle.orLocale(CoreLocaleKeys.errors_page_not_found_title);

  /// Returns provided message or default localization key.
  String get _resolvedErrorMessage =>
      errorMessage.orLocale(CoreLocaleKeys.errors_page_not_found_message);
  //
}
