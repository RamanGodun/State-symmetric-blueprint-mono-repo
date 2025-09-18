import 'package:bloc_adapter/bloc_adapter.dart' show OverlayStatusCubit;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🚧 [FooterGuard] — universal wrapper for footers / submit buttons
/// ✅ Combines 2 conditions that disable the child:
///    - `isLoading` (extracted from any Cubit/Bloc via selector)
///    - `isOverlayActive` (true when dialog/banner/toast is visible)
///

final class FooterGuard<C extends StateStreamable<S>, S>
    extends StatelessWidget {
  ///--------------------------------------------------------------------------
  const FooterGuard({
    required this.isLoadingSelector,
    required this.childBuilder,
    super.key,
  });

  /// 🔎 Selector function — extracts "isLoading" flag from Cubit/Bloc state
  final bool Function(S state) isLoadingSelector;

  /// 🏗️ Builder callback — builds child with computed `isEnabled` flag
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext context, bool isEnabled) childBuilder;

  @override
  Widget build(BuildContext context) {
    // 🛡️ Overlay guard — if any overlay is active → disable child
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );

    return BlocSelector<C, S, bool>(
      selector: isLoadingSelector,
      builder: (context, isLoading) {
        // ♻️ Combine both conditions → final "isEnabled"
        final isEnabled = !isLoading && !isOverlayActive;
        return childBuilder(context, isEnabled);
      },
    );
  }
}

/*

/// ? 💡 Usage:
/// ```dart
/// FooterGuard<ResetPasswordCubit, ResetPasswordState>(
///   isLoadingSelector: (s) => s.status.isSubmissionInProgress,
///   childBuilder: (_, isEnabled) => _ResetPasswordFooter(isEnabled: isEnabled),
/// )
/// ```

 */
