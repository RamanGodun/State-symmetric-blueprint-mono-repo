# ADR-002: Dependency Injection Strategy — Context-Free DI for Symmetric State Managers

## 1. 🎯 Context

The **State-Symmetric Architecture** (see [ADR-001](./ADR-001-State-symmetric-architecture.md)) requires that apps built on different state managers — **Bloc/Cubit**, **Riverpod**, and optionally **Provider** — share the same clean architectural structure and developer experience.

However, **dependency injection (DI)** is handled differently across these ecosystems:

- **Riverpod** provides context-free DI out of the box via `ProviderContainer` or `.ref.read(...)`, enabling testable and decoupled access to dependencies.
- **Bloc/Cubit** lacks global DI support and typically relies on `BuildContext`, which introduces several problems:
  - Tight coupling between logic and widget trees.
  - Reduced reusability of services across non-UI layers (e.g., overlays, theming, routing).
  - Complex testing/mocking setups.

To maintain _full state symmetry_ and _clean dependency flow_, we must provide Bloc-based apps with the same **context-free DI** capabilities as Riverpod — without introducing heavy abstractions.

This ADR formalizes the use of PlatIt (Platform Logic Injection Toolkit) — a lightweight and modular DI convention built atop GetIt, ensuring global, testable, and maintainable dependency management for Bloc/Cubit apps.

> See [info-007-PlatIt.md](../ADR/supporting_info/info-007-PlatIt.md) for full technical specification and rationale.

### ⚙️ The Problem to Solve

1. Bloc and Cubit rely on context-bound providers (`BuildContext.read()`, `BlocProvider.of()`), which conflict with the **State-Symmetric goal** of clean, context-free DI.
2. Shared infrastructure (e.g., overlays, routing, localization) cannot depend on widget context.
3. Testing and mocking are cumbersome without a global DI container.
4. Riverpod apps already solve this elegantly via `ProviderScope`; Bloc apps need a comparable mechanism.

## 2. ✅ Decisions

### Adopted Strategy

For **full symmetry and clean architecture parity** across state managers, we adopt a **dual-platform DI approach**:

#### 1. **Bloc-based apps**

→ Use **PlatIt**, a modular DI pattern built on `GetIt`
Provides:

- Global, context-free DI (`di<T>()`)
- Modular registration via `DIModule` and `ModuleManager`
- Safe registration utilities (`SafeRegistration`, `SafeDispose`)
- Testability via `resetDI()` and mock injection
- Deterministic bootstrap through the `AppBootstrap` pipeline

#### 2. **Riverpod-based apps**

→ Use **native Riverpod DI**

- Leverage `ProviderScope`, `.ref.read()`, and `ProviderContainer` for dependency management.
- Symmetric mental model to PlatIt — all dependencies can be accessed globally, without widget context.

### 2.1 Design Principles

- **Symmetry:** Both Bloc and Riverpod apps achieve the same context-free DI behavior.
- **Modularity:** Dependencies are grouped by `DIModule` units (e.g., `AuthModule`, `FirebaseModule`).
- **Isolation:** Each module defines its own dependencies and registers them independently.
- **Safety:** `SafeRegistration` and `SafeDispose` extensions prevent double registration or unsafe disposal.
- **Scalability:** New features register their dependencies declaratively and can be independently tested.
- **No Over-Engineering:** No abstract DI bridges; GetIt and Riverpod are used directly, wrapped only by thin facades.

## 3. 🧩 Consequences of the Decision

### ✅ Positive

- **Full DI Symmetry** → Bloc and Riverpod apps achieve identical DI experience.
- **Testability** → Easy to inject mocks and reset DI containers per test.
- **Global Access** → Logic outside widget trees (e.g., overlays, notifications, background jobs) can access dependencies directly.
- **Low Overhead** → GetIt adds negligible runtime or LOC overhead.
- **Hot Reload Safe** → `SafeRegistration` prevents duplicate singletons.
- **Predictable Composition** → Modular structure (`DIModule`s) ensures controlled dependency graphs.

### ⚠️ Negative

- **Manual registration** → Developers must maintain module registration order and dependencies.
- **Runtime safety** → GetIt lacks compile-time validation (compared to Riverpod’s generator-based DI).
- **Discipline required** → Teams must enforce DI consistency through reviews or CI checks.
- **Lifecycle management** → Automatic disposal is limited; long-lived singletons require explicit cleanup.

## 4. 💡 Success Criteria and Alternatives Considered

### 🥪 Success Criteria

- [ ] Consistent, context-free DI across Bloc and Riverpod apps
- [ ] DI setup <10 minutes per new feature
- [ ] Zero circular dependencies during module registration
- [ ] 100% DI module coverage in CI initialization tests
- [ ] Hot reload works without manual container reset
- [ ] Fully testable DI environment with mock injection

### 🦭 Alternatives Considered

1. **Pure GetIt without PlatIt structure**
   - ✅ Simpler, less boilerplate.
   - ❌ Lacks modular isolation and dependency resolution.
   - ❌ Prone to circular dependencies and initialization order issues.

2. **Provider / InheritedWidget-based DI for Bloc**
   - ✅ Type-safe and Flutter-native.
   - ❌ Context-bound — violates State-Symmetric goals.
   - ❌ Poor fit for background services, routing, or multi-app reuse.

🟢 **Result:** PlatIt + GetIt offers the best pragmatic balance between _symmetry, testability, and simplicity._

## 5. 📌 Summary

> **Decision:** Adopt `PlatIt` (GetIt-based) DI for Bloc/Cubit apps, keep native DI for Riverpod, ensuring consistent, context-free dependency access across all architectures.

**Outcome:**

- Unified DI model across state managers.
- Minimal overhead, high testability.
- Modular, maintainable dependency graph.

**Trade-off:**

- Manual discipline required (order of registration, runtime safety).

🟢 **Result:** Pragmatic, maintainable, and fully symmetrical dependency injection layer for all State-Symmetric Architecture apps.

## 6. 🔗 Related Info

### Related ADRs

- [ADR-001 State-Symmetric Architecture](./ADR-001-State-symmetric-architecture.md)
- [ADR-003 GoRouter-navigation](ADR-003-GoRouter-navigation.md)
- [ADR-004 EasyLocalization](ADR-004-EasyLocalization.md)
- [ADR-005 Errors-management](ADR-005-Errors-management.md)
- [ADR-006 Overlays-management](ADR-006-Overlays-management.md)
- [ADR-007 Theming](ADR-007-Theming.md)

### References

- [get_it](https://pub.dev/packages/get_it)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- [info-007-PlatIt.md](supporting_info/info-007-PlatIt.md)
