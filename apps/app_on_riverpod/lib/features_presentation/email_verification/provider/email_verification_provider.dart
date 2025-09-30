import 'dart:async';

import 'package:core/public_api/core.dart';
import 'package:features/features.dart' show EmailVerificationUseCase;
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_provider.g.dart';

/// 📧 [EmailVerificationNotifier] - Orchestrates the email-verification flow on Notifier
/// Exposes `AsyncValue<void>` for a state-agnostic UI API
//
@riverpod
final class EmailVerificationNotifier extends _$EmailVerificationNotifier
    with SafeAsyncState<void> {
  ///---------------------------------------------------------------------------------------------
  //
  // 🧰 Domain use case entrypoint (send/reload/check)
  late final EmailVerificationUseCase _useCase;
  // ⏱️ Generic polling utility (tick/loading/timeout/verified callbacks)
  late final VerificationPoller _poller;
  // 🛡️ Re-entrancy guard (prevents double bootstrap)
  bool _started = false;

  ////

  /// 🏁 Lifecycle entrypoint, that initializes use case & poller, hooks disposal cleanup
  @override
  FutureOr<void> build() {
    _useCase = ref.read(emailVerificationUseCaseProvider);
    _poller = VerificationPoller(
      interval: AppDurations.sec3,
      timeout: AppDurations.min1,
    );

    initSafe();
    ref.onDispose(_poller.cancel);
    unawaited(_bootstrap());
  }

  /// 🏁 One-time bootstrap
  Future<void> _bootstrap() async {
    if (_started) return;
    _started = true;
    if (isAlive) state = const AsyncLoading();
    //
    // ✅ Sends verification email
    final sent = await _useCase.sendVerificationEmail();
    // ❌ Emits failure state if email send fails
    sent.fold(
      (failure) {
        if (!isAlive) return;
        state = AsyncError(failure, StackTrace.current);
      },
      // ✅ Starts polling loop on success
      (_) => _startPolling(),
    );
  }

  /////

  /// 🔁 Starts the polling loop
  void _startPolling() {
    _poller.start(
      check: () async {
        final result = await _useCase.checkIfEmailVerified();
        return result.fold((_) => false, (v) => v);
      },
      //
      /// ✅ Emits `loading` on every tick
      onLoadingTick: () {
        if (isAlive) state = const AsyncLoading();
      },
      //
      /// ✅ Emits `error` on timeout
      onTimeout: () {
        if (!isAlive) return;
        final timeoutFailure = const Failure(
          type: EmailVerificationTimeoutFailureType(),
        )..log(StackTrace.current);
        state = AsyncError(timeoutFailure, StackTrace.current);
      },
      //
      /// ✅ Emits `data(null)` once email is verified
      onVerified: () async {
        if (!isAlive) return;
        await _useCase.reloadUser();
        final gateway = ref.read(authGatewayProvider);
        // 🔔 Triggers router refresh (auth state sync)
        await gateway.refresh();
        debugPrint(
          '🔁 After reload + refresh: emailVerified=${FirebaseRefs.auth.currentUser?.emailVerified}',
        );
        //
        /// 🎉 Final success state — `AsyncData(null)` signals flow completion
        if (isAlive) state = const AsyncData(null);
      },
    );
  }

  //
}
