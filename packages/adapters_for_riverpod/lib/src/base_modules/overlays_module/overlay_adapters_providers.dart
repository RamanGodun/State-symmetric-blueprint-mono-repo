import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayActivityPort, OverlayDispatcher;

part 'overlay_adapters_providers.g.dart';

/// 🔌 Bridges [OverlayDispatcher] activity into Riverpod state.
/// Used by the dispatcher to notify UI about overlay visibility.
//
final class RiverpodOverlayActivityPort implements OverlayActivityPort {
  ///-------------------------------------------------
  RiverpodOverlayActivityPort(this._ref);
  final Ref _ref;

  /// local cache to avoid redundant state updates
  bool? _last;

  @override
  void setActive({required bool isActive}) {
    if (_last == isActive) return; // no-op if unchanged
    _last = isActive;

    // Defer state updates to avoid "modify while building" assertions.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      try {
        _ref.read(overlayStatusProvider.notifier).isActive = isActive;
      } on Exception {
        // Provider might be disposed; ignore safely.
      }
    });
  }

  /// 🔄 Clear the local cache (useful e.g. after hot-reload)
  void resetCache() => _last = null;
  //
}

////
////

/// 🧩 DI binding: provides a process-wide [OverlayDispatcher].
@Riverpod(keepAlive: true)
OverlayDispatcher overlayDispatcher(Ref ref) {
  final port = RiverpodOverlayActivityPort(ref);
  return OverlayDispatcher(activityPort: port);
}

////
////

/// 🧠 Global overlay activity flag (default: false).
//
@Riverpod(keepAlive: true)
final class OverlayStatus extends _$OverlayStatus {
  ///-------------------------------------------
  @override
  bool build() => false;
  //
  /// 🔄 Setter for overlay activity.
  set isActive(bool v) => state = v;
  //
  /// 👁️ Getter for overlay activity.
  bool get isActive => state;
  //
}
