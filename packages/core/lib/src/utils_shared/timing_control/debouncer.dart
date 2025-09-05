import 'dart:async';

/// ⏱️ [Debouncer] — Utility to delay execution until a pause in user input
//
final class Debouncer {
  ///-----------------
  /// 🔧 Create a new [Debouncer] with given delay duration
  Debouncer(this.duration);

  /// ⏳ Duration to wait before triggering action
  final Duration duration;

  /// 🕒 Internal timer to handle delay logic
  Timer? _timer;

  /// 🚀 Run [action] after a pause; cancels previous if still pending
  void run(void Function() action) {
    _timer?.cancel(); // cancel previous timer if any
    _timer = Timer(duration, action);
  }

  /// 🧹 Manually cancel any pending action
  void cancel() => _timer?.cancel();

  //
}
