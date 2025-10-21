part of 'sign_up__page.dart';

/// 👤  [_UserNameFormField] — User name input field with localized validation
/// ✅ Rebuilds only when `name.uiError` changes
//
final class _UserNameFormField extends ConsumerWidget {
  ///-----------------------------------------------
  const _UserNameFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (:errorText, :isValid, :epoch) = ref.watch(
      signUpFormProvider.select(recordsForNameFormField()),
    );
    final form = ref.read(signUpFormProvider.notifier);
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
final class _EmailFormField extends ConsumerWidget {
  ///--------------------------------------------
  const _EmailFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (:errorText, :isValid, :epoch) = ref.watch(
      signUpFormProvider.select(recordsForEmailFormField()),
    );
    final form = ref.read(signUpFormProvider.notifier);
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
final class _PasswordFormField extends ConsumerWidget {
  ///-----------------------------------------------
  const _PasswordFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = ref.watch(
      signUpFormProvider.select(recordsForPasswordFormField()),
    );
    final form = ref.read(signUpFormProvider.notifier);
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
final class _ConfirmPasswordFormField extends ConsumerWidget {
  ///------------------------------------------------------
  const _ConfirmPasswordFormField(this.focusNodes);
  //
  final NodesForSignUpPage focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = ref.watch(
      signUpFormProvider.select(
        recordsForConfirmPasswordFormField(useFormValidity: true),
      ),
    );
    final form = ref.read(signUpFormProvider.notifier);
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
      onSubmitted: isValid ? () => ref.submitSignUp() : null,
      //
    ).withPaddingBottom(AppSpacing.xl);
  }
}
