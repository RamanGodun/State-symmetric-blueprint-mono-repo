import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧩 [OverlayStatusCubit] — global overlay activity state (Bloc)
///
final class OverlayStatusCubit extends Cubit<bool> {
  ///--------------------------------------------
  OverlayStatusCubit() : super(false);

  /// 🔄 Updates overlay activity flag
  set isActive(bool v) => emit(v);

  /// 👁️ Current overlay activity flag
  bool get isActive => state;

  /// 🔄 Legacy-style update API (optional, for compatibility)
  void updateStatus({required bool isActive}) => emit(isActive);

  //
}
