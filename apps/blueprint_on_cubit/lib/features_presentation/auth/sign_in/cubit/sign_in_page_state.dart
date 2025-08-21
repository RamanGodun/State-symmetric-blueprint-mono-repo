//
// ignore_for_file: public_member_api_docs

part of 'sign_in_page_cubit.dart';

/// 📄 [SignInPageState] — Stores form field values and validation status
/// ✅ Used by [SignIncubit] to manage UI state reactively
//
final class SignInPageState extends Equatable {
  ///---------------------------------------
  // 🧱 Initial constructor with default values
  const SignInPageState({
    this.email = const EmailInputValidation.pure(),
    this.password = const PasswordInputValidation.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.failure,
    this.isPasswordObscure = true,
  });
  //
  final EmailInputValidation email;
  final PasswordInputValidation password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final Consumable<Failure>? failure;
  final bool isPasswordObscure;

  // 🔁 Returns new instance with optional overridden fields
  // ⚠️ Use only inside `updateWith(...)` to ensure validation is re-applied!
  SignInPageState _copyWith({
    EmailInputValidation? email,
    PasswordInputValidation? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    Consumable<Failure>? failure,
    bool? isPasswordObscure,
  }) {
    return SignInPageState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    isValid,
    failure,
    isPasswordObscure,
  ];

  //
}

////
////

/// 🧩 [SignInStateValidationX] — Adds validation and update logic to [SignInPageState]
/// ✅ Ensures clean and consistent field updates with auto-validation
/// 🔐 Used inside `SignIncubit` to simplify `emit(...)` logic
//
extension SignInStateValidationX on SignInPageState {
  ///----------------------------------------------
  //
  // ✅ Validates [email] and [password] fields using [Formz]
  // 📥 Accepts overrides or falls back to current state values
  bool validateWith({
    EmailInputValidation? email,
    PasswordInputValidation? password,
  }) {
    return Formz.validate([email ?? this.email, password ?? this.password]);
  }

  // 🔁 Returns updated state with revalidated `isValid` flag
  // 📦 Supports field updates and additional UI flags like status & visibility
  SignInPageState updateWith({
    EmailInputValidation? email,
    PasswordInputValidation? password,
    FormzSubmissionStatus? status,
    Consumable<Failure>? failure,
    bool? isPasswordObscure,
  }) {
    final updated = _copyWith(
      email: email,
      password: password,
      status: status,
      failure: failure,
      isPasswordObscure: isPasswordObscure,
    );
    return updated._copyWith(isValid: updated.validateWith());
  }

  //
}
