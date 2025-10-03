# ADR-001: State Management Strategy — State Symmetric Architecture Style

⸻

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

- ⚠️ **Increased Complexity** (additional abstractions, wrappers, and files)
  => may add to the size of the codebase and **Higher Initial Investment**
  → More effort and resources are required upfront,
  plus onboarding may be slower for new contributors,
  also needs discipline in codebase's development and maintenance

### ✅ **Accepting of "State-symmetric approach"** and its requirements

👉 This monorepo was created to demonstrate an example of next challenge solving:

**Implement a State-Symmetric architecture style** that _preserves the benefits of the state-agnostic approach_
(high scalability and maintainability, flexibility in team allocation, and effortless feature migration across projects,
regardless of the chosen state manager), _but avoid its pitfalls connected to **Increased Complexity** of such approach_.
In other words, make research of golden mean between business effectiveness and developer experience (DX).

Therefore, the **following requirements are adopted** for the monorepo’s codebase: - _Code Reusability_: Codebase mostly can be reused across projects/apps - _Scalability_: Easily extend features and team size. - _Maintainability_: Clear separation of concerns, modular code. - _Testability_: Business logic can be unit-tested in isolation. - _Onboarding_: Easy for new devs to understand and contribute. - _Development flexibility_: Team members and code can shift between projects without friction.

⸻

## Decisions, Key Principles

In this monorepo **State-Symmetric** approach was implemented by reducing of **State-agnostic approach's over-engineering**,
that rarely delivers true value. Therefore, instead of introducing heavy abstractions, bridges, or interface patterns
(no unified "StateManager" interface abstraction), just stick to clean architecture principles (strict layer separation)
and applying a thin, symmetric facade and/or adapter layer on top of native state managers (BLoC/Cubit and Riverpod).

### Accepted Decisions

- **Thin Symmetric Facades**
  Minimal wrappers-facades with identical API/signatures for BLoC & Riverpod (e.g. SubmissionStateSideEffects ↔ listenSubmissionSideEffects),
  and which use native state managers (BLoC/Cubit and Riverpod) behind the scenes.
  This facade widgets are located in `bloc_adapter`, `riverpod_adapter` flutter packages accordingly

- **Using Adapters and codebase separation between apps and dedicated flutter packages**
  Contracts mostly are in shared `core` flutter package, implementations – in flutter packages.
  In other words we use different adapters, eg presentation-layer adapters (located accordingly in `bloc_adapter`, `riverpod_adapter` packages),
  data-layer adapters (located in `firebase_adapter` flutter package)

- **Selective Abstractions (only when useful)**
  E.g. Profile feature → uses unified AsyncStateView abstraction across BLoC/Riverpod.

- **Shared reactive states and state orchestration through native tools**
  E.g. SignIn feature uses shared between apps [ButtonSubmissionState] and [SignInFormState], without extra wrappers and reuse in both apps.

- **Core features are practically state-agnostic**
  All shared foundational modules from `core` flutter package ([animation], [errors_managing], [localization], [navigation], [overlays], [ui_design], etc.) are practically independent from state manager logic and reused in all apps

- **Stick to clean architecture principles**
  Business logic, data, and UI layers should be clearly separated. The state manager’s files only responsibility is orchestration (all business logic lives in use cases), UI layer is intentionally kept thin, nearly all widgets are stateless, simply react to state changes through facades and/or adapters and can be reused 1:1 across apps

- **Symmetry between Riverpod and other state managers is ensured via GetIt**
  DI is provided by Riverpod’s ProviderScope, no additional DI container needed, unlike others state managers (Bloc/Cubit/provider), which are context dependant => with them use GetIt

🟢 The result: 90%+ code reuse with minimal overhead, fast onboarding, and excellent DX — a golden mean between state-agnostic scalability and engineering pragmatism.

⸻

## Alternatives Considered

Alternatives Considered:

1. Pure State-Agnostic (heavy abstractions)
   • ✅ Pros: maximal independence from state manager.
   • ❌ Cons: complex, heavy to maintain, slower onboarding, larger apps size

2. Riverpod-only
   • ✅ Pros: simpler, no symmetry layer, smaller apps size, no extra packages (like GetIt, etc)
   • ❌ Cons: lose development flexibility, harder to codebase migrate/share, in some apps need an analog of BLoC's Event feature

⸻

## Consequences

### Positive

- Same advantages as state-agnostic (reusability, flexibility, clean code).
- Fewer abstractions → lower complexity.
- Faster onboarding (devs familiar with Cubit/BLoC or Riverpod can jump in immediately).
- Business logic and UI are reusable across apps.

### Negative

- State-symmetric thinking require team buy-in and onboarding.
- Requires discipline to keep symmetry in thin adapters.
- Some code duplication (e.g., ListenerForBloc and ListenerForRiverpod), that provides symmetry

⸻

## Success Criteria

- [ ] Features migrate between projects with <10% code change.
- [ ] Code coverage >80% on business logic.
- [ ] New dev onboarding <1 week.
- [ ] Feature delivery cycle <2 weeks.
- [ ] Shared UI components are reused across state-manager apps without modifications.

⸻

## SUMMARY

**State-Symmetric** Architecture style - is a pragmatic refinement of the state-agnostic approach,
_designed to avoid its pitfalls and preserve its benefits_.
(State-Symmetric is a lighter, DX-friendly evolution of state-agnostic architecture: same structure, shared code, less abstraction)

Instead of introducing heavy abstractions, it uses thin, symmetric facades and adapters around native state managers (e.g., Bloc, Cubit, Riverpod, Provider),
enabling shared UI and logic across apps while preserving native patterns.

It delivers a balanced approach:

- 💡 **Reusable business logic & UI** → code is shared across apps with minimal duplication.
- ⚡ **Improved team productivity** → teams can be scaled quickly in critical phases.
- 📈 **Scalability & Maintainability** → as this approach requires/enforced clean architecture,
  that makes the codebase easier to maintain and extend.
- 🤝 **Excellent developer experience (DX)** (at least much better then within "State-agnostic approach")

⸻

## References

- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture Guidelines](https://docs.flutter.dev/app-architecture)

⸻

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
