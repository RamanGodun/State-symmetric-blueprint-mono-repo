# ADR-002: Dependency Injection Pattern (via GetIt or native ProviderScope in Riverpod) in Symmetric State Management

## 1. Review and Lifecycle

_Status_: _Accepted_ (2025-09-26)
_Revision history:_ First version
_Author:_ Roman Godun

---

## 2. 🎯 Context

Our Flutter monorepo architecture aims for:

- 🔁 _Shared logic and code reuse_ across apps with different state managers (Bloc/Riverpod, with easy migration support).
- ✅ _Clean architecture principles_ (testability, separation of concerns, thin UI).
- 🧩 _State-Symmetric pattern_ (see ADR-001) with pragmatic dependency injection (DI).

In **Riverpod apps**, DI is inherently contextless via native `ProviderContainer` or `.ref.read(...)` access.

In **Bloc-based apps**, we adopt `GetIt` to replicate the same level of **context independence**, enabling shared modules, consistent state orchestration, and global availability for features like theming, overlays, routing, and background tasks.

This ADR formalizes **PlatIt (Platform Logic Injection Toolkit)** — a modular, scalable DI convention built on top of `GetIt`, powered by `SafeRegistration`, `DIModule`s and `ModuleManager`.

---

### Main Problem

- Bloc and Cubit do not support global DI out of the box.
- DI by `BuildContext` is problematic for:
  - cross-feature orchestration (theme, router, overlays)
  - shared widgets outside widget tree (e.g., notifications, background workers)
  - testing and mocking
- Riverpod solves this with `ProviderContainer`, but Bloc-based apps need structured DI management.

---

## 3. ✅ Decisions, Key Principles

For full platform symmetry and maximum portability across apps we adopt a **dual-platform DI strategy**:

1. **For Bloc-based apps** → use **PlatIt**, a custom DI pattern built on top of `GetIt`

   > **PlatIt** = **Platform Logic Injection Toolkit** — a convention for structured, testable, and context-free service injection in Bloc-based apps.
   > (- [PlatIt-pattern](../packages/bloc_adapter/lib/src/app_bootstrap/di/docs/plat_it_di_pattern.md))

2. **For Riverpod-based apps** → use **native Riverpod ProviderContainer** and `.ref.read()` pattern

### Rationale

- **Platform Symmetry**: Riverpod and Bloc achieve same benefits — global, context-free access to shared dependencies
- **Scalability**: Add/remove feature modules independently
- **Testability**: Inject mocks or override providers/registrations easily
- **Stability**: Supports clean hot reload, reduces chance of registration errors
- **No Over-engineering**: No interface bridges unless necessary
- **Consistency**: Same mental model in Riverpod and Bloc apps

---

## 4. 💡 Success Criteria and Alternatives Considered

### 🧪 Success Criteria

- [ ] Easy dependency injection
- [ ] Graet documentation to used packages

---

## 5. 🧨 Consequences

- Requires discipline around `DIModule` dependencies and registration order
- `GetIt` container must be initialized before use (during bootstrap)
- Riverpod DI assumes clear separation between `ProviderScope` and overrides
- PlatIt is minimal yet extensible, but not fully auto-magical (no auto-dispose)

---

## 6. 🔗 Related info

### Related ADRs

- ADR-003: State-Symmetric Architecture
- ADR-005: Navigation & Routing Strategy
- ADR-006: Localization & Overlay Strategy

---

### References

- [get_it](https://pub.dev/packages/get_it)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- [State-Symmetric Architecture](./ADR-001-State-symmetric-architecture.md)
- [PlatIt-pattern](../packages/bloc_adapter/lib/src/app_bootstrap/di/docs/plat_it_di_pattern.md)

---

## 7. 📌 Summary

Chose approach is non-alternative due to the accepted criteria
