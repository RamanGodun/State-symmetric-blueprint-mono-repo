import 'package:core/public_api/shared_layers/presentation.dart'
    show FooterEnabled;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/base_modules/overlays_module/overlay_status_x.dart';

/// 🛡️ [FooterGuardScopeRiverpod] — disables footer actions while submitting or overlay active
/// ✅ Combines 2 guards:
///    1) `isLoading` — watched from provided Riverpod selector
///    2) `isOverlayActive` — true while dialog/banner/toast shown
/// ♻️ State-agnostic — identical logic for parity with BLoC
//
final class FooterGuardScopeRiverpod extends ConsumerWidget {
  ///-----------------------------------------------------
  const FooterGuardScopeRiverpod({
    required this.isLoadingProvider,
    required this.child,
    super.key,
  });

  /// 🔎 External loading flag (e.g. `signInProvider.select(...)`)
  final ProviderListenable<bool> isLoadingProvider;

  /// 🧱 Footer child that will receive computed `isEnabled`
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⏳ Submission loading flag
    final isLoading = ref.watch(isLoadingProvider);

    /// 🛡️ Overlay guard — disables when overlay is visible
    final isOverlayActive = ref.isOverlayActive;

    /// ♻️ Combine both conditions → final `isEnabled`
    final isEnabled = !isLoading && !isOverlayActive;

    return FooterEnabled(isEnabled: isEnabled, child: child);
  }
}
