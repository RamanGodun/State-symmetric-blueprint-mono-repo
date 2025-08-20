import 'package:blueprint_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 🧭🚦 [RoutesRedirectionService] — centralized redirect logic for GoRouter
/// 🔐 Dynamically handles redirection based on Firebase auth state:
///   - 🚪 `/signin` if unauthenticated
///   - 🧪 `/verifyEmail` if email is not verified
///   - 🧯 `/firebaseError` if an auth error occurs
///   - ⏳ `/splash` while loading
///   - ✅ `/home` if fully authenticated and verified
//
abstract final class RoutesRedirectionService {
  ///----------------------------------------
  RoutesRedirectionService._();

  /// 🗝️ Publicly accessible routes (no authentication required)
  static const Set<String> _publicRoutes = {
    RoutesPaths.signIn,
    RoutesPaths.signUp,
    RoutesPaths.resetPassword,
  };

  //

  /// 🔁 Maps current router state + auth state to a redirect route (if needed)
  static String? from(
    BuildContext context,
    GoRouterState goRouterState,
    AsyncValue<User?> authState,
  ) {
    ///
    // 🔄 Error/Loading State, directly from state
    final isLoading = authState is AsyncLoading<User?>;
    final isAuthError = authState is AsyncError<User?>;

    // User
    final user = authState.valueOrNull;
    final isAuthenticated = user != null;
    final isEmailVerified = user?.emailVerified ?? false;

    // 🔄 CurrentPath
    final currentPath = goRouterState.matchedLocation;

    // 📍 Route flags
    final isOnPublicPages = _publicRoutes.contains(currentPath);
    final isOnVerifyPage = currentPath == RoutesPaths.verifyEmail;
    final isOnSplashPage = currentPath == RoutesPaths.splash;

    //
    // ⏳ Redirect to splash while loading
    if (isLoading) return isOnSplashPage ? null : RoutesPaths.splash;

    // ❌ Error state → redirect to SignIn (optional logic)
    if (isAuthError) return RoutesPaths.signIn;

    // 🚪 Unauthenticated → allow only public routes
    if (!isAuthenticated) return isOnPublicPages ? null : RoutesPaths.signIn;

    // 🧪 Not verified → redirect to verify page
    if (!isEmailVerified)
      return isOnVerifyPage ? null : RoutesPaths.verifyEmail;

    // ✅ List of pages, that restricted to redirection
    const restrictedToRedirect = {
      RoutesPaths.splash,
      RoutesPaths.verifyEmail,
      ..._publicRoutes,
    };

    // ✅ Redirect to /home if already authenticated and on splash/public/verify
    final shouldRedirectHome =
        restrictedToRedirect.contains(currentPath) &&
        isAuthenticated &&
        isEmailVerified;

    // ✅ Prevent double redirect
    if (shouldRedirectHome && currentPath != RoutesPaths.home) {
      if (kDebugMode) {
        debugPrint(
          '[🔁 Redirect] currentPath: $currentPath | status: $authState | verified: $isEmailVerified',
        );
      }
      return RoutesPaths.home;
    }

    // 🔁 Prevent redundant redirect
    if (currentPath == RoutesPaths.home && isAuthenticated && isEmailVerified) {
      return null;
    }

    // ➖ No redirect
    return null;
  }

  //
}

/*
? for debugging:

    if (kDebugMode) {
        debugPrint(
          '[🔁 Redirect] $currentPath → $target (authStatus: unknown)',
        );
      }
 */
