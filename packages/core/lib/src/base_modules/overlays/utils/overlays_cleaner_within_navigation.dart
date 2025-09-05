import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/src/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show resolveOverlayDispatcherGlobal;
import 'package:flutter/widgets.dart';

/// 🧭 [OverlaysCleanerWithinNavigation] — Navigator observer that resets overlays
/// ✅ Ensures overlays (banners, dialogs, snackbars) never "leak" between screens
/// ✅ Clears only on page-level transitions (push/pop/remove/replace)
/// ❌ Ignores popup routes (dropdowns, dialogs) — avoids killing useful banners
//
final class OverlaysCleanerWithinNavigation extends NavigatorObserver {
  ///---------------------------------------------------------------
  OverlaysCleanerWithinNavigation();

  /// 📦 Reference to global overlay dispatcher (wired via DI)
  OverlayDispatcher get _dispatcher => resolveOverlayDispatcherGlobal();

  /// 🔎 Filter: only clear overlays when real page routes are changing
  bool _isPageLevel(Route<dynamic>? r) => r is PageRoute;

  /// 🧹 Safely clears queued overlays (but never kills the current one)
  void _maybeClearQueue(Route<dynamic>? r) {
    if (!_isPageLevel(r)) return;
    _dispatcher.clearAll();
  }

  /// 🔁 Fired when a new route is pushed onto the stack
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _maybeClearQueue(route);
  }

  /// 🔁 Fired when a route is popped off the stack
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _maybeClearQueue(route); // Important: check popped route, not previous
  }

  /// 🔁 Fired when a route is removed without completion
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _maybeClearQueue(route);
  }

  /// 🔁 Fired when a route is replaced
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _maybeClearQueue(newRoute);
  }

  //
}
