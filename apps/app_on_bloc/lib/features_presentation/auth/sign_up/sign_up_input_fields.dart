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
    final (:errorText, :epoch) = context
        .watchSelect<SignUpFormFieldCubit, SignUpFormState, ErrEpoch>(
          selectNameSlice,
        );
    final formFieldCubit = context.read<SignUpFormFieldCubit>();
    //
    return InputFieldFactory.create(
      fieldKeyOverride: ValueKey('name_$epoch'),
      type: InputFieldType.name,
      focusNode: focusNodes.name,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      //
      onChanged: formFieldCubit.onNameChanged,
      onSubmitted: goNext(focusNodes.email),
      //
    ).withPaddingBottom(AppSpacing.xm);
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
    final (:errorText, :epoch) = context
        .watchSelect<SignUpFormFieldCubit, SignUpFormState, ErrEpoch>(
          selectEmailSlice,
        );
    final cubit = context.read<SignUpFormFieldCubit>();
    //
    return InputFieldFactory.create(
      fieldKeyOverride: ValueKey('email_$epoch'),
      type: InputFieldType.email,
      focusNode: focusNodes.email,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username, AutofillHints.email],
      //
      onChanged: cubit.onEmailChanged,
      onSubmitted: goNext(focusNodes.password),
      //
    ).withPaddingBottom(AppSpacing.xm);
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
    final (:errorText, :isObscure, :epoch) = context
        .watchSelect<SignUpFormFieldCubit, SignUpFormState, PwdEpoch>(
          selectPasswordSlice,
        );
    final cubit = context.read<SignUpFormFieldCubit>();
    //
    return InputFieldFactory.create(
      fieldKeyOverride: ValueKey('password_$epoch'),
      type: InputFieldType.password,
      focusNode: focusNodes.password,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: cubit.togglePasswordVisibility,
      ),
      //
      onChanged: cubit.onPasswordChanged,
      onSubmitted: goNext(focusNodes.confirmPassword),
      //
    ).withPaddingBottom(AppSpacing.xm);
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
    final (:errorText, :isObscure, :isValid, :epoch) = context
        .watchSelect<SignUpFormFieldCubit, SignUpFormState, CmpEpoch>(
          selectConfirmSlice,
        );
    final cubit = context.read<SignUpFormFieldCubit>();
    //
    return InputFieldFactory.create(
      fieldKeyOverride: ValueKey('confirm_$epoch'),
      type: InputFieldType.confirmPassword,
      focusNode: focusNodes.confirmPassword,
      errorText: errorText,
      textInputAction: TextInputAction.done,
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: cubit.toggleConfirmPasswordVisibility,
      ),
      //
      onChanged: cubit.onConfirmPasswordChanged,
      onSubmitted: isValid ? () => context.submitSignUp() : null,
      //
    ).withPaddingBottom(AppSpacing.xl);
  }
}
