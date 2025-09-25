import 'package:flutter/material.dart' show BuildContext, FocusNode;
import 'package:formz/formz.dart';

/// 🧾 [FormFieldUiState] — compact record for UI error + obscurity (perfect for selectors).
typedef FormFieldUiState = ({String? errorText, bool isObscure});

/// 📮 [SubmitSlice] — form validity + submission status (lightweight derive for buttons).
typedef SubmitSlice = ({bool isValid, FormzSubmissionStatus status});

/// ✉️ Email + Password tuple (common submit DTO).
typedef EmailAndPassword = ({String email, String password});

/// 👤 Name + Email + Password tuple (signup DTO).
typedef NameEmailPassword = ({String name, String email, String password});

/// 🚀 [SubmitCallback] — submit action with [BuildContext].
typedef SubmitCallback = void Function(BuildContext context);

////
////

/// 🎛️ Common selector records (error/obscure/valid/epoch)

/// ❗ Error + epoch (minimal rebuild gate).
typedef ErrEpoch = ({String? errorText, int epoch});

/// 🧩 Confirm slice: error + obscure + valid + epoch.
typedef CmpEpoch = ({
  String? errorText,
  bool isObscure,
  bool isValid,
  int epoch,
});

////
/// 🔐 SignIn focus nodes (symmetric with SignUp).
typedef SignInNodes = ({FocusNode email, FocusNode password});

/// 🔒 Password slice w/ validity (SignIn).
typedef PwdValidEpoch = ({
  String? errorText,
  bool isObscure,
  bool isValid,
  int epoch,
});

////
////

/// 🔁 ResetPassword focus node (symmetry first).
typedef ResetNodes = ({FocusNode email});

/// 📧 Reset email: error + validity + epoch.
typedef ErrValidEpoch = ({String? errorText, bool isValid, int epoch});

////
/// 🔄 ChangePassword focus nodes (password + confirm).
typedef ChangePwdNodes = ({FocusNode password, FocusNode confirmPassword});

/// 🔒 Password: error + obscure + epoch.
typedef PwdEpoch = ({String? errorText, bool isObscure, int epoch});

/// 🔐 Confirm: error + obscure + validity + epoch.
typedef CmpValidEpoch = ({
  String? errorText,
  bool isObscure,
  bool isValid,
  int epoch,
});
