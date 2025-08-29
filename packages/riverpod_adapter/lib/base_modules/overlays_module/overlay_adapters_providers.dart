import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/base_modules/overlays/utils/ports/overlay_activity_port.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_adapters_providers.g.dart';

/// 🔌 [RiverpodOverlayActivityPort] — bridges OverlayDispatcher with Riverpod state
//
final class RiverpodOverlayActivityPort implements OverlayActivityPort {
  ///-------------------------------------------------
  RiverpodOverlayActivityPort(this._ref);
  final Ref _ref;

  bool? _last; // local cache to avoid redundant state updates

  @override
  void setActive({required bool isActive}) {
    if (_last == isActive) return; // no-op if state hasn't changed
    _last = isActive;

    // always defer updates to avoid "modify while building" assertions
    SchedulerBinding.instance.addPostFrameCallback((_) {
      try {
        _ref.read(overlayStatusProvider.notifier).isActive = isActive;
      } on Exception {
        // provider may already be disposed — safely ignore
      }
    });
  }

  /// 🔄 resets the local cache (useful e.g. after hot-reload)
  void resetCache() => _last = null;
  //
}

////
////

/// 🧩 DI binding of OverlayDispatcher into Riverpod
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
final class OverlayStatus extends _$OverlayStatus {
  ///-------------------------------------------
  @override
  bool build() => false;
  //
  /// 🔄 state setter
  set isActive(bool v) => state = v;
  //
  /// 👁️ state getter
  bool get isActive => state;
  //
}
