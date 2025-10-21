import 'package:core/public_api/base_modules/overlays.dart'
    show OverlayActivityWatcher;
import 'package:core/public_api/utils.dart' show AppDurations;
import 'package:core/src/utils_shared/type_definitions.dart' show Cancel;

/// Controller that locks submit button after completion to avoid flicker.
/// Unlocks automatically when overlay activates or after [fallback] timeout.
//
final class SubmitCompletionLockController {
  ///-------------------------------------
  SubmitCompletionLockController({
    required this.overlayWatcher,
    this.fallback = AppDurations.ms180,
  });

  /// 👁️ Watches overlay state (injected from Riverpod/BLoC adapter).
  final OverlayActivityWatcher overlayWatcher;
  //
  /// ⏳ Fallback duration for auto-unlock if overlay never activates.
  final Duration fallback;
  //
  /// Internal lock flag.
  bool _locked = false;
  //
  /// ✅ Whether the lock is currently active.
  bool get isLocked => _locked;
  //
  /// Cancel callback for overlay subscription.
  Cancel? _cancelOverlay;

  /// 🚀 Arms the lock after submit finishes (loading: true → false).
  /// Unlocks on overlay activation or after [fallback] timeout.
  void arm() {
    if (_locked) return;
    _locked = true;

    _cancelOverlay?.call();
    _cancelOverlay = overlayWatcher.subscribe(
      ({required bool active}) {
        if (active) _unlock();
      },
    );
    Future.delayed(fallback, _unlock);
  }

  /// 🔓 Internal unlock logic — clears lock & overlay subscription.
  void _unlock() {
    if (!_locked) return;
    _locked = false;
    _cancelOverlay?.call();
    _cancelOverlay = null;
  }

  /// 🧼 Cleanup: cancels overlay subscription and releases resources.
  void dispose() {
    _cancelOverlay?.call();
    _cancelOverlay = null;
  }

  //
}
