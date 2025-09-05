part of 'go_router_factory.dart';

/// 📍 Path alias for readability
typedef Path = String;

/// 🧭🚦 [computeRedirect] — pure function for redirect decisions
/// ✅ Shared across Riverpod and Bloc
/// ✅ Deterministic, idempotent, and testable
/// ✅ Hysteresis: after first resolution, transient Loading won’t push `/splash`
//
Path? computeRedirect({
  required Path currentPath,
  required AuthSnapshot snapshot,
  required bool hasResolvedOnce,
}) {
  /// 🗝️ Publicly accessible routes (no auth required)
  const publicRoutes = {
    RoutesPaths.signIn,
    RoutesPaths.signUp,
    RoutesPaths.resetPassword,
  };

  /// 📍 Route classification flags
  final isOnPublic = publicRoutes.contains(currentPath);
  final isOnVerify = currentPath == RoutesPaths.verifyEmail;
  final isOnSplash = currentPath == RoutesPaths.splash;

  /// 🔄 Decision tree
  return switch (snapshot) {
    /// ⏳ Loading → splash before first resolution, otherwise no redirect
    AuthLoading() =>
      hasResolvedOnce ? null : (isOnSplash ? null : RoutesPaths.splash),

    /// ❌ Failure → force redirect to SignIn
    AuthFailure() => RoutesPaths.signIn,

    /// ✅ Ready → evaluate authentication and verification status
    AuthReady(:final session) => () {
      final authed = session.isAuthenticated;
      final verified = session.emailVerified;

      /// 🚪 Not authenticated → restrict to public routes
      if (!authed) return isOnPublic ? null : RoutesPaths.signIn;

      /// 🧪 Not verified → restrict to verify page
      if (!verified) return isOnVerify ? null : RoutesPaths.verifyEmail;

      /// 🏠 Authenticated + verified → force home if on restricted routes
      const restricted = {
        RoutesPaths.splash,
        RoutesPaths.verifyEmail,
        ...publicRoutes,
      };
      final shouldGoHome =
          restricted.contains(currentPath) && authed && verified;
      if (shouldGoHome && currentPath != RoutesPaths.home) {
        return RoutesPaths.home;
      }

      // ➖ Otherwise, no redirect
      return null;
    }(),
  };
}
