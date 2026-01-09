import 'dart:async' show unawaited;

import 'package:flutter/material.dart'
    show BuildContext, VoidCallback, WidgetsBinding, debugPrint;
import 'package:shared_core_modules/src/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show resolveOverlayDispatcher;

/// 🛠️ [OverlayUtils] — utility class for overlay-related helpers
/// ✅ Dismisses current overlay before executing the given action
///
abstract final class OverlayUtils {
  ///---------------------------
  OverlayUtils._();

  /// 🔁 Dismisses the currently visible overlay (if any) and executes [action]
  static VoidCallback dismissAndRun(VoidCallback action, BuildContext context) {
    return () {
      final d = resolveOverlayDispatcher(context);
      unawaited(
        d.dismissCurrent(force: true).whenComplete(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint('[OverlayUtils] running deferred action');
            action();
          });
        }),
      );
    };
  }

  //
}
