import 'package:core/base_modules/overlays/overlays_barrel.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/utils/ports/overlay_activity_port.dart';
import 'package:core/core_barrel.dart' show OverlayDispatcher;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧩 [overlayStatusProvider] — global overlay activity state (Riverpod)
final overlayStatusProvider =
    StateNotifierProvider<OverlayStatusNotifier, bool>(
      (_) => OverlayStatusNotifier(),
    );

////
////

/// 🧩 [OverlayStatusNotifier] — manages overlay visibility state
//
final class OverlayStatusNotifier extends StateNotifier<bool> {
  ///-------------------------------------------------------
  OverlayStatusNotifier() : super(false);
  //
  /// 🔄 Updates overlay activity flag
  set isActive(bool v) => state = v;
  //
  /// 👁️ Current overlay activity flag
  bool get isActive => state;
}

////
////

/// 🔌 [RiverpodOverlayActivityPort] — adapter port for [OverlayDispatcher] → Riverpod
//
final class RiverpodOverlayActivityPort implements OverlayActivityPort {
  ///----------------------------------------------------------------
  RiverpodOverlayActivityPort(this._ref);
  final Ref _ref;

  /// 🔄 Propagates overlay activity to [overlayStatusProvider]
  @override
  void setActive({required bool isActive}) {
    _ref.read(overlayStatusProvider.notifier).isActive = isActive;
  }
}

////
////

/// 🧠 [OverlayStatusX] — extension for quick overlay activity access
extension OverlayStatusX on WidgetRef {
  /// ✅ Returns true if any overlay is active
  bool get isOverlayActive => watch(overlayStatusProvider);
}
