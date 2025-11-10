# 🧭 Principles and Economic Rationale of the State-Symmetric Architecture

## 1. The Core Problem

In multi-app Flutter ecosystems, teams sometimes face a recurring dilemma:
**How should the code be structured to enable reuse — and when does such an architecture actually pay off instead of becoming over-engineering or empty overhead?**

Software architecture is not just about code and patterns — it’s also about the economics of change.
Every boundary or abstraction is an investment: some pay back through reuse and flexibility, while others turn into technical debt or wasteful over-engineering.
**State-Symmetric Architecture (SSA) exists to make this trade-off measurable, predictable, and profitable.**

## 2. The Solution: Pragmatic Symmetry

**State‑Symmetric Architecture (SSA)** assumes that over **90% of feature code** (UI, domain, data, infra) can stay identical across apps using different state managers. It does so without abstracting state management itself.

Think of **SSA as engineering insurance** — you pay a small premium (adapter overhead) upfront, and it pays back when features are migrated or reused across state managers.

### 🏛️ Architect's Note: What SSA Is (and Isn't)

**State-Symmetric Architecture is NOT:**

- ❌ A multi-layered "state-agnostic" abstraction (no universal `StateManager` interface)
- ❌ A state manager unification library (BLoC, Riverpod, Provider stay native)
- ❌ Traditional Clean Architecture (though it builds on Clean principles)

**State-Symmetric Architecture IS:**

- ✅ Clean Architecture discipline (layers separation, state managers orchestrate only; UI remains thin and stateless).
- ✅ Thin adapters (2–5 touchpoints per feature) over native state managers
- ✅ Shared state models (same data structures used by different SMs)
- ✅ Symmetry contracts (consistent API signatures across SMs)

* ✅ Symmetry contract (iInfrastructure layers, Data/Domain layers, shared models and presentation APIs stay consistent across SMs)

- ✅ Distributed modularity (code is organized into independent packages (core, features, bloc_adapter, riverpod_adapter, etc.), enforcing clear architectural boundaries and dependency isolation.)
- ✅ Lazy parity (build 2nd SM adapters only when reuse is confirmed, CI policy for sleeping adapters)

**Key distinction:** Instead of abstracting state management itself, SSA keeps state managers **native** but makes the **presentation layer symmetric** through shared models and thin seams.
**Result:** **90%+ code reuse** across apps with different state managers, without the complexity of heavy abstraction layers.
For architectural decisions, see **ADR-001**.

## 4. Design Philosophy

The design values are simple but strict:

- **Pragmatic profit over aesthetic pleasure** — Clean code is a means to efficiency, not an end in itself
- **Empirical metrics** — Measure overhead, savings, and reuse rates instead of guessing.
- **Cognitive symmetry** — Developers navigate identical project structures across apps, reducing mental load.
- **Clean boundaries** — Stick to Clean Architecture discipline.

## 7. The Essence

State-Symmetric Architecture turns Clean Architecture from ideology into economics.
**You pay a small, quantifiable premium for reusability and flexibility — instead of speculative abstraction debt.**

It’s not “write once, run everywhere.”

**It’s about “use it when it’s profitable, and measure when it pays off...”**
