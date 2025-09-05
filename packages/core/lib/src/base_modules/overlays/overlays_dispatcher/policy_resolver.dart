part of 'overlay_dispatcher.dart';

/// 🎯 [OverlayPolicyResolver] — Static resolver for overlay conflict and dismiss policies
/// ✅ Centralizes logic for priority-based replacement and dismissibility behavior
//
final class OverlayPolicyResolver {
  ///---------------------------
  const OverlayPolicyResolver._();
  //

  /// 🔁 Determines if the [next] overlay should replace the [current] one
  /// based on the replacement [OverlayReplacePolicy].
  /// Returns `true` if replacement is allowed according to policy logic.
  static bool shouldReplaceCurrent(
    OverlayUIEntry next,
    OverlayUIEntry current,
  ) {
    final n = next.strategy;
    final c = current.strategy;
    //

    ///
    return switch (n.policy) {
      //
      // Always replace current overlay, regardless of type or category
      OverlayReplacePolicy.forceReplace => true,

      // Replace if both overlays belong to the same category (e.g., dialog)
      OverlayReplacePolicy.forceIfSameCategory => n.category == c.category,

      // Replace only if next overlay has higher priority
      OverlayReplacePolicy.forceIfLowerPriority =>
        n.priority.index > c.priority.index,

      // Do not show if same type of overlay is already visible
      OverlayReplacePolicy.dropIfSameType =>
        next.runtimeType == current.runtimeType,

      // Never replace immediately; queue instead
      OverlayReplacePolicy.waitQueue => false,
    };
  }

  ////

  /// ⏳ Determines if the incoming overlay should wait instead of showing immediately
  /// Relevant for [OverlayReplacePolicy.waitQueue].
  static bool shouldWait(OverlayUIEntry entry) =>
      entry.strategy.policy == OverlayReplacePolicy.waitQueue;

  ////

  /// 📌 Maps a `bool` flag to corresponding [OverlayDismissPolicy].
  /// Returns [OverlayDismissPolicy.dismissible] if `true`, otherwise [OverlayDismissPolicy.persistent].
  static OverlayDismissPolicy resolveDismissPolicy({
    required bool isDismissible,
  }) => isDismissible
      ? OverlayDismissPolicy.dismissible
      : OverlayDismissPolicy.persistent;

  ////

  // 🔁 Map of debounce instances by overlay category
  // Ensures that banners/snackbars/dialogs debounce independently.
  static final Map<OverlayCategory, Debouncer> _categoryDebouncers = {};

  ////

  /// ⏱️ Predefined debounce durations for categories
  /// Banners/snackbars usually need small delays; dialogs — instant.
  static final Map<OverlayCategory, Duration> _defaultDebounceDurations = {
    OverlayCategory.banner: AppDurations.ms500,
    OverlayCategory.snackbar: AppDurations.ms500,
    OverlayCategory.dialog: Duration.zero,
  };

  ////

  // 🔁 Retrieves or creates a debouncer for given overlay category.
  // Used to prevent rapid re-triggering of overlays like banners/snackbars.
  static Debouncer getDebouncer(OverlayCategory category) {
    return _categoryDebouncers.putIfAbsent(
      category,
      () => Debouncer(_defaultDebounceDurations[category] ?? Duration.zero),
    );
  }

  //
}

////
////

/// 📦 [OverlayQueueItem] — Internal holder for enqueued overlays.
/// ✅ Binds [OverlayState] with a specific [OverlayUIEntry] for insertion.
//
final class OverlayQueueItem {
  ///----------------------
  /// 🔗 Creates a new queue item with [overlay] target and [request] data
  const OverlayQueueItem({required this.overlay, required this.request});
  //
  /// 🏗️ The [OverlayState] where entry will be inserted
  final OverlayState overlay;
  //
  /// 📄 The overlay request metadata + builder logic
  final OverlayUIEntry request;
  //
}
