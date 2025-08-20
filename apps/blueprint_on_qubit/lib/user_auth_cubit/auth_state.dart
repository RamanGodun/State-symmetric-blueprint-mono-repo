//
// ignore_for_file: public_member_api_docs

part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, authError }

////
////

/// 🔒 [AuthStatus] — Represents current authentication state
/// - `unknown`: Initial state (e.g. splash screen)
/// - `authenticated`: User is signed in
/// - `unauthenticated`: User is signed out
//
final class AuthState extends Equatable {
  ///---------------------------------
  /// ✅ Constructor for [AuthState]
  const AuthState({required this.authStatus, this.user});

  /// 🆕 Factory: initial unknown state (e.g. at app launch)
  factory AuthState.unknown() =>
      const AuthState(authStatus: AuthStatus.unknown);

  final AuthStatus authStatus;
  final User? user;

  /// 🔁 Creates a new state with optional overrides
  AuthState copyWith({AuthStatus? authStatus, User? user}) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }

  ///
  @override
  List<Object?> get props => [authStatus, user];

  ///
  @override
  String toString() => 'AuthState(authStatus: $authStatus, user: $user)';

  //
}
