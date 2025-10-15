# ADR-003: Navigation & Routing Strategy — Declarative, State-Agnostic, and Reactive

## 1. Review and Lifecycle

_Status_: _Accepted_ (2025-09-26)
_Revision history:_ First version
_Author:_ Roman Godun

---

## 2. 🎯 Context

This architecture targets production-ready, scalable, and maintainable Flutter applications where **navigation is declarative, testable, and orchestration is reactive to app state** (e.g., auth status).

The codebase follows the **State-Symmetric Architecture** (see ADR-001), where both Riverpod and Bloc-based apps share a navigation layer via thin adapters, ensuring consistency and maximum reusability across the platform.

**Navigation orchestration** is:

- **Declarative**: Pages are not coupled imperatively (e.g., only after pushing on form submit), but alo can be redirected reactively based on application state (e.g., auth snapshot).
- **State-agnostic**: Core navigation logic does not depend on the state manager — it works with both Riverpod and Bloc/Cubit via symmetric wrappers.
- **Testable**: Redirect decisions live in pure Dart services.

---

## 3. ✅ Decisions, Key Principles

### 🧩 Decision Summary: Use GoRouter with Modular, Declarative Routing Pattern

We adopt [`go_router`](https://pub.dev/packages/go_router) as the routing framework for both Bloc and Riverpod apps, with a **modular, declarative**, and **Auth-aware** orchestration

> ⚠️ The routing setup is **reactive to auth state**, but routing flow is declared _outside_ of the widgets — not tied to button presses or widget callbacks.

The router instance is injected via DI (`ProviderScope` in Riverpod, `GetIt` in Bloc) and initialized through a factory method that sets up routes, transitions, and reactive redirect logic.

---

## Design Goals

- ✅ **Declarative Navigation** — Page rendering is based on auth state, not imperatively triggered.
- ✅ **State-Agnostic** — Works equally in Bloc and Riverpod.
- ✅ **Scalable** — Easily support nested routing, deep linking, and auth guards.
- ✅ **Extensible** — Add transitions, redirect types, route grouping, etc. modularly.
- ✅ **Testable** — Redirect and navigation decisions are pure and isolated.
- ✅ **Unified Navigation UX** — Consistent UX across apps, error handling, and transitions.

---

### 🔧 Key Implementation Decisions

### 1. **GoRouter as the Navigation Engine**

- Shared between Bloc and Riverpod variants.
- Central config via `AppRoutes`, `RoutesNames`, `RoutesPaths`.
- Error fallback and transitions are handled via `AppTransitions.fade()` (or custom).

#### 2. **Reactive Redirects (Auth-aware Routing)**

- Redirects are computed based on current **AuthSnapshot**.
- Shared pure function `computeRedirect(...)` accepts snapshot + currentPath + flags.
- Ensures idempotent and deterministic redirects (e.g., Splash → SignIn → Verify → Home).

```dart
final target = computeRedirect(
  currentPath: state.uri.toString(),
  snapshot: gateway.currentSnapshot,
  hasResolvedOnce: hasResolvedOnce,
);
```

- This logic works in both Riverpod and Bloc, with snapshot provided via `Provider` or `di.get()`.

#### 3. **DI Symmetry for Router**

- **Riverpod**: `routerProvider` exposes stable router via `buildGoRouter()`.
- **Bloc**: `GoRouter` is built via `buildGoRouter()` and injected into `GetIt`.

> This ensures consistency across apps while keeping navigation manager decoupled from state logic.

---

### 🧪 Testability

- All redirect logic is **pure Dart**, e.g., `computeRedirect(...)` returns a nullable string.
- `RoutesRedirectionService` can be tested without UI.
- Transitions are deterministic and modular.
- Navigation helpers (e.g., `context.goTo(...)`) are decoupled from widget logic.

---

## 🤝 Navigation Helpers (DX Layer)

Navigation helpers in `NavigationX` extension:

- `goTo`, `goPushTo` for named routing.
- `pushTo`, `replaceWith` for widget-based routing.
- `goIfMounted(...)` for safe usage in async callbacks.

Also, `Either<Failure, T>.redirectIfSuccess(...)` extension improves DX for result-driven redirects.

```dart
final result = await useCase();
result.redirectIfSuccess((value) => context.goTo(RoutesPaths.home));
```

---

## 🧱 Routing Composition

### AppRoutes

- Central list of all route definitions (`GoRoute[]`).
- Includes nested routes: e.g., `Profile → ChangePassword`.
- Shared transitions via `AppTransitions.fade()` (slide, scale, etc. can be added).

### RoutesPaths & RoutesNames

- `RoutesPaths`: string URIs (`/signin`, `/profile/...`).
- `RoutesNames`: GoRouter `name` params.
- Used across redirects, navigation helpers, tests.

---

## 🧭 Redirection Flow: Auth-Aware

Declarative navigation is **reactively driven** by the current `AuthSnapshot`. Examples:

- 🔓 Not signed in → redirect to `/signin`
- 📧 Email not verified → redirect to `/verifyEmail`
- ✅ Signed in and verified → route to `/home`

This happens **without imperative push** logic in the UI. User lands on `/signin`, submits credentials, and the router reacts automatically to the new `AuthSnapshot` emitted by the stream.

> No widget-to-widget push logic — navigation is derived from **app state**.

---

## 📍 How to Extend

- ✅ Add routes: update `AppRoutes.all`, define names/paths.
- ✅ Add transitions: extend `AppTransitions`.
- ✅ Add redirect logic: update `computeRedirect()`.
- ✅ Deep linking: plug into GoRouter URI parsing.
- ✅ Nested routers: compose via child GoRouters.

---

## 4. 💡 Success Criteria and Alternatives Considered

### Imperative Navigation (Navigator 1.0)

- ❌ Doesn’t scale for complex flows, deep links, auth.
- ❌ Imperative push/pop scattered across widgets.

### Bridge-based Routing Abstraction

- ❌ Over-engineering. Not needed for symmetrical routing via shared GoRouter.
- ✅ Can be revisited if full migration layer needed.

### Use AutoRoute

- ❌
- ✅

### 🧪 Success Criteria

- [ ] Simple DX
- [ ] Declarative navigation

---

## 5. 🧨 Consequences

- 🧩 Declarative, centralized, and symmetrical navigation.
- ♻️ Reused between Bloc and Riverpod apps.
- 🧪 Testable at redirect and router factory level.
- ⚡ Fast onboarding, minimal coupling.

---

## 6. 🔗 Related info

### Related ADRs

- ADR-001: State-Symmetric Architecture
- ADR-002: Dependency Injection Pattern (via GetIt / ProviderScope)
- ADR-004: Localization & Overlay Strategy

## References

- [GoRouter documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation 2.0](https://flutter.dev/docs/development/ui/navigation)
- [State-Symmetric Architecture](./adr_001_state_symmetric.md)

## 7. 📌 Summary

According to personal criterai GoRouter was chosen
