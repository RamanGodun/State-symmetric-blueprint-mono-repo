import 'package:flutter/material.dart' show FocusNode;

/// 🔐 SignIn focus nodes (symmetric with SignUp).
typedef NodesForSignInPage = ({FocusNode email, FocusNode password});

/// 🔄 SignUp page's focus nodes (name + email + password + confirm).
typedef NodesForSignUpPage = ({
  FocusNode name,
  FocusNode email,
  FocusNode password,
  FocusNode confirmPassword,
});

/// 🔁 ResetPassword focus node (symmetry first).
typedef NodesForResetPasswordPage = ({FocusNode email});

/// 🔄 ChangePassword focus nodes (password + confirm).
typedef NodesForChangePasswordPage = ({
  FocusNode password,
  FocusNode confirmPassword,
});

////
////

/// 🔒 [SelectedValuesForPasswordFormField] - error + obscure + validity + epoch.
typedef SelectedValuesForPasswordFormField = ({
  String? errorText,
  bool isObscure,
  bool isValid,
  int epoch,
});

/// ✅ [SelectedValuesForConfirmPasswordFormField] - error + obscure + validity + epoch.
typedef SelectedValuesForConfirmPasswordFormField = ({
  String? errorText,
  bool isObscure,
  bool isValid,
  int epoch,
});

/// 📧 [SelectedValuesForEmailFormField] — error + validity + epoch.
typedef SelectedValuesForEmailFormField = ({
  String? errorText,
  bool isValid,
  int epoch,
});

/// 🧑‍💼  [SelectedValuesForNameFormField] - error + validity + epoch.
typedef SelectedValuesForNameFormField = ({
  String? errorText,
  bool isValid,
  int epoch,
});
