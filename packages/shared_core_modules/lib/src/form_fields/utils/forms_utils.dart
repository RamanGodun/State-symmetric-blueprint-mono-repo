import 'package:flutter/widgets.dart' show FocusNode, VoidCallback;
import 'package:shared_core_modules/public_api/base_modules/forms.dart'
    show
        ChangePasswordFormState,
        ResetPasswordFormState,
        SelectedValuesForConfirmPasswordFormField,
        SelectedValuesForEmailFormField,
        SelectedValuesForNameFormField,
        SelectedValuesForPasswordFormField,
        SignInFormState,
        SignUpFormState;

/// 🎯 [goNext] — returns a callback that jumps focus to [next] (perfect for onSubmitted).
VoidCallback goNext(FocusNode next) =>
    () => next.requestFocus();

////
////

/// 🔹 General selectors via Dart 3 pattern matching (BLoC & Riverpod parity)
///    One function per field type, shared across features.
///--------------------------------------------------------------------------

/// 👤 Name field (SignUp): error + validity (field|form) + epoch.
///    useFormValidity=false → name.isValid (field-level)
///    useFormValidity=true  → state.isValid (form-level)
SelectedValuesForNameFormField Function(Object) recordsForNameFormField({
  bool useFormValidity = false,
}) {
  return (Object s) => switch (s) {
    SignUpFormState(:final name, :final isValid, :final epoch) => (
      errorText: name.uiErrorKey,
      isValid: useFormValidity ? isValid : name.isValid,
      epoch: epoch,
    ),
    _ => throw ArgumentError(
      'Unsupported type for name field: ${s.runtimeType}',
    ),
  };
}

/// 📧 Email field (SignUp / SignIn / ResetPassword): error + validity (field|form) + epoch.
///    useFormValidity=false → email.isValid (field-level)
///    useFormValidity=true  → state.isValid (form-level)
SelectedValuesForEmailFormField Function(Object) recordsForEmailFormField({
  bool useFormValidity = false,
}) {
  return (Object s) => switch (s) {
    SignUpFormState(:final email, :final isValid, :final epoch) ||
    SignInFormState(:final email, :final isValid, :final epoch) ||
    ResetPasswordFormState(:final email, :final isValid, :final epoch) => (
      errorText: email.uiErrorKey,
      isValid: useFormValidity ? isValid : email.isValid,
      epoch: epoch,
    ),
    _ => throw ArgumentError(
      'Unsupported type for email field: ${s.runtimeType}',
    ),
  };
}

/// 🔒 Password field (SignUp / SignIn / ChangePassword):
///    error + obscure + validity (field|form) + epoch.
///    useFormValidity=false → password.isValid (field-level)
///    useFormValidity=true  → state.isValid (form-level)
SelectedValuesForPasswordFormField Function(Object)
recordsForPasswordFormField({bool useFormValidity = false}) {
  return (Object s) => switch (s) {
    SignUpFormState(
      :final password,
      :final isPasswordObscure,
      :final isValid,
      :final epoch,
    ) ||
    SignInFormState(
      :final password,
      :final isPasswordObscure,
      :final isValid,
      :final epoch,
    ) ||
    ChangePasswordFormState(
      :final password,
      :final isPasswordObscure,
      :final isValid,
      :final epoch,
    ) => (
      errorText: password.uiErrorKey,
      isObscure: isPasswordObscure,
      isValid: useFormValidity ? isValid : password.isValid,
      epoch: epoch,
    ),
    _ => throw ArgumentError(
      'Unsupported type for password field: ${s.runtimeType}',
    ),
  };
}

/// 🔐 Confirm field (SignUp / ChangePassword):
///    error + obscure + validity (field|form) + epoch.
///    useFormValidity=false → confirmPassword.isValid (field-level)
///    useFormValidity=true  → state.isValid (form-level)
SelectedValuesForConfirmPasswordFormField Function(Object)
recordsForConfirmPasswordFormField({
  bool useFormValidity = false,
}) {
  return (Object s) => switch (s) {
    SignUpFormState(
      :final confirmPassword,
      :final isConfirmPasswordObscure,
      :final isValid,
      :final epoch,
    ) ||
    ChangePasswordFormState(
      :final confirmPassword,
      :final isConfirmPasswordObscure,
      :final isValid,
      :final epoch,
    ) => (
      errorText: confirmPassword.uiErrorKey,
      isObscure: isConfirmPasswordObscure,
      isValid: useFormValidity ? isValid : confirmPassword.isValid,
      epoch: epoch,
    ),
    _ => throw ArgumentError(
      'Unsupported type for confirm field: ${s.runtimeType}',
    ),
  };
}
