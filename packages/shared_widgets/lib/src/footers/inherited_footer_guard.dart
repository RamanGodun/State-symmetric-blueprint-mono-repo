import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 🛡️ [FooterGuardInherited] — context carrier for `isEnabled`
/// ✅ Universal flag (works in BLoC & Riverpod stacks)
/// ♻️ Access via `FooterEnabled.of(context)`
//
final class FooterGuardInherited extends InheritedWidget {
  ///-------------------------------------------
  /// Creates a [FooterGuardInherited] that passes the `isEnabled` flag down the tree.
  const FooterGuardInherited({
    required this.isEnabled,
    required super.child,
    super.key,
  });

  /// 🔖 Current enable/disable flag.
  final bool isEnabled;

  /// ✅ Accessor with dependency — rebuilds when `isEnabled` changes.
  /// Safe fallback (default `true`) so UX never breaks in prod if missing.
  static bool of(BuildContext context, {bool orElse = true}) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<FooterGuardInherited>();
    assert(
      widget != null,
      'FooterEnabled.of(): no FooterEnabled ancestor found. '
      'Using fallback=$orElse. Wrap the subtree with FooterGuardScope '
      '(Bloc/Riverpod adapter) or provide FooterEnabled manually.',
    );
    return widget?.isEnabled ?? orElse;
  }

  /// 🫶 Nullable accessor without dependency (no rebuild on updates).
  static bool? maybeOf(BuildContext context) {
    final elem = context
        .getElementForInheritedWidgetOfExactType<FooterGuardInherited>();
    final widget = elem?.widget as FooterGuardInherited?;
    return widget?.isEnabled;
  }

  /// 🔄 Triggers rebuild when `isEnabled` flag changes.
  @override
  bool updateShouldNotify(FooterGuardInherited oldWidget) =>
      oldWidget.isEnabled != isEnabled;

  /// 🪛 Adds `isEnabled` flag to widget tree diagnostics (debug inspector).
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('isEnabled', value: isEnabled));
  }

  //
}

////
////

/// 🧩 [FooterEnabledContextX] — extension for quick access
/// ✅ Declarative API: `context.isFooterEnabled`
//
extension FooterEnabledContextX on BuildContext {
  //
  /// 📌 Returns current footer enabled state
  /// (safe fallback = true if no ancestor found)
  bool get isFooterEnabled => FooterGuardInherited.of(this);

  /// 📌 Returns nullable footer enabled state
  /// (null if no ancestor found)
  bool? get maybeFooterEnabled => FooterGuardInherited.maybeOf(this);
  //
}

////
////
////

/// ---------------------------------------------------------------------------
/// 💡 If in the future you need to change `isEnabled` without rebuilding
/// the entire parent widget, consider using `InheritedNotifier`.
/// It allows you to keep the state in a `ValueNotifier`/`ChangeNotifier`
/// and push updates down the tree.
///
/// Example:
///
/// ```dart
/// final class FooterGuardNotifier extends InheritedNotifier<ValueNotifier<bool>> {
///   const FooterGuardNotifier({
///     required bool isEnabled,
///     required super.child,
///     super.key,
///   }) : super(notifier: ValueNotifier<bool>(isEnabled));
///
///   static bool of(BuildContext context, {bool orElse = true}) {
///     final w = context.dependOnInheritedWidgetOfExactType<FooterGuardNotifier>();
///     return w?.notifier?.value ?? orElse;
///   }
///
///   void setEnabled(bool value) => notifier?.value = value;
/// }
/// ```
///
/// 🔎 Advantages:
/// - you can update the state (`setEnabled`) without recreating the whole tree;
/// - descendants calling `.of(context)` will rebuild automatically;
/// - convenient if you need to pass multiple flags or more complex states.
///
/// For current use case with a single static flag, the plain `InheritedWidget`- is the simplest and most correct option.
/// But for dynamic or more complex scenarios, `InheritedNotifier` would be a better fit.
/// ---------------------------------------------------------------------------
