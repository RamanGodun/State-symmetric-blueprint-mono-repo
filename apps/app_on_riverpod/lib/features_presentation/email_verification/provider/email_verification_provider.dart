import 'dart:async';

import 'package:core/core.dart';
import 'package:features/features.dart' show EmailVerificationUseCase;
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_provider.g.dart';

/// 📧 [EmailVerificationNotifier] — Orchestrates the email-verification flow (Riverpod).
/// 🧰 Uses shared async state: [AsyncValue<void>] via [SafeAsyncState].
/// 🔁 Symmetric to BLoC 'EmailVerificationCubit' (bootstrap → polling → success/timeout).
//
@riverpod
final class EmailVerificationNotifier extends _$EmailVerificationNotifier
    with SafeAsyncState<void> {
  ///-------------------------------------------------------------
  //
  // 📦 Injected use case for email verification operations
  late final EmailVerificationUseCase _emailVerificationUseCase;
  // ⏱ Periodic polling timer
  Timer? _timer;
  // ⏱ Max allowed polling duration before timeout
  static const Duration _maxPollingDuration = AppDurations.min1;
  // ⏱ Elapsed time tracker
  final Stopwatch _stopwatch = Stopwatch();

  ////

  /// ▶️ One-shot bootstrap: send verification email + start polling.
  @override
  FutureOr<void> build() {
    _emailVerificationUseCase = ref.read(emailVerificationUseCaseProvider);
    initSafe();
    debugPrint('VerificationNotifier: build() called...');
    //
    /// 🌀 Initial loader visible while starting the flow
    state = const AsyncLoading();
    //
    /// ✉️ Fire immediately and start polling
    unawaited(_emailVerificationUseCase.sendVerificationEmail());
    _startPolling();
    // 🧹 Cleanup timer on dispose
    ref.onDispose(() => _timer?.cancel());
  }

  ////

  /// 🔁 Polls every 3s until verified or timeout reached.
  void _startPolling() {
    _stopwatch.start();
    // 🌀 Show loader during active polling
    state = const AsyncLoading();
    //
    _timer = Timer.periodic(AppDurations.sec3, (_) {
      if (_stopwatch.elapsed > _maxPollingDuration) {
        // ⏳ Timeout — stop polling and emit failure
        _timer?.cancel();
        final timeoutFailure = const Failure(
          type: EmailVerificationTimeoutFailureType(),
          message: 'Polling timed out after 1 minute',
        )..log(StackTrace.current);
        state = AsyncError(timeoutFailure, StackTrace.current);
        return;
      }
      //
      // Visualize active polling tick
      state = const AsyncLoading();
      _checkEmailVerified();
    });
  }

  ////

  /// ✅ Check verification; if verified → reload user, stop polling, emit success.
  Future<void> _checkEmailVerified() async {
    final result = await _emailVerificationUseCase.checkIfEmailVerified();
    await result.fold((_) => null, (isVerified) async {
      if (!isVerified) return;
      //
      /// 🛑 Stop polling
      _timer?.cancel();
      // 🔄 Reload current Firebase user
      await _emailVerificationUseCase.reloadUser();
      //
      /// 📢 Notify router via gateway refresh
      final gateway = ref.read(authGatewayProvider);
      await gateway.refresh();
      debugPrint(
        '🔁 After reload + refresh: emailVerified=${FirebaseRefs.auth.currentUser?.emailVerified}',
      );
      //
      /// 🎉 Mark state as success
      state = const AsyncData(null);
    });
  }

  //
}
