import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/base_modules/overlays/utils/ports/overlay_activity_port.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_adapters_providers.g.dart';

/// 🔌 [RiverpodOverlayActivityPort] — bridges OverlayDispatcher → Riverpod state
//
final class RiverpodOverlayActivityPort implements OverlayActivityPort {
  ///-----------------------------------------------------------------
  RiverpodOverlayActivityPort(this._ref);
  final Ref _ref;
  //
  @override
  void setActive({required bool isActive}) {
    // Forward activity flag to generated provider
    _ref.read(overlayStatusProvider.notifier).isActive = isActive;
  }
}

////
////

/// 🧩 OverlayDispatcher DI with Riverpod port
//
@Riverpod(keepAlive: true)
OverlayDispatcher overlayDispatcher(Ref ref) {
  final port = RiverpodOverlayActivityPort(ref);
  return OverlayDispatcher(activityPort: port);
}

////
////

/// 🧠 OverlayStatus — global overlay activity flag (default: false)
//
@Riverpod(keepAlive: true)
class OverlayStatus extends _$OverlayStatus {
  @override
  bool build() => false;
  //
  /// 🔄 Setter: update overlay activity flag
  set isActive(bool v) => state = v;
  //
  /// 👁️ Getter: current overlay activity flag
  bool get isActive => state;
  //
}
