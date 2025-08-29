part of 'go_router_factory.dart';

/// 📍 Route path alias
typedef Path = String;

////
////

/// 🧭🚦 [computeRedirect] — pure function for redirect decisions
/// ✅ Shared across Riverpod and Bloc
/// ✅ Hysteresis: after first resolution, transient Loading won’t push `/splash`
//
Path? computeRedirect({
  required Path currentPath,
  required AuthSnapshot snapshot,
  required bool hasResolvedOnce,
}) {
  /// 🗝️ Public routes — accessible without authentication
  const publicRoutes = {
    RoutesPaths.signIn,
    RoutesPaths.signUp,
    RoutesPaths.resetPassword,
  };

  /// 📍 Route flags
  final isOnPublic = publicRoutes.contains(currentPath);
  final isOnVerify = currentPath == RoutesPaths.verifyEmail;
  final isOnSplash = currentPath == RoutesPaths.splash;

  ////

  /// 🔄 Decision tree
  return switch (snapshot) {
    /// ⏳ Loading → splash before first resolution, otherwise stay put
    AuthLoading() =>
      hasResolvedOnce ? null : (isOnSplash ? null : RoutesPaths.splash),

    /// ❌ Failure → force SignIn
    AuthFailure() => RoutesPaths.signIn,

    /// ✅ Ready → enforce authentication + verification
    AuthReady(:final session) => () {
      final authed = session.isAuthenticated;
      final verified = session.emailVerified;

      /// 🚪 Not authenticated → only public routes allowed
      if (!authed) return isOnPublic ? null : RoutesPaths.signIn;

      /// 🧪 Email not verified → lock to verify page
      if (!verified) return isOnVerify ? null : RoutesPaths.verifyEmail;

      /// 🏠 Fully authed + verified → home if on restricted routes
      const restricted = {
        RoutesPaths.splash,
        RoutesPaths.verifyEmail,
        ...publicRoutes,
      };
      final shouldGoHome =
          restricted.contains(currentPath) && authed && verified;
      if (shouldGoHome && currentPath != RoutesPaths.home)
        return RoutesPaths.home;

      // ➖ No redirect
      return null;
    }(),
  };
}

////
////

/*
? for debugging:

    if (kDebugMode) {
        debugPrint(
          '[🔁 Redirect] $currentPath → $target (authStatus: unknown)',
        );
      }
 */
