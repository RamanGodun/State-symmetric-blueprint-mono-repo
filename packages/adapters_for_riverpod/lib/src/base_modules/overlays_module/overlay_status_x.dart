import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show overlayStatusProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, WidgetRef;

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
