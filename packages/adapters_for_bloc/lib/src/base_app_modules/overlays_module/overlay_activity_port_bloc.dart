import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show OverlayStatusCubit;
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayActivityPort, OverlayDispatcher;

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
      if (!_cubit.isClosed) {
        _cubit.isActive = isActive;
      }
    });
  }

  //
}
