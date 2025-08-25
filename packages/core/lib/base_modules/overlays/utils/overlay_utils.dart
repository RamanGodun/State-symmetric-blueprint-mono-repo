import 'package:core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:flutter/material.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di.dart';

/// 🛠️ [OverlayUtils] — utility class for overlay-related helpers
/// ✅ Dismisses current overlay before executing the given action
///
abstract final class OverlayUtils {
  ///---------------------------
  OverlayUtils._();

  /// 🔁 Dismisses the currently visible overlay (if any) and executes [action]
  static VoidCallback dismissAndRun(VoidCallback action, BuildContext context) {
    //
    return () {
      // context.readDI(overlayDispatcherProvider).dismissCurrent(force: true);
      di<OverlayDispatcher>().dismissCurrent(force: true);
      action.call();
    };
  }

  //
}
