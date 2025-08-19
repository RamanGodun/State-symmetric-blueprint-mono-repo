# ADR-003: Navigation & Routing Strategy

## Context

The project targets production-ready, scalable, and maintainable Flutter applications,
where navigation is a core part of user experience and codebase structure.
The application codebase is designed to be state-agnostic, allowing seamless
integration with various state managers (Riverpod, Bloc, etc.) without
coupling navigation logic to a specific solution. The navigation system should
be testable, easily extensible (e.g. for deep links or nested navigation), and support a modern, unified UX for all flows.

## Decision Drivers (Design Goals)

- **State-agnostic orchestration:** Navigation logic (routing, redirect, transitions) does not depend on the app's state management solution.
- **Scalability:** Easy to add new routes, guards, and flows (incl. deep linking, multi-stack, nested routing).
- **Testability:** All navigation logic (routing, redirects) can be tested in isolation, including unit/integration tests for redirect services and guards.
- **Maintainability:** Centralized definition of all routes, names, and transitions. Route logic is transparent, documented, and easy to update.
- **Extensibility & Open/Close Principle:** Transition types (fade, slide, scale, shared axis, etc.) can be added without touching existing code, and flows can be composed without boilerplate.
- **Unified navigation UX:** All navigation is handled declaratively, ensuring consistency, predictability, and a modern app feel (e.g. iOS-like airiness).

## Decision: Adopt GoRouter with Modular Routing Pattern

The project will use [`go_router`](https://pub.dev/packages/go_router) as the single source of truth for navigation,
route definition, transitions, and redirect logic. The router instance is provided via DI (Riverpod Provider or Bloc DI), making the setup fully agnostic to state management.

### Solution Details

1. **Router Initialization**
   - `GoRouter` is instantiated via DI and injected into the app tree.
   - Routes, transitions, and error pages are centralized in `AppRoutes`.
   - Theme and navigation configs are provided as separate modules for minimal rebuilds (using `select`/`selector`).

2. **Routing & Transitions**
   - All routes, paths, and route names are defined in a single module.
   - Page transitions are modular: `AppTransitions` exposes fade by default, but allows adding slide, scale, shared axis, etc., without breaking existing flows
   - All error/fallback routes (404/PageNotFound) are handled centrally.

3. **Redirection & Guards**
   - Centralized `RoutesRedirectionService` handles all auth-driven (or custom) redirects based on app/user state.
   - Logic is state-agnostic: works equally with Riverpod's `StreamProvider`, Bloc's `Cubit/Stream`, or any other observable/stream.
   - System is ready for extension: deep links, future guard objects, and multi-stack (Navigator 2.0) scenarios.

4. **Testability**
   - Redirect/guard logic lives in pure Dart classes, easily testable in isolation.
   - Route configs, transitions, and fallback logic are deterministic, covered by unit/integration tests.

5. **Fallback/Error Handling**
   - All unknown or failed routes resolve to a centralized error/fallback page.
   - Error flows (e.g., unauthorized, email not verified, etc.) can trigger navigation/redirects as first-class citizens.

## Rejected Alternatives

- **Imperative Routing (Navigator 1.0):**
  - Does not scale for modern apps with auth, nested navigation, or deep linking. Hard to maintain and test.

- **Per-page RouteObservers, Manual Guards:**
  - Leads to fragmented navigation logic, inconsistent user experience, and more boilerplate.

- **Bridge-based Abstraction:**
  - Considered for cross-state-manager abstraction but rejected as unnecessary overhead.
    Bridge pattern is only justified for planned migration between state managers, not for everyday extensibility.

## Consequences and Resulting Context

- **The navigation system is 100% declarative and almost state-agnostic.** Changing state management does not require re-writing navigation logic.
- **Extensible and maintainable.** New routes, transitions, and guards can be added with minimal code changes and without touching core logic.
- **Ready for scale.** Deep linking, guard objects, nested routing, and advanced transitions are supported by design, not by accident.
- **Centralized and documented.** All navigation-related code is easy to find, read, and update; fallback/error flows are robust and predictable.
- **Testability** Pure functions and services enable safe and reliable navigation and redirect testing, which is critical for complex flows (e.g. auth, onboarding).

## How to Extend

- **Add custom page transitions** (slide, scale, fadeThrough, shared axis, etc.) via `AppTransitions`, without touching route definitions.
- **Add new guards/redirects** by updating or extending `RoutesRedirectionService`.
- **Integrate nested navigation/multi-stack** (Navigator 2.0) by composing sub-routers.
- **Plug in deep linking** by adding path patterns to `AppRoutes` and updating guards.

---

This ADR ensures the navigation system remains robust, future-proof, and decoupled from any particular state management or UI architecture.

## See Also

- ADR-001: Riverpod-centric State Agnostic Clean Architecture
- ADR-002: State Management and Dependency Injection Pattern (Bloc + GetIt)
- ADR-004: Localization
