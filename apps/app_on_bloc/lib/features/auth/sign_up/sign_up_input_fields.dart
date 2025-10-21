part of 'sign_up__page.dart';

/// 👤  [_UserNameFormField] — User name input field with localized validation
/// ✅ Rebuilds only when `name.uiError` changes
//
final class _UserNameFormField extends StatelessWidget {
  ///------------------------------------------------
  const _UserNameFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isValid, :epoch) = context
        .watchAndSelect<
          SignUpFormFieldCubit,
          SignUpFormState,
          SelectedValuesForNameFormField
        >(
          recordsForNameFormField(),
        );
    final form = context.read<SignUpFormFieldCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('name_$epoch'),
      type: InputFieldType.name,
      focusNode: focusNodes.name,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      //
      onChanged: form.onNameChanged,
      onSubmitted: goNext(focusNodes.email),
      //
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🧩 [_EmailFormField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _EmailFormField extends StatelessWidget {
  ///---------------------------------------------
  const _EmailFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isValid, :epoch) = context
        .watchAndSelect<
          SignUpFormFieldCubit,
          SignUpFormState,
          SelectedValuesForEmailFormField
        >(
          recordsForEmailFormField(),
        );
    final form = context.read<SignUpFormFieldCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('email_$epoch'),
      type: InputFieldType.email,
      focusNode: focusNodes.email,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username, AutofillHints.email],
      //
      onChanged: form.onEmailChanged,
      onSubmitted: goNext(focusNodes.password),
      //
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🔒 [_PasswordFormField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _PasswordFormField extends StatelessWidget {
  ///------------------------------------------------
  const _PasswordFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = context
        .watchAndSelect<
          SignUpFormFieldCubit,
          SignUpFormState,
          SelectedValuesForPasswordFormField
        >(
          recordsForPasswordFormField(),
        );
    final form = context.read<SignUpFormFieldCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('password_$epoch'),
      type: InputFieldType.password,
      focusNode: focusNodes.password,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: form.togglePasswordVisibility,
      ),
      //
      onChanged: form.onPasswordChanged,
      onSubmitted: goNext(focusNodes.confirmPassword),
      //
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🔐 [_ConfirmPasswordFormField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _ConfirmPasswordFormField extends StatelessWidget {
  ///------------------------------------------------------
  const _ConfirmPasswordFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = context
        .watchAndSelect<
          SignUpFormFieldCubit,
          SignUpFormState,
          SelectedValuesForConfirmPasswordFormField
        >(
          recordsForConfirmPasswordFormField(useFormValidity: true),
        );
    final form = context.read<SignUpFormFieldCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('confirm_$epoch'),
      type: InputFieldType.confirmPassword,
      focusNode: focusNodes.confirmPassword,
      errorText: errorText,
      textInputAction: TextInputAction.done,
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: form.toggleConfirmPasswordVisibility,
      ),
      //
      onChanged: form.onConfirmPasswordChanged,
      onSubmitted: isValid ? () => context.submitSignUp() : null,
      //
    ).withPaddingBottom(AppSpacing.xl);
  }
}
