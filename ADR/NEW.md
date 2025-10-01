⸻

Decision

Instead of fully state-agnostic style, adopt a state-symmetric architecture.

👉 State-Symmetric = golden mean between business effectiveness and developer experience (DX).

Key Principles
• Thin Symmetric Adapters
Minimal wrappers with identical API/signatures for BLoC & Riverpod (e.g. SubmissionStateSideEffects ↔ listenSubmissionSideEffects).
• Contracts in Core, Implementations in Adapters
Example: AuthGateway contract → implemented in bloc_adapter and riverpod_adapter.
• Selective Abstractions (only when useful)
E.g. Profile feature → uses unified AsyncStateView abstraction across BLoC/Riverpod.
• Direct Orchestration (no abstraction when not needed)
E.g. SignIn feature → custom ButtonSubmissionState is shared directly, without extra wrappers.
• State Managers Only Orchestrate
Business logic stays in use cases; state managers are orchestration only.
• UI Remains Stateless & Shared
Widgets like \_SignInScreen, \_ProfileScreen reused 1:1 across apps.

⸻

Alternatives Considered

1. Pure State-Agnostic (heavy abstractions)
   • ✅ Pros: maximal independence from state manager.
   • ❌ Cons: complex, heavy to maintain, slower onboarding.

2. State-Symmetric (thin adapters + selective abstractions) ← chosen
   • ✅ Pros: balance of clarity, DX, and business efficiency.
   • ✅ Pros: 90%+ code reuse preserved.
   • ❌ Cons: still some duplication in thin adapters.

3. BLoC-only or Riverpod-only
   • ✅ Pros: simpler, no symmetry layer.
   • ❌ Cons: lose flexibility, harder to migrate/share.

⸻

Consequences

Positive
• Same advantages as state-agnostic (reusability, flexibility, clean code).
• Fewer abstractions → lower complexity.
• Faster onboarding (devs familiar with Cubit/BLoC or Riverpod can jump in immediately).
• Business logic and UI are reusable across apps.

Negative
• Requires discipline to keep symmetry in thin adapters.
• Some duplication (e.g., ListenerForBloc and ListenerForRiverpod).

⸻

Success Criteria
• 90%+ of UI/features remain unchanged across apps.
• Onboarding <1 week.
• Feature delivery <2 weeks.
• Code coverage >80% for business logic.

⸻

Examples

👤 Profile Feature (with abstraction)
• Shared: AsyncStateView<T> contract.
• Bloc: AsyncStateViewForBloc.
• Riverpod: AsyncStateViewForRiverpod.
• Unified in UI via AsyncValueView.

🔐 Sign-In Feature (without abstraction, only thin adapters)
• Shared: ButtonSubmissionState used by both Cubit and Riverpod.
• Bloc: SubmissionStateSideEffects.
• Riverpod: listenSubmissionSideEffects.
• Both wrap the same \_SignInScreen UI.

⸻

In Short

State-Symmetric architecture keeps the benefits of state-agnosticism but avoids its pitfalls.
It delivers a balanced approach:
• 💡 Reusable business logic & UI,
• ⚡ Productivity for critical business tasks,
• 🤝 Excellent developer experience.
