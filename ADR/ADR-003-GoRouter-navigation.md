# ADR-003: Navigation & Routing Strategy — Declarative, State-Agnostic, and Reactive

## 1. 🎯 Context

The **State-Symmetric Architecture** (see [ADR-001](./ADR-001-State-symmetric-architecture.md)) defines a shared architectural discipline where apps using different state managers (Bloc/Cubit, Riverpod) must remain functionally symmetrical. Navigation is a key part of this symmetry.

This document describes how **GoRouter** is used to achieve **declarative, reactive, and testable navigation**, with maximal parity between Bloc-based and Riverpod-based apps.

The challenge was to find a routing solution that:

- Scales to complex, multi-module apps (auth, profile, onboarding, etc.)
- Supports reactive navigation
- Is **state-agnostic** — works identically across Riverpod and Bloc
- Keeps navigation **declarative and testable** — no imperative `Navigator.push()` calls in UI

The navigation system must therefore act as a **shared architectural boundary** — modular, declarative, and symmetrical.

---

## 2. ✅ Decisions

### 🧭 Adopt GoRouter as the Unified Navigation Engine

We adopt [`go_router`](https://pub.dev/packages/go_router) for both Riverpod and Bloc apps, implemented via two thin adapters:

- `go_router_factory.dart` for Bloc
- `router_provider.dart` for Riverpod

Both rely on the **same route definitions** (`AppRoutes`, `RoutesPaths`, `RoutesNames`) and **shared redirect logic** implemented in `RoutesRedirectionService`.

### 🧱 Key Principles

- **Declarative Navigation** — Pages and redirects are derived from app state, not user actions.
- **State-Agnostic** — Works with both Bloc and Riverpod through dependency-injected router instances.
- **Auth-Driven Routing** — Redirects reactively follow `AuthSnapshot` changes.
- **Pure Redirect Logic** — Redirects implemented in pure Dart, fully unit-testable.
- **Single Source of Truth** — Centralized definitions for routes, paths, and redirect rules.

### 🧩 Implementation Summary

| Concern              | Bloc/Cubit Implementation                  | Riverpod Implementation            |
| -------------------- | ------------------------------------------ | ---------------------------------- |
| Router creation      | `buildGoRouter(AuthGateway)`               | `buildGoRouter(Ref ref)`           |
| DI registration      | via `NavigationModule` (`GetIt`)           | via provider override (`goRouter`) |
| Auth snapshot source | `AuthGateway.snapshots$`                   | `authGatewayProvider.snapshots$`   |
| Reactive updates     | `StreamChangeNotifier` (refreshListenable) | same via `StreamChangeNotifier`    |
| Redirect function    | `computeRedirect()`                        | shared same function               |

### 🧩 Declarative Redirect Flow

`computeRedirect()` maps the `AuthSnapshot` and current path to the correct route.

**Example Logic:**

| Condition            | Redirects to   |
| -------------------- | -------------- |
| Loading              | `/splash`      |
| Auth failure         | `/signin`      |
| Not signed in        | `/signin`      |
| Email not verified   | `/verifyEmail` |
| Signed in & verified | `/home`        |

This ensures consistent and predictable navigation without imperative logic in the UI.

### 🧪 Testability

- Redirect logic (`computeRedirect`) is a **pure function** — unit-testable without widget context.
- `RoutesRedirectionService` can be isolated and tested with mocked snapshots.
- The router can be rebuilt in tests with injected state or mocked dependencies.

---

## 3. 🧨 Consequences

### ✅ Positive

- **Full Navigation Symmetry** → Same routing flow across Bloc and Riverpod.
- **Declarative, Centralized Flow** → Navigation logic extracted from widgets.
- **Testable Redirects** → Pure logic functions and shared route definitions.
- **Modular Extensibility** → Easy to add new routes, guards, and transitions.
- **Predictable UX** → Shared routing and transition patterns ensure consistency.

### ⚠️ Negative

- **Learning curve** — Requires understanding declarative navigation.
- **Auth-dependency** — Redirects depend on AuthGateway; must initialize before router.
- **Verbose configuration** — Separate factory and provider for each state manager.

---

## 4. 💡 Success Criteria and Alternatives Considered

### ✅ Success Criteria

- [ ] Declarative, auth-aware navigation
- [ ] Identical routing parity for Bloc and Riverpod apps
- [ ] Zero imperative `Navigator.push()` in UI
- [ ] 100% redirect logic covered by unit tests
- [ ] Configurable, modular routes and transitions

### 🦭 Alternatives Considered

#### 1. **Navigator 2.0 (Raw API)**

- ✅ Full control over navigation stack, URL sync, and platform back handling
- ❌ High implementation complexity — requires manual state management via `RouterDelegate`, `RouteInformationParser`, and `BackButtonDispatcher`
- ❌ Limited developer productivity and readability in large projects
- ✅ Valuable for SDK or framework-level use, but impractical for production app teams

#### 2. **AutoRoute**

- ✅ Strongly typed declarative routing with code generation and guards
- ✅ Built on top of Navigator 2.0 with excellent nested navigation support
- ❌ Heavy dependency on code generation (`build_runner`) and less flexible for dynamic DI-driven redirects
- ❌ Integrates less seamlessly with `GetIt` / `ProviderScope` symmetry — redirect logic is bound to guards rather than shared services

🟢 **Decision**: Adopt **GoRouter** with a shared redirect service for a pragmatic, testable, and symmetrical navigation layer across Bloc and Riverpod apps.

---

## 5. 📌 Summary

> **Decision:** Use GoRouter as a shared navigation framework for all apps within the State-Symmetric Architecture.

**Outcome:**

- Declarative, testable, and reactive navigation.
- Identical routing system across Bloc and Riverpod.
- Centralized redirect and route definitions.

**Trade-offs:**

- Requires strict discipline to keep navigation logic outside UI.

🟢 **Result:** Predictable, maintainable, and scalable navigation model with full architectural symmetry.

---

## 6. 🔗 Related Info

### Related ADRs

- [ADR-001 State-Symmetric Architecture](./ADR-001-State-symmetric-architecture.md)
- [ADR-002 Context-Free-DI.md](ADR-002-Context-Free-DI.md)
- [ADR-004 EasyLocalization](ADR-004-EasyLocalization.md)
- [ADR-005 Errors-management](ADR-005-Errors-management.md)
- [ADR-006 Overlays-management](ADR-006-Overlays-management.md)
- [ADR-007 Theming](ADR-007-Theming.md)

### References

- [GoRouter documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation 2.0](https://flutter.dev/docs/development/ui/navigation)
- [Navigation Module Guide](../packages/core/lib/src/base_modules/navigation/README%28navigation%29.md)

---
