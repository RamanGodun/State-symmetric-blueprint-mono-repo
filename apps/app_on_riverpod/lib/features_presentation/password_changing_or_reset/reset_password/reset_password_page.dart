import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/reset_password__provider.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/reset_password_form_provider.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_reset_password_page.dart';
part 'x_on_ref_for_reset_password.dart';

/// 🔐 [ResetPasswordPage] — screen that allows user to request password reset
/// 📩 Sends reset link to user's email using [resetPasswordProvider]
//
final class ResetPasswordPage extends ConsumerWidget {
  ///------------------------------------------
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // 👂 Declarative listener for success/failure
    ref.listenToResetPassword(context);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: context.unfocusKeyboard,
          child: ListView(
            shrinkWrap: true,
            children: const [
              //
              _ResetPasswordHeader(),

              _ResetPasswordEmailInputField(),
              SizedBox(height: AppSpacing.huge),

              _ResetPasswordSubmitButton(),
              SizedBox(height: AppSpacing.xxxs),

              _ResetPasswordFooter(),
            ],
          ).withPaddingHorizontal(AppSpacing.l),
        ),
      ),
    );
  }
}
