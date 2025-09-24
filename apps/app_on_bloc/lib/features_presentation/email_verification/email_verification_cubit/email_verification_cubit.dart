import 'dart:async' show Timer, scheduleMicrotask;

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features_barrels/email_verification/email_verification.dart';

/// 📧 [EmailVerificationCubit] — Orchestrates the email-verification flow (BLoC).
/// 🧰 Uses shared async state: [AsyncState<void>] (loader / data / error).
/// 🔁 Symmetric to Riverpod 'EmailVerificationNotifier' (bootstrap → polling → success/timeout).
//
final class EmailVerificationCubit extends CubitWithAsyncValue<void> {
  ///--------------------------------------------------------------
  EmailVerificationCubit(this._useCase) : super() {
    // ▶️ Fire-and-forget bootstrap after listeners attach (microtask)
    //    Guarded by [_started] to avoid double start.
    scheduleMicrotask(_bootstrap);
  }
  // 📦 Injected use case for email verification operations
  final EmailVerificationUseCase _useCase;
  // ⏱ Periodic polling timer
  Timer? _pollingTimer;
  // ⏱ Max allowed polling duration before timeout
  static const Duration _maxPollingDuration = AppDurations.min1;
  // ⏱ Elapsed time tracker
  final Stopwatch _stopwatch = Stopwatch();
  bool _started = false;

  ////

  /// ▶️ One-shot bootstrap: send verification email + start polling.
  Future<void> _bootstrap() async {
    if (_started) return;
    _started = true;
    // 🌀 Inline loader while we kick things off
    emit(const AsyncState.loading());
    //
    final sent = await _useCase.sendVerificationEmail();
    sent.fold(
      // ❌ Error shown by listener via state.error
      (failure) => emit(AsyncState<void>.error(failure)),
      (_) => _startPolling(),
    );
  }

  ////

  /// 🔁 Polls every 3s until verified or timeout reached.
  void _startPolling() {
    // ensure clean start
    _pollingTimer?.cancel();
    _stopwatch
      ..reset()
      ..start();
    // 🌀 Keep loader visible during active polling
    emit(const AsyncState.loading());
    //
    _pollingTimer = Timer.periodic(AppDurations.sec3, (_) async {
      // ⏳ Timeout → stop + emit timeout failure
      if (_stopwatch.elapsed >= _maxPollingDuration) {
        _stopPolling();
        emit(
          const AsyncState<void>.error(
            Failure(
              type: EmailVerificationTimeoutFailureType(),
              message: 'Timeout exceeded',
            ),
          ),
        );
        return;
      }
      //
      await _checkVerified();
    });
  }

  ////

  /// ✅ Check verification; if verified → reload user, stop polling, emit success.
  Future<void> _checkVerified() async {
    // 🌀 Keep loader while checking
    emit(const AsyncState.loading());
    //
    final result = await _useCase.checkIfEmailVerified();
    result.fold(
      (f) => emit(AsyncState<void>.error(f)),
      (isVerified) async {
        if (!isVerified) {
          // Not verified yet → keep inline spinner UX
          emit(const AsyncState.loading());
          return;
        }
        //
        /// verified → reload + stop + signal success
        await _useCase.reloadUser();
        _stopPolling();
        // 🎉 Success convention: AsyncState.data(null)
        emit(const AsyncState<void>.data(null));
      },
    );
  }

  ////

  /// 🛑 Stops the polling loop and halts the stopwatch.
  void _stopPolling() {
    _pollingTimer?.cancel();
    _stopwatch.stop();
  }

  /// 🧹 Dispose hook — cancel polling to prevent leaks.
  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }

  //
}
