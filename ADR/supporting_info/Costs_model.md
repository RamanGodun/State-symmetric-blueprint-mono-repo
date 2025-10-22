# State‑Symmetric Cost Algorithm (Round‑Trip, Concise)

This document describes how we measure and interpret the cost of moving a feature between apps that use Riverpod and Cubit, using the State‑Symmetric architecture style.

## 📖 Glossary

- **SCSM (Shared Custom State Models) Track**: Auth‑like features using custom state models (Sign‑In, Sign‑Up, Password flows).
- **AVLSM (AsyncValue‑Like State Models) Track**: Profile‑like features using native async primitives (Profile, Email Verification, Sign Out).
- **Round‑Trip**: Sum of RP→CB + CB→RP migrations, **then divided by two** to get an averaged cost per migration leg.
- **Overhead (OH)**: Adapter/seam LOC relative to total feature size. Measured as a one‑time cost for track adoption (averaged per migration as `(OH_RP + OH_CB)/2`).
- **Change Surface (CS)**: Fraction of codebase touched by typical maintenance changes (0–1).
- **Lazy Parity**: Strategy of building adapters for the 2nd SM only when reuse is confirmed, avoiding speculative overhead.

## Cost and ROI Model (realistic, observed)

- **Visible UI parity:** **95–100%** (widgets/screens are visually identical).
- **Presentation parity:** **~90%+** (remaining differences are thin wrappers).
- **Lazy Parity in production:** only one adapter is compiled; others remain in **sleep mode** (smoke/compile‑check only). Ongoing cost for tests and CI matrix is kept at **≤5%**.

Adapters are implemented as **thin seams** (2–7 touchpoints per feature):

**ROI Formula**

```
Expected ROI ≈ R · I · F − OMI · F
  F   = feature cost (effort)
  R   = reuse probability (within planning horizon)
  I   = impact (savings from reuse)
  OMI = overhead + maintenance + initial training
```

## 🔎 Scenarios Compared

### **Two tracks for State-Symmetric approach** are accepted:

- **Shared-Custom-State-Models (SCSM) Track** — relies on a shared state models (e.g. `SubmissionFlowStateModel`, `SignInFormState`, `SignUpFormState`, etc). Implemented in next features: Sign‑In, Sign‑Up, Change Password, Reset Password.

- **AsyncValue-Like-State-Models (AVLSM) Track** — relies on native async primitives per state manager (Riverpod’s `AsyncValue<T>`; `AsyncValueForBloc<T>`), and keep symmetry via thin adapters only — no cross-SM async facade. Implemented in Profile, Email Verification, Sign Out features.

**Therefore three scenarios are evaluated:**

### **Baseline (Clean Architecture, no symmetry)**

- Reuse only **Reused Core (Domain/Data layers)**.
- For each leg: rewrite full Presentation layer (except stateless shared UI) + INIT of target SM.
- OH = 0.

### **AsyncValue Track (Shared Async)**

- Reuse: Core + AsyncValue-like State model + all Presentation.
- For each leg: only target SM + its initialization and target adapters.
- Overhead = one‑time ([AsyncValueForBloC] state model + SM-based adapters) => counted once, then divided by two.

### **Custom Models Track (Shared Custom)**

- Reuse: Core + all Presentation + custom shared models.
- For each leg: target SM+INIT + OH_target
- Overhead: OH_RP (only adapters) + OH_CB (only adapters), then divided by two.

**NOTES**

1. All results are **CONSERVATIVE**: the baseline _Clean Architecture_ also needs infra codebase, but those LOC are **not** counted due to team/style variance. Within Baseline track the migration to another SM-based app it was counted only presentation layer + INIT/wiring of SM.
2. Costs always computed as a **round‑trip average** (ROUND_TRIP_AVG = (Cost_RP→CB + Cost_CB→RP) / 2)

### 🎯 Why use Round‑Trip?

Migration costs are **asymmetric**: RP→CB ≠ CB→RP. By computing both directions we capture the full range of costs. To obtain a **statistically balanced, weighted average**, we then **divide the sum by two**. This reflects real projects where features may need to be reused in either direction.

_This way_:

- We avoid double‑counting and instead **measure the average cost of one migration leg**.
- The same principle applies to **overhead**: we add `OH` for both legs, then divide by two to yield an averaged overhead cost. This reflects the practical case where, under Lazy Parity, only one seam is typically written, but our round‑trip average smooths it into a per‑migration cost.

> This makes comparisons across tracks consistent and directly interpretable for ROI analysis.

## 📦 Buckets (Counting Rules)

We split all feature codebase into **five distinct buckets**. This makes migration costs transparent and allows us to separately measure **overhead and migrations costs to target state-manager**.

1. **Infrastructure (ignored, not evaluated):**
   Infrastructure code is not included in migration cost models (low‑level build/CI tooling, codegen, configs, theming, error/overlay modules, localization, routing, animations, etc.).

2. **Reused Core:**
   Always reused: Domain/Data layers and stateless shared UI (pure presentation widgets with no SM coupling).

3. **State-Manager + Init (SM+INIT):**
   Feature‑local SM code (Cubit, Notifier, Provider, BLoC) **plus** its initialization (DI bindings, provider creation, route wiring). Models are reused, but the SM wiring must be implemented.

4. **State models**
   As reused state models are in shared packages, therefore they counted separately and added into Presentation layer.

5. **Overhead (OH):**
   Thin adapters/facades bridging the shared state models with the chosen SM and shared UI (for AVLSM shared OH for the entire track counted one-time, for SCSM track - OH is per-SM, in round-trip we sum OH_RP + OH_CB, then divide by two for averaged cost).

6. **Presentation layer (Stateful UI):**
   SM-dependent parts of the presentation layer (selectors, builders, side-effect listeners, form submit buttons, footer guards). Must be rewritten in baseline migrations; mostly reused in symmetric migrations.

> Every LOC must map to exactly one bucket. This ensures clarity in calculating baseline vs symmetric costs and allows us to compare **SM+INIT vs OH** contributions separately.

## 📊 Outputs Reported

1. **Round‑Trip Average Costs**: for Baseline track vs every of State-Symmetric tracks (AVLSM and CSM).
2. **Savings:** for Baseline track vs every of State-Symmetric tracks (`SAVINGS = ROUND_TRIP_BASELINE − ROUND_TRIP_SYM`).
3. **Overhead ratio:** (OH_RATIO = (OH_RP + OH_CB) / 2 / FEATURE_SIZE_TOTAL)
4. **Amortized view:** Recompute with OH=0 to show steady‑state cost after overhead is paid.

---

## ⏱ Lifecycle Cost Model (Hours/Budget)

Convert LOC to hours and cost using per‑bucket rates.

**Core metrics**

- **ΔLOC**: lines changed in a migration (**use RT/2 per bucket**).
- **CS (Change Surface)**: fraction of the feature touched by changes (0–1).

**Development effort**

```
H_dev = Σ(ΔLOC_bucket_i × dev_rate_i)
```

**Reference dev rates** (hours per 100 LOC, tune per team)

| Bucket Type             | Rate (h/100 LOC) | Rationale                     |
| ----------------------- | ---------------- | ----------------------------- |
| SM+INIT                 | 2.0–3.5          | Wiring, minimal logic         |
| Presentation (stateful) | 3.0–5.0          | UI integration, state binding |
| Adapters/Seams (OH)     | 3.0–4.0          | Thin facades, careful design  |

**Test coverage cost**

```
H_tests = Σ(ΔLOC_bucket_i × test_impact_factor_i)
```

| Bucket Type    | Test Factor (h/100 LOC) | Coverage | Notes                                 |
| -------------- | ----------------------- | -------- | ------------------------------------- |
| SM+INIT        | +0.8–1.2                | 85–95%   | State transitions, DI wiring          |
| Presentation   | +1.5–2.5                | 70–85%   | Widget/integration, goldens           |
| Adapters/Seams | +1.0–1.8                | 90–100%  | Validate symmetry contract across SMs |

**Additional components**

```
H_e2e       = scenarios × platforms × (0.8–1.2 h)
H_CI_fixed  = 0.5–2.0 h per PR
H_review_PM = H_dev × (0.15–0.25)
```

**Totals & budget**

```
H_total = H_dev + H_tests + H_e2e + H_CI_fixed + H_review_PM
Cost    = H_total × blended_hourly_rate
```

---

## 🔄 Maintenance Tax Model

Ongoing cost after initial implementation:

```
Annual_Maintenance_Baseline  = N_changes × CS_baseline × K_change × hourly_rate
Annual_Maintenance_Symmetric = N_changes × CS_symmetric × K_change × hourly_rate
```

Typical ranges: `CS_baseline ≈ 0.4–0.6`, `CS_symmetric ≈ 0.1–0.2`.

**Example**

```
Baseline:  10 changes/yr × 0.5 × 4h × $100 = $2,000/yr
Symmetric: 10 changes/yr × 0.15 × 4h × $100 = $600/yr
Annual Savings: $1,400 per feature
```

---

## 🛡️ Insurance Model (Break‑Even)

**Concept.** State‑Symmetric acts like insurance. You pay a **premium** (the one‑time OH) and get a **payout** (savings) if a “claim” happens — i.e., when a feature must be ported to the other SM.

All quantities are expressed in **RT/2 units** to avoid double counting.

### Premium (what we pay)

- **One‑time OH (averaged):**

  ```
  OH_avg_LOC = (OH_RP + OH_CB) / 2
  OH_hours   = OH_avg_LOC × (rate_OH + test_OH) / 100
  ```

- In planning with **N** features on the same track (adapters reused):

  ```
  OH_hours_effective = OH_hours / N
  ```

### Payout (what we gain when reuse happens)

- **Migration savings per event (hours):**

  ```
  S_mig = Σ_b (RT_BASE_b − RT_SYM_b) × (rate_b + test_b) / 100
  ```

- **Maintenance savings over Y years (hours):**

  ```
  S_maint = (CS_baseline − CS_symmetric) × K_change × N_changes_per_year × Y
  ```

- **Total expected payout per event:**

  ```
  S_total = S_mig + S_maint
  ```

### Break‑even probability (per feature)

The insurance is worth it if expected savings cover the premium:

```
R* = OH_hours_effective / S_total
```

Where **R\*** is the **minimum reuse probability** at which symmetry is justified. In steady‑state (OH already paid), set `OH_hours_effective = 0`.

### Equivalent compact form (percent of track)

When normalizing to % of track (still RT/2):

```
R* = o / (p_clean − a)
```

Where `o` is overhead as % of track, `p_clean` is Baseline migration cost % of track, and `a` is symmetric migration cost % of track.

### Planning helpers

- **Target probability to features:**

  ```
  N* = OH_hours / (R_target × S_total)
  ```

- **Amortization effect:** Larger N ↓ lowers `R*` linearly (`OH/N`). Recompute each sprint:

  ```
  effective_overhead = overhead_paid / features_using_it
  break_even_R       = effective_overhead / migration_savings
  ```

> Maintenance costs for sleeping adapters are already reflected via `CS_symmetric` (and ≤5% test/CI overhead); do **not** double‑count a separate “annual premium”.

---

## Summary

- Use **RT/2** for all migration and OH numbers (balanced mean per leg).
- Treat **OH** as a **one‑time premium**; amortize across features on the same track.
- Break‑even comes from **probability vs savings**: `R* = OH_effective / (S_mig + S_maint)`.
- In steady‑state (OH paid), symmetry’s case strengthens further (R\* → 0).

**Actual values will be filled after running corrected loc_report.sh script.**, and only then uncomment and correct text bellow!

<!-- ### 📈 Business Value (Latest Measurements)

Source: melos loc:report
Last updated: [TO BE FILLED]
All values averaged per migration (RoundTrip/2) and normalized to % of track codebase.


**SCSM Track (Shared Custom State Models)**
Features: Sign-In, Sign-Up, Change Password, Reset Password
Scenario: RP→CB + CB→RPAvg (RT/2)% of TrackBaseline[TBF][TBF][TBF][TBF]Symmetric[TBF][TBF][TBF][TBF]
Savings: [TBF] LOC ([TBF]%)
Overhead (1st feature): [TBF] LOC ([TBF]%)

**AVLSM Track (AsyncValue-Like State Models)**
Features: Profile, Email Verification, Sign Out
Scenario: RP→CB + CB→RPAvg (RT/2)% of TrackBaseline[TBF][TBF][TBF][TBF]Symmetric[TBF][TBF][TBF][TBF]
Savings: [TBF] LOC ([TBF]%)
Overhead (1st feature): [TBF] LOC ([TBF]%) -->

<!-- ### 📌 Interpretation Guidelines

**SCSM Track expectations:**

Overhead: 15–25% for first feature
Savings: 40–60% per migration
Break-even: ~3–5 features or ≥20–35% reuse probability

**AVLSM Track expectations:**

Overhead: 25–35% for first feature
Savings: 20–30% per migration
Break-even: ~5–8 features or ≥26–43% reuse probability -->

<!-- ### 📝 Implementation Notes

Lazy Parity: Build seams only when needed for 2nd SM → delays overhead cost until reuse is confirmed.
AVLSM track: After initial OH, migration legs = SM+INIT only (minimal touch).
SCSM track: Each new SM requires its seam once, then reused across similar features.
Test strategy: Full coverage for active SM; smoke/compile checks for sleeping adapter (≤5% ongoing cost). -->

<!-- ### Practical guidance

- **Adopt CSM symmetry selectively** — when the roadmap indicates **multiple Auth‑like sub‑features** (sign‑in/up, password, 2FA, etc.) across apps/SMs. Target **3–5 features on the track** to cross break‑even comfortably.
- **Adopt AVSM symmetry only when a stream of async features is planned** (Profile, Feed, Dashboard, Settings, etc.) and you can **reuse the same AsyncValue seams** across them (aim **5+ features**).
- **Track real amortization**: keep a tiny table per track — `overhead_paid`, `features_using_it`, `effective_overhead = overhead_paid / features_using_it` — and recompute the break‑even every sprint.
- **Keep the adapter scope tight** (2–7 touchpoints) to minimize `o` and push break‑even left. -->

<!-- - **CSM track** pays off when the **same symmetric seams** are expected to be reused across **≥3–5 features** _or_ when reuse probability per feature is **≥20–35%**.
- **AVSM track** needs **more reuse** to break even—expect **≥5–8 features** on that track _or_ reuse probability **≥26–43%** per feature.

> These are conservative: if future features are larger than the first one, or if a part of the overhead is shared with other tracks (e.g., shared widgets), break‑even shifts lower.


- With the **latest measurements**, symmetry **reduces per‑migration cost** by ~**19% (CSM)** and ~**30% (AVSM)**, but the **one‑time overhead** per track (**9% / 16%**) means you should **only pay the premium if you’ll reuse it**.
- **Break‑even (amortized):**
  - **CSM:** reuse probability per feature **≥20–35%** (or **≥3–5 features** on the same track).
  - **AVSM:** reuse probability per feature **≥26–43%** (or **≥5–8 features** on the same track). -->

- If those conditions hold, the **State‑Symmetric “insurance”** is worth it; otherwise, stick to clean single‑SM implementation for that track.
