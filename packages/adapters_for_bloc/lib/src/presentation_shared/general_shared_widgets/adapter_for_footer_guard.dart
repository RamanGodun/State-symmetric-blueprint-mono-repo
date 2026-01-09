import 'package:adapters_for_bloc/src/base_app_modules/overlays_module/overlay_status_cubit.dart'
    show OverlayStatusCubit;
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocSelector, SelectContext, StateStreamable;
import 'package:shared_widgets/public_api/footers.dart' show FooterGuardScope;

/// 🛡️ [BlocAdapterForFooterGuard] — thin BLoC adapter over [FooterGuardScope].
//
final class BlocAdapterForFooterGuard<C extends StateStreamable<S>, S>
    extends StatelessWidget {
  ///------------------------------------------------------------------------------------
  const BlocAdapterForFooterGuard({
    required bool Function(S) isLoadingSelector,
    required this.child,
    super.key,
  }) : _isLoadingSelector = isLoadingSelector;

  /// 🔎 Selector that extracts loading flag from Bloc state
  final bool Function(S) _isLoadingSelector;
  //
  /// 🧱 Footer child that will receive computed `isEnabled`
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    /// 🛡️ Overlay guard — disables when overlay is visible
    final isOverlayActiveNow = context.select<OverlayStatusCubit, bool>(
      (c) => c.state,
    );
    //
    return BlocSelector<C, S, bool>(
      selector: _isLoadingSelector,
      builder: (context, isLoadingNow) {
        // Getters allows FooterGuardScope be state-agnostic
        return FooterGuardScope(
          isLoading: () => isLoadingNow,
          isOverlayActive: () => isOverlayActiveNow,
          child: child,
        );
      },
    );
  }
}
