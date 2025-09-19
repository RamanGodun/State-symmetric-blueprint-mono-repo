part of 'change_password__page.dart';

/// ℹ️ Info section for [ChangePasswordPage]
/// ✅ Same widget used in Riverpod app for perfect parity
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

/// 🧾 [_PasswordInputField] — input for the new password
//
final class _PasswordInputField extends StatelessWidget {
  ///-------------------------------------------
  const _PasswordInputField(this.focusNodes);
  //
  final ({FocusNode password, FocusNode confirmPassword}) focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final formCubit = context.read<ChangePasswordFormFieldsCubit>();

    return BlocSelector<
      ChangePasswordFormFieldsCubit,
      ChangePasswordFormState,
      FieldUiState
    >(
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
            onPressed: formCubit.togglePasswordVisibility,
          ),
          //
          onChanged: formCubit.onPasswordChanged,
          onSubmitted: focusNodes.confirmPassword.requestFocus,
          //
        ).withPaddingBottom(AppSpacing.m);
      },
    );
  }
}

////
////

/// 🧾 [_ConfirmPasswordInputField] — confirmation input
//w
final class _ConfirmPasswordInputField extends StatelessWidget {
  ///---------------------------------------------------
  const _ConfirmPasswordInputField(this.focusNodes);
  //
  final ({FocusNode password, FocusNode confirmPassword}) focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final formCubit = context.read<ChangePasswordFormFieldsCubit>();

    return BlocSelector<
      ChangePasswordFormFieldsCubit,
      ChangePasswordFormState,
      (String?, bool, bool)
    >(
      selector: (s) =>
          (s.confirmPassword.uiErrorKey, s.isConfirmPasswordObscure, s.isValid),
      builder: (context, field) {
        final (errorText, isObscure, isValid) = field;

        return InputFieldFactory.create(
          type: InputFieldType.confirmPassword,
          focusNode: focusNodes.confirmPassword,
          errorText: errorText,
          //
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.toggleConfirmPasswordVisibility,
          ),
          //
          onChanged: formCubit.onConfirmPasswordChanged,
          onSubmitted: isValid
              ? () {
                  final password = context
                      .read<ChangePasswordFormFieldsCubit>()
                      .state
                      .password
                      .value;
                  context.read<ChangePasswordCubit>().submit(password);
                }
              : null,
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
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );

    return BlocBuilder<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
      buildWhen: (prev, cur) => prev.isValid != cur.isValid,
      builder: (context, form) {
        //
        final isLoading = context.select<ChangePasswordCubit, bool>(
          (cubit) => cubit.state.isLoading,
        );
        final isEnabled = form.isValid && !isLoading && !isOverlayActive;

        return CustomFilledButton(
          label: isLoading
              ? LocaleKeys.buttons_submitting
              : LocaleKeys.change_password_title,
          isLoading: isLoading,
          isEnabled: isEnabled,
          onPressed: isEnabled
              ? () {
                  context.unfocusKeyboard();
                  final pwd = form.password.value;
                  context.read<ChangePasswordCubit>().submit(pwd);
                }
              : null,
        );
      },
    ).withPaddingBottom(AppSpacing.l);
  }
}
