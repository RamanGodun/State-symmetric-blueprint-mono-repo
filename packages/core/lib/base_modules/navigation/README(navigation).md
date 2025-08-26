# 🧭 Navigation Module Guide

_Last updated: 2025-08-01_

---

## 🎯 GOAL

This module provides a **universal, declarative, and scalable navigation system** for Flutter apps,
based on GoRouter. It encapsulates all route declarations, observers, redirect logic,
and navigation extensions, and supports navigation side-effects, auth-driven routing
and **both Riverpod and cubit/BLoC** via fully decoupled DI (navigation is state-agnostic).

🦾 Designed for Clean Architecture, scalable projects, and modular codebases

---

## 🚀 Quick Start

All navigation logic, transitions, redirects, and overlay handling are configured out-of-the-box.
Just injects GoRouter into `MaterialApp.router` and define your routes and redirects/extend as needed.

### With Riverpod:

```dart
// main.dart (after DI and localization initialization)
runApp(
  ProviderScope(
    parent: GlobalDIContainer.instance,
    child: AppLocalizationShell(),
  ),
);

// In your root shell widget:
final router = ref.watch(routerProvider);

MaterialApp.router(
  routerConfig: router,
  // ...theme, localization, overlays, etc
);
```

### With cubit/BLoC:

```dart
// main.dart (after DI and localization initialization)
runApp(GlobalProviders(child: AppLocalizationShell()));

// In your root shell widget:
final router = buildGoRouter(context.select((Authcubit c) => c.state));

MaterialApp.router(
  routerConfig: router,
  // ...theme, localization, overlays, etc
);
```

- UI rebuilds **only when necessary** thanks to Riverpod’s `.select()` / `BLoCSelector`

---

## 📦 File Structure

\*> Each file/folder is responsible for a clear separation of navigation concerns:
routes config, transitions, observers, redirects, extension methods.

```
navigation/
├── module_core
│   ├── specific_for_bloc
│   │   ├── go_router_factory.dart                   # Factory/fn for GoRouter (cubit/BLoC)
│   │   └── routes_redirection_service.dart          # Central redirect logic for auth flows
│   └── specific_for_riverpod
│       ├── go_router__provider.dart                 # Riverpod Provider for GoRouter
│       ├── go_router_factory.dart                   # Factory/fn for GoRouter (Riverpod)
│       └── routes_redirection_service.dart          # Central redirect logic for auth flows
│
├── routes/
│   ├── app_routes.dart                               # Main list of all GoRoute(s)
│   ├── routes_names.dart                             # Route names as consts
│   └── route_paths.dart                              # Route paths as consts
│
├── utils/
│   ├── extensions/
│   │   ├── navigation_x_on_context.dart              # Context-based navigation ext
│   │   ├── result_navigation_x.dart                  # Result/Either ext for nav/redirects
│   │   └── navigation_x_on_failure.dart              # Failure ext for error-based nav
│   └── overlays_cleaner_within_navigation.dart       # Observer for auto-dismiss overlays
│
├── README(navigation).md
└── navigation_barrel.dart
```

---

## 🧩 Architecture & Flow

> **Everything in this module is declarative, predictable, and extensible — ready for real-world apps.**

- **Declarative routes:**
  All routes, names, and paths are defined centrally and strictly typed. `app_routes.dart` describes the route tree,
  while `routes_names.dart` and `route_paths.dart` keep names and paths in sync.
- **State-agnostic GoRouter instantiation:**
  GoRouter is constructed either via Riverpod provider or cubit-based factory, always with dependency injection for reactive auth state.
- **Auth state driven**
  Auth state is provided via Authcubit or `authStateStreamProvider` (for Riverpod)).
  GoRouter instance watches the **auth state** and re-evaluates routes on changes
- **Centralized redirects:**
  The `RoutesRedirectionService` handles all global redirects in one place
- **Custom observers:**
  Navigation observers (like `OverlaysCleanerWithinNavigation`) handle side-effects such as dismissing overlays on navigation change.
- **Navigation extensions:**
  Extensions on `BuildContext` and result types provide a concise, ergonomic API for navigation, error flows, and result handling.
- **Testable, replaceable:**
  Each piece (routes, redirects, observers, transitions) is isolated and can be replaced or unit-tested independently.

### Typical Navigation Flow

1. **App bootstraps** and resolves auth state (or other guards).
2. **GoRouter** is created with centralized route tree, observers, and redirect logic.
3. **On navigation**, observers trigger overlay cleanup and logging.
4. **If redirect needed**, `RoutesRedirectionService` maps the current app/auth state to the desired route.
5. **All navigation logic** can be unit-tested or replaced for e2e, QA, or new business rules.

---

## 🔁 Current Redirect Logic: Flow & Rules

All redirect logic is centralized in `RoutesRedirectionService.from(...)` — ensuring users always land where they belong,
based on authentication and verification state. No duplicate logic in UI or widgets!

### Core Redirect Rules

- **Loading**: If auth state is loading/unknown, always redirect to `/splash` (unless already there).
- **Auth Error**: On authentication error, redirect to `/signin`.
- **Unauthenticated**: If not signed in, only allow public routes (`/signin`, `/signup`, `/resetPassword`).
  All other routes redirect to `/signin`.
- **Email Not Verified**: If signed in but email not verified, redirect to `/verifyEmail` (unless already there).
- **Authenticated & Verified**: If user is fully authenticated and verified and lands on splash, public, or verify pages, redirect to `/home`.
- **Redundant Redirect Prevention**: If already on `/home` and state is valid — no redirect (prevents loops).
- **Default**: If none of the above, stay on the current page.

---

### Redirect Flow Table

| Condition                | Redirects to                         |
| ------------------------ | ------------------------------------ |
| Loading/Unknown          | `/splash`                            |
| Auth Error               | `/signin`                            |
| Unauthenticated          | `/signin` (if not public)            |
| Email not verified       | `/verifyEmail`                       |
| Authenticated & Verified | `/home` (if on splash/verify/public) |
| On `/home` + valid state | No redirect                          |
| Anything else            | No redirect                          |

---

> **All private routes are protected by default. Redirects are triggered automatically on state change.**
> To add custom guards or flows, simply extend `RoutesRedirectionService.from(...)`.

---

## 📝 Usage

### Page Navigation (with extensions)

```dart
// Simple navigation via context extensions
context.goToHome();
context.goToProfile(userId: '123');

// Result-based navigation (using ResultNavigationX)
final result = await someAsyncAction();
result.navigateOrShowError(context, onSuccess: (data) => context.goToProfile());

// Error navigation (using NavigationXOnFailure)
context.navigateOnFailure(someFailure);

// Named route navigation (GoRouter API)
context.goNamed(RoutesNames.signIn);
context.go(RoutesPaths.home);
```

### Reactive Navigation (redirects/auth flows)

- All redirects (e.g., auth, verify email, splash, error) are handled **automatically** by `RoutesRedirectionService`.
- No need to manually check auth state or duplicate logic in UI.
- To add a new redirect, extend `RoutesRedirectionService.from()` with your custom logic.

### Overlay-cleaning on navigation

- Overlays, dialogs, toasts are **automatically dismissed** when navigating via context or observers.
- No manual overlay closing required!

> **All navigation is declarative, testable, and DX-first — no imperative Navigator calls in your UI.**

---

## ❓ FAQ

> **How do I add a new route?**

- Add it to `app_routes.dart` (GoRoute), and define its path/name in `routes_names.dart` / `route_paths.dart`.
- Implement the page widget in `/pages`.

---

> **How do I add a new redirect/guard?**

- Edit `RoutesRedirectionService.from()` and declare your custom guard logic (e.g., role-based, onboarding, etc).
- All auth/email/splash/404 redirects are already handled — just extend the logic.

---

> **How do I customize transitions?**

- Override transition fields in your GoRoute definition in `app_routes.dart` (e.g., pageBuilder, transitionBuilder).

---

> **How do I handle unknown/404 routes?**

- The fallback route is declared in `app_routes.dart` via `errorBuilder: (ctx, state) => PageNotFound(...)`.

---

> **How do I unit-test navigation or redirects?**

- All logic is testable — call `RoutesRedirectionService.from()` in your test with mock states.
- GoRouter and all extension methods are isolated and composable.

---

> **How do I perform navigation from async results/errors?**

- Use `ResultNavigationX` and `NavigationXOnFailure` extensions for declarative flows (see Usage section).

---

## 💡 Best Practices

- **Keep all route declarations in `/routes`:** Never hardcode route names or paths in your UI/widgets.
  Always use named routes via constants (`RoutesNames`, `RoutesPaths`)
- **All navigation/redirect logic lives outside UI** No inline navigation in widgets.
  All global app redirect logic flow (auth, onboarding, splash) must go via `RoutesRedirectionService` only.
- **Use navigation extensions:** Always prefer `context.goToXxx()`, `ResultNavigationX`,
  and failure-based navigation over raw Navigator/GoRouter calls.
- **Use OverlaysCleanerWithinNavigation** for dismissing overlays automatically,
  use it for overlay/dialog cleanup instead of manual UI code.
- **Error Handling & Chaining navigation**
  Use `FailureNavigationX` to handle redirects on domain failures (e.g. 401 → sign out and go to `/signin`)
  Use `ResultNavigationExt` to trigger navigation after successful results in a functional style
- **Consistent naming:** Stick to the established pattern for routes, names, and extension methods.

---

## ⚠️ Avoid Pitfalls

- **No imperative navigation in UI:** Don’t use `Navigator.push` or `GoRouter.of(context)` directly in widgets.
- **No duplicated redirect logic:** Never check auth state for redirects in the UI — always centralize in redirection service.
- **No hardcoded paths:** Route paths and names must always be sourced from constants.
- **No mixing logic:** Don’t mix navigation code with business or state logic — keep flows declarative and isolated.
- **No manual overlay closing:** Never close overlays/dialogs manually after navigation; use observers.

---

## ✅ Final Notes

- Universal: Works with both Riverpod and cubit/BLoC (only state injection layer differs)
- Fully declarative: Navigation, redirects, and side effects are centralized, testable, and extendable
- UI-agnostic: All navigation code is outside the widget layer
- Overlay-safe: All overlays/toasts/dialogs are auto-dismissed on navigation
- Predictable: Navigation flow, redirects, errors, and page not found are always handled

---

> **Happy coding! 🧭✨**
> Build robust, scalable apps with predictable and maintainable navigation. Architecture-first, UI-last.

---
