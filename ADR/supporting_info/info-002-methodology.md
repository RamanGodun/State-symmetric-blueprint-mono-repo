# Business Value Costs Methodology

This document describes how we measure and interpret the cost of moving features between apps using Riverpod and Cubit, within the State-Symmetric Architecture framework.

---

## 📖 Glossary

- **SCSM (Shared Custom State Models) Track** — Features with **custom shared state models** (e.g., `SubmissionFlowStateModel`, `SignInFormState`, `SignUpFormState`). Includes: Sign-In, Sign-Up, Change Password, Reset Password.
- **AVLSM (AsyncValue-Like State Models) Track** — Features relying on **AsyncValue-like state models** for each SM (Riverpod's `AsyncValue<T>`, BLoC's `AsyncValueForBloc<T>`). Includes: Profile, Email Verification.
- **Round-Trip (RT)** — Sum of **RP→CB** and **CB→RP** migration efforts.
- **RT/2** — Average cost **per migration direction**: `(RP→CB + CB→RP) / 2`.
- **Overhead (OH)** — Adapter/seam LOC. Counted **once per track adoption**, then averaged per migration as `(OH_RP + OH_CB)/2` for reporting.
- **Change Surface (CS)** — Fraction (0–1) of a feature's code that must change during routine maintenance.
- **Lazy Parity** — Build the second SM's adapters **only when reuse is confirmed**, preventing speculative overhead.

---

## 1. Core Assumptions & ROI Formula

### ROI Planning Formula

```
Expected ROI ≈ R · I · F − OMI · F

Where:
  F   = feature cost (development effort)
  R   = reuse probability (within planning horizon)
  I   = impact (savings from reuse)
  OMI = overhead + maintenance + initial training
```

### Methodology Assumptions

1. **Visual UI parity: 95–100%** — Widgets/screens are visually identical across SMs
2. **Presentation parity: 90%+** — Remaining differences are thin adapter wrappers
3. **Lazy Parity in production** — Only one adapter compiled at a time; others in sleep mode (smoke/compile-check only). Test/CI overhead kept at ≤5%
4. **Thin adapters** — 2–5 touchpoints per feature (listeners, selectors, submit buttons, guards)
5. **Conservative estimates** — Baseline costs **exclude infrastructure** (theming, routing, i18n, animations). Only presentation layer + SM+INIT counted for migrations

### Why Round-Trip Averaging?

Migration costs are **asymmetric**: RP→CB ≠ CB→RP. Computing both directions captures the full cost range.

**Benefits:**

- Avoids double-counting — measures **average cost per migration direction**
- Same principle for overhead: `(OH_RP + OH_CB) / 2` yields averaged cost per migration
- Under Lazy Parity, typically only one seam is written, but round-trip average smooths this into a per-migration cost
- Makes cross-track comparisons consistent and directly interpretable for ROI analysis

---

## 2. Accounting Buckets (Counting Rules)

All feature code is split into **six buckets**. Every LOC belongs to **exactly one** bucket, enabling transparent baseline vs. symmetric comparisons.

| Bucket                            | Description                                                                 | Baseline     | Symmetric         | Notes                                                       |
| --------------------------------- | --------------------------------------------------------------------------- | ------------ | ----------------- | ----------------------------------------------------------- |
| **1. Infrastructure**             | Tooling, codegen, theming, overlays, i18n, routing, animations              | Ignored      | Ignored           | Team/style variance too high                                |
| **2. Reused Core**                | Domain/Data layers + stateless shared UI                                    | ✅ Reused    | ✅ Reused         | Always shared                                               |
| **3. SM+INIT**                    | Feature-local SM + initialization (DI bindings, provider creation, routing) | ⚠️ Rewritten | ⚠️ Rewritten      | State models themselves are reused                          |
| **4. State Models**               | Shared state models (live in packages)                                      | ⚠️ Rewritten | ✅ Reused         | Accounted separately from presentation                      |
| **5. Overhead (OH)**              | Thin adapters/facades bridging models to UI                                 | N/A          | ⚠️ One-time       | **AVLSM:** whole-track cost; **SCSM:** per-SM (Lazy Parity) |
| **6. Presentation (stateful UI)** | SM-dependent UI (selectors, builders, listeners, buttons, guards)           | ⚠️ Rewritten | ✅ Largely reused | Must rewrite in baseline                                    |

What files in which bucket are shown in **[info-004-files_buckets.md](info-004-files_buckets.md)**

**Feature size for % calculations:**

```
FEATURE_SIZE_TOTAL = Bucket_2 + Bucket_3 + Bucket_4 + Bucket_6
(Infrastructure and OH excluded)
```

---

## 3. Scenarios Compared

### Baseline (Clean Architecture, No Symmetry)

**What's reused:** Only **Reused Core** (domain/data + stateless shared UI)

**Per migration direction:**

```
ΔLOC_baseline = Presentation_full + State_Models + SM+INIT_target
OH = 0
```

---

### SCSM Track (Shared Custom State Models)

**What's reused:** Core + Presentation + custom shared state models

**Per migration direction:**

```
ΔLOC_symmetric = SM+INIT_target + OH_target_if_new
```

**Overhead:** Per-SM adapters (`OH_RP` + `OH_CB`), reported as average `(OH_RP + OH_CB)/2`

**When seam already exists:** `OH_target_if_new = 0` (Lazy Parity benefit)

---

### AVLSM Track (Shared Async State Models)

**What's reused:** Core + AsyncValue-like models + all Presentation

**Per migration direction:**

```
ΔLOC_symmetric = SM+INIT_target
```

**Overhead:** One-time for **whole track** (`AsyncValueForBloc<T>` + helpers + adapters for both SMs), reported separately as `(OH_RP + OH_CB)/2`

**Critical:** Overhead is **NOT included** in per-leg migration cost — it's a one-time track adoption cost, reported separately.

---

## 4. Calculation Algorithm (First Migration)

### Step 1: Baseline Cost (Per Direction)

Assumption: Each SM defines **its own** state models → models rewritten in all usage sites

```
ΔLOC_baseline_leg = Presentation_full_under_target_SM
                   + State_Models_rewrite
                   + SM+INIT_target
```

**Round-trip average:**

```
ROUND_TRIP_BASELINE_AVG = (ΔLOC_RP→CB + ΔLOC_CB→RP) / 2
```

---

### Step 2: Symmetric Cost (Per Direction)

**SCSM Track:**

```
ΔLOC_symmetric_leg = SM+INIT_target + OH_target_if_new

If seam exists: OH_target_if_new = 0
```

**AVLSM Track:**

```
ΔLOC_symmetric_leg = SM+INIT_target

OH counted separately (one-time for track)
```

**Round-trip average:**

```
ROUND_TRIP_SYMMETRIC_AVG = (ΔLOC_RP→CB + ΔLOC_CB→RP) / 2
```

---

### Step 3: Migration Savings

```
SAVINGS_migration = ROUND_TRIP_BASELINE_AVG − ROUND_TRIP_SYMMETRIC_AVG
```

---

### Step 4: Overhead Calculation (Averaged, No Amortization)

**Only adapters (Bucket 5) count as OH. SM+INIT (Bucket 3) is NOT overhead.**

**SCSM Track:**

```
OH_avg_per_leg = (OH_adapters_RP + OH_adapters_CB) / 2
```

**AVLSM Track:**

```
OH_avg_per_leg = (OH_AsyncValueForBloc_model
                 + OH_adapters_RP
                 + OH_adapters_CB) / 2
```

---

### Step 5: Overhead Ratio (First Feature)

```
OH_RATIO = OH_avg_per_leg / FEATURE_SIZE_TOTAL
```

**Interpretation:**

- **SCSM:** 148 / 2,838 = 5.2% (low overhead, thin adapters)
- **AVLSM:** 377 / 1,746 = 21.6% (high overhead, front-loaded infrastructure)

---

### Step 6: Optional — Full "Insurance" Benefit

For planning, include maintenance/testing savings:

```
MAINT_BENEFIT   = (CS_baseline − CS_symmetric) × N_changes × K_change
EXPECTED_PAYOUT = SAVINGS_migration + MAINT_BENEFIT
```

**Report both:**

- Migration-only savings (conservative)
- Migration + maintenance savings (realistic long-term)

---

## 5. Amortization: How Overhead Decreases with Scale

### Concept

As more features join a track and reuse the same adapters, **overhead amortizes**:

```
OH_effective = OH_total / N

Where:
  N = number of features sharing the same track infrastructure
```

**Key insight:** Overhead is paid **once** but benefits **N** features → per-feature cost drops linearly.

---

### Amortization Formula

```
OH_per_feature(N) = OH_total / N

Break-even_R*(N) = OH_per_feature(N) / Savings_per_feature
                 = (OH_total / N) / (Total_Savings / N_features_in_track)
```

**Simplifies to:**

```
Break-even_R*(N) = OH_total / (N × Savings_per_feature)
```

--

## 6. Reported Outputs

### Primary Metrics

1. **Round-Trip Average Costs** — For Baseline vs. each Symmetric track (SCSM, AVLSM)
2. **Savings** — `SAVINGS = ROUND_TRIP_BASELINE − ROUND_TRIP_SYMMETRIC`
3. **Overhead Ratio (First Feature)** — `OH_RATIO = OH_total / FEATURE_SIZE_TOTAL`
4. **Amortized Overhead** — Per-feature overhead at different N values
5. **Break-Even Probability** — Minimum reuse % for positive ROI at each N

### Interpretation Guidelines

- **SCSM Track:** Low overhead (5.2%), high savings (53.5%) → break-even at 9.8% (N=4)
- **AVLSM Track:** High overhead (21.6%), modest savings (16.8%) → break-even at 25.6% (N≥10)

---

## 7. Lifecycle Cost Model (Hours/Budget)

### Core Metrics

- **ΔLOC** — Lines changed in a migration (use RT/2 per bucket)
- **CS (Change Surface)** — Fraction of feature touched by changes (0–1)

### Development Effort

```
H_dev = Σ(ΔLOC_bucket_i × dev_rate_i)
```

**Reference rates** (hours per 100 LOC, tune per team):

| Bucket Type             | Rate (h/100 LOC) | Rationale                     |
| ----------------------- | ---------------- | ----------------------------- |
| SM+INIT                 | 2.0–3.5          | Wiring, minimal logic         |
| Presentation (stateful) | 3.0–5.0          | UI integration, state binding |
| Adapters/Seams (OH)     | 3.0–4.0          | Thin facades, careful design  |

---

### Test Coverage Cost

```
H_tests = Σ(ΔLOC_bucket_i × test_impact_factor_i)
```

| Bucket Type    | Test Factor (h/100 LOC) | Coverage | Notes                        |
| -------------- | ----------------------- | -------- | ---------------------------- |
| SM+INIT        | 0.8–1.2                 | 85–95%   | State transitions, DI wiring |
| Presentation   | 1.5–2.5                 | 70–85%   | Widget/integration, goldens  |
| Adapters/Seams | 1.0–1.8                 | 90–100%  | Validate symmetry contract   |

---

### Additional Components

```
H_e2e       = scenarios × platforms × (0.8–1.2 h)
H_CI_fixed  = 0.5–2.0 h per PR
H_review_PM = H_dev × (0.15–0.25)
```

### Total Budget

```
H_total = H_dev + H_tests + H_e2e + H_CI_fixed + H_review_PM
Cost    = H_total × blended_hourly_rate
```

---

## 8. Maintenance Tax Model

Ongoing cost after initial implementation:

```
Annual_Maintenance_Baseline  = N_changes × CS_baseline × K_change × hourly_rate
Annual_Maintenance_Symmetric = N_changes × CS_symmetric × K_change × hourly_rate
```

**Typical ranges:**

- `CS_baseline ≈ 0.4–0.6` (40-60% of feature touched per change)
- `CS_symmetric ≈ 0.1–0.2` (10-20% touched — shared layer + thin adapters)

**Example:**

```
Baseline:  10 changes/yr × 0.5 × 4h × $100 = $2,000/yr
Symmetric: 10 changes/yr × 0.15 × 4h × $100 = $600/yr

Annual Savings: $1,400 per feature
```

---

## 9. Insurance Model (Break-Even Analysis)

### Concept

State-Symmetric Architecture functions as **engineering insurance**:

- **Premium** — One-time overhead (adapters/seams)
- **Payout** — Savings when features are reused across state managers

### Premium (What We Pay)

**One-time overhead (averaged):**

```
OH_avg_LOC = (OH_RP + OH_CB) / 2
OH_hours   = OH_avg_LOC × (rate_OH + test_OH) / 100
```

**With N features on same track (adapters reused):**

```
OH_hours_effective = OH_hours / N
```

---

### Payout (What We Gain)

**Migration savings per feature (constant for track):**

```
Savings_per_feature = Total_Savings / N_features_in_track
```

**Maintenance savings over Y years:**

```
S_maint = (CS_baseline − CS_symmetric) × K_change × N_changes/yr × Y
```

**Total expected payout per feature:**

```
S_total_per_feature = Savings_per_feature + S_maint_per_feature
```

---

### Break-Even Probability (Canonical Formula)

Insurance is worth it if expected savings cover the amortized premium:

```
R* = OH_effective / Savings_per_feature

Where:
  R* = Break-even reuse probability (minimum % for positive ROI)
  OH_effective = OH_total / N  (amortized overhead per feature)
  Savings_per_feature = Total_Savings / N_features_in_track  (constant)
  N = number of features sharing the same adapters
```

**Key insight:** As N increases, `OH_effective` decreases linearly (`OH_total / N`), while `Savings_per_feature` stays constant → break-even probability drops proportionally.

---

### Compact Form (Percent of Track)

When normalizing to % of track (still RT/2):

```
R* = (OH_total / N) / Savings_per_feature
```

All values expressed as percentages of `FEATURE_SIZE_TOTAL`.

---

### Planning Helpers

**Required features for target break-even:**

```
N* = OH_total / (R_target × Savings_per_feature)
```

**Amortization tracking (recompute each sprint):**

```
effective_overhead = OH_total / current_feature_count
break_even_R       = effective_overhead / savings_per_feature
```

**Example (SCSM Track):**

```
OH_total = 148 LOC
Savings_per_feature = 379 LOC

At N=1:  R* = 148 / 379 = 39.1%
At N=4:  R* = 37 / 379 = 9.8%
At N=10: R* = 14.8 / 379 = 3.9%

Note: Maintenance costs for sleeping adapters are already reflected via CS_symmetric (and ≤5% test/CI overhead). Do not double-count a separate "annual premium".
```

---

## 11. Summary

This methodology provides empirical, reproducible measurements for State-Symmetric Architecture business value.

**Key principles:**

- ✅ Conservative estimates — Infrastructure costs excluded, baseline already assumes Clean Architecture
- ✅ Round-trip averaging — Captures asymmetric costs, avoids double-counting
- ✅ Transparent buckets — Every LOC accounted for in one of six categories
- ✅ Insurance model — Clear break-even thresholds based on measured overhead and savings
- ✅ Amortization tracking — Overhead decreases linearly with N, break-even drops proportionally
- ✅ Reproducible — Run `melos loc:report` in showcase monorepo to verify

**For results and detailed ROI analysis** open [`info-001-business-value-estimates.md`](info-001-business-value-estimates.md)
