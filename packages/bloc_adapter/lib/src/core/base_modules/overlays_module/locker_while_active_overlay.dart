import 'package:bloc_adapter/bloc_adapter.dart' show OverlayStatusCubit;
import 'package:bloc_adapter/src/core/base_modules/overlays_module/overlay_status_cubit.dart'
    show OverlayStatusCubit;
import 'package:core/public_api/base_modules/overlays.dart'
    show OverlayActivityWatcher, SubmitCompletionLockController;
import 'package:core/public_api/utils.dart' show Cancel;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔌 [BlocOverlayWatcher] — bridges overlay activity from BLoC
/// to the core [SubmitCompletionLockController].
//
final class BlocOverlayWatcher implements OverlayActivityWatcher {
  /// ---------------------------------------------------------
  BlocOverlayWatcher(this.ctx);
  //
  /// Context used to access [OverlayStatusCubit].
  final BuildContext ctx;

  @override
  Cancel subscribe(void Function({required bool active}) onChange) {
    final sub = ctx.read<OverlayStatusCubit>().stream.listen(
      (value) => onChange(active: value),
    );
    return sub.cancel;
  }

  //
}
