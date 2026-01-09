import 'dart:async' show Timer;

/// ⏱️ [Throttler] — Utility that ensures action is triggered at most once within the specified [duration].
/// ✅ Ignores all calls made during the throttle window.
/// ✅ Useful for preventing spamming of buttons or repeated API calls.
//
final class Throttler {
  ///----------------
  /// 🛠️ Initializes a new throttler with specified [duration]
  Throttler(this.duration);

  /// 🕒 Duration window for throttling
  final Duration duration;

  /// 🚫 Flag indicating whether new actions can be accepted
  bool _canCall = true;

  /// 🚀 Runs the [action] only if throttle window is open
  /// ⛔ Ignores subsequent calls until [duration] has passed
  void run(void Function() action) {
    if (!_canCall) return;

    _canCall = false;
    action();

    Timer(duration, () => _canCall = true);
  }

  /// 🔄 Manually resets the throttler to allow next action immediately
  void reset() => _canCall = true;

  //
}
