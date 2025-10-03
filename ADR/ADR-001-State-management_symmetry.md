# ADR-001: State Management Strategy — State Symmetric Architecture Style

## Status

Accepted

**Date:** 2025-07-25
**Author:** Roman Godun
**Reviewers:**

### Review and Lifecycle

- Status: **Accepted** (2025-09-26)
- Revision history: First version

## Related ADRs

- ADR-002: Bloc + GetIt state management approach
- ADR-003: Navigation and Routing strategy (GoRouter)

## 📌 Definition

**State-Symmetric Architecture** - is a pragmatic refinement of the state-agnostic approach (with preserving all its core principles),
designed to improve Developer Experience (DX) by replacing heavy abstraction layers with thin, symmetric facades and adapters over native state managers (e.g., Bloc, Riverpod).
🟢 The result: 90%+ code reuse with minimal overhead, fast onboarding, and nice DX — a golden mean
between state-agnostic benefits (business effectiveness) and engineering pragmatism (developer experience).

## Context and Problem

There are different view points about **state-agnostic approach** (when codebase mostly remains unchanged,
regardless of whether the app uses **Riverpod**, **Cubit/BLoC**, or **Provider**),
that achieves via additional abstractions, wrappers, and files.

### ✅⚠️ Main **Advantages and Trade-offs** of "state-agnostic approach"

- ✅♻️ **Code Reusability** → Shared modules can be reused across projects/apps,
  improving efficiency and reducing time-to-market.

- ✅🚀 **Development Flexibility** → Developers can seamlessly move between projects/teams
  with minimal context-switch overhead => easier scaling of teams during critical tasks

- ✅📈 **Scalability & Maintainability** → This approach requires/enforced clean architecture,
  that makes the codebase easier to maintain and extend.

- ⚠️ **Increased Complexity** => Heavy abstractions (additional abstractions, wrappers, and files)
  increase size and onboarding cost; maintenance becomes harder without strict discipline.

### ✅ **Adoption of the State-Symmetric Approach** and requirements

👉 This monorepo was created to demonstrate how to implement a State-Symmetric architecture style — one that maintains
the benefits of state-agnosticism (scalability, team flexibility, reusable business logic) but avoids its pitfalls (over-abstraction, complexity).

Therefore, the **following requirements are adopted** for the monorepo’s codebase:

- _Code Reusability_: Codebase is shared across apps
- _Scalability_: Features and teams can be extended easily
- _Maintainability_: Modular, decoupled, and testable code
- _Testability_: Business logic testable in isolation
- _Onboarding_: Lightweight entry for new developers
- _Flexibility_: Code and people can move freely between apps/projects

## Decisions, Key Principles

In this monorepo **State-Symmetric** approach was implemented by reducing of _State-agnostic approach's over-engineering_ (that rarely delivers true value) and instead applying a thin, symmetric facade layer over native state managers (BLoC/Cubit and Riverpod)
with preserving of others principle of state-agnostic architecture codestyle

🟢 The result: 90%+ code reuse with minimal overhead, fast onboarding, and excellent DX — a golden mean between state-agnostic scalability and engineering pragmatism.

### Accepted Decisions

- **Thin Symmetric Facades**
  Minimal UI-layer facades wrapping native state with symmetrical API/signature. Used for parity in shared widgets across apps. Located in `bloc_adapter` and `riverpod_adapter` packages.
  Example: `SubmissionStateSideEffects` ↔ `listenSubmissionSideEffects`

- **Adapters & Modular Codebase**
  Shared _contracts_ in the `core` package, implementations in adapter packages. Separate adapters for:
  - Presentation-layer (`bloc_adapter`, `riverpod_adapter`)
  - Data-layer (`firebase_adapter`)
    Example: AuthServiceContract (core) → FirebaseAuthAdapter (adapter)

- **No Global Abstractions**
  No abstract "StateManager" interface; native state managers are used directly. Wrapping happens only for DX/UI reuse.

- **Shared Reactive States**
  Example: SignIn feature uses `ButtonSubmissionState` and `SignInFormState` directly in both Bloc and Riverpod apps.

- **State-Agnostic Core Modules**
  Modules like localization, overlays, theming, and animations are almost completely independent of state management and reused across apps.

- **Clean Architecture Compliance**
  UI layer is thin and stateless. Orchestration sits in the state manager layer. Business logic lives in use cases and domain logic.

- **DI Symmetry via GetIt**
  Riverpod uses `ProviderScope` (DI via context-free global scope), so to maintain symmetry, Bloc/Cubit/Provider-based apps use `GetIt` to achieve the same context-free experience.

- **Composable and Layered Patterns**
  The architecture allows for combining patterns pragmatically. For example, the Profile feature uses a UI compatibility wrapper (or API-mirroring approach) — enabling shared rendering logic across state managers while not introducing unnecessary indirection.
  This illustrates how wrapper, facade, and adapter patterns may coexist when appropriate.

## Alternatives Considered

Alternatives Considered:

1. Pure State-Agnostic (heavy abstractions)
   • ✅ Pros: maximal independence from state manager.
   • ❌ Cons: complex, verbose, hard to maintain, slow onboarding.

2. Riverpod-only
   • ✅ Pros: clean, small, minimal setup.
   • ❌ Cons: less flexibility, harder to share or migrate codebases with Bloc/Provider-based apps, in some apps need to create an analog of BLoC's event-streams feature

## Consequences

### ✅ Positive

- All benefits of state-agnostic architecture preserved (reusability, flexibility, clean code).
- Fewer abstractions → lower complexity.
- Faster onboarding (devs familiar with Cubit/BLoC or Riverpod can jump in immediately).
- Business logic and UI are reusable across apps.

### ⚠️ Negative

- Some duplication (e.g., `ListenerForBloc`, `ListenerForRiverpod`)
- Requires team discipline to maintain API parity and consistency
- Teams must adopt symmetric thinking

## Success Criteria

- [ ] Features migrate between apps with <10% code change
- [ ] > 80% code coverage on business logic
- [ ] Onboarding time for new devs <1 week
- [ ] Feature delivery <2 weeks
- [ ] Shared UI widgets reused without modification

## Summary

The **State-Symmetric** architecture style keeps the benefits of state-agnosticism but avoids its pitfalls.

> State-Symmetric is a **lighter, DX-focused evolution** of state-agnostic: same structure, shared logic, fewer abstractions.

It delivers a **balanced architecture**:

- 💡 **Reusable logic and UI**
- ⚡ **High productivity** for teams in critical phases
- 📈 **Scalability & clean maintenance** via architecture
- 🤝 **Much improved developer experience**

## References

- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture Guidelines](https://docs.flutter.dev/app-architecture)
