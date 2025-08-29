import 'package:blueprint_on_riverpod/core/base_modules/navigation/module_core/go_router_factory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 🧩 [routerProvider] — Public-facing router provider for the widget tree
/// ✅ Use `ref.watch(routerProvider)` in the UI (supports `.select(...)`)
//
final routerProvider = Provider<GoRouter>((ref) => ref.read(goRouter));

////
////

/// 🧭 [goRouter] — Low-level DI token for GoRouter
/// ✅ Overridden globally with [buildGoRouter]
/// 🚫 Do not use directly in UI (use [routerProvider] instead)
//
final goRouter = Provider<GoRouter>((_) => throw UnimplementedError());
