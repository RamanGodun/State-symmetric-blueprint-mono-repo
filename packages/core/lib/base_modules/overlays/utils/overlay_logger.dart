import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_entries/_overlay_entries_registry.dart';
import 'package:flutter/foundation.dart';

/// 🧾 [OverlayLogger] – Utility class for logging overlay lifecycle events.
//
abstract final class OverlayLogger {
  ///-------------------------------
  const OverlayLogger._();

  /// 🪧 Called when overlay is requested to be shown (enqueued)
  static void show(OverlayUIEntry entry) {
    final type = entry.runtimeType.toString();
    final strategy = entry.strategy;
    debugPrint(
      '[Overlay][$type] Show → '
      'priority: ${strategy.priority.name}, '
      'category: ${strategy.category.name}, '
      'policy: ${strategy.policy.name}, '
      'tapThrough: ${entry.tapPassthroughEnabled}',
    );
  }

  /// 🟢 Called when overlay is inserted into widget tree
  static void inserted(OverlayUIEntry? entry) {
    final type = entry?.runtimeType.toString() ?? 'Unknown';
    final strategy = entry?.strategy;
    debugPrint(
      '[Overlay][$type] Inserted → '
      'priority: ${strategy?.priority.name ?? 'n/a'}, '
      'category: ${strategy?.category.name ?? 'n/a'}, '
      'policy: ${strategy?.policy.name ?? 'n/a'}',
    );
  }

  /// ❌ Called when overlay is dismissed
  static void dismissed(OverlayUIEntry? entry) {
    final type = entry?.runtimeType.toString() ?? 'Unknown';
    final strategy = entry?.strategy;
    debugPrint(
      '[Overlay][$type] Dismissed → '
      'priority: ${strategy?.priority.name ?? 'n/a'}, '
      'category: ${strategy?.category.name ?? 'n/a'}, '
      'policy: ${strategy?.policy.name ?? 'n/a'}',
    );
  }

  /// 🟠 Called if active overlay already exists
  static void activeExists(OverlayUIEntry? entry) {
    debugPrint('[🟠 Active exists → ${entry.runtimeType}]');
  }

  /// 🚫 Called if duplicate overlay is dropped by policy
  static void droppedSameType() {
    debugPrint('[🚫 Dropped: dropIfSameType]');
  }

  /// 🔄 Called when replacing an active overlay
  static void replacing() {
    debugPrint('[♻️ Replacing current]');
  }

  /// ➕ Called when overlay is added to the processing queue
  static void addedToQueue(int length) {
    debugPrint('[➕ Added to queue] length = $length');
  }

  /// ❗ Called when dismiss animation fails
  static void dismissAnimationError(
    OverlayUIEntry? entry, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final type = entry?.runtimeType.toString() ?? 'Unknown';
    _printWithErrorPrefix(
      prefix: '[Overlay][$type] ❌ Failed to reverse dismiss animation',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// ⏳ Called when overlay is auto-dismissed (e.g., timeout)
  static void autoDismissed(OverlayUIEntry? entry) {
    final type = entry?.runtimeType.toString() ?? 'Unknown';
    final strategy = entry?.strategy;
    debugPrint(
      '[Overlay][$type] ⏳ AutoDismissed → '
      'priority: ${strategy?.priority.name ?? 'n/a'}, '
      'category: ${strategy?.category.name ?? 'n/a'}, '
      'policy: ${strategy?.policy.name ?? 'n/a'}',
    );
  }

  ////

  /// Helper to print a base message + optional error/stack details.
  static void _printWithErrorPrefix({
    required String prefix,
    String? body,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final base = (body == null || body.isEmpty) ? prefix : '$prefix → $body';
    if (error == null && stackTrace == null) {
      debugPrint(base);
      return;
    }
    final errLine = error == null ? '' : '\n  error: $error';
    final stLine = stackTrace == null ? '' : '\n  stackTrace: $stackTrace';
    debugPrint('$base$errLine$stLine');
  }

  //
}
