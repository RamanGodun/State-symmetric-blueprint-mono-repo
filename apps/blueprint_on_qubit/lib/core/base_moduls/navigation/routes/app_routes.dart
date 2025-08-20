import 'package:blueprint_on_qubit/core/shared_presentation/pages/home_page.dart';
import 'package:blueprint_on_qubit/core/shared_presentation/pages/page_not_found.dart';
import 'package:blueprint_on_qubit/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:blueprint_on_qubit/features/auth/presentation/sign_up/sign_up_page.dart';
import 'package:blueprint_on_qubit/features/change_or_reset_password/presentation/change_password/change_password_page.dart';
import 'package:blueprint_on_qubit/features/change_or_reset_password/presentation/reset_password/reset_password_page.dart';
import 'package:blueprint_on_qubit/features/email_verification/presentation/email_verification_page.dart';
import 'package:blueprint_on_qubit/features/profile/presentation/profile_page.dart';
import 'package:core/base_modules/navigation/utils/page_transition.dart'
    show AppTransitions;
import 'package:core/shared_presentation_layer/pages_shared/splash_page.dart';
import 'package:go_router/go_router.dart';

part 'route_paths.dart';
part 'routes_names.dart';

/// 🧭 [AppRoutes] — Centralized list of all GoRouter routes
/// ✅ Used in [GoRoute] and matches [RoutesNames]
//
abstract final class AppRoutes {
  ///-------------------------
  AppRoutes._();
  //

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
