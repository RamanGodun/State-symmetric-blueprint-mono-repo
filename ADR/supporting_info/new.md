# State‑Symmetric Cost Algorithm (Round‑Trip, Concise)

This note fixes **what and how we count** when estimating the cost of moving a feature between apps that use **Riverpod** and **Cubit**.

**Why Round‑Trip?**

We use round‑trip (RP→CB + CB→RP) because migration costs are asymmetric: moving from Riverpod to Cubit is not identical to Cubit→Riverpod. By summing both legs we get a more balanced, averaged estimate of the true long‑term maintenance cost. This reflects real projects where features may need to be reused in either direction.

---

## Buckets (single source of truth for counting)

1. **Overhead (OH)**
   Thin seams/facades/adapters that bridge the state manager (SM) with shared state models.
   - **AsyncValue track:** **one‑time, shared** OH for the whole track (AsyncStateView<T> + RP/CB adapters). In a round‑trip it is counted **once**.
   - **Custom track:** OH is **per SM**. In a round‑trip we sum **OH_RP + OH_CB**.

2. **Reused Core**
   Always reused in any scenario: **Domain/Data** layers and **stateless shared UI** (pure presentational widgets with no SM coupling).

3. **State‑Manager + Init (SM+INIT)**
   Feature‑local SM files (Cubit / Notifier / Providers) **plus** minimal bootstrapping to wire them (DI/route/provider creation at the feature boundary).

> Everything in a feature must be mapped to exactly one bucket.

---

## Scenarios we compare (always as a **round‑trip**)

We compute costs for **both directions** to reflect real maintenance (RP→CB and back CB→RP).

### A) Baseline (Clean Architecture, no symmetry)

- Reuse only **Reused Core**.
- For each leg you **rewrite the full Presentation layer** (excluding stateless shared UI) under the target SM + do INIT.
- OH = 0 by definition.

**Formulas:**
`BASE_MIGRATION = P_full_under_target_SM + INIT_target`
`ROUND_TRIP_BASE = BASE_MIGRATION(RP→CB) + BASE_MIGRATION(CB→RP)`

### B) AsyncValue State‑Model Track (Shared Async)

- Reuse: **Reused Core + Shared async model (AsyncStateView<T>) + all Presentation**.
- For each leg you only write **SM+INIT**.
- **OH_async is one‑time** for the whole track (counted once across the round‑trip).

**Formulas:**
`SYM_MIGRATION = SM_files_target + INIT_target`
`ROUND_TRIP_ASYNC = OH_async_once + SYM_MIGRATION(RP→CB) + SYM_MIGRATION(CB→RP)`

### C) Custom State‑Models Track (Shared Custom)

- Reuse: **Reused Core + all Presentation + shared custom models (e.g., SubmissionFlowState, FormStates)**.
- For each leg you write **SM+INIT**, **and** pay the seam for that SM **if it’s not yet built (Lazy Parity)**.

**Formulas:**
`SYM_MIGRATION = SM_files_target + INIT_target + OH_target_if_new`
`ROUND_TRIP_CUSTOM = (OH_CB_if_new + SM_CB + INIT_CB) + (OH_RP_if_new + SM_RP + INIT_RP)`

---

## What goes into each symbol (implementation rules)

- `P_full_under_target_SM` — all Presentation code that is **not** stateless shared UI (forms/screens bound to SM, submit buttons, side‑effects listeners, footer guards, selectors/builders, etc.).
- `SM_files_target` — minimal Cubit/Notifier/Provider files that connect the shared state models to the target SM.
- `INIT_target` — per‑feature DI/route/provider wiring needed to activate the feature in the target app.
- `OH_async_once` — AsyncStateView<T> + error mapping + both RP/CB adapters (count once per track).
- `OH_target_if_new` — thin seam for **that** SM in the Custom track; 0 if already built.

---

## Outputs to report (per track)

1. `ROUND_TRIP_BASE` vs `ROUND_TRIP_ASYNC` / `ROUND_TRIP_CUSTOM`
2. `SAVINGS = ROUND_TRIP_BASE − ROUND_TRIP_SYM` and `%SAVINGS`
3. **Overhead ratio** (first adoption):
   `OH_RATIO = OH_paid_in_round_trip / FEATURE_SIZE_TOTAL`
   where `FEATURE_SIZE_TOTAL` includes **all buckets** (Core + Presentation + SM+INIT) for context.
4. **Amortized view** (OH already paid): recompute `ROUND_TRIP_SYM` with `OH=0` to show steady‑state cost for subsequent migrations.

---

## Track membership (what we aggregate)

- **Custom track:** Sign‑In, Sign‑Up, Change Password, Reset Password.
- **Async track:** Profile + Email Verification + Sign Out.

> We aggregate per‑subfeature and then roll up to the track to get round‑trip numbers and ratios.

---

## Lifecycle cost model (hours/$$)

Use to convert counting into time and budget.

- **ΔLOC** — lines that actually change in a migration.
- **CS (Change Surface)** — fraction of the feature touched by the change (0..1).

**Hours estimate**
`H_dev = Σ( ΔLOC_bucket_i × rate_i )`
`H_tests = Σ( ΔLOC_bucket_i × tif_i )`
`H_total = H_dev + H_tests + H_e2e + H_CI_fixed + overhead_review_PM%`

Guideline multipliers (tune per team):

- Rates (dev hours per 100 LOC):
  - SM+INIT: **2.0–3.5 h**
  - Presentation (stateful/glue): **3.0–5.0 h**
  - Seams/Bridges: **3.0–4.0 h**

- Test Impact (extra hours per 100 LOC):
  - SM+INIT: **+0.8–1.2 h**
  - Presentation: **+1.5–2.5 h**
  - Seams: **+1.0–1.8 h**

- E2E: `H_e2e ≈ scenarios × platforms × 0.8–1.2 h`
- Review/PM: **+15–25%** of `H_dev`
- CI fixed per PR: \*\*0.5–2.0 h`

**Money**
`Cost = H_total × blended_rate`

**Maintenance tail (future updates)**
`Tax_baseline ≈ N × (CS_baseline × K_change)`
`Tax_symmetric ≈ N × (CS_symmetric × K_change)`

> In symmetric tracks `CS` is smaller (mostly SM files / seams), so long‑term change tax is lower.

---

## Notes

- **Lazy Parity:** we build seams only when we need the 2nd SM; until then OH is only specific for SM.
- **Async track migration:** after the one‑time OH, **a migration leg writes only SM+INIT**.
- **Custom track migration:** a leg writes **SM+INIT** and pays the **missing seam** for that target SM (if not yet present).

# 📈 Business Value Estimates (updated)

_A pragmatic summary of the **State‑Symmetric** approach using the latest measurements from the showcase repo._

> **Source:** `melos loc:report` (current run). All per‑migration costs are reported as **RoundTrip/2** and as **% of track codebase**.

---

## 1) Fresh results at a glance

### CSM Track (Custom State Models)

| Bucket           | RP→CB | CB→RP | RoundTrip/2 |    %Track |
| ---------------- | ----: | ----: | ----------: | --------: |
| Baseline (Clean) | 1 979 | 1 890 |   **1 935** | **46.2%** |
| Symmetric        | 1 541 | 1 582 |   **1 562** | **37.3%** |

| Bucket                      |     LOC |   %Track |
| --------------------------- | ------: | -------: |
| **SAVINGS (per migration)** | **373** | **8.9%** |

**One‑time overhead (first adoption):** 379 LOC (**9.0% of track**)

---

### AVSM Track (AsyncValue + EmailV + SignOut)

| Bucket           | RP→CB | CB→RP | RoundTrip/2 |    %Track |
| ---------------- | ----: | ----: | ----------: | --------: |
| Baseline (Clean) | 1 733 | 1 665 |   **1 699** | **42.3%** |
| Symmetric        |   779 |   943 |   **1 190** | **29.7%** |

| Bucket                      |     LOC |    %Track |
| --------------------------- | ------: | --------: |
| **SAVINGS (per migration)** | **509** | **12.7%** |

**One‑time overhead (first adoption):** 657 LOC (**16.4% of track**)

---

## 2) What the new numbers mean

- **Observed reduction vs baseline (per migration):**
  - **CSM:** (1 935 → 1 562) ≈ **−19%** cost
  - **AVSM:** (1 699 → 1 190) ≈ **−30%** cost

- **Overhead vs Savings (single feature):**
  - **CSM:** saves **8.9%** per migration, but asks **9.0%** overhead upfront.
  - **AVSM:** saves **12.7%** per migration, overhead **16.4%**.

**Implication:** treating symmetry as an **insurance** for a _single_ feature is **not** immediately profitable under these measurements. It becomes compelling when the **one‑time overhead is amortized across multiple features** in the same track.

---

## 3) "Insurance" break‑even — when is it worth paying?

We use the same rule of thumb:

```
Break-even probability of reuse (R) ≥ o / (p_clean − a)

where
  o        = one‑time overhead as % of track
  p_clean  = baseline per‑migration cost as % of track
  a        = symmetric per‑migration cost as % of track
```

### Direct (no amortization, N = 1 feature)

- **CSM:** o = 9.0%, p_clean − a = 46.2% − 37.3% = **8.9%** →
  - **R ≥ 9.0 / 8.9 ≈ 101%** (not feasible)

- **AVSM:** o = 16.4%, p_clean − a = 42.3% − 29.7% = **12.6%** →
  - **R ≥ 16.4 / 12.6 ≈ 130%** (not feasible)

👉 Conclusion: **Don’t pay the premium for a single feature** unless there is some other forcing function (org consistency, multi‑app parity commitment, etc.).

### Amortized overhead across N features in the same track

If the same track seams are reused, the effective overhead per feature is **o/N**. Break‑even becomes:

```
R ≥ (o / N) / (p_clean − a)
```

**CSM (o = 9.0%, Δ = 8.9%)**

| N features |  o/N | R ≥ (o/N)/Δ |
| ---------: | ---: | ----------: |
|          2 | 4.5% |   **50.6%** |
|          3 | 3.0% |   **33.7%** |
|          5 | 1.8% |   **20.2%** |
|          8 | 1.1% |   **12.7%** |

**AVSM (o = 16.4%, Δ = 12.6%)**

| N features |  o/N | R ≥ (o/N)/Δ |
| ---------: | ---: | ----------: |
|          2 | 8.2% |   **65.1%** |
|          3 | 5.5% |   **43.4%** |
|          5 | 3.3% |   **26.0%** |
|          8 | 2.1% |   **16.3%** |

**Interpretation:**

- **CSM track** pays off when the **same symmetric seams** are expected to be reused across **≥3–5 features** _or_ when reuse probability per feature is **≥20–35%**.
- **AVSM track** needs **more reuse** to break even—expect **≥5–8 features** on that track _or_ reuse probability **≥26–43%** per feature.

> These are conservative: if future features are larger than the first one, or if a part of the overhead is shared with other tracks (e.g., shared widgets), break‑even shifts lower.

---

## 4) Practical guidance

- **Adopt CSM symmetry selectively** — when the roadmap indicates **multiple Auth‑like sub‑features** (sign‑in/up, password, 2FA, etc.) across apps/SMs. Target **3–5 features on the track** to cross break‑even comfortably.
- **Adopt AVSM symmetry only when a stream of async features is planned** (Profile, Feed, Dashboard, Settings, etc.) and you can **reuse the same AsyncValue seams** across them (aim **5+ features**).
- **Track real amortization**: keep a tiny table per track — `overhead_paid`, `features_using_it`, `effective_overhead = overhead_paid / features_using_it` — and recompute the break‑even every sprint.
- **Keep the adapter scope tight** (2–7 touchpoints) to minimize `o` and push break‑even left.

---

## 5) What stays the same (principles)

- **Visible UI parity:** 95–100% (screens/widgets look the same)
- **Presentation parity:** ~85–90% (thin wrappers remain)
- **Lazy Parity in prod:** one adapter active; the other is smoke/compile‑checked → on‑going cost kept ≤5%.

---

## 6) TL;DR

- With the **latest measurements**, symmetry **reduces per‑migration cost** by ~**19% (CSM)** and ~**30% (AVSM)**, but the **one‑time overhead** per track (**9% / 16%**) means you should **only pay the premium if you’ll reuse it**.
- **Break‑even (amortized):**
  - **CSM:** reuse probability per feature **≥20–35%** (or **≥3–5 features** on the same track).
  - **AVSM:** reuse probability per feature **≥26–43%** (or **≥5–8 features** on the same track).

- If those conditions hold, the **State‑Symmetric “insurance”** is worth it; otherwise, stick to clean single‑SM implementation for that track.
