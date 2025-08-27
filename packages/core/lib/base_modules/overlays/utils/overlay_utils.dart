import 'package:bloc_adapter/di/core/di.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_dispatcher_provider.dart';
import 'package:riverpod_adapter/di/read_di_x_on_context.dart';

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
