# 📈 Business Value Estimates

A pragmatic summary of the **State-Symmetric Architecture**, based on measured data from the showcase monorepo (`melos loc:report`).

> **Goal:** Keep state-dependent code within **15–50% LOC upfront (first feature)**, amortized to **≤5–10% per feature**, achieve **90%+ code reuse across stacks**, and pay that cost **only when reuse is likely** (≥15–25% reuse probability, considering amortization).

---

## 1. What a “Track” Means

A **track** is a _set of related features_ that share the same **state-symmetry contract** and reuse the same **adapters, seams, and state models**.

For example:

- **SCSM Track (Shared Custom State Models)** — _Sign-In, Sign-Up, Change Password, Reset Password_ — all reuse shared state models and adapter seams.
- **AVLSM Track (AsyncValue-Like State Models)** — _Profile_ and _Email Verification_ — both rely on the shared `AsyncValueForBloc<T>` and `AsyncValue<T>` parity seam.

The reported **track overhead** is a **one-time adapter cost**, paid once and reused across all features within the track.
This demonstrates the **minimum achievable amortized overhead** under real reuse.

---

## 2. ROI Snapshots (Measured Results)

All numbers represent **round-trip averages (RT/2)** — the mean cost of migrating a feature between Riverpod ↔ Cubit apps.

### **A) Shared-Custom-State-Models Track (SCSM)**

_Features: Sign-In, Sign-Up, Change Password, Reset Password_

| Metric                        |                Value | Interpretation                             |
| ----------------------------- | -------------------: | ------------------------------------------ |
| Baseline (Clean Architecture) | **2171 LOC (76.5%)** | Migration effort per leg without symmetry  |
| State-Symmetric               |  **653 LOC (23.0%)** | Migration effort per leg with shared seams |
| **Savings (per migration)**   | **1518 LOC (53.5%)** | Feature reuse benefit                      |
| **Overhead (first feature)**  |   **148 LOC (5.2%)** | One-time adapter cost                      |

✅ **Conclusion:** ROI is **immediately positive**.
Even a single feature breaks even — overhead (5.2%) is minor compared to 53.5% migration savings.
With 2+ features reusing the same seams, overhead amortizes to **≤3–5% per feature**.

---

### **B) AsyncValue-Like-State-Models Track (AVLSM)**

_Features: Profile, Email Verification_

| Metric                        |               Value | Interpretation                                         |
| ----------------------------- | ------------------: | ------------------------------------------------------ |
| Baseline (Clean Architecture) | **891 LOC (51.0%)** | Migration cost without symmetry                        |
| State-Symmetric               | **596 LOC (34.1%)** | Migration cost with shared AsyncValue seams            |
| **Savings (per migration)**   | **295 LOC (16.9%)** | Net savings per migration                              |
| **Overhead (first feature)**  | **377 LOC (21.6%)** | One-time cost for AsyncValue adapters and state models |

⚠️ **Conclusion:** ROI for a single async feature is weak (21.6% overhead).
✅ ROI becomes positive once **2–3 async features** reuse the same adapters.
At **5+ features**, amortized ROI exceeds **60% cumulative savings**.

---

### **C) Quick Reference Table**

| Track Type                               | Shared Code                | Adapter Cost  | Migration Savings | Break-Even Reuse Probability |
| ---------------------------------------- | -------------------------- | ------------- | ----------------- | ---------------------------- |
| **Shared-Custom-State-Models (SCSM)**    | ~77% (core + presentation) | **5.2% LOC**  | **53.5% savings** | **≈10%**                     |
| **AsyncValue-Like-State-Models (AVLSM)** | ~65% (core + presentation) | **21.6% LOC** | **16.9% savings** | **≈25% (after 5 features)**  |

> **Break-even** means the minimum probability that a feature will need reuse on another state manager for ROI ≥ 0.

---

## 3. Economics and Interpretation

### Baseline (Clean Architecture)

Rewriting the presentation + state management layer for a new SM costs **≈0.75 F (SCSM)** or **≈0.50 F (AVLSM)**.
Without symmetry, every migration is essentially a rewrite of state orchestration and UI logic.

### State-Symmetric Approach

Adapter reuse cuts migration cost to **~23% (SCSM)** and **~34% (AVLSM)** of the feature size, saving **40–55% LOC** on average.
Overhead amortizes quickly — **SCSM after 2–3 features**, **AVLSM after 3–5**.

| Track     | Baseline Cost | Symmetric Cost | Savings    | Amortized Overhead          |
| --------- | ------------- | -------------- | ---------- | --------------------------- |
| **SCSM**  | 76.5%         | 23.0%          | **−53.5%** | ≤5–10% (after 2–3 features) |
| **AVLSM** | 51.0%         | 34.1%          | **−16.9%** | ≤10% (after 3–5 features)   |

---

## 4. Break-Even Probability — “Architecture as Insurance”

Treat the symmetric adapters as an **insurance premium** (`o`) and reuse as the **claim probability** (`R`).

Formula:
\[
R ≥ \frac{o}{p\_{clean} - a}
\]
where:

- `o` — overhead ratio (the premium)
- `p_clean` — baseline migration cost
- `a` — symmetric migration cost

| Track                 | p_clean | a     | o     | Break-Even R (≈ o / (p_clean − a))  |
| --------------------- | ------- | ----- | ----- | ----------------------------------- |
| **SCSM**              | 0.765   | 0.230 | 0.052 | **≈ 0.10 (10 %)**                   |
| **AVLSM (1 feature)** | 0.510   | 0.341 | 0.216 | **≈ 1.28 (128 %) → not profitable** |

➡️ **Interpretation:**

- **SCSM:** Profitable even with a **10 %** reuse chance — symmetry pays off immediately.
- **AVLSM:** Not profitable for a single feature. As adapters are reused, overhead amortizes and the break-even probability falls rapidly:
  - ≈ 43 % at 3 features,
  - ≈ 25 % at 5 features,
  - ≈ 13 % at 10 features.
    From 5 features onward, symmetry becomes **clearly beneficial**.

> This follows the **insurance principle**: a one-time premium (overhead) is justified once the expected savings from reuse exceed it.
> No extra “maintenance tax” is included — tests and CI exist in both baselines, and coverage effort **decreases** once reuse occurs.

---

## 5. Amortization by Track Size

The table below models the **effective overhead per feature** (`OH / N`) as more features share the same track.

| # of Features in Track | SCSM (148 LOC total OH) | AVLSM (377 LOC total OH) |
| ---------------------: | ----------------------- | ------------------------ |
|      1 (first feature) | 5.2 %                   | 21.6 %                   |
|                      2 | 2.6 %                   | 10.8 %                   |
|                      3 | 1.7 %                   | 7.2 %                    |
|                      5 | 1.0 %                   | 4.3 %                    |
|                     10 | 0.5 %                   | 2.1 %                    |

> Each additional feature reduces the effective “premium,” pushing the system toward **zero-cost reuse**.

---

## 6. Key Insights

- **SCSM tracks** (Auth-like flows) are **immediately profitable** — thin adapters (5.2 % LOC) yield 53.5 % migration savings.
- **AVLSM tracks** pay off after **2–3 features**, ideal for async-heavy domains (Profile, Feed, Dashboard).
- **Symmetry rewards modular design:** seams and adapters are reusable across state managers.
- **Break-even probability:** ≈ 10 % (SCSM) and ≈ 25 % (AVLSM after 5 features) — realistic for multi-product orgs and SDK vendors.

---

## Criteria to Maximize ROI

- Keep **state-dependent code < 5 % per feature** and apply Lazy Parity — pay overhead only when reuse is confirmed.
- Scope symmetry to **2–5 horizontals**; maintain a lightweight **Symmetry Contract** (6–8 API rules + checklist).
- Avoid universal stores or view-models; use **native SM APIs** via thin facades.
- Track and validate **SLOC delta** per feature (adapters only); keep within **5–10 % per feature** after amortization.
- In CI: run full tests for the **active adapter**, and **compile + smoke** for sleepers.

---

## ⚠️ Risks & Limitations

- **Delayed payoff (AVLSM):** requires 3-4 async features to turn positive.
- **No gain on legacy code:** symmetry works only with Clean Architecture boundaries.
- **Team discipline:** following the Symmetry Contract is essential to prevent drift.

---

## 📌 Summary

| Track                        | First Feature Overhead | Migration Savings | Break-Even Probability              | ROI Trend                     |
| ---------------------------- | ---------------------- | ----------------- | ----------------------------------- | ----------------------------- |
| **SCSM (Auth-like)**         | **5.2 %**              | **53.5 %**        | **≈ 10 % reuse**                    | ✅ Immediate positive         |
| **AVLSM (Async/AsyncValue)** | **21.6 %**             | **16.9 %**        | **≈ 25 % reuse (after 5 features)** | ⚠️ Positive from 2–3 features |

> All values are conservative. In baseline clean scenarios, infrastructure code is also required but excluded from LOC counts for comparability.

In steady state, both tracks converge to **≤ 5–10 % overhead** per feature (with considering of amortization).
Below a **10–15 % reuse probability**, a clean single-SM implementation remains the optimal baseline.

**State Symmetry pays off when reuse is probable — and becomes nearly free after two features.**
It transforms architectural cleanliness into a **measurable economic advantage**.

---

### **Bottom Line**

- **Insurance Rule of Thumb:** Treat symmetry as a **low-cost premium** — **~20–35 % LOC upfront**, amortized to **≤ 5–10 %** — that pays off when **there is break-even probability of feature reuse on app, based on another SM** within your planning horizon.
- **Stick to Operational Guardrails:** Keep adapters ≤ 200–300 LOC per feature (2–5 touchpoints); enforce the **Symmetry Contract**; apply **Lazy Parity** in CI.
- **Better Developer Experience:** One consistent template across SMs simplifies mental models, reduces errors, and speeds delivery.
- **Better Maintainability:** Shared core changes propagate once across apps, avoiding divergent code bases.
- **Better Time-to-Market:** 90 % code reuse means new features ship faster with lower risk.
