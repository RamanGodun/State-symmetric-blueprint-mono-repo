import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/reset_password/cubits/reset_password_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart' show FormSubmitButton, di;
import 'package:core/base_modules/errors_management.dart';
import 'package:core/base_modules/forms.dart'
    show
        FormValidationService,
        FormzStatusX,
        InputFieldFactory,
        InputFieldType,
        useResetPasswordFocusNodes;
import 'package:core/base_modules/localization.dart'
    show LocaleKeys, TextType, TextWidget;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/overlays.dart';
import 'package:core/base_modules/ui_design.dart' show AppSpacing;
import 'package:core/shared_layers/presentation.dart' show AppTextButton;
import 'package:core/utils.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart' show FormzSubmissionStatus;

part 'widgets_for_reset_password_page.dart';

/// 🔐 [ResetPasswordPage] — allows user to request password reset
/// 🔁 Declarative side-effect for [ResetPasswordPage]
//
final class ResetPasswordPage extends StatelessWidget {
  ///---------------------------------------
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider(
      create: (_) => ResetPasswordCubit(
        di<PasswordRelatedUseCases>(),
        di<FormValidationService>(),
      ),
      child: MultiBlocListener(
        listeners: [
          /// ❌ Error Listener
          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionFailure,
            listener: (context, state) {
              final error = state.failure?.consume();
              if (error != null) {
                context.showError(error.toUIEntity());
                context.read<ResetPasswordCubit>().clearFailure();
              }
            },
          ),

          /// ✅ Success Listener
          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionSuccess,
            listener: (context, state) {
              context
                ..showSnackbar(message: LocaleKeys.reset_password_success)
                // 🧭 Navigation after success
                ..goTo(RoutesNames.signIn);
            },
          ),
        ],

        child: const _ResetPasswordView(),
      ),
    );
  }
}

/// 🔐 [_ResetPasswordView] — screen that allows user to request password reset
/// 📩 Sends reset link to user's email using [ResetPasswordCubit]
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
