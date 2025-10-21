import 'package:core/public_api/shared_layers/presentation.dart'
    show FooterGuardScope;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/base_modules/overlays_module/overlay_status_x.dart';

/// 🛡️ [RiverpodAdapterForFooterGuard] — thin Riverpod adapter over [FooterGuardScope].
//
final class RiverpodAdapterForFooterGuard extends ConsumerWidget {
  ///-----------------------------------------------------
  const RiverpodAdapterForFooterGuard({
    required this.isLoadingProvider,
    required this.child,
    super.key,
  });

  /// 🔎 External loading flag (e.g. `signInProvider.select(...)`)
  final ProviderListenable<bool> isLoadingProvider;
  //
  /// 🧱 Footer child that will receive computed `isEnabled`
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⏳ Submission loading flag
    final isLoadingNow = ref.watch(isLoadingProvider);
    //
    /// 🛡️ Overlay guard — disables when overlay is visible
    final isOverlayActiveNow = ref.isOverlayActive;

    return FooterGuardScope(
      isLoading: () => isLoadingNow,
      isOverlayActive: () => isOverlayActiveNow,
      child: child,
    );
  }

  //
}
