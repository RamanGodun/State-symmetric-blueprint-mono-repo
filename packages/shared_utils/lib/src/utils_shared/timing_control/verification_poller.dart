import 'dart:async';

/// 🔁 [VerificationPoller] — utility for “check-until-true-or-timeout” flows.
/// Exposes a lean callback API: `check` + `onLoadingTick` + `onTimeout` + `onVerified`
//
final class VerificationPoller {
  ///------------------------
  /// Creates a poller with fixed tick [interval] and hard [timeout].
  VerificationPoller({
    required this.interval,
    required this.timeout,
  });

  /// ⏱ Tick interval between checks
  final Duration interval;
  //
  /// ⛔ Absolute timeout for the whole loop
  final Duration timeout;
  //
  /// 🕰 Internal timer (null when idle)
  Timer? _timer;
  //
  /// ⏱ Elapsed time to enforce [timeout]
  final Stopwatch _stopwatch = Stopwatch();
  //
  /// 🟢 True while the periodic timer is active
  bool get isRunning => _timer?.isActive ?? false;

  ////

  /// ▶️ Starts the polling loop.
  /// Calls:
  /// - [onLoadingTick] on each tick
  /// - [onTimeout] once when [timeout] is reached
  /// - [onVerified] once when [check] returns `true`
  void start({
    required Future<bool> Function() check,
    required void Function() onLoadingTick,
    required void Function() onTimeout,
    required Future<void> Function() onVerified,
  }) {
    cancel(); // clean start
    _stopwatch
      ..reset()
      ..start();

    // show inline loader immediately (reflects active polling)
    onLoadingTick();

    _timer = Timer.periodic(interval, (t) async {
      // ⏳ hard timeout → cancel and propagate once
      if (_stopwatch.elapsed >= timeout) {
        cancel();
        onTimeout();
        return;
      }

      // keep loader UX while checking
      onLoadingTick();

      // 🧪 predicate
      final ok = await check();
      if (!ok) return;

      // 🎯 verified → finish and notify
      cancel();
      await onVerified();
    });
  }

  ////

  /// 🛑 Cancels the loop and stops the stopwatch.
  void cancel() {
    _timer?.cancel();
    _stopwatch.stop();
  }
}
