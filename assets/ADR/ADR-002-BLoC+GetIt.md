# ADR-002: State Management and Dependency Injection Pattern (Bloc + GetIt)

---

## Status

Accepted

## Context

Our Flutter projects aim for high modularity, testability, and maintainability, enabling fast onboarding
and flexible feature teams. Two major state management approaches are standardized:

- **Riverpod (ADR-001)** — used as default in most new projects for full context-independence.
- **Bloc (flutter_bloc) + GetIt** — used in projects where contextless global service location is required or for feature compatibility.

This document formalizes the approach for Bloc-based projects using GetIt as a global dependency injection (DI) container.

---

## Problem

- Bloc and Cubit rely on context-scoped providers or manual dependency passing.
- For scalable, cross-feature access (e.g., for overlays, navigation, global theming), contextless service location is desirable.
- Many dependencies (analytics, theme cubit, overlay handler, router, remote services, etc.) must be accessible across the entire app,
  including outside of widget tree (e.g., background sync, background notifications, background jobs, etc.).
- Clean code architecture demands strict separation of concerns, clear testability, and thin UI layers.

---

## Decision

- Use **GetIt** as a single, global service locator.
- All Cubits, Blocs, UseCases, Repositories, DataSources, Services are registered at startup via a single entry-point (`DIContainer.initFull`).
- Only the minimal DI container is initialized for initial app splash/loader (`DIContainer.initNecessaryForAppSplashScreen`), then fully re-initialized post-startup.
- Each Bloc/Cubit receives its dependencies via constructor injection (never by context or static access).
- **SafeRegistration** extensions prevent double-registration and facilitate safe disposal for hot reload and testability.
- All cross-feature services (analytics, overlays, navigation, etc.) are registered in the same container.
- No “Bridges” or abstract interface layers between state managers:
  - If migration to another state manager (e.g., Riverpod) is ever needed, common modules remain portable, and state manager–specific modules can be swapped.

- For testing, container supports override/unregister of singletons and factories (even if not implemented in first version, planned for future testing support).
- UI remains thin (stateless, state-dumb), all business logic in Blocs/Cubits/UseCases.

---

## Rationale

- **Maintainability:** Single point of dependency registration/tracking, simple onboarding for new engineers.
- **Flexibility:** Any feature or global service (e.g., theme, router, auth state, overlays) can be injected or replaced at any time.
- **Testability:** Blocs and services can be constructed independently in tests, DI supports overrides/mocks.
- **Scalability:** Container will be modularized by domain/feature as the codebase grows.
- **Performance:** Instantiation only occurs as needed (`registerLazySingletonIfAbsent`), and singletons are reused.
- **No Context Dependence:** Dependencies can be injected and used even outside the widget tree, supporting background operations and cross-cutting concerns.
- **No Overengineering:** Bridge/adapters pattern is explicitly avoided, unless a true migration plan requires it (rare in practice).

---

## Consequences

- **DI container will be split by domain/feature when project size requires.**
- **No on-the-fly re-init of container (e.g., hot reload) — not currently planned nor required.**
- **Test support via unregister/override to be added as needed.**
- **GetIt is used for all global/shared services, not just Cubits.**

---

## Example (Simplified)

```dart
final di = GetIt.instance;

abstract final class DIContainer {
  DIContainer._();

  static Future<void> initFull() async {
    di.registerLazySingletonIfAbsent(() => ThemeCubit());
    di.registerLazySingletonIfAbsent(() => AuthCubit(di<AuthService>()));
    di.registerLazySingletonIfAbsent(() => RouterCubit(di<AuthCubit>()));
    // ... and so on
  }
}

// Usage in UI
BlocProvider.value(value: di<AuthCubit>(), child: ...)
```

---

## References

- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [get_it](https://pub.dev/packages/get_it)
- \[State Agnostic Clean Architecture, project internal]

---

## See Also

- ADR-001: Riverpod-centric State Agnostic Clean Architecture
- ADR-003: Navigation & Routing Strategy (planned)
- ADR-004: Localization
