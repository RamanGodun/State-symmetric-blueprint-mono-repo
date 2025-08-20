//
// ignore_for_file: public_member_api_docs

part of 'email_verification_cubit.dart';

enum EmailVerificationStatus {
  initial,
  loading,
  verified,
  unverified,
  resent,
  failure,
}

////

/// Holds the state for email verification flow including
/// current status, user info, and any occurred failure.
//
final class EmailVerificationState extends Equatable {
  ///----------------------------------------------
  const EmailVerificationState({
    this.status = EmailVerificationStatus.initial,
    this.user,
    this.failure,
  });
  //
  final EmailVerificationStatus status;
  final User? user;
  final Consumable<Failure>? failure;

  ///
  EmailVerificationState copyWith({
    EmailVerificationStatus? status,
    User? user,
    Consumable<Failure>? failure,
  }) {
    return EmailVerificationState(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: failure ?? this.failure,
    );
  }

  ///
  @override
  List<Object?> get props => [status, user, failure];

  //
}
