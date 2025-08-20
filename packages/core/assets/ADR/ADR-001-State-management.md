# ADR-001: State Management Strategy — State Agnostic Clean Architecture (Riverpod as Default)

## Status

Accepted

**Date:** 2025-05-25
**Author:** Roman Godun
**Reviewers:** (Team Lead, Senior Developer)

---

## Context and Problem

The project's goal is to build an **advanced, scalable, and maintainable Flutter blueprint** for mid-to-large scale apps,
focusing on maximizing codebase reusability and minimizing dependency on a specific state manager.
The key challenge: make at least 90% of the codebase **state-agnostic**, allowing rapid onboarding,
flexibility in team allocation, and effortless feature migration across projects, regardless of the chosen state manager.

The blueprint was validated by developing two parallel apps — one using Bloc+GetIt, the other using Riverpod.
Despite different state managers, more then 90% of the code remained identical, demonstrating the effectiveness of clean, modular, state-agnostic architecture.

---

## Requirements

- **Scalability**: Easily extend features and team size.
- **Maintainability**: Clear separation of concerns, modular code.
- **Testability**: Business logic can be unit-tested in isolation.
- **Onboarding**: Easy for new devs to understand and contribute.
- **Flexibility**: Team members and code can shift between projects without friction.

---

## Decision

Adopt a **State Agnostic Clean Architecture**, using Riverpod as the default state manager for orchestration,
but ensuring all core business logic and modules are fully decoupled from any particular state manager.

- All shared modules (Animation, Error Handling, Localization, Overlay, Theme, etc.) are practically (>95%) independent from state manager logic.
- The state manager’s only responsibility is orchestration — all business logic lives in use cases.
- UI layer is as thin as possible; nearly all widgets are stateless and simply react to state changes.
- DI is provided by Riverpod’s ProviderScope; no additional DI container needed (unlike Bloc + GetIt or Provider+GetIt).
- **This is not a Bridge or interface abstraction pattern.** There is no StateManager interface.
  State-agnosticism is achieved via strict layer separation and clean code principles.

---

## Alternatives Considered

### 1. Bloc + GetIt (or Provider + GetIt)

- **Pros:** Familiar to many teams; large ecosystem; works with existing tools; decouples logic from Flutter context.
- **Cons:** Context-bound, more boilerplate, less compile-time safety, DI is external (GetIt), less flexible than Riverpod.

### 2. Bridge/Interface Abstraction Pattern

- **Pros:** Allows runtime swap of state managers; useful if migration between state managers is expected.
- **Cons:** Heavy abstraction overhead; additional complexity for little real-world benefit; slows onboarding; rarely justified except for planned migration.

### 3. Pure Provider (without GetIt)

- **Cons:** Limited flexibility for large projects; context-bound; similar to Bloc’s context-based limitations.

---

## Rationale

- **Codebase universality:** Features can be moved or shared between projects almost effortlessly, saving time and reducing bugs.
- **Team flexibility:** Any developer can jump between codebases (Riverpod, Bloc, Provider) without learning curve.
- **Reduced overengineering:** No need for custom abstractions or bridges that rarely deliver value.
- **Best practice in Clean Architecture:** Business logic, data, and UI layers are clearly separated.
- **State-agnosticism as a side effect:** Not the goal per se, but a product of clean layering and architecture discipline.

---

## Consequences

### Positive

- New features can be implemented or ported in <2 weeks.
- Onboarding for new team members is fast (<1 week).
- Business logic and UI are easy to test and maintain.
- Any module (overlays, theme, error handling, etc.) is reusable across projects and teams.
- Supports future migration to other state managers with minimal changes.

### Negative

- Requires initial investment in discipline and structure.
- Maintaining two consistent parallel projects for validation adds initial overhead.
- Clean layering and state-agnostic thinking require team buy-in and onboarding.

---

## Success Criteria

- [ ] Features migrate between projects with <5% code change.
- [ ] Code coverage >80% on business logic.
- [ ] New dev onboarding <1 week.
- [ ] Feature delivery cycle <2 weeks.

---

## Flutter-Specific Sections

**Flutter version:** 3.16.0+
**Minimum supported:** 3.13.0

**Dependency Impact:**

- flutter_riverpod: ^2.6.1
- go_router: ^15.1.2
- easy_localization: ^3.0.3
- formz: ^0.8.0
- get_storage: ^2.1.1
- shared_preferences: ^2.5.3

**Performance Considerations:**

- Build time impact: negligible
- App size impact: <+100KB (mainly from state manager lib)
- Runtime performance: No measurable impact

---

## Testing Strategy

- Unit tests for use cases and business logic
- Widget tests for UI components (stateless, functional)
- Integration tests for user flows (with real or mocked Riverpod container)

---

## Architecture Diagram (Mermaid)

```mermaid
graph TD
    UI[UI Layer (Stateless Widgets)] --> Orchestration[State Manager (Riverpod)]
    Orchestration --> UseCases[Use Cases (Business Logic)]
    UseCases --> Repos[Repositories]
    Repos --> DataSources[Data Sources]
    UI --> Overlays[Overlay, Theme, Error Handling, etc. (Shared Core)]
```

---

## Review and Lifecycle

- Status: **Accepted** (2025-05-26)
- Next review: **2025-07-10** or upon major project or team change
- Revision history: First version

---

## References

- [Riverpod documentation](https://riverpod.dev/)
- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture Guidelines](https://docs.flutter.dev/app-architecture)

---

## Related ADRs

- ADR-002: Bloc + GetIt state management approach
- ADR-003: Navigation and Routing strategy (GoRouter)
