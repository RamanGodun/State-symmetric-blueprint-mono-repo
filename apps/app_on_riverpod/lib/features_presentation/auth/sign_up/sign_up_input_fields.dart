part of 'sign_up__page.dart';

/// 👤  [_SignUpUserNameInputField] — User name input field with localized validation
/// ✅ Rebuilds only when `name.uiError` changes
//
final class _SignUpUserNameInputField extends ConsumerWidget {
  ///------------------------------------------------------
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
    final (:errorText, :epoch) = ref.watch(
      signUpFormProvider.select(selectNameSlice),
    );
    final formNotifier = ref.read(signUpFormProvider.notifier);
    //
    return InputFieldFactory.create(
      fieldKeyOverride: ValueKey('name_$epoch'),
      type: InputFieldType.name,
      focusNode: focusNodes.name,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      //
      onChanged: formNotifier.onNameChanged,
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
final class _SignUpEmailInputField extends ConsumerWidget {
  ///---------------------------------------------------
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
    final (:errorText, :epoch) = ref.watch(
      signUpFormProvider.select(selectEmailSlice),
    );
    final form = ref.read(signUpFormProvider.notifier);
    //
    return InputFieldFactory.create(
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

/// 🔒 [_SignUpPasswordInputField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _SignUpPasswordInputField extends ConsumerWidget {
  ///------------------------------------------------------
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
    final (:errorText, :isObscure, :epoch) = ref.watch(
      signUpFormProvider.select(selectPasswordSlice),
    );
    final form = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
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

/// 🔐 [_SignUpConfirmPasswordInputField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _SignUpConfirmPasswordInputField extends ConsumerWidget {
  ///-------------------------------------------------------------
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
    final (:errorText, :isObscure, :isValid, :epoch) = ref.watch(
      signUpFormProvider.select(selectConfirmSlice),
    );
    final form = ref.read(signUpFormProvider.notifier);

    return InputFieldFactory.create(
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
