import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 🧩 [routerProvider] — публічний провайдер для UI
/// ✅ У віджетах: `ref.watch(routerProvider)`
/// 🧷 Стабільність: всередині — `ref.read(goRouter)`, щоб не тригерити зайві ребілді
//
final routerProvider = Provider<GoRouter>((ref) => ref.read(goRouter));

////
////

/// 🧭 [goRouter] — DI-токен для інстансу GoRouter (overridden через buildGoRouter)
//
final goRouter = Provider<GoRouter>((_) => throw UnimplementedError());
