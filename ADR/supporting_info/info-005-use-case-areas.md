# State-Symmetric Architecture: Use Case Areas & Decision Framework

State-Symmetric Architecture (SSA) is an **economic model** for Flutter architecture. It becomes cost-effective when the **probability of reusing features across applications with different state managers** exceeds the measured break-even thresholds:

- **9.8%** for form-based features (**SCSM Track**)
- **25.6%** for async data features (**AVLSM Track**, requires **N ≥ 10**)

Teams and companies that gain the most from SSA:

- **Multi-product organizations** with **≥70% UI similarity**
- **White-label vendors** supporting partner-specific state manager choices
- **Agencies** serving **≥2 clients** using different state managers
- **Platform teams** building long-lived shared modules
- **Solo/indie developers** with high reuse patterns

> **Measurement Note**: All metrics below originate from the SSA showcase monorepo and can be reproduced via `melos loc:report`. These numbers represent conservative, context-bound estimates.

---

## Quick Navigation

- [1. Company/Team Profiles](#1-companyteam-profiles-who-benefits-and-who-doesnt)
- [2. Decision Framework](#2-decision-framework-when-to-adopt)
  - [Adoption Quick-Test](#adoption-quick-test)
  - [Track Rules: SCSM & AVLSM](#track-rules-scsm--avlsm)
  - [Legacy → New State Manager](#legacy--new-state-manager)
  - [Anti-Patterns](#anti-patterns)
- [3. Post-Adoption Metrics](#3-post-adoption-metrics-to-track)
- [4. Summary & Decision Matrix](#4-summary--decision-matrix)
- [5. Key Takeaways & Further Reading](#5-key-takeaways--further-reading)

---

## 1. Company/Team Profiles: Who Benefits (and Who Doesn’t)

SSA is **not a universal solution**. It is most effective in environments with:

- Realistic expectations of **cross–state manager reuse**
- **≥70% UI/UX similarity** across applications
- Reuse probability above break-even thresholds

### Agencies (Outsourcing)

| Pattern                             | Indicators                                         | ROI         | Decision                                     |
| ----------------------------------- | -------------------------------------------------- | ----------- | -------------------------------------------- |
| **Pattern A: Standardized SM**      | One SM for all clients (e.g., BLoC)                | ❌ Negative | Skip SSA — boilerplate is sufficient         |
| **Pattern B: Custom per client**    | No reuse across projects; different design systems | ⚠️ Weak     | Templates faster and cheaper                 |
| **Pattern C: Multi-client SM-flex** | ≥2 clients, different SMs, UI similarity ≥70%      | ✅ Positive | Recommended — break-even from the 2nd client |

**Why Pattern C works:**

- Initial overhead **20–35% LOC** amortizes to **5–10%** after 2–3 features
- **Savings per migration:** 53.5% (SCSM), 16.8% (AVLSM)

### Multi-Product Companies

| Indicators                                         | ROI            | Decision                                          |
| -------------------------------------------------- | -------------- | ------------------------------------------------- |
| 2+ apps, shared DS (UI ≥70%), similar feature sets | ⚠️ Conditional | Recommended if SMs differ **and** UI overlap ≥70% |
| Radically different UX or <50% feature overlap     | ❌ Negative    | Skip SSA                                          |

### White-Label Vendors

| Indicators                                             | ROI       | Decision                                        |
| ------------------------------------------------------ | --------- | ----------------------------------------------- |
| Core + branded variants; partners prefer different SMs | ✅ Strong | Ideal fit where partners require SM flexibility |

### Platform Teams

| Indicators                                                                            | ROI        | Decision                                                 |
| ------------------------------------------------------------------------------------- | ---------- | -------------------------------------------------------- |
| Centralized development of reusable modules; many internal consumers; long-lived code | ✅ Highest | Recommended — highest ROI in multi-consumer environments |

### Solo/Indie

| Indicators                                                     | ROI             | Decision                             |
| -------------------------------------------------------------- | --------------- | ------------------------------------ |
| High reuse, knowledge of multiple SMs, AI-assisted development | ✅ Net-positive | Often beneficial due to <3% overhead |

---

## 2. Decision Framework: When to Adopt

### Adoption Quick-Test

A 60-second decision checklist:

1. **Is UI similarity ≥ 70% across target apps?** (yes/no)
2. **Track selection:**
   - **SCSM:** Are ≥2 form features planned?
   - **AVLSM:** Are ≥10 async features planned?
3. **Reuse probability ≥ threshold?**
   - **SCSM:** ≥ **9.8%**
   - **AVLSM:** ≥ **25.6%** (for N ≈ 10)

**Result:** If (1) YES **and** (3) YES → SSA is a viable option for that track.

---

## Track Rules: SCSM & AVLSM

### 🏆 SCSM Track (Form Features)

**Adopt if:** ≥2 form features, reuse probability ≥10%, UI overlap ≥70%.

```yaml
# Measured in showcase setup
Overhead: 5.2%  (148 LOC for 4 features)
Savings: 53.5% (1,518 LOC per migration)
Break-even: 9.8% reuse probability
ROI: 9.2× (conservative; measured)
Note: Break-even drops to ~4.0% at N≈10 as overhead is amortized.
```

**Verdict:** ✅ _Recommended by default_ for multi-application scenarios involving form-based features.

---

### ⚠️ AVLSM Track (Async Data Features)

**Adopt if:** ≥10 async features, reuse probability ≥25%, product lifespan ≥3 years.

```yaml
# Measured in showcase setup
Overhead: 21.6% (377 LOC for 2 features; front-loaded infrastructure)
Savings: 16.8% (294 LOC per migration)
Break-even: 128.6% at N=2 → ~25.6% at N≈10
ROI: Negative at N=2 → positive near N≥10
```

**Verdict:** ⚠️ _Adopt selectively_ — only when ≥10 async features and ≥25% reuse probability are realistic.

---

## Legacy → New State Manager

| Scenario               | Indicators                                     | ROI         | Decision                                        |
| ---------------------- | ---------------------------------------------- | ----------- | ----------------------------------------------- |
| **Clean Architecture** | Clear domain/data/presentation layers; thin SM | ✅ Positive | Recommended — progressive Lazy Parity migration |
| **Spaghetti Code**     | Mixed state/logic/UI; no layer separation      | ⚠️ Delayed  | Refactor to Clean Architecture before adoption  |

**Migration Notes:**

- Add SM adapters gradually (**Lazy Parity**)
- Keep shared contracts (domain, data, routing, localization)
- Migrate **feature-by-feature**, avoiding big-bang rewrites

---

## Anti-Patterns

Consider skipping SSA if **≥2** of the following apply:

- Single-product company (one app, one SM)
- Reuse probability < **10%** (SCSM) or < **25%** (AVLSM)
- UI similarity < **70%**
- MVP/prototype with frequent pivots
- No Clean Architecture discipline

**Exceptions:**

- **Solo/indie developers** with high reuse and automation
- **MVP as part of a platform** — start with SCSM only

---

## 3. Post-Adoption Metrics to Track

| Metric                    | Target          | Alert Threshold | What It Measures                               |
| ------------------------- | --------------- | --------------- | ---------------------------------------------- |
| Reuse Rate                | —               | —               | % of features later ported to another SM/app   |
| Adapter Delta             | ≤ **5%**        | > **10%**       | Adapter LOC ÷ total feature LOC                |
| Lead Time to Parity       | Lower is better | —               | Time to deliver a parity feature in the 2nd SM |
| Adapter Defect Rate       | Near-zero       | > 5 per 1k LOC  | Stability of adapter seams                     |
| Symmetry Budget Adherence | ≥ **90%**       | < **70%**       | % of features within ≤200 LOC symmetry budget  |

---

## 4. Summary & Decision Matrix

### ✅ Best Fits

- Agencies (Pattern C)
- White-label vendors
- Platform teams
- Multi-product companies with SM diversity + UI≥70%
- Legacy migrations with Clean Architecture
- Solution providers offering multi-SM templates
- Solo/indie developers with high reuse

### ⚠️ Conditional

- Multi-product (only if SMs differ and UI≥70%)
- Legacy spaghetti (after refactoring to Clean Architecture)
- MVPs (only if part of a larger platform; start with SCSM)

### ❌ Poor Fits

- Single-product companies
- Chaotic MVP/startups
- Divergent UX (<70% similarity)
- No willingness to enforce Clean Architecture
- Reuse probability below 10% (SCSM) or 25% (AVLSM)

---

## 5. Key Takeaways & Further Reading

SSA is economically justified when:

- Reuse probability exceeds break-even thresholds
- UI similarity ≥70% across product lines
- The company profile matches scenarios with demonstrated ROI
