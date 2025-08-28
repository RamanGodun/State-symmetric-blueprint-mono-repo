import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show resolveOverlayDispatcherGlobal;
import 'package:flutter/widgets.dart';

/// 🧭 [OverlaysCleanerWithinNavigation] — Clears all overlays on navigation events
/// ✅ Ensures that overlays (banners, snackbars, dialogs) do not persist
/// ✅ Works with GoRouter, Navigator 2.0, or traditional Navigator
//
final class OverlaysCleanerWithinNavigation extends NavigatorObserver {
  ///--------------------------------------------------------
  OverlaysCleanerWithinNavigation();

  /// 📦 Reference to the overlay dispatcher (via DI)
  OverlayDispatcher get _overlaysDispatcher => resolveOverlayDispatcherGlobal();
  ////

  /// 🔁 Called when a new route is pushed onto the navigator
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _overlaysDispatcher.dismissCurrent(
      force: true,
      clearQueue: true,
    ); // 🧹 Clear overlay on push
  }

  /// 🔁 Called when a route is popped from the navigator
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _overlaysDispatcher.dismissCurrent(
      force: true,
      clearQueue: true,
    ); // 🧹 Clear overlay on pop
  }

  /// 🔁 Called when a route is removed without being completed
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _overlaysDispatcher.dismissCurrent(
      force: true,
      clearQueue: true,
    ); // 🧹 Clear overlay on remove
  }

  /// 🔁 Called when a route is replaced with another
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _overlaysDispatcher.dismissCurrent(
      force: true,
      clearQueue: true,
    ); // 🧹 Clear overlay on replace
  }

  //
}
