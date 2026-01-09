import 'package:adapters_for_bloc/adapters_for_bloc.dart' show DIModule, di;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/auth_module.dart'
    show AuthModule;
import 'package:app_on_cubit/core/base_modules/navigation/go_router_factory.dart'
    show buildGoRouter;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthGateway;

/// 🚦 [NavigationModule] — registers a singleton [GoRouter] in DI
/// ✅ Ensures a single GoRouter instance is used for the whole app lifecycle
/// ⚠️ Depends on [AuthModule] because [buildGoRouter] requires [AuthGateway]
//
final class NavigationModule implements DIModule {
  ///------------------------------------------
  @override
  String get name => 'NavigationModule';

  @override
  List<Type> get dependencies => const [AuthModule];

  @override
  Future<void> register() async {
    // 🧭 Register GoRouter once in DI (driven by AuthGateway)
    di.registerSingletonIfAbsent<GoRouter>(() {
      final gateway = di<AuthGateway>(); // Resolve gateway from DI
      final router = buildGoRouter(gateway); // Factory consumes AuthGateway
      debugPrint('🧭 GoRouter singleton initialized (Gateway-driven)');
      return router;
    });
  }

  @override
  Future<void> dispose() async {
    // Nothing to dispose: GoRouter lives for the entire app lifecycle
  }

  //
}
