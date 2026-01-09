/// ⏱️ [DurationX] — Extension for formatting [Duration] objects
/// ✅ Useful for timers, clocks, video playback UI, etc.
//
extension DurationX on Duration {
  ///-------------------------

  /// 🕒 Formats as MM:SS → `03:45`
  String formatAsTimer() {
    final mins = inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  /// ⏳ Formats as HH:MM:SS → `01:03:45` (for long durations)
  String formatAsClock() {
    final hrs = inHours.toString().padLeft(2, '0');
    final mins = inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hrs:$mins:$secs';
  }

  /// 🔢 Formats compactly: `3m 45s` / `1h 2m`
  String formatCompact() {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  //
}
