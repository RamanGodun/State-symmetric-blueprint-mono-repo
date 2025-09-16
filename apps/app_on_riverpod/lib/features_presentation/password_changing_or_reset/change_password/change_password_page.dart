import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_provider.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password__provider.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password_form_provider.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — Entry point for the sign-up feature,
/// 🧾 that allows user to request password change
//
final class ChangePasswordPage extends HookConsumerWidget {
  ///-------------------------------------------
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // 🔁 Declarative side-effect for ChangePassword
    ref.listenToPasswordChange(context);

    return const _ChangePasswordView();
  }

  //
}

////
////

/// 🔐 [_ChangePasswordView] — Screen that allows the user to update their password.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ChangePasswordView extends HookWidget {
  ///-------------------------------------------------
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

////
////

/// 🛡️ [PasswordChangeRefX] — handles side-effects for Change Password flow.
//
extension PasswordChangeRefX on WidgetRef {
  ///---------------------------------------------
  //
  /// Encapsulates success, error, and retry handling.
  ///   - ✅ On success: shows success snackbar and navigates home.
  ///   - ❌ On failure: shows localized error.
  ///   - 🔄 On "requires-recent-login" error: triggers reauthentication flow and retries on success.
  void listenToPasswordChange(BuildContext context) {
    listen<ChangePasswordState>(changePasswordProvider, (prev, next) async {
      switch (next) {
        ///
        // ✅ On success
        case ChangePasswordSuccess(:final message):
          context.showUserSnackbar(message: message);
          // 🧭 Navigation after success
          context.goIfMounted(RoutesNames.home);

        /// ❌ On error
        case ChangePasswordError(:final failure):
          context.showError(failure.toUIEntity());

        /// 🔄 On reauth
        case ChangePasswordRequiresReauth(:final failure):
          context.showError(
            failure.toUIEntity(),
            onConfirm: () {
              read(signOutProvider.notifier).signOut().whenComplete(() {
                context.goIfMounted(RoutesNames.signIn);
              });
            },
          );

        ///
        default:
          break;
      }
    });
  }

  //
}
