import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show resolveOverlayDispatcherGlobal;
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/widgets.dart';

/// 🧭 [OverlaysCleanerWithinNavigation] — Clears all overlays on navigation events
/// ✅ Ensures that overlays (banners, snackbars, dialogs) are cleared
///    whenever navigation stack changes, preventing “overlay leakage” across screens.
/// ✅ Works with GoRouter, Navigator 2.0, or traditional Navigator
//
final class OverlaysCleanerWithinNavigation extends NavigatorObserver {
  ///--------------------------------------------------------
  OverlaysCleanerWithinNavigation();

  /// 📦 Reference to the overlay dispatcher (via DI)
  OverlayDispatcher get _overlaysDispatcher => resolveOverlayDispatcherGlobal();

  ////

  /// 🧹 Schedule overlay cleanup after the frame is committed
  /// Avoids modifying UI during build/transition phase.
  void _deferClear() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _overlaysDispatcher.dismissCurrent(force: true, clearQueue: true);
    });
  }

  /// 🔁 Triggered after a new route is pushed
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _deferClear();
  }

  /// 🔁 Triggered after a route is popped
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _deferClear();
  }

  /// 🔁 Triggered when a route is removed
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _deferClear();
  }

  /// 🔁 Triggered when a route is replaced
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _deferClear();
  }

  //
}
