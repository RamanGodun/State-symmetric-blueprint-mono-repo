import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/core/shared_presentation/pages/page_not_found.dart';
import 'package:core/base_modules/overlays/utils/overlays_cleaner_within_navigation.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:core/utils_shared/stream_change_notifier.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart'
    show authGatewayProvider;

part 'routes_redirection_service.dart';

/// 🧭🚦 [buildGoRouter] — фабрика GoRouter (Riverpod edition)
/// ✅ Один інстанс GoRouter у DI
/// ✅ Реактивність через "refreshListenable" (стрім auth-станів)
/// ✅ Рішення редіректів по синхронному `gateway.currentSnapshot`
//
GoRouter buildGoRouter(Ref ref) {
  // 🔒 Важливо: беремо gateway через read — GoRouter не “зав’язується” реактивно
  final gateway = ref.read(authGatewayProvider);

  // 🔔 Робимо GoRouter реактивним до змін auth через ChangeNotifier-міст
  final authChange = StreamChangeNotifier<AuthSnapshot>(gateway.snapshots$);
  ref.onDispose(authChange.dispose);

  // ⛳️ Гістерезис: після першого не-loading викидаємо splash-цикли
  var hasResolvedOnce = false;

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

    // ♻️ Реактивність редіректів — кожна подія у стрімі тригерить перевірку
    refreshListenable: authChange,

    /// 🧭 Global redirect hook
    redirect: (context, state) {
      // 📊 Синхронно беремо актуальний snapshot
      final snap = gateway.currentSnapshot;

      // позначаємо, що перше реальне вирішення вже було
      if (snap is! AuthLoading) hasResolvedOnce = true;

      // поточний шлях
      final currentPath = state.matchedLocation.isNotEmpty
          ? state.matchedLocation
          : state.uri.toString();

      // чиста функція рішень
      final target = computeRedirect(
        currentPath: currentPath,
        snapshot: snap,
        hasResolvedOnce: hasResolvedOnce,
      );

      if (kDebugMode && target != null) {
        debugPrint('🧭 Redirect: $currentPath → $target (${snap.runtimeType})');
      }
      return target;
    },
  );

  //
}
