import 'package:blueprint_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:blueprint_on_riverpod/core/shared_presentation/pages/page_not_found.dart';
import 'package:core/base_modules/overlays/utils/overlays_cleaner_within_navigation.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_adapter/base_modules/navigation_module/redirect_state.dart';
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart'
    show authSnapshotsProvider;

part 'routes_redirection_service.dart';

/// 🧭🚦 [buildGoRouter] — GoRouter factory (Riverpod version)
/// ✅ Creates router declaratively, driven by [authSnapshotsProvider]
/// ✅ Keeps redirect logic pure/idempotent (delegated to [computeRedirect])
//
GoRouter buildGoRouter(Ref ref) {
  // 🧩 Local redirect state holder (no GoRouter rebuilds on auth updates)
  final redirectState = AuthRedirectState()..attach(ref);

  ////

  return GoRouter(
    //
    /// 👁️ Navigation observers (side effects like overlay cleanup)
    observers: [OverlaysCleanerWithinNavigation()],
    //
    /// 🐞 Verbose GoRouter logging in debug mode only
    debugLogDiagnostics: kDebugMode,

    ////

    /// ⏳ Splash as initial route
    initialLocation: RoutesPaths.splash,

    /// 🗺️ Full route table
    routes: AppRoutes.all,

    /// ❌ Fallback for unknown routes
    errorBuilder: (context, state) =>
        PageNotFound(errorMessage: state.error.toString()),

    ////

    /// 🧭 Global redirect hook
    redirect: (context, state) {
      //
      final snap = redirectState.current;
      if (snap == null) return null;
      //
      final currentPath = state.matchedLocation.isNotEmpty
          ? state.matchedLocation
          : state.uri.toString();

      return computeRedirect(
        currentPath: currentPath,
        snapshot: snap,
        hasResolvedOnce: redirectState.resolvedOnce,
      );
    },
  );

  //
}
