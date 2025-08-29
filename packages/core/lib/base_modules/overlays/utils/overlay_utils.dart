import 'package:core/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show resolveOverlayDispatcher;
import 'package:flutter/material.dart';

/// 🛠️ [OverlayUtils] — utility class for overlay-related helpers
/// ✅ Dismisses current overlay before executing the given action
///
abstract final class OverlayUtils {
  ///---------------------------
  OverlayUtils._();

  /// 🔁 Dismisses the currently visible overlay (if any) and executes [action]
  static VoidCallback dismissAndRun(VoidCallback action, BuildContext context) {
    //
    return () async {
      final d = resolveOverlayDispatcher(context);
      await d.dismissCurrent(force: true);
      action.call();
    };
  }

  //
}
