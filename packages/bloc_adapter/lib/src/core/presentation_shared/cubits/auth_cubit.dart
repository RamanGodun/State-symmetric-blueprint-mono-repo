import 'dart:async';

import 'package:core/public_api/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [AuthCubit] — Bloc wrapper around [AuthGateway] snapshots
//
final class AuthCubit extends Cubit<AuthViewState> {
  ///--------------------------------------------
  /// Initializes [AuthCubit] and subscribes to gateway snapshots
  AuthCubit({required AuthGateway gateway}) : super(const AuthViewLoading()) {
    _sub = gateway.snapshots$.listen((snap) {
      switch (snap) {
        case AuthLoading():
          emit(const AuthViewLoading());
        case AuthFailure(:final error):
          emit(AuthViewError(error));
        case AuthReady(:final session):
          emit(AuthViewReady(session));
      }
    });
  }

  /// 🔗 Active subscription to auth state stream
  late final StreamSubscription<AuthSnapshot> _sub;

  /// 🧹 Cancels subscription and disposes cubit
  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }

  //
}

////

////

/// 🌐 [AuthViewState] — base class for UI-facing auth states
//
sealed class AuthViewState extends Equatable {
  ///--------------------------------------
  const AuthViewState();
  //
  ///
  @override
  List<Object?> get props => [];
  //
}

////
////

/// ⏳ Loading state used while resolving auth
//
final class AuthViewLoading extends AuthViewState {
  ///-------------------------------------------
  const AuthViewLoading();
}

////
////

/// ❌ Error state exposing failure reason
//
final class AuthViewError extends AuthViewState {
  ///-----------------------------------------
  const AuthViewError(this.error);
  //
  ///
  final Object error;
  //
  ///
  @override
  List<Object?> get props => [error];
  //
}

////
////

/// ✅ Ready state exposing current [AuthSession]
//
final class AuthViewReady extends AuthViewState {
  ///------------------------------------------
  const AuthViewReady(this.session);
  //
  ///
  final AuthSession session;
  //
  ///
  @override
  List<Object?> get props => [
    session.uid,
    session.email,
    session.emailVerified,
    session.isAnonymous,
  ];
  //
}
