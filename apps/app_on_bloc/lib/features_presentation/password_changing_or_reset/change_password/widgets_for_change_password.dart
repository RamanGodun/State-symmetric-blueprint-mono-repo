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
      FormFieldUiState
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
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.togglePasswordVisibility,
          ),
          //
          onChanged: formCubit.onPasswordChanged,
          onEditingComplete: context.focusNext(focusNodes.confirmPassword),
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
    final formCubitState = formCubit.state;

    return BlocSelector<
      ChangePasswordFormFieldsCubit,
      ChangePasswordFormState,
      (String?, bool, bool)
    >(
      selector: (state) => (
        state.confirmPassword.uiErrorKey,
        state.isConfirmPasswordObscure,
        state.isValid,
      ),
      builder: (context, field) {
        final (errorText, isObscure, isValid) = field;

        return InputFieldFactory.create(
          type: InputFieldType.confirmPassword,
          focusNode: focusNodes.confirmPassword,
          errorText: errorText,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.toggleConfirmPasswordVisibility,
          ),
          //
          onChanged: formCubit.onConfirmPasswordChanged,
          onEditingComplete: () {
            if (formCubitState.isValid) {
              context.read<ChangePasswordCubit>().submit(
                formCubitState.password.value,
              );
            }
          },
          //
        ).withPaddingBottom(AppSpacing.xxxl);
      },
    );
  }
}

////
////

/// 🔐 [_ChangePasswordSubmitButton] — dispatches the password change request
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [UniversalSubmitButton]
//
final class _ChangePasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ChangePasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    final formState = context.read<ChangePasswordFormFieldsCubit>().state;
    //
    return UniversalSubmitButton<
          ChangePasswordFormFieldsCubit,
          ChangePasswordFormState,
          ChangePasswordCubit
        >(
          label: LocaleKeys.change_password_title,
          loadingLabel: LocaleKeys.buttons_submitting,
          isFormValid: (state) => state.isValid,
          //
          onPressed: () =>
              context.unfocusKeyboard().read<ChangePasswordCubit>().submit(
                formState.password.value,
              ),
          //
        )
        .withPaddingBottom(AppSpacing.l);
  }
}
