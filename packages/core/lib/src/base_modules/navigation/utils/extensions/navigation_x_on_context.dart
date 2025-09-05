import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 🧭 [NavigationX] — Adds concise navigation helpers for [GoRouter] & [Navigator]
/// ✅ Improves DX with named routes, push/pop, and fallback handling
//
extension NavigationX on BuildContext {
  ///-------------------------------

  /// 🚀 Go to a named route (replaces current stack)
  void goTo(
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
  }) {
    try {
      GoRouter.of(this).goNamed(
        routeName,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
    } on Object catch (_) {
      GoRouter.of(this).goNamed('pageNotFound');
    }
  }

  /// ➕ Push a named route onto the stack
  void goPushTo(
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
  }) {
    try {
      GoRouter.of(this).pushNamed(
        routeName,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
    } on Object catch (_) {
      GoRouter.of(this).goNamed('pageNotFound');
    }
  }

  /// 🔙 Pop the current view
  void popView<T extends Object?>([T? result]) =>
      Navigator.of(this).pop<T>(result);

  /// 🧭 Push a custom widget onto the stack using [MaterialPageRoute]
  Future<T?> pushTo<T>(Widget child) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => child));
  }

  /// 📌 Replace current view with [child]
  Future<T?> replaceWith<T>(Widget child) {
    return Navigator.of(
      this,
    ).pushReplacement<T, T>(MaterialPageRoute(builder: (_) => child));
  }

  ////

  /// 🧭 Navigates to the given [route] only if [BuildContext] is still mounted.
  /// - Prevents navigation errors after widget disposal (e.g., after async operations).
  /// - Safe to call in any async callback or state listener.
  void goIfMounted(String route) {
    if (mounted) goTo(route);
  }

  //
}
