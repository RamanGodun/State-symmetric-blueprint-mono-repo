import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/di/core/di_module_interface.dart';
import 'package:bloc_adapter/utils/user_auth_cubit/auth_stream_cubit.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:blueprint_on_cubit/core/base_modules/navigation/module_core/go_router_factory.dart'
    show buildGoRouter;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:go_router/go_router.dart';

/// 🚦 [NavigationModule] — registers a singleton [GoRouter] in DI
/// ✅ Provides a single navigation entry point across the app runtime
/// ⚠️ Depends on [AuthModule] because [buildGoRouter] requires [AuthCubit]
//
final class NavigationModule implements DIModule {
  ///------------------------------------------
  @override
  String get name => 'NavigationModule';

  @override
  List<Type> get dependencies => const [AuthModule];

  @override
  Future<void> register() async {
    // 🧭 Create GoRouter exactly once for the entire runtime
    di.registerSingletonIfAbsent<GoRouter>(() {
      final authCubit = di<AuthCubit>();
      final router = buildGoRouter(authCubit);
      debugPrint('🧭 GoRouter singleton initialized');
      return router;
    });
  }

  @override
  Future<void> dispose() async {
    // Nothing to dispose: GoRouter lives for the entire app lifecycle
  }

  //
}
