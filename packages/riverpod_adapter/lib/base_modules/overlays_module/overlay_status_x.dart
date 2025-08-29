import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_adapters_providers.dart'
    show overlayStatusProvider;

/// 🧠 Quick access to overlay activity flag
extension OverlayStatusX on WidgetRef {
  ///
  bool get isOverlayActive => watch(overlayStatusProvider);
}
