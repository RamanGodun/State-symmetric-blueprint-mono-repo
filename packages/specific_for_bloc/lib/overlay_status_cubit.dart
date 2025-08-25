import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧩 [OverlayStatusCubit] — Manages current overlay visibility state.
/// ✅ Used to propagate `isOverlayActive` from [OverlayDispatcher] to UI logic (e.g., disabling buttons).
//
final class OverlayStatusCubit extends Cubit<bool> {
  ///---------------------------------------------
  //
  OverlayStatusCubit() : super(false);

  ///
  void updateStatus({required bool isActive}) => emit(isActive);
  //
}

////

////

/// 🧠 [OverlayStatusX] — Extension for accessing overlay activity status from [BuildContext].
/// ⚠️ Note: For read-only checks only. For reactive usage, prefer listening to [OverlayStatusCubit] via BlocBuilder
//
extension OverlayStatusX on BuildContext {
  ///
  bool get overlayStatus => read<OverlayStatusCubit>().state;
}
