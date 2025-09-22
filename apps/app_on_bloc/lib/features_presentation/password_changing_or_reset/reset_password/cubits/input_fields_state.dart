//
// ignore_for_file: public_member_api_docs

part of 'input_fields_cubit.dart';

/// 📄 [ResetPasswordFormState] — Stores email field + isValid
final class ResetPasswordFormState extends Equatable {
  ///------------------------------------------
  const ResetPasswordFormState({
    this.email = const EmailInputValidation.pure(),
    this.isValid = false,
    this.epoch = 0,
  });

  final EmailInputValidation email;
  final bool isValid;
  final int epoch;

  ResetPasswordFormState _copyWith({
    EmailInputValidation? email,
    bool? isValid,
    int? epoch,
  }) {
    return ResetPasswordFormState(
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
      epoch: epoch ?? this.epoch,
    );
  }

  /// ✅ Validates email via Formz
  ResetPasswordFormState validate() {
    final valid = Formz.validate([email]);
    return _copyWith(isValid: valid);
  }

  ///
  @override
  List<Object?> get props => [email, isValid, epoch];
  //
}
