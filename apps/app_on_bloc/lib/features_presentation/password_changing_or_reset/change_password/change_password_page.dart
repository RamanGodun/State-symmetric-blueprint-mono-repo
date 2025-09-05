import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/change_password/cubit/change_password_cubit.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/reset_password/reset_password_page.dart'
    show ResetPasswordPage;
import 'package:bloc_adapter/bloc_adapter.dart' show FormSubmitButton, di;
import 'package:core/base_modules/errors_management.dart';
import 'package:core/base_modules/forms.dart'
    show
        FormValidationService,
        FormzStatusX,
        InputFieldFactory,
        InputFieldType,
        ObscureToggleIcon,
        useChangePasswordFocusNodes;
import 'package:core/base_modules/localization.dart'
    show LocaleKeys, TextType, TextWidget;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/overlays.dart';
import 'package:core/base_modules/ui_design.dart' show AppSpacing;
import 'package:core/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — allows user to request password change
/// 🔁 Declarative side-effect for [ResetPasswordPage]
//
final class ChangePasswordPage extends StatelessWidget {
  ///---------------------------------------
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider(
      create: (_) => ChangePasswordCubit(
        di<PasswordRelatedUseCases>(),
        di<FormValidationService>(),
      ),
      child: MultiBlocListener(
        listeners: [
          /// ❌ Error Listener
          BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionFailure,
            listener: (context, state) {
              final error = state.failure?.consume();
              if (error != null) {
                context.showError(error.toUIEntity());
                context.read<ChangePasswordCubit>().clearFailure();
              }
            },
          ),

          /// ✅ Success Listener
          BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionSuccess,
            listener: (context, state) {
              context
                ..showSnackbar(message: LocaleKeys.change_password_success)
                // 🧭 Navigation after success
                ..goTo(RoutesNames.home);
            },
          ),
        ],

        child: const _ChangePasswordView(),
      ),
    );
  }
}

/// 🔐 [_ChangePasswordView] — Screen that allows the user to update their password.
//
final class _ChangePasswordView extends HookWidget {
  ///-------------------------------------------
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
                _PasswordField(focusNodes: focus),
                _ConfirmPasswordField(focusNodes: focus),
                const _ChangePasswordSubmitButton(),
                //
              ],
            ).withPaddingHorizontal(AppSpacing.l),
          ),
        ),
      ),
    );
  }

  //
}
