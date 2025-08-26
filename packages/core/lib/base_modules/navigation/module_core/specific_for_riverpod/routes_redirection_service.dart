/*

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
 */

/*
? for debugging:

    if (kDebugMode) {
        debugPrint(
          '[🔁 Redirect] $currentPath → $target (authStatus: unknown)',
        );
      }
 */
