//
// ignore_for_file: public_member_api_docs
import 'package:core/public_api/base_modules/forms.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

/// 📦 [ResetPasswordFormState] — immutable state of the reset-password form.
///    Tracks each input field and overall form validity.
//
final class ResetPasswordFormState extends Equatable {
  ///-----------------------------------
  const ResetPasswordFormState({
    this.email = const EmailInputValidation.pure(),
    this.isValid = false,
    this.epoch = 0,
  });
  //
  final EmailInputValidation email;
  final bool isValid;
  final int epoch;

  /// 🧱 Updates current state  (raw Strings → Formz inputs)
  ResetPasswordFormState updateState({
    String? email,
    int? epoch,
    bool revalidate = true,
  }) {
    //
    /// 🔍🧪 Input fields and validation
    final inputs = _nextInputs(email: email);
    //
    final nextIsValid = revalidate ? Formz.validate([inputs.email]) : isValid;
    //
    /// 🆕 Get new state
    return ResetPasswordFormState(
      email: inputs.email,
      isValid: nextIsValid,
      epoch: epoch ?? this.epoch,
    );
  }

  /// 💠 Forms next inputs
  ({EmailInputValidation email}) _nextInputs({String? email}) {
    final nextEmail = (email != null)
        ? EmailInputValidation.dirty(email.trim())
        : this.email;
    return (email: nextEmail);
  }

  ////

  @override
  List<Object> get props => [email, isValid, epoch];
  //
}
