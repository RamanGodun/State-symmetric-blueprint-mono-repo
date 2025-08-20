import 'package:core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher_provider.dart';
import 'package:core/di_container_cubit/core/di.dart' show di;
import 'package:core/di_container_riverpod/read_di_x_on_context.dart';
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
    return () {
      context.readDI(overlayDispatcherProvider).dismissCurrent(force: true);
      // di<OverlayDispatcher>().dismissCurrent(force: true);
      action.call();
    };
  }

  //
}
