import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show OverlayStatusRefX;
import 'package:flutter/material.dart' show BuildContext, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, ProviderListenable, WidgetRef;
import 'package:shared_widgets/public_api/footers.dart' show FooterGuardScope;

/// 🛡️ [RiverpodAdapterForFooterGuard] — thin Riverpod adapter over [FooterGuardScope].
//
final class RiverpodAdapterForFooterGuard extends ConsumerWidget {
  ///-----------------------------------------------------
  const RiverpodAdapterForFooterGuard({
    required this.isLoadingSelector,
    required this.child,
    super.key,
  });

  /// 🔎 External loading flag (e.g. `signInProvider.select(...)`)
  final ProviderListenable<bool> isLoadingSelector;
  //
  /// 🧱 Footer child that will receive computed `isEnabled`
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⏳ Submission loading flag
    final isLoadingNow = ref.watch(isLoadingSelector);
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
