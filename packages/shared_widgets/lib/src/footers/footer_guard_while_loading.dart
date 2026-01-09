import 'package:flutter/widgets.dart';
import 'package:shared_utils/public_api/general_utils.dart' show BoolGetter;
import 'package:shared_widgets/public_api/footers.dart'
    show FooterGuardInherited;

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
