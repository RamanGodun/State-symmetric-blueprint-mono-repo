import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/base_modules/overlays_module/overlay_adapters_providers.dart'
    show overlayStatusProvider;

/// 🧠 Quick access to the global overlay activity flag.
/// Usage: `if (ref.isOverlayActive) { ... }`
//
extension OverlayStatusRefX on WidgetRef {
  ///
  bool get isOverlayActive => watch(overlayStatusProvider);
}

////
////

/// 🧠 Quick access to the global overlay activity flag from any Ref.
/// Works both inside widgets (WidgetRef) and plain providers (Ref).
//
extension OverlayRefX on Ref {
  ///
  bool get isOverlayActive => watch(overlayStatusProvider);
}
