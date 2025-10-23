# Business value Costs Methdology

This document describes how we measure and interpret the cost of moving a feature between apps that use Riverpod and Cubit, using the State‑Symmetric architecture style.

## 📖 Glossary

- **SCSM (Shared Custom State Models) Track** — Pack of features with **custom shared models** (e.g., `SubmissionFlowStateModel`, `SignInFormState`, `SignUpFormState`, etc.). Consist of Sign‑In, Sign‑Up, Change Password, Reset Password features.
- **AVLSM (AsyncValue‑Like State Models) Track** — includes features that rely on **AsyncValue-like state models** of each SM (Riverpod’s `AsyncValue<T>`, BLoC’s `AsyncValueForBloc<T>`). Consist of Profile and Email Verification features.
- **Round‑Trip (RT)** — Sum of **RP→CB** and **CB→RP** migration efforts.
- **RT/2** — Average cost **per migration leg**: `(RP→CB + CB→RP) / 2`.
- **Overhead (OH)** — Adapter/seam LOC. Counted **once per track adoption**, then averaged per migration as `(OH_RP + OH_CB)/2` for reporting.
- **Change Surface (CS)** — Fraction (0–1) of a feature’s code that must change during routine maintenance.
- **Lazy Parity** — Build the second SM’s adapters **only when reuse is confirmed**, preventing speculative OH.

## Assumptions and ROI formula

**ROI (planning) formula:**

```
Expected ROI ≈ R · I · F − OMI · F
  F   = feature cost (effort)
  R   = reuse probability (within planning horizon)
  I   = impact (savings from reuse)
  OMI = overhead + maintenance + initial training
```

**Within methodology it was accepted next**:

- **Visible UI parity: is ~ 95–100%** (widgets/screens are visually identical).
- **Presentation parity is 90%+** (remaining differences are thin wrappers).
- **Lazy Parity in production:** only one adapter is compiled; others remain in sleep mode (smoke/compile‑check only). Ongoing cost for tests and CI matrix is kept at ≤5%.
- **Adapters are implemented as thin seams** (2–5 touchpoints per feature).
- All **results are CONSERVATIVE**: the baseline for estimations (feature on Clean Architecture) also needs infra codebase, but evaluated **LOC are not counted** due to team/style variance. Within Baseline track the migration to another SM-based app it was counted only presentation layer + INIT/wiring of SM.

2. Costs always computed as a **round‑trip average** (ROUND_TRIP_AVG = (Cost_RP→CB + Cost_CB→RP) / 2)

### 🎯 Why use Round‑Trip?

Migration costs are **asymmetric**: RP→CB ≠ CB→RP. By computing both directions we capture the full range of costs. To obtain a **statistically balanced, weighted average**, we then **divide the sum by two**. This reflects real projects where features may need to be reused in either direction.

_This way_:

- We avoid double‑counting and instead **measure the average cost of one migration leg**.
- The same principle applies to **overhead**: we add `OH` for both legs, then divide by two to yield an averaged overhead cost. This reflects the practical case where, under Lazy Parity, only one seam is typically written, but our round‑trip average smooths it into a per‑migration cost.
  > This makes comparisons across tracks consistent and directly interpretable for ROI analysis.

## 📦 Buckets (Counting Rules)

We split all feature code into **six buckets**. Every LOC belongs to **exactly one** bucket. This enables transparent baseline vs. symmetric comparisons and isolates **SM+INIT vs. OH**.

1. **Infrastructure (ignored)** — Tooling, codegen, configs, theming, error/overlay modules, i18n, routing, animations, etc.
2. **Reused Core** — Always reused: Domain/Data layers and **stateless shared UI** (pure, SM‑agnostic widgets).
3. **State‑Manager + Init (SM+INIT)** — Feature‑local Cubit/Bloc/Notifier/Provider **and** its initialization (DI bindings, provider creation, route wiring). Models themselves are reused.
4. **State Models** — Shared state models used by the feature (live in shared packages). Accounted **separately** from presentation because they may be reused across SMs.
5. **Overhead (OH)** — Thin adapters/facades that bridge shared models with a concrete SM and shared UI:
   - **AVLSM:** one‑time OH for the **whole track** (e.g., `AsyncValueForBloc` + adapters); averaged as `(OH_RP + OH_CB)/2`.
   - **SCSM:** OH is **per‑SM** (Lazy Parity). In a round‑trip we add OH for both legs and divide by two.
6. **Presentation (stateful UI)** — SM‑dependent parts (selectors, builders, side‑effects listeners, submit buttons, footer guards). Must be **rewritten** in baseline; largely **reused** in symmetric.

> **Feature size for % calculations:** `FEATURE_SIZE_TOTAL = 2 + 3 + 4 + 6` (Infrastructure and OH excluded).

## 🔎 Scenarios Compared

### Baseline (Clean Architecture, no symmetry)

- Reuse only **Reused Core**.
- For each leg: rewrite **Presentation** (except stateless shared UI) **+ SM+INIT** for the target SM.
- `OH = 0`.

### AVLSM Track (Shared Async)

- Reuse: **Core + AsyncValue‑like models + all Presentation**.
- For each leg: (Overhead / 2) + **SM+INIT**.
- Overhead counted **once** for both apps (e.g., `AsyncValueForBloc` + helpers + adapters), then **averaged** per migration.

### SCSM Track (Shared Custom Models)

- Reuse: **Core + Presentation + custom shared models**.
- For each leg: implement **target SM+INIT + OH_target**.
- Overhead per SM: `OH_RP` (adapters on Riverpod side) and `OH_CB` (adapters on Cubit side); report average `(OH_RP + OH_CB)/2`.

## ✅ Calculation Algorithm (First Migration, RT/2)

### 0) Buckets

See the six buckets above. **Percent of track** is always computed relative to `FEATURE_SIZE_TOTAL = 2 + 3 + 4 + 6`.

### 1) Baseline (per leg)

Assumption: each SM defines **its own** state models; therefore **state models are rewritten** in all places of use.

For a single leg:

```
ΔLOC_base_leg = Presentation_full_under_target_SM
               + State_Models_rewrite
               + SM+INIT_target
```

Round‑trip averaging (balanced, no double count):

```
ROUND_TRIP_BASE_AVG = (ΔLOC_base_RP→CB + ΔLOC_base_CB→RP) / 2
```

### 2) State‑Symmetric (per leg)

**SCSM track:**

```
ΔLOC_sym_leg = SM+INIT_target (bucket 3)
             + OH_target_if_new (bucket 5)
```

If the seam already exists → `OH_target_if_new = 0`.

Average across legs:

```
ROUND_TRIP_SYM_AVG = (ΔLOC_sym_RP→CB + ΔLOC_sym_CB→RP) / 2
```

**AVLSM track:**

- `OH_target_if_new` is a **one‑time** cost: `AsyncValueForBloc` + all adapters/helpers + **SM+INIT**.
- To report an **averaged** OH for the first migration, divide the one‑time OH by 2:

```
OH_avg_per_leg = (OH_RP + OH_CB) / 2    # for reporting
```

Each migration leg then includes **only** `SM+INIT_target` (bucket 3).

### 3) Migration Savings (no amortization)

```
SAVINGS_migration = ROUND_TRIP_BASE_AVG − ROUND_TRIP_SYM_AVG
```

### 4) Overhead for the First Migration (averaged, no amortization)

Only **adapters** (bucket 5) are OH. **SM+INIT (bucket 3) is not OH**.

- **AVLSM:**

```
OH_avg_per_leg = (OH_AsyncValueForBloc_state_model
                 + OH_adapters_RP
                 + OH_adapters_CB) / 2
```

- **SCSM:**

```
OH_avg_per_leg = (OH_adapters_RP + OH_adapters_CB) / 2
```

### 5) OH Ratio vs Feature Size

```
OH_RATIO = OH_avg_per_leg / FEATURE_SIZE_TOTAL
```

### 6) Optional: Full “Insurance” Benefit

For planning, add maintenance/testing savings:

```
MAINT_BENEFIT   ≈ (CS_baseline − CS_symmetric) × N_changes × K_change
EXPECTED_PAYOUT = SAVINGS_migration + MAINT_BENEFIT
```

Report both **migration‑only** and **migration+maintenance** scenarios in early iterations.

### 📊 Outputs Reported

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

**Concept.** State‑Symmetric acts like insurance. You pay a **premium** (the one‑time OH) and get a **payout** (savings) if a “claim” happens — i.e., when a feature must be migrated to the app on another SM.

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

This

- If those conditions hold, the **State‑Symmetric “insurance”** is worth it; otherwise, stick to clean single‑SM implementation for that track.
