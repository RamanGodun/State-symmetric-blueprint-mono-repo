part of 'change_password_page.dart';

/// ℹ️ Info section for [ChangePasswordPage]
//
final class _ChangePasswordInfo extends StatelessWidget {
  ///-------------------------------------------------
  const _ChangePasswordInfo();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const SizedBox(height: AppSpacing.massive),
        const TextWidget(
          LocaleKeys.change_password_title,
          TextType.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.xxxs),
        const TextWidget(
          LocaleKeys.change_password_warning,
          TextType.bodyMedium,
        ),
        Text.rich(
          TextSpan(
            text: LocaleKeys.change_password_prefix.tr(),
            style: const TextStyle(fontSize: 16),
            children: [
              TextSpan(
                text: LocaleKeys.change_password_signed_out.tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).withPaddingOnly(top: AppSpacing.xxl, bottom: AppSpacing.xxxm);
  }
}

////

////

/// 🧾 [_PasswordField] — input for the new password
//
final class _PasswordField extends StatelessWidget {
  ///-------------------------------------------
  const _PasswordField({required this.focusNodes});
  //
  final ({FocusNode password, FocusNode confirmPassword}) focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final changePasswordcubit = context.read<ChangePasswordCubit>();

    return BlocSelector<ChangePasswordCubit, ChangePasswordState, FieldUiState>(
      selector: (state) => (
        errorText: state.password.uiErrorKey,
        isObscure: state.isPasswordObscure,
      ),
      builder: (context, field) {
        final (errorText: errorText, isObscure: isObscure) = field;

        return InputFieldFactory.create(
          type: InputFieldType.password,
          focusNode: focusNodes.password,
          errorText: errorText,
          //
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: changePasswordcubit.togglePasswordVisibility,
          ),
          //
          onChanged: changePasswordcubit.onPasswordChanged,
          onSubmitted: focusNodes.confirmPassword.requestFocus,
          //
        ).withPaddingBottom(AppSpacing.m);
      },
    );
  }
}

////

////

/// 🧾 [_ConfirmPasswordField] — confirmation input
//
final class _ConfirmPasswordField extends StatelessWidget {
  ///---------------------------------------------------
  const _ConfirmPasswordField({required this.focusNodes});
  //
  final ({FocusNode password, FocusNode confirmPassword}) focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final changePasswordcubit = context.read<ChangePasswordCubit>();

    return BlocSelector<ChangePasswordCubit, ChangePasswordState, FieldUiState>(
      selector: (state) => (
        errorText: state.confirmPassword.uiErrorKey,
        isObscure: state.isConfirmPasswordObscure,
      ),
      builder: (context, field) {
        final (errorText: errorText, isObscure: isObscure) = field;

        return InputFieldFactory.create(
          type: InputFieldType.confirmPassword,
          focusNode: focusNodes.confirmPassword,
          errorText: errorText,
          //
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: changePasswordcubit.toggleConfirmPasswordVisibility,
          ),
          //
          onChanged: changePasswordcubit.onConfirmPasswordChanged,
          onSubmitted: changePasswordcubit.submit,
          //
        ).withPaddingBottom(AppSpacing.xxxl);
      },
    );
  }
}

////

////

/// 🔐 [_ChangePasswordSubmitButton] — dispatches the password change request
/// 📤 Submits new password when form is valid
//
final class _ChangePasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ChangePasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return FormSubmitButton<ChangePasswordCubit, ChangePasswordState>(
      label: LocaleKeys.change_password_title,
      onPressed: (context) {
        context.unfocusKeyboard();
        context.read<ChangePasswordCubit>().submit();
      },
      statusSelector: (state) => state.status,
      isValidatedSelector: (state) => state.isValid,
    );
  }
}
