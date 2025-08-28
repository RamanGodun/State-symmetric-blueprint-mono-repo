import 'package:blueprint_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';

///
typedef Path = String;

////
////

/// 🧭🚦 [computeRedirect] — centralized redirect logic for GoRouter
/// 🔐 Dynamically handles navigation based on normalized auth state ([AuthSnapshot]):
///   - 🚪 `/signin` if unauthenticated
///   - 🧪 `/verifyEmail` if email is not verified
///   - 🧯 `/signin` on auth failure (optionally map to a dedicated error page)
///   - ⏳ `/splash` while initial loading (first auth resolution)
///   - ✅ `/home` when fully authenticated and verified
///
/// 🧲 Hysteresis: After the first non-loading auth state,
///    transient `Loading` does NOT force navigation to `/splash`.
//
Path? computeRedirect({
  required Path currentPath,
  required AuthSnapshot snapshot,
  required bool hasResolvedOnce,
}) {
  // 🗝️ Public routes — accessible without authentication
  const publicRoutes = {
    RoutesPaths.signIn,
    RoutesPaths.signUp,
    RoutesPaths.resetPassword,
  };

  // 📍 Route flags
  final isOnPublic = publicRoutes.contains(currentPath);
  final isOnVerify = currentPath == RoutesPaths.verifyEmail;
  final isOnSplash = currentPath == RoutesPaths.splash;

  // 🔄 Decisions
  return switch (snapshot) {
    // ⏳ Loading:
    // - before first resolution → show splash
    // - after first resolution → stay where you are (avoid bouncing to /home later)
    AuthLoading() =>
      hasResolvedOnce ? null : (isOnSplash ? null : RoutesPaths.splash),

    // ❌ Failure → go to SignIn (or a dedicated error route)
    AuthFailure() => RoutesPaths.signIn,

    // ✅ Ready → check authentication and verification flags
    AuthReady(:final session) => () {
      final authed = session.isAuthenticated;
      final verified = session.emailVerified;

      // 🚪 Not authenticated → allow only public routes
      if (!authed) return isOnPublic ? null : RoutesPaths.signIn;

      // 🧪 Not verified → stay on /verifyEmail or redirect there
      if (!verified) return isOnVerify ? null : RoutesPaths.verifyEmail;

      // 🏠 If authenticated & verified and currently on splash/public/verify → go home
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
