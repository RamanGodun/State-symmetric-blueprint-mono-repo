import 'package:flutter/material.dart';

/// 🛡️ [FooterEnabled] — context carrier for `isEnabled`
/// ✅ Universal flag (works in BLoC & Riverpod stacks)
/// ♻️ Provides access via `FooterEnabled.of(context)`
//
final class FooterEnabled extends InheritedWidget {
  ///--------------------------------------------
  /// Creates a [FooterEnabled] widget to pass
  /// the `isEnabled` flag down the tree.
  const FooterEnabled({
    required this.isEnabled,
    required super.child,
    super.key,
  });

  /// 🔖 Current enable/disable flag
  final bool isEnabled;
  //

  /// ✅ Safe accessor with fallback (default = true → UX never breaks)
  static bool of(BuildContext context, {bool orElse = true}) {
    final element = context
        .getElementForInheritedWidgetOfExactType<FooterEnabled>();
    final widget = element?.widget as FooterEnabled?;
    assert(
      () {
        if (widget == null) {
          // 💡 Tip: wrap subtree with FooterGuardScope… so footer reads a real value
          debugPrint(
            '⚠️ FooterEnabled.of() → no ancestor found. Using fallback=$orElse',
          );
        }
        return true;
      }(),
      'FooterEnabled.of() called with no ancestor in the widget tree.',
    );
    return widget?.isEnabled ?? orElse;
  }

  /// 🫶 Nullable accessor (explicit fallback control if needed)
  static bool? maybeOf(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<FooterEnabled>();
    final widget = element?.widget as FooterEnabled?;
    return widget?.isEnabled;
  }

  @override
  bool updateShouldNotify(FooterEnabled old) => old.isEnabled != isEnabled;
}

////
////

/// 🧩 [FooterEnabledContextX] — extension for quick access
/// ✅ Declarative API: `context.isFooterEnabled`
extension FooterEnabledContextX on BuildContext {
  /// 📌 Returns current footer enabled state
  /// (safe fallback = true if no ancestor found)
  bool get isFooterEnabled => FooterEnabled.of(this);

  /// 📌 Returns nullable footer enabled state
  /// (null if no ancestor found)
  bool? get maybeFooterEnabled => FooterEnabled.maybeOf(this);
  //
}
