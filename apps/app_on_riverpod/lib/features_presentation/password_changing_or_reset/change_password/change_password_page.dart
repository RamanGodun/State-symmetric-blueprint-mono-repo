import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/sign_in_page.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password__provider.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password_form_provider.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_change_password.dart';
part 'x_on_ref_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — Screen that allows the user to update their password.
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
//
final class _ChangePasswordView extends HookWidget {
  ///-------------------------------------------------
  const _ChangePasswordView();

  @override
  Widget build(BuildContext context) {
    //
    final focus = useChangePasswordFocusNodes();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: context.unfocusKeyboard,
          child: FocusTraversalGroup(
            child: ListView(
              shrinkWrap: true,
              children: [
                //
                const _ChangePasswordInfo(),
                _PasswordField(focus: focus),
                _ConfirmPasswordField(focus: focus),
                const _ChangePasswordSubmitButton(),
                //
              ],
            ).withPaddingHorizontal(AppSpacing.l),
          ),
        ),
      ),
    );
  }
}
