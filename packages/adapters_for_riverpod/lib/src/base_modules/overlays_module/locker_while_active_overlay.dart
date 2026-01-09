import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_adapters_providers.dart'
    show overlayStatusProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayActivityWatcher, SubmitCompletionLockController;
import 'package:shared_utils/public_api/general_utils.dart' show Cancel;

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
