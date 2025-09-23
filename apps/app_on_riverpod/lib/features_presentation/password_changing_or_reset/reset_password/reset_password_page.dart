import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/input_fields_provider.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/reset_password__provider.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_reset_password_page.dart';
part 'x_on_ref_for_reset_password.dart';

/// 🔐 [ResetPasswordPage] — Entry point for the request-password feature,
/// 📩 Sends reset link to user's email using [resetPasswordProvider]
//
final class ResetPasswordPage extends ConsumerWidget {
  ///----------------------------------------------
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🔁 Declarative side-effect listener for [ResetPasswordPage]
    ref.listenToResetPassword(context);

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _ResetPasswordView();
  }
}

////
////

/// 🔐 [_ResetPasswordView] — Screen that allows the user to reset password.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordView extends StatelessWidget {
  ///------------------------------------------------
  const _ResetPasswordView();

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          // 🔕 Dismiss keyboard on outside tap
          onTap: context.unfocusKeyboard,
          // used "LayoutBuilder+ConstrainedBox" pattern
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                ///
                child: ListView(
                  children: const [
                    /// ℹ️ Info section for [ResetPasswordPage]
                    _ResetPasswordHeader(),

                    /// 🔒 Password input field
                    _ResetPasswordEmailInputField(),

                    /// 🚀 Primary submit button
                    _ResetPasswordSubmitButton(),

                    /// 🔁 Links to redirect to sign-in screen
                    _WrapperForFooter(),
                  ],
                ).withPaddingHorizontal(AppSpacing.l),
              );
            },
          ),
        ),
      ),
    );
  }
}
