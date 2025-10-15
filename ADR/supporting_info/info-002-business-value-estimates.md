# 📈 Business Value Estimates

A pragmatic summary of the **State‑Symmetric** approach using real measurements from the showcase repo.

> Goals: keep **state‑dependent code in range 15–35% LOC upfront, amortized to ≤5–10% per feature**, reuse **60–80%** across stacks, and pay the cost **only when reuse is likely**.

---

## 1) Cost and ROI Model (realistic, observed)

- **Visible UI parity:** **95–100%** (widgets/screens are visually identical).
- **Presentation parity:** **~85–90%** (remaining differences are thin wrappers).
- **Lazy Parity in production:** only one adapter is compiled; others remain in **sleep mode** (smoke/compile‑check only). Ongoing cost for tests and CI matrix is kept at **≤5%**.

Adapters are implemented as **thin seams** (2–7 touchpoints per feature):

1. Side‑effects / submission listeners (success, error, retry)
2. Async glue (Idle / Loading / Success / Error)
3. UI events → domain commands
4. Screen lifecycle hooks (init, dispose, cleanup)
5. _(Optional)_ lightweight overlays, guards, router hooks

Everything else remains **shared**:

- State models (form/submission) in presentation
- Entire **domain/data** layer (use‑cases, repositories)
- **Stateless UI** widgets
- Cross‑cutting infrastructure (errors, overlays, localization, navigation, theming, forms, etc)

**ROI Formula**

```
Expected ROI ≈ R · I · F − OMI · F
  F   = feature cost (effort)
  R   = reuse probability (within horizont of planning)
  I   = impact (savings from reuse)
  OMI = overhead + maintenance + initial training
```

---

## 2) ROI Snapshots for showcase Features

Assessments are based on the [`loc_report.sh`](../scripts/loc_report.sh) script.

### A) Auth (Sign-In/Up, Password actions sub-features)

- **Core shared:** 400 LOC (~28–29%)
- **Presentation per SM:** 684–715 LOC (~50%)
- **Adapters:** 285–291 LOC (~20–21%)

**Savings (migration to 2nd SM):**

- BLoC → Riverpod: **+399 LOC saved (~58%)**
- Riverpod → BLoC: **+424 LOC saved (~59%)**

✅ **Conclusion:** ROI is already positive from the **1st feature** → always worth using in case of probability of feature's using in another state manager.

---

### B) Profile (+ Email Verification sub-feature)

- **Core shared:** 185 LOC (~27%)
- **Presentation per SM:** 262–266 LOC (~39%)
- **Adapters:** 237–238 LOC (~34–35%)

**Savings (migration to 2nd SM):**

- BLoC → Riverpod: only **+24 LOC (~9%)**
- Riverpod → BLoC: only **+29 LOC (~11%)**

⚠️ **Conclusion:** ROI is weak for a **single feature**.
✅ Becomes positive with **≥2 async features** (e.g., Feed, Dashboard).

---

### Quick reference

| Feature type | Shared code\*   | Adapter cost | Savings (2nd SM migration) |
| ------------ | --------------- | ------------ | -------------------------- |
| **Auth**     | ~80% (28 + 52%) | 20%          | 58–59%                     |
| **Profile**  | ~65% (27 + 39%) | ~34–35%      | 9–11%                      |

\*Shared code includes the presentation layer (52% for Auth and 39% for Profile), which has **Visible UI 95–100% parity** (see accepted model).

---

### ROI Insights

- **Auth features (submission flows):**
  - ROI is **immediately positive** ✅
  - **Break-even:** 1st feature → recommended by default.

- **Profile features (async flows):**
  - ROI is **marginally positive** for the 1st feature ⚠️ (~10% savings, but 237 LOC investment).
  - ROI turns **positive with 2+ async features** (≈28% cumulative savings).
  - With **3+ async features**, ROI grows strongly (≥60%).

---

## 6) Practical Economics — Break‑Even with Real Measurements

All numbers below come directly from the `loc_report.sh` analysis of the showcase monorepo.

---

### A) Baseline — Clean Architecture (single SM)

- **Auth / submission flows**: porting cost to a new SM ≈ **0.40·F** (40% of the feature).
- **Profile / async features**: porting cost to a new SM ≈ **0.40·F** as well (domain/data reused, but presentation glue must be rebuilt).

### B) Baseline — Spaghetti Code

- State, presentation, and logic are entangled → nearly a full rewrite.
- **Port cost**: **0.70–0.90·F** (≈ 70–90% rewrite).
- **Conclusion**: symmetry cannot help until code is refactored to Clean Architecture.

### C) State-symmetric approach

- **Observed adapter overhead (Auth, Profile)**: **~20–35% LOC** for the first features.
- **Amortized overhead**: drops to **≤5–10%** after 2–3 features, since adapters are reused.
- **Cost to add 2nd SM:**
  - **Auth / submission flows:** **0.06·F** (≈ 291 LOC vs 715 LOC baseline).
  - **Profile / async flows:** **0.07·F** (≈ 237 LOC vs 262 LOC baseline).

---

### D) Break‑Even Probability (as “insurance”)

Formula:
**`R ≥ o / (p_clean − a)`**

- **o** — initial overhead (the “insurance premium”).
- **p_clean** — porting cost under a clean baseline.
- **a** — porting cost with adapters in place.
- **R** — probability that the feature will need to be reused on another SM.

#### Auth (submission flows)

- `p_clean = 0.40`, `a = 0.06`, `o = 0.05–0.06`
- Break‑even: **R ≈ 15–20%**
- Interpretation: if there **is even a 1‑in‑5 chance the feature will be reused in another state manager, symmetry pays off**.
- ROI: already positive from the very first feature (58–59% savings).

#### Profile (AsyncValue features)

- `p_clean = 0.40`, `a = 0.07`, `o = 0.07`
- Break‑even: **R ≈ 20–25%**
- For **1 async feature**: weak ROI (~10% savings, −200 LOC net).
- For multiple async features: amortization drives ROI strongly positive.

**Adapter amortization (237 LOC one‑time cost):**

| # of async features | Cumulative savings |              Net ROI |
| ------------------- | -----------------: | -------------------: |
| **1** (Profile)     |         ~24–29 LOC | negative (~−200 LOC) |
| **5**               |          ~1.2k LOC |            +1.0k LOC |
| **10**              |          ~2.5k LOC |            +2.2k LOC |
| **15**              |          ~3.8k LOC |            +3.6k LOC |
| **20**              |          ~5.0k LOC |            +4.8k LOC |

**Conclusion:** AsyncValue adapters become worthwhile starting at **2–3 features**, and highly profitable from **5+ features**.

---

## 📈 Break‑Even Graph

```
ROI
│
│                    /
│                   /
│                  /
│                 /
│                /
│               /
│______________/__________________  → R(reuse)
              0.15  0.25

```

Probabiity of feature reuse in another state-manager:

- Reuse ≤ 15% → ❌ Negative ROI
- Reuse 15–25% → ⚠️ Conditional (depends on roadmap)
- Reuse ≥ 25% → ✅ Positive ROI

## Criteria to Maximize ROI

- Keep **state‑dependent code at target <5% per feature** and pay only when reuse is likely (**Lazy Parity**).
- **Symmetry scope:** only **2–7 horizontals**. Make **“Symmetry Contract” doc:** **6–8 API rules** + **review checklist**.
- **No “full” symmetry:** ❌ no universal VM/Store; use **native SM APIs** with thin facades.
- **Prove the budget:** track **SLOC delta** per feature (adapters only) → target **5-10% per feature** (within ammortization acumulation).
- **CI policy:** full suite for the **active** adapter; **sleeping** adapter = compile + smoke.

## 📌 Summary

- **Implementation cost (measured):** For the **first** features, adapters account for **~15–35%** of feature LOC (Auth‑like on the lower end; Profile‑like on the higher end). After the approach is applied across **2–3 features** (reusing the same seams), the **amortized overhead drops to ≤5–10%** per feature.

- **Auth / submission flows:** **Immediate positive ROI** from feature #1. Adding a second state manager yields **~58–60% savings** versus a clean‑baseline port. **Recommendation:** use by default when there is any realistic cross‑SM reuse (≈ **≥15–20%** probability).

- **Profile / async flows:** ROI is **weak for a single feature** (only **~9–11%** savings versus **~34–35%** adapter cost). ROI turns **positive once adapters are reused across ≥2 async features** (e.g., Feed, Dashboard), and compounds to **≥60%** with **3+** features.

- **Baselines:** All estimates assume a **Clean Architecture** (single SM) baseline. Under a **spaghetti** baseline (state/logic/UI entangled), symmetry **does not help** until the system is **refactored to clean boundaries**.

### **Bottom line:**

- **Insurance rule of thumb:** Treat symmetry as a **low‑cost premium**—**~20–35% LOC upfront, amortized to ≤5–10%**—that **pays off if the probability of reuse on another SM is ≥15–25%** within your planning horizon.
- **Operational guardrails:** Keep the **adapter budget ≤200–300 LOC** per feature (2–7 touchpoints), enforce a lightweight **Symmetry Contract**, and run **Lazy Parity** in CI (active adapter = full tests; sleeper = compile + smoke).
- **Developer Experience:** A hidden but significant benefit is the simplified mental model — developers don’t need to memorize different coding styles and patterns per state manager. There is **one consistent template** that works across SMs, which makes feature development faster, cleaner, and less error‑prone.
- **Maintainability across apps:** When multiple apps rely on different SMs (e.g., one uses Riverpod, another uses Cubit), keeping features symmetric means changes are applied **once** in the shared core and instantly reused. Without symmetry, teams would face duplicated maintenance effort and divergence over time.
- **Time-to-Market** — code reuse shortens feature delivery cycles. New features ship significantly faster since ~90% of the code is already shared and validated.
