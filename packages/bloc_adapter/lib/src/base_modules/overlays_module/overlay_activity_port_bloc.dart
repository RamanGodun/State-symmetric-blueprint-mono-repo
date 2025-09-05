import 'package:bloc_adapter/src/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:core/base_modules/overlays.dart'
    show OverlayActivityPort, OverlayDispatcher;
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
