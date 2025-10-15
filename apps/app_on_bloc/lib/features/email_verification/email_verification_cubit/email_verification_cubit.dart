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
    if (_started) return;
    _started = true;
    emit(const AsyncLoadingForBLoC());
    //
    /// ✅ Sends verification email
    final sent = await _useCase.sendVerificationEmail();
    // ❌ Emits failure state if email send fails
    sent.fold(
      (failure) => emit(AsyncErrorForBLoC(failure)),
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
      onLoadingTick: () => emit(const AsyncLoadingForBLoC()),
      //
      /// ✅ Emits `error` on timeout
      onTimeout: () => emit(
        const AsyncErrorForBLoC(
          Failure(type: EmailVerificationTimeoutFailureType()),
        ),
      ),
      //
      /// ✅ Emits `data(null)` once email is verified
      onVerified: () async {
        await _useCase.reloadUser();
        // 🔔 Triggers router refresh (auth state sync)
        await gateway.refresh();
        debugPrint(
          '🔁 After reload + refresh: emailVerified=${FirebaseRefs.auth.currentUser?.emailVerified}',
        );
        //
        /// 🎉 Final success state — `AsyncData(null)` signals flow completion
        emit(const AsyncDataForBLoC(null));
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
