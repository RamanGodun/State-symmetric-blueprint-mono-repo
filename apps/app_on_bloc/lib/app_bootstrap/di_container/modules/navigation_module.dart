import 'package:app_on_bloc/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:app_on_bloc/core/base_modules/navigation/go_router_factory.dart'
    show buildGoRouter;
import 'package:bloc_adapter/bloc_adapter.dart' show DIModule, di;
import 'package:core/public_api/utils.dart' show AuthGateway;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:go_router/go_router.dart';

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
