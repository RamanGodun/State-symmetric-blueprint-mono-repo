import 'package:bloc_adapter/bloc_adapter.dart' show OverlayStatusCubit;
import 'package:core/public_api/shared_layers/presentation.dart'
    show FooterGuardScope;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
