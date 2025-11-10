# 📈 Business Value Estimates — State-Symmetric Architecture

**TL;DR.** Empirical measurements from a production-grade Flutter monorepo show that State-Symmetric Architecture delivers **53.5% migration savings** for form-based features (SCSM Track) with only **5.2% overhead** — reaching break-even at **9.8% reuse probability**. For async data features (AVLSM Track), savings are **16.8%** with **21.6% overhead**, becoming viable at **≥10 features** (**25.6%** break-even). This document presents measured ROI thresholds that determine when symmetry becomes economically justified.

---

## 📋 Document Purpose & Scope

This analysis provides empirical business value measurements for the State-Symmetric Architecture (SSA), based on real LOC counts from the showcase monorepo.

**What's inside this document:**

- Measured migration costs and savings (Symmetric vs Baseline on just Clean Architecture)
- Break-even thresholds for different feature types
- Amortization trajectories for both tracks
- Design guardrails to prevent over-engineering

---

## 1. Understanding Feature "Tracks"

A **track** represents a group of features that share the **same state-symmetry infrastructure** — common adapters, state models, and UI seams that can be reused across multiple features.

**Economic principle:** Infrastructure overhead is paid **once per track**, then amortized across all features that use it.

### Two Track Types in This Monorepo

#### 🏆 **SCSM Track (Shared Custom State Models)**

**What it is:** Features with **form inputs and submission flows**

**Shared infrastructure:**

- **State models:**
  - `SubmissionFlowStateModel` — manages submit button states (idle/loading/success/error)
  - Input field state models (`SignInFormState`, `SignUpFormState`, etc.)

- **Adapters:** Thin seams (2–5 touchpoints) that connect these models to stateless UI widgets
- **Pattern:** Multi-step forms, authentication flows, any feature with "fill form → submit → handle response"

**Example features:**

- Sign-In (email/password inputs + submit)
- Sign-Up (username/email/password inputs + submit)
- Change Password (old/new password inputs + submit)
- Reset Password (email input + submit)

**Why it's reusable:** Nearly every app needs form-based features — the submission flow logic is identical across apps, only state managers differ.

---

#### ⚠️ **AVLSM Track (AsyncValue-Like State Models)**

**What it is:** Features that **fetch/display async data** (loading → data/error states)

**Shared infrastructure:**

- **State models:**
  - Riverpod: Native `AsyncValue<T>` (loading/data/error union)
  - BLoC/Cubit/Provider: Custom `AsyncValueForBloc<T>` (parity implementation) ← **this is the overhead**

- **Adapters:** Seams that bridge `AsyncValue` ↔ `AsyncValueForBloc` to stateless UI
- **Pattern:** CRUD operations, profile views, data lists, any feature displaying server-fetched data

**Example features:**

- Profile page (fetch user data → display)
- Email Verification (check status → show result)

**Why overhead is higher:** Must implement full `AsyncValueForBloc<T>` parity model + adapters for non-Riverpod state managers (753 LOC total infrastructure). Riverpod gets this for free, others pay upfront.

---

### Quick Comparison

| Aspect            | SCSM Track                                | AVLSM Track                              |
| ----------------- | ----------------------------------------- | ---------------------------------------- |
| **Pattern**       | Forms + submission                        | Async data fetching                      |
| **Shared models** | `SubmissionFlowStateModel` + input states | `AsyncValue<T>` / `AsyncValueForBloc<T>` |
| **Overhead**      | Low (148 LOC) — simple adapters           | High (377 LOC) — full parity model       |
| **Reusability**   | High (most apps has forms)                | Very high (almos every apps fetch data)  |
| **Break-even**    | Fast (9.8% at N=4)                        | Slow (25.6% at N=10)                     |

---

## 1.5. Break-Even Formula (Canonical Reference)

State-Symmetric Architecture follows an **insurance model** — you pay a premium (overhead) upfront, which pays back when features are reused across state managers.

### Formula

```
R* = OH_effective / Savings_per_feature

Where:
  R* = Break-even reuse probability (minimum % for positive ROI)
  OH_effective = OH_total / N  (amortized overhead per feature)
  Savings_per_feature = Total_Savings / N_features_in_track  (constant)
  N = number of features sharing the same track infrastructure
```

### Example Calculation (SCSM Track at N=4)

```
Given:
  OH_total = 148 LOC
  Total_Savings = 1,518 LOC
  N_features_in_track = 4

Calculate:
  OH_effective = 148 / 4 = 37 LOC
  Savings_per_feature = 1,518 / 4 = 379 LOC
  R* = 37 / 379 = 0.098 = 9.8%
```

**Interpretation:** If reuse probability ≥ 9.8%, symmetry is economically justified.

**Key insight:** As N increases, `OH_effective` decreases linearly, while `Savings_per_feature` stays constant → break-even threshold drops proportionally.

_All break-even calculations in this document use this formula. See **[info-002-methodology.md](info-002-methodology.md)** for full derivation._

---

## 2. Measured Results: Two Track Profiles

# 🏆 SCSM Track (Shared Custom State Models)

**Features in monorepo:** Sign-In, Sign-Up, Change Password, Reset Password (N=4)

### Migration Cost Comparison

| Metric                 | Baseline (Clean Arch) | State-Symmetric | Delta                   |
| ---------------------- | --------------------- | --------------- | ----------------------- |
| **Cost per migration** | 2,171 LOC (76.5%)     | 653 LOC (23.0%) | **-1,518 LOC (-53.5%)** |
| **One-time overhead**  | 0 LOC                 | 148 LOC (5.2%)  | +148 LOC                |

**What's included in overhead (148 LOC):**

- Thin adapters for `SubmissionFlowStateModel` (BLoC + Riverpod sides)
- Submit button seams
- Footer guard widgets (disable UI during submission)
- Side-effect listeners for success/error handling

### Per-Feature Economics

```
Avg feature size:       710 LOC   (2,838 total / 4 features)
Savings per feature:    379 LOC   (53.5% / 4 = 13.4% per feature)
Overhead per feature:   37 LOC    (148 / 4 = 5.2% amortized)
Net benefit:            +342 LOC  (savings - overhead)
ROI:                    9.2× return (924% ROI: 342 saved per 37 invested)
```

### Break-Even Analysis

**At N=4:** Symmetry is profitable if **reuse probability ≥ 9.8%**

```
R* = Overhead_per_feature / Savings_per_feature
R* = 37 / 379 = 0.098 = 9.8%
```

**Interpretation:** If there's ≥10% chance these form features will be reused in another app (with a different state manager), the 148 LOC adapter investment pays off.

**Why SCSM performs well:**

- ✅ Form submission logic is **highly reusable** (most apps has auth/settings/contact forms)
- ✅ Adapters are **thin** (2–5 touchpoints per feature)
- ✅ Overhead amortizes **rapidly** (20.8% → 5.2% from N=1 to N=4)

---

# ⚠️ AVLSM Track (AsyncValue-Like State Models)

**Features in monorepo:** Profile, Email Verification (N=2)

### Migration Cost Comparison

| Metric                 | Baseline        | State-Symmetric | Delta                 |
| ---------------------- | --------------- | --------------- | --------------------- |
| **Cost per migration** | 891 LOC (51.0%) | 596 LOC (34.1%) | **-294 LOC (-16.8%)** |
| **One-time overhead**  | 0 LOC           | 377 LOC (21.6%) | +377 LOC              |

### AVLSM Infrastructure Breakdown (753 LOC Total)

**Why AVLSM overhead is high:** Must implement full `AsyncValue<T>` parity for non-Riverpod state managers.

| Component                        |     LOC | Purpose                                                                   | Reusability                         |
| -------------------------------- | ------: | ------------------------------------------------------------------------- | ----------------------------------- |
| **`AsyncValueForBloc<T>` model** |     272 | Loading/data/error union type (mirrors Riverpod's native `AsyncValue<T>`) | ✅ Reused by all async features     |
| **Base async cubit**             |      79 | Standard cubit for async operations                                       | ✅ Extended by all async cubits     |
| **Introspection helpers**        |     151 | State inspection utilities (BLoC: 72, Riverpod: 79)                       | ✅ Shared across all async features |
| **UI adapters**                  |     251 | Loading/error/data seams (BLoC: 125, Riverpod: 126)                       | ✅ Reused by all async widgets      |
| **Total infrastructure**         | **753** | One-time cost for track                                                   | **Amortized across N features**     |

**Reporting convention:** For symmetry (both directions), overhead is averaged:

```
OH_avg_per_migration = 753 / 2 = 377 LOC
```

**Amortization effect:**

```
N=2:  377 / 2 = 189 LOC per feature (21.6% of track)
N=10: 377 / 10 = 38 LOC per feature (4.3% of track)
N=20: 377 / 20 = 19 LOC per feature (2.2% of track)
```

**Why Riverpod doesn't pay this cost:** Riverpod has `AsyncValue<T>` natively → only needs UI adapters (~126 LOC), not the full parity model.

### Per-Feature Economics

```
Avg feature size:       873 LOC
Savings per feature:    147 LOC (16.8% / 2 = 8.4% per feature)
Overhead per feature:   189 LOC (377 / 2 = 21.6% amortized)
Net cost:               -42 LOC  (overhead exceeds savings at N=2)
ROI:                    -22% (negative until more features added)
```

### Break-Even Analysis

```
At N=2:   189 / 147 = 128.6%   ❌ Not feasible (negative ROI)
At N=10:  37.7 / 147 = 25.6%   ✅ Viable for platform teams
At N=20:  18.9 / 147 = 12.9%   ✅ Strongly profitable
```

**Why AVLSM starts slow:**

- ⚠️ Must implement **full `AsyncValueForBloc<T>` parity model** (Riverpod has it natively, others don't)
- ⚠️ Async features have **less stateful UI** than forms → smaller savings potential
- ⚠️ Infrastructure cost is **front-loaded** (753 LOC before first feature reuse)

**When AVLSM becomes profitable:**

- ✅ Platform teams building **10+ async features** (dashboards, lists, CRUD screens)
- ✅ Long-lived products with **expanding data-driven features**
- ✅ Multi-app scenarios where **async patterns are standardized**

---

## 3. Amortization: How ROI Improves with Scale

### 📉 SCSM Track — Rapid Break-Even Decay

|     N | OH/Feature | Break-Even R\* | Cumulative Savings | Assessment                   |
| ----: | ---------: | -------------: | -----------------: | ---------------------------- |
|     1 |      20.8% |          39.1% |            379 LOC | ⚠️ High certainty needed     |
|     2 |      10.4% |          19.5% |            758 LOC | ✅ Viable for small teams    |
|     3 |       6.9% |          12.9% |          1,137 LOC | ✅ Multi-product             |
| **4** |   **5.2%** |       **9.8%** |      **1,516 LOC** | ✅ **Strong case (current)** |
|     5 |       4.2% |           7.9% |          1,895 LOC | ✅ Nearly free               |
|    10 |       2.1% |           4.0% |          3,790 LOC | ✅ Negligible cost           |
|    20 |       1.0% |           1.8% |          7,580 LOC | ✅ Always profitable         |

**Visual trajectory:**

```
Overhead per feature (% of track)
20% │ ●                          First feature: high initial cost
    │  \
10% │   ● ●___                   N=2-4: rapid decay
    │        \___
 5% │            ●___●___        N=5-10: effectively free
    │                    ●___●
 0% └────────────────────────────► Number of features
    1   2   3   4   5      10   20

Break-even: 39% → 20% → 13% → 10% → 8% → 4% → 2%
```

**Key insight:** After **4 form features**, overhead is negligible (<10% break-even). Most apps need at least 4 forms (sign-in, sign-up, settings, contact) → SCSM is **nearly free insurance** by default.

---

### 📈 AVLSM Track — Slow Burn to Viability

|     N | OH/Feature | Break-Even R\* | Cumulative Savings | Assessment                 |
| ----: | ---------: | -------------: | -----------------: | -------------------------- |
|     1 |      43.2% |      256.5% ❌ |            147 LOC | Not feasible               |
| **2** |  **21.6%** |  **128.6%** ❌ |        **294 LOC** | **Unprofitable (current)** |
|     5 |       8.6% |       51.0% ⚠️ |            735 LOC | High certainty needed      |
|    10 |       4.3% |   **25.6%** ✅ |          1,470 LOC | **Viable for platforms**   |
|    15 |       2.9% |       17.0% ✅ |          2,205 LOC | Reasonable                 |
|    20 |       2.2% |       12.9% ✅ |          2,940 LOC | Comfortable                |
|    50 |       0.9% |        5.4% ✅ |          7,350 LOC | Nearly free                |

**Visual trajectory:**

```
Break-even threshold (%)
250% │ ●                          N=1-2: Unfeasible (negative ROI)
     │  \___
125% │      ●___
     │          \___
 50% │              ●___          N=5: Still risky (51% certainty)
     │                  \___
 25% │                      ●___  N=10: Viable (26% certainty)
     │                          ●___ N=15-20: Comfortable
  5% │                              ●___● N=50+: Nearly free
  0% └────────────────────────────────────────► Number of features
     1   2       5          10   15  20      50
```

**Key insight:** AVLSM requires **critical mass** (N≥10) to become viable. Below 10 features, ROI is negative unless reuse certainty is very high (>50%). Best for **platform teams** building many data-driven screens.

---

### Industry Benchmark Comparison

| Scenario                 |  SCSM Track |  AVLSM Track | Industry Avg (DRY) | Verdict                                  |
| ------------------------ | ----------: | -----------: | -----------------: | ---------------------------------------- |
| **First adoption (N=1)** |    39.1% ⚠️ |    256.5% ❌ |             50–70% | SCSM: Competitive / AVLSM: Poor          |
| **At N=4**               | **9.8%** ✅ |     63.9% ⚠️ |             20–30% | SCSM: **2–3× better** / AVLSM: Below avg |
| **At N=10**              | **4.0%** ✅ | **25.6%** ✅ |             10–15% | Both: Competitive                        |
| **At N=20**              | **1.8%** ✅ | **12.9%** ✅ |              5–10% | Both: Industry-leading                   |

**Why SCSM outperforms:**

- ✅ Form submission flows are **universal patterns** (every app has them)
- ✅ Thin adapters keep overhead **minimal**
- ✅ High stateful UI complexity → **bigger savings**

**Why AVLSM starts slow:**

- ⚠️ Must build full `AsyncValueForBloc<T>` infrastructure (Riverpod gets it free)
- ⚠️ Async features have **less UI duplication** → modest savings
- ⚠️ Infrastructure cost front-loaded → requires **scale** to amortize

---

## 4. Design Guardrails (Prevent Over-Engineering and Over-costs)

### Adapter Budget Limits

| Constraint                  |   Target | Hard Cap | Penalty           |
| --------------------------- | -------: | -------: | ----------------- |
| **Adapter LOC per track**   | ≤200 LOC |  300 LOC | Sign-off required |
| **Touchpoints per feature** |      2–5 |        7 | Refactor required |
| **API symmetry violations** |        0 |        0 | Fix immediately   |

**Rationale:** If adapters exceed 300 LOC, abstractions are too heavy → drift toward over-engineering.

### Symmetry Contract (6 Core Principles)

1. **Shared state models** — No SM-specific state structures
2. **Stateless UI** — No direct SM dependencies in widgets
3. **Thin adapters** — 2–5 touchpoints (listeners, selectors, buttons)
4. **Symmetric APIs** — Method names/params identical across SMs
5. **Extracted side effects** — Overlays, navigation, logging via adapters
6. **Lazy parity** — Build 2nd SM adapters only when reuse confirmed

**Violation = broken symmetry contract → migration costs spike**

### CI Policy for Sleeping Adapters

| Adapter State              | Test Coverage         | CI Overhead | Rationale                     |
| -------------------------- | --------------------- | ----------: | ----------------------------- |
| **Active** (in production) | Full suite            |    Standard | Validate production code      |
| **Sleeping** (Lazy Parity) | Compile + smoke tests |         ≤5% | No full tests until activated |

**Benefit:** Sleeping adapters don't incur full maintenance costs until actually used → keeps ongoing overhead low.

---

## 5. Hidden Benefits (Beyond LOC Metrics)

State-Symmetric Architecture delivers **intangible advantages** not captured in raw LOC savings:

### 5.1. Developer Experience

- **One coding model** across state managers → no mental context-switching
- **Consistent patterns** → fewer bugs, faster code reviews
- **Onboarding: <1 week** → new devs productive immediately

**Estimated impact:** 15–25% productivity boost (not in base ROI)

---

### 5.2. Maintainability

- **Single source of truth** → fixes applied once, reused everywhere
- **No divergence** → parallel implementations stay in sync
- **Lower test burden** → only thin adapters need SM-specific tests

**Estimated impact:** 40–70% fewer maintenance touch points in reused features

#### Example: Maintenance Impact (SCSM Track)

Bug fix in submission flow affecting 4 features:

```
Baseline (Clean Arch without symmetry):
  → Touch 4 features × 2 SMs = 8 presentation files modified
  → Test 8 files independently
  → PR review: ~8 file diffs

Symmetric (Shared submission flow):
  → Touch 1 shared flow + 2 thin adapters = 3 files modified
  → Test 1 shared flow + 2 adapters
  → PR review: ~3 file diffs

Reduction: 62.5% fewer touch points per change
```

---

### 5.3. Time-to-Market

- **90% code reuse** → feature delivery ~50% faster
- **Pre-validated patterns** → reduced QA cycles
- **Easy team scaling** → devs cross-project without ramp-up

**Estimated impact:** 30–60% faster delivery for reused features

**Conservative accounting:** These benefits are **NOT** included in base ROI calculations → actual value is at least **15-20%** higher than reported.

---

## 6. Conservative Estimates & Real-World Expectations

All numbers are lower bounds — actual ROI is higher:

| Assumption                             | Impact                   | Reality                               |
| -------------------------------------- | ------------------------ | ------------------------------------- |
| Baseline excludes infrastructure costs | Understates savings      | Infra rebuild adds 15–30% to baseline |
| Maintenance savings not included       | Ignores ongoing value    | ~$1,400/year/feature saved            |
| Hidden benefits not quantified         | Undervalues total impact | +20–40% additional ROI                |

**Expected real-world ROI:** In case of feature reuse in app with another SM the actual savings are at least **30-50%** higher than reported.

---

## 7. Next Steps

**Reproduce Results**

```bash
# In monorepo root
melos loc:report
```

**Learn More**

- Use cases → **[use-case-areas.md](info-005-use-case-areas.md)**
- Methodology → **[methodology.md](info-002-methodology.md)**
- Raw LOC data → **[results-of-loc-report.md](info-003-results-of-loc-report.md)**
- Architecture: → **[State-symmetric-architecture.md](../ADR-001-State-symmetric-architecture.md)**

---

## Final Takeaway

**For form-based features (SCSM):**

- ✅ Nearly free at realistic reuse probabilities (≥10%)
- ✅ Outperforms industry DRY patterns by 2–3×
- ✅ Viable from N=2 features

**For async data features (AVLSM):**

- ⚠️ Requires critical mass (N≥10) due to infrastructure cost
- ⚠️ Front-loaded overhead (753 LOC for `AsyncValueForBloc<T>` parity)
- ✅ Becomes strongly profitable at scale (N≥20: 12.9% break-even)

**The key:** Apply it when reuse probability exceeds break-even thresholds — and this analysis provides clear, reproducible measurements to guide that decision.
