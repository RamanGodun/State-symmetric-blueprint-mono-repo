import 'dart:async';

import 'package:core/core.dart';
import 'package:features/features.dart' show EmailVerificationUseCase;
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_provider.g.dart';

/// 🧩 [EmailVerificationNotifier] — orchestrates email verification flow
/// - Immediately sends a verification email on creation
/// - Polls every 3s for up to 1min until the email is verified
/// - On success: reloads Firebase user + triggers [AuthGateway.refresh]
/// - Exposes async state for UI feedback
//
@riverpod
final class EmailVerificationNotifier extends _$EmailVerificationNotifier
    with SafeAsyncState<void> {
  ///-------------------------------------------------------------

  /// ⏱ Timer for periodic polling
  Timer? _timer;

  /// ⏱ Max allowed polling duration before timeout
  static const Duration _maxPollingDuration = AppDurations.min1;

  /// ⏱ Stopwatch to track elapsed time
  final Stopwatch _stopwatch = Stopwatch();

  /// 📦 Injected use case for email verification operations
  late final EmailVerificationUseCase _emailVerificationUseCase;

  /// 🏗 Initializes notifier:
  /// - Reads the use case from DI
  /// - Sends verification email
  /// - Starts polling loop
  @override
  FutureOr<void> build() {
    _emailVerificationUseCase = ref.read(emailVerificationUseCaseProvider);
    initSafe();
    debugPrint('VerificationNotifier: build() called...');

    // ✉️ Fire off email immediately and start polling
    unawaited(_emailVerificationUseCase.sendVerificationEmail());
    _startPolling();

    // 🔌 Ensure timer is cleaned up on dispose
    ref.onDispose(() => _timer?.cancel());
  }

  ////

  /// 🔁 Polls every 3 seconds until verified or timeout reached
  void _startPolling() {
    _stopwatch.start();
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
      _checkEmailVerified();
    });
  }

  /// ✅ Checks email verification status:
  /// - If not verified → continue polling
  /// - If verified:
  ///   1) Cancel polling
  ///   2) Reload Firebase user
  ///   3) Trigger [AuthGateway.refresh] to notify router
  ///   4) Mark notifier state as success
  Future<void> _checkEmailVerified() async {
    debugPrint('EmailVerificationNotifier: checking email verification…');
    final result = await _emailVerificationUseCase.checkIfEmailVerified();

    await result.fold((_) => null, (isVerified) async {
      if (!isVerified) return;

      // 🛑 Stop polling
      _timer?.cancel();

      // 🔄 Reload current Firebase user
      await _emailVerificationUseCase.reloadUser();

      // 📢 Trigger gateway refresh to update GoRouter redirect instantly
      final gateway = ref.read(authGatewayProvider);
      await gateway.refresh();

      final refreshed = FirebaseRefs.auth.currentUser;
      debugPrint(
        '🔁 After reload + refresh: emailVerified=${refreshed?.emailVerified}',
      );

      // 🎉 Mark state as success
      state = const AsyncData(null);
    });
  }

  //
}
