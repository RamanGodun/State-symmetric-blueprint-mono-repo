import 'package:app_on_riverpod/core/base_modules/navigation/module_core/go_router_factory.dart';
import 'package:app_on_riverpod/core/shared_presentation/pages/home_page.dart';
import 'package:app_on_riverpod/core/shared_presentation/pages/page_not_found.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/sign_in__page.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_up/sign_up__page.dart';
import 'package:app_on_riverpod/features_presentation/email_verification/email_verification_page.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/change_password/change_password_page.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/reset_password_page.dart';
import 'package:app_on_riverpod/features_presentation/profile/profile_page.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

part 'route_paths.dart';
part 'routes_names.dart';

/// 🧭 [AppRoutes] — Centralized list of all GoRouter routes
/// ✅ Used in [buildGoRouter] and matches [RoutesNames]
//
abstract final class AppRoutes {
  ///-------------------------
  AppRoutes._();

  ///
  static final List<GoRoute> all = [
    /// ⏳ Splash Page
    GoRoute(
      path: RoutesPaths.splash,
      name: RoutesNames.splash,
      pageBuilder: (_, _) => AppTransitions.fade(const SplashPage()),
    ),

    /// 🏠 Home Page
    GoRoute(
      path: RoutesPaths.home,
      name: RoutesNames.home,
      pageBuilder: (context, state) => AppTransitions.fade(const HomePage()),
      routes: [
        /// 👤 Profile Page (Nested under Home)
        GoRoute(
          path: RoutesNames.profile,
          name: RoutesNames.profile,
          pageBuilder: (context, state) =>
              AppTransitions.fade(const ProfilePage()),
          routes: [
            /// 👤  Change password Page (Nested under Profile page)
            GoRoute(
              path: RoutesNames.changePassword,
              name: RoutesNames.changePassword,
              pageBuilder: (context, state) =>
                  AppTransitions.fade(const ChangePasswordPage()),
            ),
          ],
        ),
      ],
    ),

    /// 🔐 Auth Pages
    GoRoute(
      path: RoutesPaths.signIn,
      name: RoutesNames.signIn,
      pageBuilder: (context, state) => AppTransitions.fade(const SignInPage()),
    ),

    GoRoute(
      path: RoutesPaths.signUp,
      name: RoutesNames.signUp,
      pageBuilder: (context, state) => AppTransitions.fade(const SignUpPage()),
    ),

    GoRoute(
      path: RoutesPaths.resetPassword,
      name: RoutesNames.resetPassword,
      pageBuilder: (context, state) =>
          AppTransitions.fade(const ResetPasswordPage()),
    ),

    GoRoute(
      path: RoutesPaths.verifyEmail,
      name: RoutesNames.verifyEmail,
      pageBuilder: (context, state) =>
          AppTransitions.fade(const VerifyEmailPage()),
    ),

    ///

    /// ❌ Error / 404 Page
    GoRoute(
      path: RoutesPaths.pageNotFound,
      name: RoutesNames.pageNotFound,
      pageBuilder: (context, state) => AppTransitions.fade(
        const PageNotFound(errorMessage: 'Page not found'),
      ),
    ),

    //
  ];

  //
}
