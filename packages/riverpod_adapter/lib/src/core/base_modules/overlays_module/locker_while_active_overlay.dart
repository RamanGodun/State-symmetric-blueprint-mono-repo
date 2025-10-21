import 'package:core/public_api/core.dart'
    show Cancel, OverlayActivityWatcher, SubmitCompletionLockController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/base_modules/overlays_module/overlay_adapters_providers.dart'
    show overlayStatusProvider;

/// 🔌 [RiverpodOverlayWatcher] — bridges overlay activity from Riverpod
/// to the core [SubmitCompletionLockController].
//
final class RiverpodOverlayWatcher implements OverlayActivityWatcher {
  /// -------------------------------------------------------------
  RiverpodOverlayWatcher(this.ref);
  //
  /// Riverpod reference to access providers.
  final WidgetRef ref;

  @override
  Cancel subscribe(void Function({required bool active}) onChange) {
    final sub = ref.listenManual<bool>(
      overlayStatusProvider,
      (prev, next) => onChange(active: next),
      fireImmediately: false,
    );
    return sub.close;
  }

  //
}
