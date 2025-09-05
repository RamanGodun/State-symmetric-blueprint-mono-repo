//
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/localization/generated/locale_keys.g.dart';
import 'package:formz/formz.dart';
import 'package:validators/validators.dart' show isEmail;

part 'currently_using_validators/email_input.dart';
part 'currently_using_validators/name_input.dart';
part 'currently_using_validators/password__input.dart';
part 'currently_using_validators/password_confirm.dart';

/// 📧 [EmailValidationError] — Enum representing email-specific validation failures.
//
enum EmailValidationError {
  ///--------------------
  // 🔠 Email is empty
  empty,
  // ❌ Email format is invalid
  invalid,
}

////
////

/// 🧾 [NameValidationError] — Enum representing possible name input errors.
//
enum NameValidationError {
  ///-------------------
  // 🟥 Field is empty
  empty,
  // 🔡 Name is too short (less than 2 characters)
  tooShort,
}

////
////

/// 🔐 [PasswordValidationError] — Describes password validation issues.
//
enum PasswordValidationError {
  ///-----------------------
  // 🟥 Field is empty
  empty,
  // 🔡 Less than 6 characters
  tooShort,
}

////

////

/// 🔒 [ConfirmPasswordValidationError] — Represents possible validation failures.
//
enum ConfirmPasswordValidationError {
  ///------------------------------
  // 🟥 Field is empty
  empty,
  // 🔁 Passwords do not match
  mismatch,
}

////
////

/// 🔠 Supported input types for signup & login forms
//
enum InputFieldType {
  ///--------------
  // 👤 User's display name. Used for user registration.
  name,
  // 📧 Email address. Used for login and registration.
  email,
  // 🔒 Account password. Used in login, signup, and change-password.
  password,
  // 🔒🔁 Password confirmation. Used in signup and password reset.
  confirmPassword,
}
