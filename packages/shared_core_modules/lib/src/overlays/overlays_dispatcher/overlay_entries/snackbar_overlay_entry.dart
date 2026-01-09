// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

part of '_overlay_entries_registry.dart';

/// 🍞 [SnackbarOverlayEntry] — State-driven platform-aware snackbar
///   - Used by [OverlayDispatcher] for automatic snackbar rendering
///   - Encapsulates priority, dismiss policy, and visual props
///   - Built via [AnimationEngine] and animated per platform
///   - Called by Dispatcher during overlay insertion
//
final class SnackbarOverlayEntry extends OverlayUIEntry {
  ///---------------------------------------------------
  SnackbarOverlayEntry({
    required this.widget,
    required this.priority,
    this.isError = false,
    this.dismissPolicy = OverlayDismissPolicy.dismissible,
  });
  //
  final Widget widget;
  final bool isError; // ❗ Marks as an error (affects strategy and priority)
  // 🔐 Dismiss policy (persistent or dismissible)
  @override
  final OverlayDismissPolicy dismissPolicy;
  final OverlayPriority priority;

  //

  /// ⚙️ Defines how this entry behaves in conflict scenarios
  @override
  OverlayConflictStrategy get strategy => OverlayConflictStrategy(
    priority: priority,
    policy: switch (priority) {
      OverlayPriority.critical => OverlayReplacePolicy.forceReplace,
      OverlayPriority.high => OverlayReplacePolicy.forceIfLowerPriority,
      OverlayPriority.normal => OverlayReplacePolicy.forceIfSameCategory,
      OverlayPriority.userDriven => OverlayReplacePolicy.waitQueue,
    },
    category: isError ? OverlayCategory.error : OverlayCategory.snackbar,
  );

  /// 🫥 Enables tap passthrough to UI underneath (non-blocking UX)
  @override
  bool get tapPassthroughEnabled => true;

  /// 🧱 Builds and animates the snackbar via [AnimationEngine]
  @override
  Widget buildWidget() => widget;

  @override
  void onAutoDismissed() {
    // 🎯 Make some actions after dismiss or
    // Track/log auto-dismissed overlay if needed
  }

  //
}
