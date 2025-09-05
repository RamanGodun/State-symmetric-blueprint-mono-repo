// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

part of '_overlay_entries_registry.dart';

/// 💬 [DialogOverlayEntry] — DTO for Info/Error dialogs in state-driven flows
/// ✅ Used by [OverlayDispatcher] to build animated platform dialogs
//
final class DialogOverlayEntry extends OverlayUIEntry {
  ///-----------------------------------------------
  DialogOverlayEntry({
    required this.widget,
    required this.priority,
    this.isError = false,
    this.dismissPolicy = OverlayDismissPolicy.dismissible,
  });
  //
  final Widget widget;
  final bool isError; // ❗ Marks as an error (affects strategy and priority)
  final OverlayPriority priority;
  @override
  final OverlayDismissPolicy? dismissPolicy;

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
    category: isError ? OverlayCategory.error : OverlayCategory.dialog,
  );

  ///
  @override
  Widget buildWidget() {
    return widget;
  }

  @override
  void onAutoDismissed() {
    // 🎯 Make some actions after dismiss or
    // Track/log auto-dismissed overlay if needed
  }

  //
}
