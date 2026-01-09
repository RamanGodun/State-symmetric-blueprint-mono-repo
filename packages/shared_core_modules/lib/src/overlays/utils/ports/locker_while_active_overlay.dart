import 'package:shared_utils/public_api/general_utils.dart' show Cancel;

/// Contract for overlay activity watcher.
/// Decouples overlay state from specific state managers.
//
abstract interface class OverlayActivityWatcher {
  ///------------------------------------------
  //
  /// Subscribes to overlay activity and returns a cancel callback.
  Cancel subscribe(void Function({required bool active}) onChange);
  //
}
