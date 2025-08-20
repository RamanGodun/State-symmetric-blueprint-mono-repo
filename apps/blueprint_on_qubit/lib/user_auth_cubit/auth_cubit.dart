import 'dart:async';

import 'package:blueprint_on_qubit/features/auth/presentation/sign_out/sign_out_cubit/sign_out_cubit.dart'
    show SignOutCubit;
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

/// 🔐 [AuthCubit] — Manages authentication state using Firebase [userStream].
/// ✅ Emits `authenticated` / `unauthenticated` states reactively (SRP)
/// ✅ signOut logic is in separate [SignOutCubit]
//
final class AuthCubit extends Cubit<AuthState> {
  ///------------------------------------------
  /// 🧱 Initializes [AuthCubit] with Firebase user stream
  /// 🧭 Listens to auth state changes and emits updates
  AuthCubit({required this.userStream}) : super(AuthState.unknown()) {
    _authSubscription = userStream.listen(_onAuthStateChanged);
  }

  ///
  final Stream<User?> userStream;
  late final StreamSubscription<User?> _authSubscription;

  ///

  /// 🔁 Handles Firebase user changes → updates [AuthState]
  void _onAuthStateChanged(User? user) {
    final newStatus = user != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    //
    if (state.authStatus == newStatus && state.user?.uid == user?.uid) {
      return; // 🛑 No actual change — skip emit
    }
    //
    debugPrint(
      '🟡 [AuthCubit] FirebaseAuth stream event received.\n'
      'User: ${user?.uid ?? "null"} | Verified: ${user?.emailVerified} | NewStatus: $newStatus',
    );

    emit(state.copyWith(authStatus: newStatus, user: user));
  }

  /// 🔄 Reload current user from Firebase
  Future<void> reloadUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint('⚠️ [AuthCubit] reloadUser: currentUser is null');
        return;
      }
      //
      await currentUser.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;
      //
      if (updatedUser == null) {
        debugPrint(
          '⚠️ [AuthCubit] reloadUser: updatedUser is null after reload',
        );
        return;
      }
      //
      final newStatus = updatedUser.emailVerified
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
      //
      // 🛑 Skip emit if no actual changes
      final nothingChanged =
          state.authStatus == newStatus &&
          state.user?.uid == updatedUser.uid &&
          state.user?.emailVerified == updatedUser.emailVerified;
      //
      if (nothingChanged) {
        debugPrint('🟢 [AuthCubit] reloadUser skipped: no state changes');
        return;
      }
      //
      debugPrint(
        '🔄 [AuthCubit] reloadUser completed.\n'
        'User: ${updatedUser.uid} | Verified: ${updatedUser.emailVerified} | NewStatus: $newStatus',
      );
      //
      emit(state.copyWith(user: updatedUser, authStatus: newStatus));
    } on Object catch (e, st) {
      debugPrint('❌ [AuthCubit] reloadUser error: $e\n$st');
      debugPrint(st.toString());
    }
  }

  /// 🧼 Cancels auth stream subscription on Cubit close
  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  //
}
