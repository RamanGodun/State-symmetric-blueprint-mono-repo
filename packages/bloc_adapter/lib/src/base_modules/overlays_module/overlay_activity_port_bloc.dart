import 'package:bloc_adapter/src/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:core/base_modules/overlays/overlays_barrel.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/utils/ports/overlay_activity_port.dart';
import 'package:core/core_barrel.dart' show OverlayDispatcher;
import 'package:flutter/scheduler.dart' show SchedulerBinding;

/// 🔌 [BlocOverlayActivityPort] — adapter port for [OverlayDispatcher] → Bloc
//
final class BlocOverlayActivityPort implements OverlayActivityPort {
  ///------------------------------------------------------------
  BlocOverlayActivityPort(this._cubit);
  final OverlayStatusCubit _cubit;

  /// 🔄 Propagates overlay activity to [OverlayStatusCubit]
  @override
  void setActive({required bool isActive}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _cubit.isActive = isActive;
    });
  }

  //
}
