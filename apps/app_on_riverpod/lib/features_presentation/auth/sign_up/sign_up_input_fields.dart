part of 'sign_up__page.dart';

/// 🧩 [_NameInputField] — name input field
//
final class _NameInputField extends ConsumerWidget {
  ///--------------------------------------------
  const _NameInputField(this.focus);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(signUpFormProvider);
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.name,
      focusNode: focus.name,
      errorText: form.name.uiErrorKey,
      onChanged: formNotifier.nameChanged,
      onSubmitted: focus.email.requestFocus,
    ).withPaddingBottom(AppSpacing.m);
  }
}

////

////

/// 🧩 [_EmailInputField] — email input field
//
final class _EmailInputField extends ConsumerWidget {
  ///---------------------------------------------
  const _EmailInputField(this.focus);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(signUpFormProvider);
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.email,
      focusNode: focus.email,
      errorText: form.email.uiErrorKey,
      onChanged: formNotifier.emailChanged,
      onSubmitted: goNext(focus.password),
    ).withPaddingBottom(AppSpacing.m);
  }
}

////

////

/// 🧩 [_PasswordInputField] — password input field
//
final class _PasswordInputField extends ConsumerWidget {
  ///------------------------------------------------
  const _PasswordInputField(this.focus);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(signUpFormProvider);
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.password,
      focusNode: focus.password,
      errorText: form.password.uiErrorKey,
      isObscure: form.isPasswordObscure,
      onChanged: formNotifier.passwordChanged,
      onSubmitted: goNext(focus.confirmPassword),
      suffixIcon: ObscureToggleIcon(
        isObscure: form.isPasswordObscure,
        onPressed: formNotifier.togglePasswordVisibility,
      ),
    ).withPaddingBottom(AppSpacing.m);
  }
}

////

////

/// 🧩 [_ConfirmPasswordInputField] — confirm password field
//
final class _ConfirmPasswordInputField extends ConsumerWidget {
  ///-------------------------------------------------------
  const _ConfirmPasswordInputField(this.focus);
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(signUpFormProvider);
    final formNotifier = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.confirmPassword,
      focusNode: focus.confirmPassword,
      errorText: form.confirmPassword.uiErrorKey,
      isObscure: form.isConfirmPasswordObscure,
      onChanged: formNotifier.confirmPasswordChanged,
      onSubmitted: form.isValid ? () => ref.submit() : null,
      suffixIcon: ObscureToggleIcon(
        isObscure: form.isConfirmPasswordObscure,
        onPressed: formNotifier.toggleConfirmPasswordVisibility,
      ),
    ).withPaddingBottom(AppSpacing.xxxl);
  }
}
