import 'package:blueprint_on_qubit/core/base_moduls/navigation/routes/app_routes.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';

///
typedef Path = String;

///
Path? computeRedirect({
  required Path currentPath,
  required AuthSnapshot snapshot,
}) {
  const publicRoutes = {
    RoutesPaths.signIn,
    RoutesPaths.signUp,
    RoutesPaths.resetPassword,
  };

  final isOnPublic = publicRoutes.contains(currentPath);
  final isOnVerify = currentPath == RoutesPaths.verifyEmail;
  final isOnSplash = currentPath == RoutesPaths.splash;

  return switch (snapshot) {
    AuthLoading() => isOnSplash ? null : RoutesPaths.splash,
    AuthFailure() => RoutesPaths.signIn, // або сторінка помилки
    AuthReady(:final session) => () {
      final authed = session.isAuthenticated;
      final verified = session.emailVerified;

      if (!authed) return isOnPublic ? null : RoutesPaths.signIn;
      if (!verified) return isOnVerify ? null : RoutesPaths.verifyEmail;

      const restricted = {
        RoutesPaths.splash,
        RoutesPaths.verifyEmail,
        ...publicRoutes,
      };
      final shouldGoHome =
          restricted.contains(currentPath) && authed && verified;
      if (shouldGoHome && currentPath != RoutesPaths.home)
        return RoutesPaths.home;

      return null; // no redirect
    }(),
  };
}

/*



/// 🧭🚦 [RoutesRedirectionService] — Centralized redirect logic based on [AuthState].
/// ✅ Declaratively maps current router state + authState to needed redirect route.
///   - 🚪 `/signin` if unauthenticated
///   - 🧪 `/verifyEmail` if email is not verified
///   - 🧯 `/firebaseError` if an auth error occurs
///   - ⏳ `/splash` while loading
///   - ✅ `/home` if fully authenticated and verified
//
final class RoutesRedirectionService {
  ///-------------------------------
  RoutesRedirectionService._();
  //

  /// 🗝️ Publicly accessible routes (no authentication required)
  static const Set<String> _publicRoutes = {
    RoutesPaths.signIn,
    RoutesPaths.signUp,
    RoutesPaths.resetPassword,
  };

  /// 🔁 Maps current router state + auth state to a redirect route (if needed)
  static String? from(
    BuildContext context,
    GoRouterState goRouterState,
    AuthState authState,
  ) {
    /// 🔍 Auth status flags
    final status = authState.authStatus;
    final user = authState.user;
    final isLoading = status == AuthStatus.unknown;
    final isUnauthenticated = status == AuthStatus.unauthenticated;
    final isAuthenticated = status == AuthStatus.authenticated;
    final isAuthError = status == AuthStatus.authError; // Додати, якщо треба

    // Email verification logic
    final isEmailVerified = user?.emailVerified ?? false;

    // Current path
    final currentPath = goRouterState.matchedLocation.isNotEmpty
        ? goRouterState.matchedLocation
        : goRouterState.uri.toString();
    final isOnPublicPages = _publicRoutes.contains(currentPath);
    final isOnVerifyPage = currentPath == RoutesPaths.verifyEmail;
    final isOnSplashPage = currentPath == RoutesPaths.splash;

    // ⏳ Redirect to splash while loading
    if (isLoading) return isOnSplashPage ? null : RoutesPaths.splash;

    // 💥 Redirect to error page if auth error (опційно, якщо таке треба)
    if (isAuthError) return RoutesPaths.signIn;

    // 🚪 Redirect to SignIn page if unauthenticated and not on public page
    if (isUnauthenticated) return isOnPublicPages ? null : RoutesPaths.signIn;

    // 🧪 Redirect to /verifyEmail if not verified
    if (isAuthenticated && !isEmailVerified) {
      return isOnVerifyPage ? null : RoutesPaths.verifyEmail;
    }

    // ✅ List of pages, that restricted to redirection
    const restrictedToRedirect = <String>{
      RoutesPaths.splash,
      RoutesPaths.verifyEmail,
      ..._publicRoutes,
    };

    // ✅ Redirect to /home if already authenticated and on splash/public/verify
    final shouldRedirectHome =
        restrictedToRedirect.contains(currentPath) &&
        isAuthenticated &&
        isEmailVerified;

    if (shouldRedirectHome && currentPath != RoutesPaths.home) {
      if (kDebugMode) {
        debugPrint(
          '[🔁 Redirect] currentPath: $currentPath | status: $status | verified: $isEmailVerified',
        );
      }
      return RoutesPaths.home;
    }

    // ➖ No redirect
    return null;
  }
}

/*
for debugging:

    if (kDebugMode) {
        debugPrint(
          '[🔁 Redirect] $currentPath → $target (authStatus: unknown)',
        );
      }
 */



 */
