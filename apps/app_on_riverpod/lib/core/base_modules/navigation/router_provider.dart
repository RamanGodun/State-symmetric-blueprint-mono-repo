import 'package:app_on_riverpod/core/base_modules/navigation/go_router_factory.dart'
    show buildGoRouter;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:go_router/go_router.dart' show GoRouter;

/// 🧩 [routerProvider] — public-facing provider for UI usage
/// ✅ Use `ref.watch(routerProvider)` inside widgets
/// ✅ Internally uses `ref.read(goRouter)` to avoid unnecessary rebuilds
//
final routerProvider = Provider<GoRouter>((ref) => ref.read(goRouter));

/// 🧭 [goRouter] — low-level DI token for GoRouter
/// ✅ Overridden globally via [buildGoRouter]
/// 🚫 Do not use directly in UI — always prefer [routerProvider]
//
final goRouter = Provider<GoRouter>((_) => throw UnimplementedError());
