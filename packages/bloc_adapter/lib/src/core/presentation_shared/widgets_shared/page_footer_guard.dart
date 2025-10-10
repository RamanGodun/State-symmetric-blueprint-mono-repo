import 'package:bloc_adapter/bloc_adapter.dart' show OverlayStatusCubit;
import 'package:core/public_api/shared_layers/presentation.dart'
    show FooterEnabled;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🛡️ [FooterGuardScopeBloc] — disables footer actions while submitting or overlay active
/// ✅ Combines 2 guards:
///    1) `isLoading` — extracted from Cubit/Bloc via selector
///    2) `isOverlayActive` — true while dialog/banner/toast shown
/// ♻️ State-agnostic — identical logic for parity with Riverpod
//
final class FooterGuardScopeBloc<C extends StateStreamable<S>, S>
    extends StatelessWidget {
  ///------------------------------------------------------------
  const FooterGuardScopeBloc({
    required bool Function(S) isLoadingSelector,
    required this.child,
    super.key,
  }) : _isLoadingSelector = isLoadingSelector;

  /// 🔎 Selector that extracts loading flag from Bloc state
  final bool Function(S) _isLoadingSelector;

  /// 🧱 Footer child that will receive computed `isEnabled`
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    /// 🛡️ Overlay guard — disables when overlay is visible
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (c) => c.state,
    );

    return BlocSelector<C, S, bool>(
      selector: _isLoadingSelector,
      builder: (context, isLoading) {
        /// ♻️ Combine both conditions → final `isEnabled`
        final isEnabled = !isLoading && !isOverlayActive;

        return FooterEnabled(isEnabled: isEnabled, child: child);
      },
    );
  }
}
