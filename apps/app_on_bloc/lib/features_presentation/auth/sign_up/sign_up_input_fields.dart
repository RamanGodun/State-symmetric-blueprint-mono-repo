part of 'sign_up__page.dart';

/// 👤  [_SignUpUserNameInputField] — User name input field with localized validation
/// ✅ Rebuilds only when `name.uiError` changes
//
final class _SignUpUserNameInputField extends StatelessWidget {
  ///-------------------------------------------------------
  const _SignUpUserNameInputField(this.focusNodes);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignUpFormFieldCubit, SignUpFormState, (String?, int)>(
      selector: (state) => (state.name.uiErrorKey, state.epoch),
      builder: (context, tuple) {
        final (errorText, epoch) = tuple;
        //
        return InputFieldFactory.create(
          fieldKeyOverride: ValueKey('name_$epoch'),
          type: InputFieldType.name,
          focusNode: focusNodes.name,
          errorText: errorText,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          onChanged: context.read<SignUpFormFieldCubit>().onNameChanged,
          onSubmitted: goNext(focusNodes.email),
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🧩 [_SignUpEmailInputField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _SignUpEmailInputField extends StatelessWidget {
  ///----------------------------------------------------
  const _SignUpEmailInputField(this.focusNodes);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignUpFormFieldCubit, SignUpFormState, (String?, int)>(
      selector: (state) => (state.email.uiErrorKey, state.epoch),
      builder: (context, tuple) {
        final (errorText, epoch) = tuple;
        //
        return InputFieldFactory.create(
          fieldKeyOverride: ValueKey('email_$epoch'),
          type: InputFieldType.email,
          focusNode: focusNodes.email,
          errorText: errorText,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
          onChanged: context.read<SignUpFormFieldCubit>().onEmailChanged,
          onSubmitted: goNext(focusNodes.password),
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🔒 [_SignUpPasswordInputField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _SignUpPasswordInputField extends StatelessWidget {
  ///-------------------------------------------------------
  const _SignUpPasswordInputField(this.focusNodes);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<
      SignUpFormFieldCubit,
      SignUpFormState,
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
        final formCubit = context.read<SignUpFormFieldCubit>();
        //
        return InputFieldFactory.create(
          fieldKeyOverride: ValueKey('password_$epoch'),
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
          onChanged: formCubit.onPasswordChanged,
          onSubmitted: goNext(focusNodes.confirmPassword),
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🔐 [_SignUpConfirmPasswordInputField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _SignUpConfirmPasswordInputField extends StatelessWidget {
  ///--------------------------------------------------------------
  const _SignUpConfirmPasswordInputField(this.focusNodes);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<
      SignUpFormFieldCubit,
      SignUpFormState,
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
        final formCubit = context.read<SignUpFormFieldCubit>();
        final formState = formCubit.state;

        //
        return InputFieldFactory.create(
          fieldKeyOverride: ValueKey('confirm_$epoch'),
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
          onChanged: formCubit.onConfirmPasswordChanged,
          onSubmitted: formState.isValid ? () => context.submitSignUp() : null,
        ).withPaddingBottom(AppSpacing.xl);
      },
    );
  }
}
