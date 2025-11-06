# ADR-001: State Management Strategy — State Symmetric Architecture Style

## 1. 🎯 Context

The **state-agnostic approach** aims to keep the codebase mostly unchanged regardless of whether the app uses **Riverpod**, **Cubit/BLoC**, or **Provider**, achieved through additional abstractions, wrappers, and boilerplate layers.

### ✅⚠️ Main **Advantages and Trade-offs** of the state-agnostic approach

- ✅♻️ **Code Reusability** → Shared modules can be reused across projects/apps, reducing time-to-market and testing/maintenance costs of shared features.
- ✅🚀 **Development Flexibility** → Developers can seamlessly move between projects/teams with minimal friction, enabling easier team scaling during critical phases.
- ✅📈 **Scalability & Maintainability** → Clean architecture is enforced, making the codebase easier to extend and maintain.
- ⚠️ **Increased Complexity** → Heavy abstractions (extra contracts, wrappers, files) raise onboarding costs and parity tax. Maintenance becomes harder without strict discipline.

**State-Symmetric Architecture** is a **pragmatic refinement of the state-agnostic approach**, designed to preserve its benefits while avoiding its pitfalls (over-engineering, excessive complexity that rarely delivers true value).

Instead of heavy abstraction layers, the approach applies:

- **Thin, symmetric facades/adapters** over native state managers (Bloc/Cubit, Riverpod, Provider),
- **Clean Architecture principles and Dedicated Flutter packages** to split responsibilities cleanly,
- **Lazy Parity Mode** to minimize overhead by adding adapters for other SMs only when required.
- **Distributed modular structure:** the monorepo organizes code into dedicated Flutter packages, each with its own dependency scope and responsibility; this enforces isolation, clear ownership, and frictionless reuse across apps and state managers.

👉 This monorepo was created to **demonstrate the State-Symmetric architecture style** and measure its **business value** in practice.

## 2. ✅ Decisions

### Adoption of the Requirements to State-Symmetric Approach

The **following requirements are adopted** for the monorepo’s codebase:

- **Code Reusability:** ≥90% of codebase shared across apps/state managers.
- **Scalability:** Features and teams can be extended easily without re‑implementing core layers.
- **Maintainability:** Modular, decoupled, and testable code with clear separation of concerns.
- **Testability:** Business logic testable in isolation, with target >80% coverage.
- **Onboarding:** Lightweight entry for new developers (≤1 week), familiar with Clean Architecture patterns.
- **Flexibility / Portability:** Features can be migrated between apps/SM with <10% code changes.
- **Symmetry Budget:**
  - First feature adapters: ≤15–50% LOC overhead.
  - After 2–3 features: amortized to ≤5–10% LOC, with final target ≤5%.
- **Reuse Gate:** Enable symmetry only if reuse probability ≥15% and UI/UX similarity ≥70%.
- **Maintenance/Test Cost Delta:** Total QA + support cost with symmetry must be lower than maintaining duplicated Presentation layers across different SMs.

### Details of Accepted Decisions

1. **Clean Architecture First**
   UI layer remains thin and stateless. Orchestration is delegated to the state manager layer. Business logic is encapsulated in use cases and domain logic. This ensures modularity, testability, and long-term maintainability.

2. **Thin Symmetric Facades/Adapters**
   Minimal UI-layer wrappers with symmetric APIs/signatures, enabling widget reuse across apps. Implemented in `bloc_adapter` and `riverpod_adapter` packages.

3. **Lazy Parity Principle**
   Overhead adapters are written only for the primary state manager in use. Parity adapters for alternative SMs are added **only when required**, minimizing upfront and ongoing parity costs.

4. **No Global Abstractions**
   No abstract “StateManager” interfaces. Native state managers are used directly; only thin facades wrap them when needed for DX and reuse.

5. **Shared Reactive States and Models**
   Dual-track support: custom state models (e.g. `SubmissionFlowStateModel`, `SignInFormState`) and mirrored async unions (`AsyncValue` ↔ `AsyncValueForBloc`), ensuring consistency across state managers.

6. **State-Agnostic Core Modules**
   Infrastructure modules like localization, overlays, theming, animations remain independent of state management and are reused seamlessly across apps.

7. **DI Symmetry via GetIt**
   Riverpod apps rely on `ProviderScope` (context-free DI). To preserve symmetry, Cubit/BLoC/Provider apps use `GetIt` to achieve the same context-free experience.

8. **Composable and Layered Patterns**
   Features can share models across sub-flows (e.g., Auth/Profile reuse), allowing pragmatic composition without duplication.

9. **Distributed Modular Structure**
   The monorepo follows a distributed modular architecture: all code is organized into dedicated Flutter packages, each owning its own dependency scope and responsibility.
   This structure enables true isolation of concerns, clear ownership boundaries, and frictionless code reuse across apps and state managers.

🟢 **Result:** 90%+ code reuse with minimal overhead, fast onboarding, and improved DX — the golden mean between state-agnostic benefits and engineering pragmatism.

## 3 🧨 Consequences of accepted decisions

### ✅ Positive

- **Preserves state-agnostic benefits** → high code reusability, flexibility, and clean separation of concerns.
- **Lower abstraction overhead** → fewer layers and wrappers reduce complexity and parity tax.
- **Fast onboarding** → developers familiar with Clean Architecture and any major SM (Cubit/BLoC/Riverpod) can contribute within a week.
- **Shared UI/Domain/Data reuse** → >90% of code reused across apps, only thin adapters differ.
- **Reduced QA & maintenance costs** → no duplicated Presentation layers to test/maintain, preventing divergence and lowering long-term support costs; only thin adapters require coverage;
- **Business value as “insurance”** → small upfront adapter overhead (≤20–35% LOC in first features, amortized to ≤5–10%) pays off when reuse probability ≥15–25%.
- **Developer Experience** — one consistent coding model across state managers eliminates mental switching, improving speed and reducing errors.
- **Time-to-Market** — code reuse shortens feature delivery cycles. New features ship significantly faster since ~90% + of the code is already shared and validated.
- **Modular separation ensures that**:
  • Each package has a clear architectural boundary and isolated dependency graph.
  • State manager–specific code lives only in adapters, while core logic remains agnostic.
  • Features can be reused, tested, or migrated independently, preserving symmetry and scalability.

### ⚠️ Negative

- **Niche applicability** → this is not a universal solution. Scenarios where features are reused across apps with different state managers represent <5% of the market, so ROI is only justified in specific niches (agencies, multi-product companies, white-label, platform teams).
- **Adapter duplication** → some parallel classes (e.g., Bloc vs Riverpod listeners) still needed.
- **Discipline required** → teams must consistently enforce symmetry rules and maintain API parity.
- **Symmetric mindset** → developers must adapt to thinking in terms of shared state models and thin facades.

### 🧩 Regarding infrastructure Foundation (required for adoption)

To make the State-Symmetric Architecture feasible and productive, a dedicated infrastructure codebase is required.
Within this monorepo, a base foundation has already been implemented as the core package — a shared module that provides essential building blocks used across all apps and state managers.
The core package includes: errors and overlays management, app navigation, localization, design system and theming, animations, form fields / inputs
This infrastructure enables true symmetry by isolating app-level responsibilities from state management concerns, ensuring that state-symmetric features can operate identically across Riverpod, Cubit/BLoC, and Provider apps with minimal duplication.

## 4. 💡 Success Criteria and Alternatives Considered

### 🧪 Success Criteria for accepted decisions

- [ ] **Reuse ROI**: Symmetry pays off when feature reuse probability ≥ **15–25%** across apps/stacks.
- [ ] **Adapter Overhead**: amortized ≤ **5–10% LOC per feature** (target ≤200 LOC, hard cap 300 LOC).
- [ ] **Migration Savings**: ≥ **40–80%** code saved when features migrate to another app with different SM.
- [ ] **Testing & Maintenance Cost**: reduced duplication → no need to test/maintain multiple Presentation layers for the same feature; only adapters require thin coverage.
- [ ] **Onboarding**: new developers productive in < **1 week** (familiar Clean Architecture + thin adapters).
- [ ] **Delivery Speed**: feature delivery cycle < **2 weeks**, thanks to 90%+ reuse.
- [ ] **Shared UI**: > **90% of UI widgets reused without modification** across apps.

### **Alternatives Considered**

1. **Pure State-Agnostic (heavy abstractions)**
   • ✅ **Pros:** maximal state‑manager independence. With an already developed infrastructure (contracts, adapters, seams, test scaffolding), features can be migrated faster between different SMs‑based apps.
   • ❌ **Cons:** verbose, complex, high parity tax, steep learning curve, slower delivery. Very high upfront cost — the infrastructure codebase must first be developed and later maintained, otherwise the benefits never materialize.

2. **Choose one state‑manager per project (BLoC/Cubit for Enterprise/Banking, Riverpod for mid‑sized/modern apps, Provider for legacy/simple cases)**
   • ✅ **Pros:** clean, minimal setup, small app size, familiar DX, straightforward onboarding.
   • ❌ **Cons:** reduced flexibility — each feature is effectively locked into its chosen SM. Reuse across SMs is limited (→ at least duplicated Presentation layers). Testing and maintenance costs rise (every duplicate Presentation layer must be covered separately). Migration is much harder:
   – From **Riverpod → Cubit/BLoC/Provider** requires building a GetIt‑based DI layer.
   – From **BLoC → Riverpod/Provider** requires creating EventStreamManager equivalents.
   – For both directions, shared infrastructure (themes, overlays, localization, routing, animations) must be replicated.
   **Result:** each migration demands substantial infrastructure rebuild, making parity migrations often impractical in real projects.

## 5. 📌 Summary

> State-Symmetric is a **lighter, DX-focused evolution** of state-agnostic approach. It keeps the benefits of state-agnosticism but avoids its pitfalls.

It delivers a **balanced Clean architecture with**:

- 💡 **Reusable logic and UI**
- ⚡ **High productivity** for teams in critical phases
- 📈 **Scalability & flexibility**
- 🤝 **Much improved developer experience**

🟢 **Result:** 90%+ code reuse with low overhead, fast onboarding, and nice DX — a golden mean between state-agnostic approach (with its benefits) and engineering pragmatism, developer experience.

## 6. 🔗 Related info

### Related ADRs

- [ADR-002 Context-Free-DI.md](ADR-002-Context-Free-DI.md)
- [ADR-003 GoRouter-navigation](ADR-003-GoRouter-navigation.md)
- [ADR-004 EasyLocalization](ADR-004-EasyLocalization.md)
- [ADR-005 Errors-management](ADR-005-Errors-management.md)
- [ADR-006 Overlays-management](ADR-006-Overlays-management.md)
- [ADR-007 Theming](ADR-007-Theming.md)

### References

- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture Guidelines](https://docs.flutter.dev/app-architecture)
