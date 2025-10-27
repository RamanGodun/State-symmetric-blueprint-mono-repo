# 📈 Business Value Estimates

This document summarizes the results of the **State‑Symmetric Architecture** analysis, derived from measured data in the showcase monorepo (run `melos loc:report` to reproduce results).
Results for showcase features in symmetric apps are in **[info-003-results-of-loc-report.md](info-003-results-of-loc-report.md)**

The applied measurement and calculation principles are detailed in **[info-002-methodology.md](info-002-methodology.md)**.

> **Goal:** Determine the **break‑even reuse probabilities** — the reuse thresholds at which adopting the State‑Symmetric approach becomes **economically justified and operationally profitable**.

## 1. What a "Track" Means

A **track** is a _group of related features_ that share one **state-symmetry contract** and reuse the same **adapters, seams, and state models**.

For example:

- **SCSM Track (Shared Custom State Models)** — _Sign-In, Sign-Up, Change Password, Reset Password_ (4 features) — all reuse the same authentication seams and state models.
- **AVLSM Track (AsyncValue-Like State Models)** — _Profile_ and _Email Verification_ (2 features) — both rely on the shared `AsyncValueForBloc<T>` / `AsyncValue<T>` parity seam.

> Each **track** is the measurement unit for ROI — results aggregate across all its features.
> The reported **track overhead** is a one-time adapter cost spread across all features on that track.

## 2. ROI Snapshots (Measured Results)

### **Shared-Custom-State-Models Track (SCSM)**

_Features: Sign-In, Sign-Up, Change Password, Reset Password (4 features total)_

| Metric                              | Migration costs      | Interpretation                            |
| ----------------------------------- | -------------------- | ----------------------------------------- |
| **Baseline** (Clean Architecture)   | **2171 LOC (76.2%)** | Migration effort per track (no symmetry)  |
| **State-Symmetric**                 | **653 LOC (22.9%)**  | Migration effort with shared seams        |
| **Savings (per migration)**         | **1518 LOC (53.3%)** | Net LOC saved through reuse               |
| **Overhead (total for 4 features)** | **148 LOC (5.2%)**   | One-time adapter cost for the whole track |

**Per-feature breakdown:**

- Feature size (avg): **711 LOC**
- Overhead (1st feature): **148 LOC → 20.8%** of single feature
- Overhead (amortized, 4 features): **37 LOC → 5.2%** per feature
- Savings (per 4 features): **380 LOC → 53.3%**

✅ **Conclusion:** ROI is **strongly positive at track level** (5.2% overhead vs 53.3% savings → **break even at 10% reuse probability**). Even the first feature alone (20.8% overhead) needs only **39% reuse probability** to break even.

### **AsyncValue-Like-State-Models Track (AVLSM)**

_Features: Profile and Email Verification (2 features total)_

| Metric                              | Migration costs     | Interpretation                            |
| ----------------------------------- | ------------------- | ----------------------------------------- |
| **Baseline** (Clean Architecture)   | **891 LOC (51.0%)** | Migration cost per track (no symmetry)    |
| **State-Symmetric**                 | **596 LOC (34.1%)** | Costs with shared AsyncValue seams        |
| **Savings (per migration)**         | **295 LOC (16.9%)** | Net LOC saved                             |
| **Overhead (total for 2 features)** | **377 LOC (21.6%)** | One-time adapter cost for the whole track |

**Per-feature breakdown:**

- Feature size (avg): **874 LOC**
- Overhead (1st feature): **377 LOC → 43.2%** of single feature
- Overhead (amortized, 2 features): **189 LOC → 21.6%** per feature
- Savings (per 2 features): **148 LOC → 16.9%**

⚠️ **Conclusion:** For a 2-feature track, ROI is **negative** (21.6% overhead > 16.9% savings). Break-even requires **128% reuse probability** (unfeasible). However, as more async features join, overhead amortizes rapidly.

### **Quick Reference Table**

| Track Type | # Features | OH Per-Feature / Track | Savings per track | Break-Even            |
| ---------- | ---------- | ---------------------- | ----------------- | --------------------- |
| **SCSM**   | 4          | 20.8% / 5.2%           | 53.3%             | **9.7%** reuse        |
| **AVLSM**  | 2          | 43.2% / 21.6%          | 16.9%             | **128%** (unfeasible) |

## 3. Break-Even Probability ("Insurance Model")

The symmetric overhead acts as an **insurance premium** that pays off when features are reused across state managers.

**Formula:**

```
R* = OH_effective / (Savings_per_feature × N)
*Where:*
  OH_effective = OH_total / N  (amortized overhead)
  N = number of features on the track
```

### SCSM Track: R\* = o / (s × N) = 5.2 / (53.3 × N)

| N Features | OH Effective | Break-Even R\* | Amortized Savings (LOC) | Scenario                               |
| ---------- | ------------ | -------------- | ----------------------- | -------------------------------------- |
| 1          | 20.8%        | **9.7%**       | 380 LOC                 | Marginal (first feature, no reuse yet) |
| 2          | 10.4%        | **4.8%**       | 760 LOC                 | Realistic for small teams              |
| 3          | 6.9%         | **3.3%**       | 1,140 LOC               | Comfortable for multi-product          |
| **4**      | **5.2%**     | **2.4%**       | **1,520 LOC**           | **Strong case (current track ✅)**     |
| 5          | 4.2%         | **2.0%**       | 1,900 LOC               | Nearly free insurance                  |
| 10         | 2.1%         | **1.0%**       | 3,800 LOC               | Negligible cost                        |
| 15         | 1.4%         | **0.7%**       | 5,700 LOC               | Zero-cost reuse                        |
| 20         | 1.0%         | **0.5%**       | 7,600 LOC               | Always profitable                      |

**Interpretation:**

- At **N=4** (current track), symmetry pays off if there's just a **≥10% chance** that features will be reused.
- At **N≥10**, break-even drops to **≈1%**, effectively **free insurance** for any realistic reuse scenario.

---

### AVLSM Track: R\* = o / (s × N) = 21.6 / (16.9 × N)

| N Features | OH Effective | Break-Even R\* | Amortized Savings (LOC) | Scenario                            |
| ---------- | ------------ | -------------- | ----------------------- | ----------------------------------- |
| 1          | 43.2%        | **128%** ❌    | 148 LOC                 | Not feasible (>100%)                |
| **2**      | **21.6%**    | **64%** ⚠️     | **296 LOC**             | **Unprofitable (current track ✅)** |
| 3          | 14.4%        | **43%** ⚠️     | 444 LOC                 | High certainty needed               |
| 4          | 10.8%        | **32%** ⚠️     | 592 LOC                 | Marginal viability                  |
| 5          | 8.6%         | **26%** ✅     | 740 LOC                 | Reasonable for platform projects    |
| 10         | 4.3%         | **13%** ✅✅   | 1,480 LOC               | Viable for async-heavy products     |
| 15         | 2.9%         | **9%** ✅✅    | 2,220 LOC               | Comfortable threshold               |
| 20         | 2.2%         | **6%** ✅✅    | 2,960 LOC               | Strong case                         |
| 25         | 1.7%         | **5%** ✅✅    | 3,700 LOC               | Nearly free                         |
| 50         | 0.9%         | **2.5%** ✅✅  | 7,400 LOC               | Negligible cost                     |
| 100        | 0.4%         | **1.3%** ✅✅  | 14,800 LOC              | Zero-cost reuse                     |

**Interpretation:**

- At **N=2**, reuse needs to be **extremely certain (~64%)** to break even.
- By **N=5–10**, break-even drops to **26–13%**, matching realistic reuse patterns.
- At **N≥20**, AVLSM becomes effectively **zero-cost** and strongly profitable.

## 4. Amortization Effect Visualized

### SCSM Track: Overhead & Break-Even Decay

```
% (of feature)
 25%  │ ●
      │  \
 20%  │   ● (20.8%)
      │     \
 10%  │       ● (5.2%)
      │         \
   5% │           ● (2.1%)
      │             \
   1% │               ● (1.0%)
      │                 \
   0% └──────────────────────────────────────────────► N Features
       1    2    3    4    5   10   15   20

Break-Even R* (%): 9.7 → 4.8 → 3.3 → 2.4 → 2.0 → 1.0 → 0.7 → 0.5
```

**Key Insight:** For the **SCSM track**, overhead and break-even drop rapidly — from **~10% at 1 feature** to **<1% by 10 features**. After 4 features, symmetry is already strongly profitable, and beyond 10, effectively free.

---

### AVLSM Track: Break-Even Trajectory

```
Break-Even R* (%)
 130% │ ● (128%)
      │    \
  60% │     ● (64%)
      │        \
  40% │         ● (43%)
      │           \
  30% │            ● (32%)
      │              \
  20% │               ● (26%)
      │                 \
  10% │                   ● (13%)
      │                      ● (9%)
   5% │                          ● (6%)
      │                              ● (5%)
   2% │                                   ● (2.5%)
   1% │                                       ● (1.3%)
   0% └─────────────────────────────────────────────────────► N Features
       1    2    3    4    5   10   15   20   25   50   100

Break-Even R* (%): 128 → 64 → 43 → 32 → 26 → 13 → 9 → 6 → 5 → 2.5 → 1.3
```

**Key Insight:** AVLSM starts unprofitable (**>100%**) but becomes viable around **N=5 (26%)**, realistic by **N=10 (13%)**, and nearly free beyond **N≥25 (5%)**. At **N=100**, break-even is ~**1.3%**, indicating effectively zero cost for large tracks.

## 5. Practical Recommendations

### For SCSM Track:

✅ **Always adopt** if you expect:

- ≥2 apps with different SMs
- ≥10% chance of feature reuse
- Similar UX/UI across apps (≥70% overlap)

**Why:** Break-even is **10%** with 4 features, dropping to **2%** with 10 features. Essentially **free insurance** for any realistic multi-app scenario.

### For AVLSM Track:

⚠️ **Adopt selectively** if your roadmap includes:

- ≥10 async features with common state-patterns (data/error/loading)
- ≥25% reuse probability across apps
- Long-lived product (3+ years)

**Why:** Break-even drops from **128%** (2 features) to **26%** (5 features) to **2.2%** (20 features). Becomes **no-brainer for platform teams** with 20+ features.

❌ **Skip** if:

- Building ≤5 async features
- Single-product company
- Rapid MVP iteration phase

## 6. Key Constraints & Guardrails

### Design Constraints:

- Keep adapters **≤200–300 LOC** per feature (2–5 touchpoints)
- Enforce **Symmetry Contract** (6–8 API rules + review checklist)
- Use **Lazy Parity** (build 2nd SM adapters only when needed)
- Avoid universal abstractions — thin facades over native SMs only

### CI Policy:

- **Active adapter**: full test suite
- **Sleeping adapter**: compile + smoke tests only (≤5% overhead)

### Team Discipline:

- Track **SLOC delta** per feature (target ≤10% after amortization)
- **Adapter Defect Rate**: should be near-zero (thin seams are easy to test)
- **Symmetry Budget**: sign-off required if OH exceeds 300 LOC (except AVLSM track)

## 📌 Summary

### SCSM Track

- **Current state**: 4 features, 5.2% overhead, 53.3% savings
- **Break-even**: **10% reuse probability**
- **Verdict**: ✅ **Adopt by default** for any multi-app scenario
- **Amortization**: Overhead drops to **<2%** with 10+ features

### AVLSM Track (Async features)

- **Current state**: 2 features, 21.6% overhead, 16.9% savings
- **Break-even**: **128% reuse** (unfeasible) → **26% with 5 features**
- **Verdict**: ⚠️ **Wait until ≥10 async features** unless platform team
- **Amortization**: Becomes no-brainer at 20+ features (13% break-even)

> All estimates are conservative. Actual savings may be higher due to reduced testing/maintenance burden and faster time-to-market, as well as no need to create infrastructure codebase (that should be done within baseline scenario)

### Bottom Line

**State-Symmetric Architecture is insurance:**

- **Low premium**: <=5% overhead after amortization
- **Break-even**: Realistic for **SCSM at ≥4 features** (10% reuse), **AVLSM at ≥5 features** (26% reuse)

**Decision rule:**

1. **Always adopt SCSM** if building ≥2 SCSM-track-like features across apps
2. **Adopt AVLSM** only if roadmap shows ≥10 async features
3. **Track amortization** — ROI improves dramatically with each new feature

> For a detailed overview of where and how the State-Symmetric Architecture can be applied, see **[info-005-use-case-areas.md](info-005-use-case-areas.md)**.

### Hidden Benefits (Not in LOC Metrics)

Beyond raw LOC savings, symmetry delivers:

1. **Better Developer Experience**
   - One consistent coding model across SMs
   - Reduced mental switching cost
   - Fewer errors from inconsistent patterns

2. **Better Maintainability**
   - Fixes/improvements applied once, reused everywhere
   - No divergence between parallel codebases
   - Lower long-term support costs (including tests coverage's costs)

3. **Better Time-to-Market**
   - 90% code reuse → faster feature delivery
   - Pre-validated patterns reduce QA cycles
   - Easier team scaling (developers productive in <1 week)
