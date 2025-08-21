// packages/specific_for_bloc/lib/auth/auth_cubit.dart
// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthViewState extends Equatable {
  const AuthViewState();
  @override
  List<Object?> get props => [];
}

final class AuthViewLoading extends AuthViewState {
  const AuthViewLoading();
}

final class AuthViewError extends AuthViewState {
  const AuthViewError(this.error);
  final Object error;
  @override
  List<Object?> get props => [error];
}

final class AuthViewReady extends AuthViewState {
  const AuthViewReady(this.session);
  final AuthSession session;
  @override
  List<Object?> get props => [session.uid, session.emailVerified];
}

////

////

final class AuthCubit extends Cubit<AuthViewState> {
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
  late final StreamSubscription<AuthSnapshot> _sub;

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
