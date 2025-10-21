import 'package:core/public_api/shared_layers/presentation.dart'
    show FooterGuardInherited;
import 'package:core/src/utils_shared/type_definitions.dart' show BoolGetter;
import 'package:flutter/widgets.dart';

/// 🛡️ [FooterGuardScope] — state-agnostic guard for footer actions.
/// Enabled iff `!isLoading() && !isOverlayActive()`.
//
final class FooterGuardScope extends StatelessWidget {
  ///----------------------------------------------
  const FooterGuardScope({
    required this.isLoading,
    required this.isOverlayActive,
    required this.child,
    super.key,
  });

  /// External loading flag getter.
  final BoolGetter isLoading;
  //
  /// External overlay flag getter.
  final BoolGetter isOverlayActive;
  //
  /// Footer subtree that reads computed `isEnabled`.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    /// ♻️ Combine both conditions → final `isEnabled`
    final enabled = !isLoading() && !isOverlayActive();
    //
    return FooterGuardInherited(isEnabled: enabled, child: child);
    //
  }
}
