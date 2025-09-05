/// 🧭 Navigation Module — barrel exports
// ignore_for_file: combinators_ordering
library;

//
// ─── CONTEXT EXTENSIONS (GoRouter helpers) ─────────────────────────────────────
//
export '../src/base_modules/navigation/utils/extensions/navigation_x_on_context.dart'
    show NavigationX;

//
// ─── FAILURE-DRIVEN NAVIGATION ─────────────────────────────────────────────────
//
export '../src/base_modules/navigation/utils/extensions/navigation_x_on_failure.dart'
    show FailureNavigationX;

//
// ─── RESULT-DRIVEN NAVIGATION (Either/Async) ───────────────────────────────────
//
export '../src/base_modules/navigation/utils/extensions/result_navigation_x.dart'
    show ResultNavigationExt, ResultFutureNavigationExt;

// ! NOTE:
// App-specific factories and redirection services (ModuleCore/go_router_factory.dart,
// ModuleCore/routes_redirection_service.dart, routes/*) are intentionally NOT
// exported here — they must live in each concrete app.
