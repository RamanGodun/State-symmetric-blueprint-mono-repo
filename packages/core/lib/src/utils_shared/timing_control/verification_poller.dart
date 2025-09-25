// ignore_for_file: comment_references, public_member_api_docs

import 'dart:async';

/// 🔁 Generic polling helper for “check-until-true-or-timeout” flows.
/// - Calls [onLoadingTick] on every tick (удобно тримати inline loader)
/// - Calls [onTimeout] once if timeout reached
/// - Calls [onVerified] once when [check] returns true
//
final class VerificationPoller {
  VerificationPoller({
    required this.interval,
    required this.timeout,
  });

  final Duration interval;
  final Duration timeout;

  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();
  bool get isRunning => _timer?.isActive ?? false;

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

    // show loader immediately to reflect “active polling” state
    onLoadingTick();

    _timer = Timer.periodic(interval, (t) async {
      if (_stopwatch.elapsed >= timeout) {
        cancel();
        onTimeout();
        return;
      }

      // keep inline loader UX while we check
      onLoadingTick();

      final ok = await check();
      if (!ok) return;

      // verified!
      cancel();
      await onVerified();
    });
  }

  void cancel() {
    _timer?.cancel();
    _stopwatch.stop();
  }
}
