import 'dart:async' show scheduleMicrotask;

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/public_api/core.dart';
import 'package:features/features_barrels/email_verification/email_verification.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/foundation.dart' show debugPrint;

/// 📧 [EmailVerificationCubit] - Orchestrates the email-verification flow on BLoC:
/// Exposes a `AsyncValueForBLoC<void>` for a state-agnostic UI API
//
final class EmailVerificationCubit extends CubitWithAsyncValue<void> {
  ///--------------------------------------------------------------
  /// Creates a cubit bound to [EmailVerificationUseCase], [AuthGateway] and [VerificationPoller].
  EmailVerificationCubit(this._useCase, this.gateway)
    : _poller = VerificationPoller(
        interval: AppDurations.sec3,
        timeout: AppDurations.min1,
      ),
      super() {
    // 🚀 Bootstrap kicks off immediately in a microtask
    scheduleMicrotask(_bootstrap);
  }

  /// 🔌 Auth gateway for refreshing router/auth snapshot
  final AuthGateway gateway;
  // 🧰 Domain use case entrypoint (send/reload/check)
  final EmailVerificationUseCase _useCase;
  // ⏱️ Generic polling utility (tick/loading/timeout/verified callbacks)
  final VerificationPoller _poller;
  // 🛡️ Re-entrancy guard (prevents double bootstrap)
  bool _started = false;

  ////

  /// 🏁 One-time bootstrap
  Future<void> _bootstrap() async {
    if (_started || isClosed) return;
    _started = true;
    //
    emitLoading(); // ⏳
    //
    /// ✅ Sends verification email
    final sent = await _useCase.sendVerificationEmail();
    if (isClosed) return;
    //
    /// ❌ Emits failure state if email send fails
    sent.fold(
      emitFailure, // ❌
      // ✅ Starts polling loop on success
      (_) => _startPolling(),
    );
  }

  ////

  /// 🔁 Starts the polling loop
  void _startPolling() {
    _poller.start(
      check: () async {
        final result = await _useCase.checkIfEmailVerified();
        return result.fold((_) => false, (v) => v);
      },
      //
      /// ✅ Emits `loading` on every tick
      onLoadingTick: emitLoading,
      //
      /// ✅ Emits `error` on timeout
      onTimeout: () => emitFailure(
        const Failure(type: EmailVerificationTimeoutFailureType()),
      ),
      //
      /// ✅ Emits `data(null)` once email is verified
      onVerified: () async {
        if (isClosed) return;
        emitData(null); // 🎉 flow complete
        await _useCase.reloadUser();
        // 🔔 Triggers router refresh (auth state sync)
        await gateway.refresh();
        debugPrint(
          '🔁 After reload + refresh: emailVerified=${FirebaseRefs.auth.currentUser?.emailVerified}',
        );
        //
      },
    );
  }

  ////

  /// 🧹 Cleanup, cancels the poller to prevent timers from leaking after dispose.
  @override
  Future<void> close() {
    _poller.cancel();
    return super.close();
  }

  //
}
