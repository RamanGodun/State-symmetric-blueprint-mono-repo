import 'package:adapters_for_bloc/src/base_app_modules/overlays_module/overlay_status_cubit.dart'
    show OverlayStatusCubit;
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayActivityWatcher;
import 'package:shared_core_modules/shared_core_modules.dart'
    show SubmitCompletionLockController;
import 'package:shared_utils/public_api/general_utils.dart' show Cancel;

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
