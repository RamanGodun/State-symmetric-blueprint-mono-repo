import 'dart:collection';

import 'package:core/base_modules/animations/overlays_animation/animation_wrapper/overlay_animation_x_for_widget.dart';
import 'package:core/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/base_modules/overlays/core/tap_through_overlay_barrier.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_entries/_overlay_entries_registry.dart';
import 'package:core/base_modules/overlays/utils/overlay_logger.dart';
import 'package:core/utils_shared/timing_control/debouncer.dart';
import 'package:core/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';

part 'policy_resolver.dart';

/// 🧠 [OverlayDispatcher] – Handles overlay lifecycle:
/// - Queueing requests
/// - Resolving conflicts
/// - Managing overlay insertion & dismissal
/// - Centralized logging
//
final class OverlayDispatcher {
  ///------------------------
  OverlayDispatcher({this.onOverlayStateChanged});
  //
  ///
  final void Function({required bool isActive})? onOverlayStateChanged;

  ////

  // 📦 Queue to hold pending overlay requests
  final Queue<OverlayQueueItem> _queue = Queue();
  // 🎯 Currently visible overlay entry in the widget tree
  OverlayEntry? _activeEntry;
  // 📄 Metadata of the currently shown overlay (used for decisions)
  OverlayUIEntry? _activeRequest;
  // 🚦 Whether an overlay is currently being inserted
  bool _isProcessing = false;
  //
  /// 🔓 Whether the current overlay can be dismissed externally.
  bool get canBeDismissedExternally =>
      _activeRequest?.dismissPolicy == OverlayDismissPolicy.dismissible;
  //

  /// 📥 Adds a new request to the queue, resolves replacement/drop strategy
  Future<void> enqueueRequest(
    BuildContext context,
    OverlayUIEntry request,
  ) async {
    if (!context.mounted) return; // ✅ avoid insertion if context is dead
    OverlayLogger.show(request);
    final overlay = Overlay.of(context, rootOverlay: true);
    //
    if (_activeRequest != null) {
      OverlayLogger.activeExists(_activeRequest);

      /// 🚫 Drop if strategy disallows same-type duplicates
      final isSameType =
          request.runtimeType == _activeRequest.runtimeType &&
          request.strategy.policy == OverlayReplacePolicy.dropIfSameType;
      if (isSameType) {
        OverlayLogger.droppedSameType();
        return;
      }
      //
      /// 🔁 Replace if conflict strategy allows
      final shouldReplace = OverlayPolicyResolver.shouldReplaceCurrent(
        request,
        _activeRequest!,
      );
      if (shouldReplace) {
        OverlayLogger.replacing();
        await dismissCurrent(force: true);
        OverlayPolicyResolver.getDebouncer(request.strategy.category).run(() {
          _finalizeEnqueue(overlay, request);
        });
        return;
      }
    }
    //
    _finalizeEnqueue(overlay, request);
  }

  ////

  /// 🧱 Finalizes the enqueue logic after replacement/drop resolution
  void _finalizeEnqueue(OverlayState overlay, OverlayUIEntry request) {
    _removeDuplicateInQueue(request);
    _queue.add(OverlayQueueItem(overlay: overlay, request: request));
    OverlayLogger.addedToQueue(_queue.length);
    _tryProcessQueue();
  }
  //

  /// ▶️ Processes the first item in queue if no active entry.
  void _tryProcessQueue() {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;
    //
    final item = _queue.removeFirst();
    _activeRequest = item.request;
    //
    /// 🧠 Notify listeners overlay is shown
    onOverlayStateChanged?.call(isActive: true);
    //
    final widget = item.request.buildWidget();
    //
    /// 🧠 Apply centralized dismiss handling if AnimatedOverlayWrapper is used
    final processedWidget = widget.withDispatcherOverlayControl(
      onDismiss: () async {
        OverlayLogger.autoDismissed(_activeRequest);
        _activeRequest?.onAutoDismissed();
        await dismissCurrent(force: true);
        _isProcessing = false;
        _tryProcessQueue();
      },
    );
    //
    /// Inserts new OverlayEntry with tap-through barrier.
    _activeEntry = OverlayEntry(
      builder: (ctx) => TapThroughOverlayBarrier(
        enablePassthrough: item.request.tapPassthroughEnabled,
        onTapOverlay: () {
          if (item.request.dismissPolicy == OverlayDismissPolicy.dismissible) {
            dismissCurrent();
          }
        },
        child: processedWidget,
      ),
    );
    //
    item.overlay.insert(_activeEntry!);
    OverlayLogger.inserted(_activeRequest);
  }
  //

  /// ❌ Dismisses current overlay and clears queue if needed.
  Future<void> dismissCurrent({
    bool clearQueue = false,
    bool force = false,
  }) async {
    await _dismissEntry(force: force);
    if (clearQueue) _queue.clear();
    _isProcessing = false;
    _tryProcessQueue();
  }

  /// 🧹 Internal: removes entry, handles animation and resets state.
  Future<void> _dismissEntry({bool force = false}) async {
    try {
      _activeEntry?.remove();
      OverlayLogger.dismissed(_activeRequest);
    } on Object catch (_) {
      OverlayLogger.dismissAnimationError(_activeRequest);
    }
    _activeEntry = null;
    _activeRequest = null;
    //
    /// 🧠 Notify listeners overlay was dismissed
    onOverlayStateChanged?.call(isActive: false);
  }

  /// 🔁 Removes pending duplicates by type & category to avoid stacking
  void _removeDuplicateInQueue(OverlayUIEntry request) {
    _queue.removeWhere(
      (item) =>
          item.request.runtimeType == request.runtimeType &&
          item.request.strategy.category == request.strategy.category &&
          item.request.id == request.id,
    );
  }

  /// ❌ Clears entire queue.
  void clearAll() => _queue.clear();

  //
}
