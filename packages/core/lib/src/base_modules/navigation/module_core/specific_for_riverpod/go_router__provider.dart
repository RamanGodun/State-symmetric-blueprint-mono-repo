/*


part 'go_router_factory.dart';

/// 🧩 [routerProvider] — Public-facing provider used in the widget tree.
/// ✅ Supports `.select(...)` for optimized rebuilds.
/// 💡 Always use `ref.watch(routerProvider)` in the UI layer instead of `goRouter`.
//
final routerProvider = Provider<GoRouter>((ref) => ref.watch(goRouter));

////
////

/// 🧭 [goRouter] — Low-level DI token for GoRouter instance.
/// ✅ Overridden in the global DI container with `buildGoRouter(...)`.
/// 🚫 Should not be used directly in the widget tree.
//
final goRouter = Provider<GoRouter>((_) => throw UnimplementedError());


*/
