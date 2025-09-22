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
    return BlocSelector<
      ChangePasswordFormFieldsCubit,
      ChangePasswordFormState,
      (FormFieldUiState, int)
    >(
      selector: (state) => (
        (
          errorText: state.password.uiErrorKey,
          isObscure: state.isPasswordObscure,
        ),
        state.epoch,
      ),
      builder: (context, pair) {
        final (field, epoch) = pair;
        final (:errorText, :isObscure) = field;
        final formCubit = context.read<ChangePasswordFormFieldsCubit>();

        return InputFieldFactory.create(
          type: InputFieldType.password,
          focusNode: focusNodes.password,
          errorText: errorText,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.password],
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.togglePasswordVisibility,
          ),
          //
          onChanged: formCubit.onPasswordChanged,
          onEditingComplete: context.focusNext(focusNodes.confirmPassword),
          fieldKeyOverride: ValueKey('password_$epoch'),
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
    return BlocSelector<
      ChangePasswordFormFieldsCubit,
      ChangePasswordFormState,
      (FormFieldUiState, int)
    >(
      selector: (state) => (
        (
          errorText: state.confirmPassword.uiErrorKey,
          isObscure: state.isConfirmPasswordObscure,
        ),
        state.epoch,
      ),
      builder: (context, pair) {
        final (field, epoch) = pair;
        final (:errorText, :isObscure) = field;
        final formCubit = context.read<ChangePasswordFormFieldsCubit>();

        return InputFieldFactory.create(
          type: InputFieldType.confirmPassword,
          focusNode: focusNodes.confirmPassword,
          errorText: errorText,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.toggleConfirmPasswordVisibility,
          ),
          //
          onChanged: formCubit.onConfirmPasswordChanged,
          onEditingComplete: () {
            final currentState = formCubit.state;
            if (currentState.isValid) {
              context.read<ChangePasswordCubit>().submit(
                currentState.password.value,
              );
            }
          },
          fieldKeyOverride: ValueKey('confirm_$epoch'),
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
    return UniversalSubmitButton<
          ChangePasswordFormFieldsCubit,
          ChangePasswordFormState,
          ChangePasswordCubit
        >(
          label: LocaleKeys.change_password_title,
          loadingLabel: LocaleKeys.buttons_submitting,
          isFormValid: (state) => state.isValid,
          //
          onPressed: () {
            context.unfocusKeyboard();
            final currentState = context
                .read<ChangePasswordFormFieldsCubit>()
                .state;
            context.read<ChangePasswordCubit>().submit(
              currentState.password.value,
            );
          },
          //
        )
        .withPaddingBottom(AppSpacing.l);
  }
}
