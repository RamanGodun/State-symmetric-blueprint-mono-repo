import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧠 [overlayDispatcherProvider] — Provides [OverlayDispatcher]
/// and syncs its activity with [overlayStatusProvider].
//
final overlayDispatcherProvider = Provider<OverlayDispatcher>((ref) {
  return OverlayDispatcher(
    onOverlayStateChanged: ref.read(overlayStatusProvider.notifier).update,
  );
});

////
////

final class OverlayStatusNotifier extends StateNotifier<bool> {
  ///------------------------------------------------------
  OverlayStatusNotifier() : super(false);
  //
  /// New recommended API
  bool get isActive => state;
  set isActive(bool value) => state = value;

  // @Deprecated('Use the `isActive` setter instead')
  ///
  // ignore: use_setters_to_change_properties
  void update({required bool isActive}) => this.isActive = isActive;
}

////
////

/// 🧩 [overlayStatusProvider] — Manages current overlay visibility state.
/// ✅ Used to propagate `isOverlayActive` from [OverlayDispatcher] to UI logic (e.g., disabling buttons).
//
final overlayStatusProvider =
    StateNotifierProvider<OverlayStatusNotifier, bool>((ref) {
      return OverlayStatusNotifier();
    });

/*
! 📌 Usage:
final dispatcher = ref.read(overlayDispatcherProvider);
final isVisible = ref.watch(overlayStatusProvider); // or ref.isOverlayActive
 */

////
////

/// 🧠 [OverlayStatusX] — Extension for accessing overlay activity status from [WidgetRef].
/// ⚠️ Quick checks only (imperative/read-only).
/// ✅ For reactive UI, watch [overlayStatusProvider] (e.g. `ref.watch(overlayStatusProvider)`)
///    inside a Consumer/HookWidget, instead of reading the notifier/dispatcher directly.
//
extension OverlayStatusX on WidgetRef {
  ///
  bool get isOverlayActive => watch(overlayStatusProvider);
}
