import 'package:adapters_for_riverpod/src/base_modules/overlays_module/locker_while_active_overlay.dart'
    show RiverpodOverlayWatcher;
import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_adapters_providers.dart'
    show overlayStatusProvider;
import 'package:flutter/material.dart' show BuildContext, VoidCallback, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, ProviderListenable, WidgetRef;
import 'package:shared_widgets/public_api/buttons.dart' show SubmitButton;

/// 🚀 [RiverpodAdapterForSubmitButton] — Riverpod adapter for core submit button.
/// Wires form validity, loading state and overlay activity into [SubmitButton].
//
final class RiverpodAdapterForSubmitButton extends ConsumerWidget {
  ///------------------------------------------------------------
  const RiverpodAdapterForSubmitButton({
    required this.label,
    required this.isFormValid,
    required this.isLoadingSelector,
    required this.onPressed,
    this.loadingLabel,
    super.key,
  });

  /// Default button label.
  final String label;
  //
  /// Optional label during loading (raw text or localization key).
  final String? loadingLabel;
  //
  /// Provider returning form validity.
  final ProviderListenable<bool> isFormValid;
  //
  /// Provider returning loading state.
  final ProviderListenable<bool> isLoadingSelector;
  //
  /// Press callback (enabled only when form is valid and not locked).
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final watcher = RiverpodOverlayWatcher(ref);
    //
    return SubmitButton(
      label: label,
      loadingLabel: loadingLabel,
      isValid: () => ref.watch(isFormValid),
      isLoading: () => ref.watch(isLoadingSelector),
      isOverlayActive: () => ref.watch(overlayStatusProvider),
      onPressed: onPressed,
      overlayWatcher: watcher,
    );
  }

  //
}
