import 'dart:async' show Future, unawaited;

import 'package:flutter/material.dart'
    show BuildContext, MaterialPageRoute, Navigator, Widget, debugPrint;
import 'package:go_router/go_router.dart' show GoRouter;

/// 🧭 [NavigationX] — concise navigation helpers for [GoRouter] & [Navigator]
/// ✅ Named routes + push/pop
/// ✅ Safe fallbacks on failures
//
extension NavigationX on BuildContext {
  /// -------------------------------

  /// 🚀 Go to a named route (replaces current stack)
  void goTo(
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
  }) {
    debugPrint('🔄 goTo → $routeName');
    try {
      GoRouter.of(this).goNamed(
        routeName,
        pathParameters: pathParameters,
        queryParameters: queryParameters, // go_router expects dynamic
      );
    } on Object catch (e) {
      debugPrint('❌ goNamed failed: $e');
      GoRouter.of(this).goNamed('pageNotFound');
    }
  }

  /// ➕ Push a named route onto the stack
  void goPushTo(
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
  }) {
    debugPrint('🔄 goPushTo → $routeName');
    try {
      unawaited(
        GoRouter.of(this).pushNamed(
          routeName,
          pathParameters: pathParameters,
          queryParameters: queryParameters, // go_router expects dynamic
        ),
      );
    } on Object catch (e) {
      debugPrint('❌ pushNamed failed: $e');
      GoRouter.of(this).goNamed('pageNotFound');
    }
  }

  /// 🔙 Pop current view
  void popView<T extends Object?>([T? result]) =>
      Navigator.of(this).pop<T>(result);

  /// 🧭 Push a custom widget via [MaterialPageRoute]
  Future<T?> pushTo<T>(Widget child) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => child));
  }

  /// 📌 Replace current view with [child]
  Future<T?> replaceWith<T>(Widget child) {
    return Navigator.of(this).pushReplacement<T, T>(
      MaterialPageRoute(builder: (_) => child),
    );
  }

  // --

  /// 🧭 Navigate to [routeName] only if context is still mounted
  void goIfMounted(String routeName) {
    if (mounted) goTo(routeName);
  }

  /// 🎯 Global router context from `GoRouter.navigatorKey` (if any)
  BuildContext? get globalRouterContext {
    try {
      return GoRouter.of(this).routerDelegate.navigatorKey.currentContext;
    } on Object catch (e) {
      debugPrint('❌ globalRouterContext error: $e');
      return null;
    }
  }

  //
}
