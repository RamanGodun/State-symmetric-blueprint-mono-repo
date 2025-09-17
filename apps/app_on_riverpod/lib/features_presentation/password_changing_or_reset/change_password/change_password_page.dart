import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password__provider.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password_form_provider.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'errors_listener.dart';
part 'widgets_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — Entry point for the sign-up feature,
/// 🧾 that allows user to request password change
//
final class ChangePasswordPage extends ConsumerWidget {
  ///-------------------------------------------
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🔁 Declarative side-effect listener for [ChangePasswordPage]
    ref.listenToPasswordChange(context);

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _ChangePasswordView();
  }
}

////
////

/// 🔐 [_ChangePasswordView] — Screen that allows the user to update their password.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ChangePasswordView extends HookWidget {
  ///--------------------------------------------
  const _ChangePasswordView();

  @override
  Widget build(BuildContext context) {
    //
    final focusNodes = useChangePasswordFocusNodes();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GestureDetector(
          // 🔕 Dismiss keyboard on outside tap
          onTap: context.unfocusKeyboard,
          // used "LayoutBuilder+ConstrainedBox" pattern
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: FocusTraversalGroup(
                  ///
                  child: ListView(
                    children: [
                      /// ℹ️ Info section for [ChangePasswordPage]
                      const _ChangePasswordInfo(),

                      /// 🔒 Password input field
                      _PasswordInputField(focusNodes),

                      /// 🔐 Confirm password input
                      _ConfirmPasswordInputField(focusNodes),

                      /// 🚀 Primary submit button
                      const _ChangePasswordSubmitButton(),
                      //
                    ],
                  ).withPaddingHorizontal(AppSpacing.l),
                  //
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
