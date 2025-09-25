import 'package:core/base_modules/forms.dart';
import 'package:flutter/widgets.dart';

/// 🧱 [fieldUi] — tiny factory for a field’s error + obscurity record (keeps selectors tidy).
FormFieldUiState fieldUi({
  required bool isObscure,
  String? error,
}) => (errorText: error, isObscure: isObscure);

////
////

/// 🎯 [goNext] — returns a callback that jumps focus to [next] (perfect for onSubmitted).
VoidCallback goNext(FocusNode next) =>
    () => next.requestFocus();

////
////

/// 🔹 Unified, reusable selectors (BLoC & Riverpod parity)
///------------------------------------------------------

/// 👤 Name: error + epoch for rebuild gating.
ErrEpoch selectNameSlice(SignUpFormState s) => (
  errorText: s.name.uiErrorKey,
  epoch: s.epoch,
);

/// 📧 Email: error + epoch for rebuild gating.
ErrEpoch selectEmailSlice(SignUpFormState s) => (
  errorText: s.email.uiErrorKey,
  epoch: s.epoch,
);

/// 🔒 Password: error + obscure + epoch (SignUp).
PwdEpoch selectPasswordSlice(SignUpFormState s) => (
  errorText: s.password.uiErrorKey,
  isObscure: s.isPasswordObscure,
  epoch: s.epoch,
);

/// 🔐 Confirm: error + obscure + validity + epoch (SignUp).
CmpEpoch selectConfirmSlice(SignUpFormState s) => (
  errorText: s.confirmPassword.uiErrorKey,
  isObscure: s.isConfirmPasswordObscure,
  isValid: s.isValid,
  epoch: s.epoch,
);

////
////

/// Auth features form fields' SLICES
///---------------------------------

/// 🔹 SignIn slices

/// 🔒 Password: error + obscure + validity + epoch (SignIn).
PwdValidEpoch selectSignInPasswordSlice(SignInFormState s) => (
  errorText: s.password.uiErrorKey,
  isObscure: s.isPasswordObscure,
  isValid: s.isValid,
  epoch: s.epoch,
);

/// 📧 Email: error + epoch (SignIn).
ErrEpoch selectSignInEmailSlice(SignInFormState s) => (
  errorText: s.email.uiErrorKey,
  epoch: s.epoch,
);

/// 🔹 Reset Password slices

/// 📧 Email: error + validity + epoch (ResetPassword).
ErrValidEpoch selectResetEmailSlice(ResetPasswordFormState s) => (
  errorText: s.email.uiErrorKey,
  isValid: s.isValid,
  epoch: s.epoch,
);

/// 🔹 Change Password slices

/// 🔒 Password: error + obscure + epoch (ChangePassword).
PwdEpoch selectChangePasswordSlice(ChangePasswordFormState s) => (
  errorText: s.password.uiErrorKey,
  isObscure: s.isPasswordObscure,
  epoch: s.epoch,
);

/// 🔐 Confirm: error + obscure + validity + epoch (ChangePassword).
CmpValidEpoch selectChangeConfirmSlice(ChangePasswordFormState s) => (
  errorText: s.confirmPassword.uiErrorKey,
  isObscure: s.isConfirmPasswordObscure,
  isValid: s.isValid,
  epoch: s.epoch,
);
