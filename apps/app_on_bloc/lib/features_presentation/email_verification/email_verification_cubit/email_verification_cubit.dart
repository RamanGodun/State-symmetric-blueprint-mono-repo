import 'dart:async' show Timer, scheduleMicrotask;

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features_barrels/email_verification/email_verification.dart';

/// 🧩 [EmailVerificationCubit] — orchestrates email verification flow (BLoC)
/// ✅ Emits [AsyncState<void>] to mirror Riverpod's notifier
/// ✅ Keeps polling/timeout logic + inline loader UX
//
final class EmailVerificationCubit extends AsyncStateCubit<void> {
  ///-----------------------------------------------
  EmailVerificationCubit(this._useCase) : super() {
    // ▶️ Fire-and-forget bootstrap: starts polling flow after construction
    //    - microtask guarantees init runs after listeners are attached
    //    - guarded by [_started] flag to avoid double-start
    scheduleMicrotask(_bootstrap);
  }
  //
  final EmailVerificationUseCase _useCase;

  Timer? _pollingTimer;
  final Stopwatch _stopwatch = Stopwatch();
  static const Duration _maxPollingDuration = AppDurations.min1;
  bool _started = false;

  /// ▶️ One-shot bootstrap: send email + start polling
  Future<void> _bootstrap() async {
    if (_started) return;
    _started = true;
    //
    /// show inline loader while we kick things off
    emit(const AsyncState.loading());
    //
    final sent = await _useCase.sendVerificationEmail();
    sent.fold(
      // show error overlay via listener
      (f) => emit(AsyncState<void>.error(f)),
      (_) => _startPolling(),
    );
  }

  /// 🔁 Poll every 3s; stop on verified or timeout
  void _startPolling() {
    // ensure clean start
    _pollingTimer?.cancel();
    _stopwatch
      ..reset()
      ..start();
    //
    /// keep loader visible during active polling
    emit(const AsyncState.loading());
    //
    _pollingTimer = Timer.periodic(AppDurations.sec3, (_) async {
      // timeout → stop + error
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

      await _checkVerified();
    });
  }

  /// ✅ Check verification; on success → reload and emit data(null)
  Future<void> _checkVerified() async {
    // keep loader while checking
    emit(const AsyncState.loading());
    //
    final result = await _useCase.checkIfEmailVerified();
    result.fold(
      (f) => emit(AsyncState<void>.error(f)),
      (isVerified) async {
        if (!isVerified) {
          // still not verified → keep loader for inline spinner UX
          emit(const AsyncState.loading());
          return;
        }
        //
        /// verified → reload + stop + signal success
        await _useCase.reloadUser();
        _stopPolling();
        //
        /// convention: success = AsyncState.data(null)
        emit(const AsyncState<void>.data(null));
      },
    );
  }

  /// 🛑 Stops the polling loop and halts the stopwatch
  /// ✅ Ensures no background timers keep running
  void _stopPolling() {
    _pollingTimer?.cancel();
    _stopwatch.stop();
  }

  /// 🧹 Dispose hook — cancels polling before closing Cubit
  /// ✅ Prevents leaks and dangling timers
  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }

  //
}
