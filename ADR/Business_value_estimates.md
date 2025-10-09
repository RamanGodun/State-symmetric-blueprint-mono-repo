# 📈 Business Value Estimates

> A pragmatic summary of the **State‑Symmetric** approach (_Clean Architecture + Thin Adapters + Lazy Parity_) using real measurements from the showcase repo. Goals: keep **state‑dependent code <5% per feature**, reuse **85–95%** across stacks, and pay the cost **only when reuse is likely**.

---

## 1) Cost Model (realistic, observed)

- **Adapter LOC for showcase features** across Cubit/Riverpod apps of monorepo: **<5%**.
  - **Visible UI parity:** **95–100%** (widgets/screens shared 1:1).
  - **Presentation parity:** **~85–90%** (differences are thin wrappers).

- **Parity ops (tests, CI matrix):** **+5–10%** overhead _only_ if both adapters run full suites.
  - With **Lazy Parity** (sleeping the inactive adapter + smoke tests), ongoing cost → **~0–3%**.

- **Production reality:** one adapter is compiled; others stay in **sleep mode** (smoke/compile‑check only).
- **Implication:** claims like _“10–15% duplication → 25–50% overhead”_ **don’t match** this repo’s measurements.

---

## 2) ROI Model

Adapters are **thin seams** (2–7 horizontals/feature, ≤ **200 LOC** or < **5%**):

1. Side‑effects / submission listeners (success/error/retry)
2. Async glue (Idle/Loading/Success/Error)
3. UI events → domain commands
4. Screen lifecycle hooks (init/dispose/cleanup)
5. _(Optional)_ lightweight overlays/guards/router hooks

Everything else is **shared**:

- State models (form/submission) in presentation
- Entire **domain/data** layer (use‑cases, repos)
- **Stateless UI** widgets
- Cross‑cutting infra (errors, overlays, i18n, navigation, theming)

**Formula**

```
Expected ROI ≈ R · I · F − OMI · F
  F   = feature cost (effort)
  R   = reuse probability (within 6–12 months)
  I   = impact (savings on reuse)
  OMI = overhead + maintenance + initial training
```

**Typical ranges (observed):**

- **OMI:** **0.05–0.15·F** on the first symmetric build; **0–0.03·F** ongoing in prod (one active adapter + smoke on the sleeper).
- **I:** **0.40–0.80·F** per reuse (UI + domain already done; you add ≤ **200 LOC**).
- **Break‑even:** **R ≳ 0.20–0.30** (the 2nd use pays off).

---

## 3) Feature‑Level ROI Snapshots

Conservative estimates under Clean Arch + Lazy Parity.

### A) **Sign‑In** (form + submission)

- **Shared code:** **~85–92%** (form state, validators, widgets, use‑case, errors, overlays, navigation).
- **Adapter seam:** `SubmissionSideEffects` + notifier/cubit + helpers → **~8–12%** _for both adapters combined_.
  - Ship one SM first → initial overhead **~4–6%**; add the 2nd later when needed.

- **Visible code reuse on 2nd stack:** **~95–100%**.
- **Reuse savings (2nd app/stack):** **~40–70%** of feature effort.

### B) **Profile** (async data + preserved UI on refresh)

- **Shared code:** **~88–95%** (entity/DTO, repo & use‑case, state‑agnostic widgets, error overlays).
- **Adapter seam:** Riverpod `AsyncValue<T>` ↔ BLoC analogue + `AsyncStateView<T>` facade → **~5–8%**.
- **Reuse savings (2nd app/stack):** **~50–80%**.

**Quick table**

| Feature type             | Shared code (1st build) | Adapter cost (both SMs) | Reuse saving (2nd stack) |
| ------------------------ | ----------------------: | ----------------------: | -----------------------: |
| **Sign‑In (submission)** |                  85–92% |                   8–12% |                   40–70% |
| **Profile (async data)** |                  88–95% |                    5–8% |                   50–80% |

> Adapter overhead is **app‑level presentation glue + adapter packages** and remains **≤ 200 LOC/feature** (e.g., Sign‑In: ~180–200 LOC per adapter vs ~1.8–2.0k shared LOC). Enforcing a **Symmetry Budget (≤ 200 LOC)** keeps the delta **<5%**.

---

## 4) Decision Flowchart (switch on/off)

```
New Feature
   ↓
Will it be reused within your planning horizon?
   ├─ NO → Single‑SM ✓
   └─ YES
        ↓
R(reuse on a different SM) ≥ 20%?
   ├─ NO → Single‑SM ✓
   └─ YES
        ↓
Feature type?
   ├─ Form/Action → ButtonSubmissionState
   ├─ Async Data/Feed → AsyncValue‑style
   └─ Both → Hybrid (if justified)
        ↓
Adapter ≤ 200 LOC (<5%)?
   ├─ NO → Simplify or keep Single‑SM
   └─ YES
        ↓
Team trained / roadmap stable?
   ├─ NO → Train or postpone (Lazy Parity)
   └─ YES → Build symmetry
```

---

## 5) Criteria to Maximize ROI

**Principle:** keep **state‑dependent code <5%** and pay only when reuse is likely (**Lazy Parity**).

- **Adapter budget:** ≤ **200 LOC** or **<5%** of feature LOC; otherwise **single‑SM**.
- **Symmetry scope:** only **2–7 horizontals** (see §2).
- **No “full” symmetry:** ❌ no universal VM/Store; use **native SM APIs** with thin facades.
- **Prove the budget:** track **SLOC delta** per feature (adapters only) → target **<5%**.
- **“Symmetry Contract” doc:** **6–8 API rules** + **review checklist** (states, errors, navigation, teardown parity).
- **CI policy:** full suite for the **active** adapter; **sleeping** adapter = compile + smoke.

### Special case — AsyncValue parity (Profile pattern)

If a native primitive like Riverpod’s **`AsyncValue<T>`** brings distinct UX gains (background refresh, preserved content), add a **one‑off BLoC analogue** plus a tiny **`AsyncStateView<T>`** facade (written once per app and reused across features). UI stays **fully state‑agnostic** while orchestration remains **native** to each SM.

---

## 6) CI Policy (concrete)

- **Active adapter (in prod):** full unit/widget/integration tests + lint + coverage.
- **Sleeping adapter:**
  - **Weekly:** compile check + smoke tests (≤ 5 min).
  - **Monthly:** light integration pass (≈ 10–15 min).
  - **Quarterly:** parity validation against the active path.

- **If parity breaks:** fix within the next sprint **or** mark the adapter deprecated.

---

## 7) Symmetry Contract — Example

**API Parity Rules**

1. Shared state models → mirrored types and side‑effects parity (success/error/retry hooks exposed uniformly).
2. Public method signatures symmetric: e.g., `submit(email, password)` ↔ `signin(email, password)`.
3. Identical error semantics: `Consumable<Failure>` (same codes/messages).
4. Lifecycle hooks matched: `init/refresh/reset/dispose`.
5. Navigation outcomes identical: routes, redirects, back‑stack effects.
6. Teardown parity: cleanup, cancellation, debouncers.
7. Docs parity: both adapters share the same API docs.

**Review Checklist**

- [ ] Sealed state classes/typedefs match across SMs
- [ ] Public API signatures aligned
- [ ] Error flows equivalent
- [ ] Success/failure handlers symmetric
- [ ] Init/refresh/reset/dispose aligned
- [ ] Navigation effects match
- [ ] Tests cover parity
- [ ] Docs updated for both adapters

---

## 8) Practical Economics — Baselines vs Symmetry (revised)

Let **F** be the total cost of delivering a feature once.

### A) Baseline — Single‑SM, Clean Architecture (no symmetry)

- **What ports to a new SM:** re‑implement presentation glue (state types, notifiers, listeners, navigation hooks) and some UI wiring; domain/data reused.
- **Port cost to a 2nd app/stack:**
  - **Submission flows (Sign‑In/Up):** **0.25–0.45·F**
  - **Async data (Profile/Feed):** **0.30–0.50·F**
  - **Mixed/complex (analytics, guards, A/B):** **0.40–0.65·F**

### B) Baseline — Single‑SM, Spaghetti (no symmetry)

- **What ports to a new SM:** mostly a rewrite (state, UI and logic entangled). You may salvage DTOs/entities and a few stateless widgets.
- **Port cost to a 2nd app/stack:** **0.70–0.90·F** (i.e., **70–90%** rebuilt). Conservative midpoint ≈ **0.80·F**.

### C) Symmetry — Clean Arch + Thin Adapters (Lazy Parity)

- **First build today:** **1.05–1.10·F** (thin facades, 4–7 horizontals, ≤ 200 LOC budget).
- **Add a 2nd SM later:**
  - **Submission flows (Sign‑In/Up):** **0.03–0.06·F**
  - **Async data (Profile/Feed):** **0.04–0.08·F**
  - **Generic rule of thumb:** **0.05–0.10·F**

- **Observed in repo:** visible UI parity **95–100%**; presentation‑layer reuse **~85–95%**.

---

### Break‑even math (reuse probability **R**)

Compare expected extra costs to support a 2nd SM within 6–12 months.

- **No symmetry (clean baseline):** `E_clean = R · p_clean · F`
- **Symmetry (thin adapters):** `E_sym = o · F + R · a · F`

Break‑even when `E_sym ≤ E_clean` ⇒ **`R ≥ o / (p_clean − a)`**.

**Typical thresholds vs clean baseline:**

- Mid‑range numbers: `o = 0.06`, `p_clean = 0.40`, `a = 0.06` ⇒ **`R ≈ 18%`**.
- Range across realistic bounds:
  - Best case: `o = 0.05`, `p_clean = 0.60`, `a = 0.05` ⇒ **`R ≈ 9%`**.
  - Worst case: `o = 0.10`, `p_clean = 0.30`, `a = 0.10` ⇒ **`R ≈ 50%`**.

**Thresholds vs spaghetti baseline:** with `p_spag = 0.70–0.90`, `a = 0.05–0.10`, `o = 0.05–0.10` ⇒ **`R ≈ 6–17%`**.

> Intuition: if there’s even a **~10%** chance you’ll need the feature on a 2nd SM _and_ the current code is spaghetti, symmetry pays for itself.

---

### Per‑feature break‑even vs clean baseline

| Feature type             | Clean‑port cost (p) | Adapter later (a) | First build overhead (o) | Break‑even **R\*** = o/(p−a) |
| ------------------------ | ------------------: | ----------------: | -----------------------: | ---------------------------: |
| **Sign‑In / submission** |           0.25–0.45 |         0.03–0.06 |                0.04–0.06 |                   **~9–32%** |
| **Profile / async data** |           0.30–0.50 |         0.04–0.08 |                0.05–0.08 |                  **~11–36%** |
| **Mixed/complex**        |           0.40–0.65 |         0.05–0.10 |                0.06–0.10 |                  **~12–33%** |

> Adapter overhead is app‑level presentation glue + adapter packages and remains **≤ 200 LOC/feature** (e.g., Sign‑In: ~180–200 LOC per adapter vs ~1.8–2.0k shared LOC). Enforcing a **Symmetry Budget (≤ 200 LOC)** keeps the delta **<5%**.

---

### Decision rules

**Enable symmetry if**

- Feature reuse (in app with othwe state-manager) probability **≥ 20–30%** (use the per‑feature table if known).
- UI similarity **≥ 70%**.
- Team accepts the **Symmetry Budget** (≤ 200 LOC, 4–7 horizontals) and has dual‑SM competence.
- Roadmap reasonably stable.

**Keep single‑SM if**

- Low reuse probability / divergent UX.
- Extreme time‑to‑market pressure.
- Spaghetti today and no time to clean — either stay single‑SM or first refactor to clean boundaries, then add symmetry.

---

## 9) Metrics to Track

- **Reuse Rate:** % of features ported to another stack/app.
- **Adapter Delta:** adapter LOC / total LOC (target **≤ 5%**).
- **Lead Time to Parity:** contract → feature‑parity app.
- **Adapter Defect Rate:** issues per 1k LOC (should be near‑zero with thin seams).

---

## 10) Summary

- **Overhead:** **5–10%** max (often **~5%** with Lazy Parity).
- **Reuse:** **85–95%** across repeated features (visible UI **95–100%** for Sign‑In).
- **Net savings:** **30–85%** per reused feature.
- **Rule of thumb:** if **≥ 1 out of 3** new features is likely to be reused within your planning horizon, symmetry is **worth it**.
- This is **not** a heavy state‑agnostic framework; it’s **Clean Architecture with pluggable state managers** via **thin adapters**.

---

## Appendix — Critics vs Reality

| Topic        | Critique                            | Reality                                                                 |
| ------------ | ----------------------------------- | ----------------------------------------------------------------------- |
| Purpose      | “Abstraction for its own sake”      | Adapters exist **only** when reuse probability justifies them.          |
| Overhead     | 25–50% overhead, 10–15% duplication | Observed adapters ≈ **≤ 5% LOC**; Lazy Parity → near‑zero prod overhead |
| Team Impact  | High cognitive load                 | Thin seams; modest training; then trivial to use.                       |
| Runtime Cost | Bigger binaries, slower apps        | Tree‑shaking compiles **one** adapter; others are dead code.            |
| Scalability  | “More layers ≠ more scalable”       | Clean Arch enforced; _not_ framework bloat.                             |

**Why this is not over‑engineering**

Heavy patterns add universal abstractions everywhere. Here, adapters live **only at the edges**, while domain/UI remain shared and simple. The result is an evolvable codebase that mirrors how platform teams operate: **shared kernel + edge adapters**.

> **Bottom line:** the common critique fits heavy, state‑agnostic frameworks. It **doesn’t** apply to this thin‑adapter, lazy‑parity state‑symmetric approach.
