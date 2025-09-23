part of 'sign_up__page.dart';

/// 👤  [_SignUpUserNameInputField] — User name input field with localized validation
/// ✅ Rebuilds only when `name.uiError` changes
//
final class _SignUpUserNameInputField extends ConsumerWidget {
  ///--------------------------------------------
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
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final nameError = ref.watch(
      signUpFormProvider.select((f) => f.name.uiErrorKey),
    );
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.name,
      focusNode: focusNodes.name,
      errorText: nameError,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      onChanged: formNotifier.onNameChanged,
      onSubmitted: focusNodes.email.requestFocus,
      // fieldKeyOverride: ValueKey('name_$epoch'),
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🧩 [_SignUpEmailInputField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _SignUpEmailInputField extends ConsumerWidget {
  ///---------------------------------------------
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
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final emailError = ref.watch(
      signUpFormProvider.select((f) => f.email.uiErrorKey),
    );
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.email,
      focusNode: focusNodes.email,
      errorText: emailError,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username, AutofillHints.email],
      onChanged: formNotifier.onEmailChanged,
      onSubmitted: goNext(focusNodes.password),
      // fieldKeyOverride: ValueKey('email_$epoch'),
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🔒 [_SignUpPasswordInputField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _SignUpPasswordInputField extends ConsumerWidget {
  ///------------------------------------------------
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
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final passwordError = ref.watch(
      signUpFormProvider.select((f) => f.password.uiErrorKey),
    );
    final isObscure = ref.watch(
      signUpFormProvider.select((f) => f.isPasswordObscure),
    );
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.password,
      focusNode: focusNodes.password,
      errorText: passwordError,
      textInputAction: TextInputAction.next,
      // autofillHints: const [AutofillHints.password],
      isObscure: isObscure,
      onChanged: formNotifier.onPasswordChanged,
      onSubmitted: goNext(focusNodes.confirmPassword),
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: formNotifier.togglePasswordVisibility,
      ),
      // fieldKeyOverride: ValueKey('password_$epoch'),
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🔐 [_SignUpConfirmPasswordInputField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _SignUpConfirmPasswordInputField extends ConsumerWidget {
  ///-------------------------------------------------------
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
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final confirmPasswordError = ref.watch(
      signUpFormProvider.select((f) => f.confirmPassword.uiErrorKey),
    );
    final isObscure = ref.watch(
      signUpFormProvider.select((f) => f.isConfirmPasswordObscure),
    );
    final isValid = ref.watch(signUpFormProvider.select((f) => f.isValid));
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.confirmPassword,
      focusNode: focusNodes.confirmPassword,
      errorText: confirmPasswordError,
      textInputAction: TextInputAction.done,
      // autofillHints: const [AutofillHints.password],
      isObscure: isObscure,
      onChanged: formNotifier.onConfirmPasswordChanged,
      onSubmitted: isValid ? () => ref.submitSignUp() : null,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: formNotifier.toggleConfirmPasswordVisibility,
      ),
      //  fieldKeyOverride: ValueKey('confirm_$epoch'),
    ).withPaddingBottom(AppSpacing.xl);
  }
}
