# State-Symmetric Approach Use Case Areas

The **State‑Symmetric Architecture** functions as an _engineering insurance model_ — a **low‑cost investment**, that yields significant ROI when the **probability of feature reuse across state managers exceeds break-even probability**.

Methodology and cost estimates are defined in **[info-002-methodology.md](info-002-methodology.md)** and detailed ROI results in **[info-001-business-value-estimates.md](info-001-business-value-estimates.md)**. To reproduce results - run `melos loc:report` in terminal of showcase monorepo.

## 🎯 Potential Niche Target for Teams/Projects

> This approach is **business‑valuable for a niche** (< 5% of market), when reuse of feature's codebase across the apps/stacks is likely. Below are the profiles where it shines (and where it doesn’t).

### 🎯 Agencies (Outsourcing Companies)

**When it applies:**

- The company wants to minimize feature duplication to deliver similar apps quickly with different requirements (≥2 clients within planning horizon, each requiring different state managers, e.g., one wants BLoC, another — Riverpod).

**Why it’s profitable:**

- ROI becomes positive starting with the **second client** choosing a different SM. Only a thin adapter is needed (**~20–35% LOC in the first features; amortized to ≤5–10% after 2–3 features**).

**When it doesn’t pay off:**

- The company standardizes under one SM and enforces it on all clients (common pattern).

### 🎯 Multi‑Product Companies

**When it applies:**

- 2+ apps for different segments (e.g., consumer app + admin app + white‑label app). They share **one design system** and **similar features** (auth, profile, payments).

**Why it’s profitable:**

- Enables parallel support across **different SMs** or migration between legacy BLoC ↔ new Riverpod.

**When it doesn’t pay off:**

- Products diverge strongly in UI/UX (radically different flows).

### 🎯 White‑Label Solutions

**When it applies:**

- A single “core product” customized for different partners/clients, often needing to adapt to **external teams** with their preferred SM.

**Why it’s profitable:**

- Reduces alignment costs: no debate over “which SM is better,” just **plug in the required one**.

**When it doesn’t pay off:**

- Each white‑label app has heavily customized UX, experiments, or flows.

### 🎯 Platform Teams (Internal Feature Platforms)

**When it applies:**

- A dedicated team builds reusable modules (auth, profile, payments, notifications) for other internal teams. Modules are **long‑lived** and centrally maintained.

**Why it’s profitable:**

- Ensures **consistency across apps**, reduce features' maintenance costs.

**When it doesn’t pay off:**

- No centralized “feature platform” culture (rare).

### 🏛️ Legacy → New State Manager Migration

#### ✅ Legacy (with Clean Architecture)

- Older project already has clear **domain/data/presentation separation**; SM layer is thin.
- With **Lazy parity**, migrate features gradually — add thin adapters for new SM, keeping shared contracts (DTO, use‑cases, navigation, localization).
- **Low risk, high reuse (80–90%)**, ROI positive with only 1–2 migrated features.

#### ⚠️ Legacy (Spaghetti Code)

- State, business logic, and UI are mixed; first requires **extracting Core/Domain** (refactoring to Clean Architecture).
- This is an **upfront cost**, so ROI is **delayed**: benefits appear **after** cleanup.
- Short‑term, rewriting to a single SM may be easier, but for **long‑lived products** symmetry pays off post‑refactor.

### 🎯 Solution‑Provider Companies / SDK‑Focused Agencies

**When it applies:**

- Company maintains a library of ready solutions/templates (auth, payments, profile, push-notifications, etc), each implemented for multiple SMs.
- Architecture follows SOLID (OCP), making layers swappable.
- Clients get SM choice with prebuilt UX/UI templates.

**Why it’s profitable:**

- Feature cost drops by up to 80%, since core/domain/data/UI are already built.
- No SM debates — company offers multiple ready options.

**When it doesn’t pay off:**

- No template library or SM diversity is irrelevant to clients.

---

## Decision Flow — When to Turn On State‑Symmetry

### Decision Rules

```
New Feature
   ↓
Will it likely be reused on another SM within the horizon? (reuse possibility >= break-even %)
   ├─ NO → Build Single‑SM ✓
   └─ YES
Does the adapter budget fit? (target ≤200 LOC, hard cap 300, exception AVLSM-track-like features)
   ├─ YES → Symmetry is viable
   └─ NO  → Keep Single‑SM or simplify scope
```

### Metrics to Track

- **Reuse Rate** — % of shipped features later ported to another SM/app.
- **Adapter Delta** — adapter LOC ÷ total feature LOC (target **≤5%**; alert at **>50%**).
- **Lead Time to Parity** — time from green‑light to parity feature in 2nd SM.
- **Adapter Defect Rate** — issues per 1k adapter LOC (should be near‑zero with thin seams).
- **Symmetry Budget Adherence** — % of features staying within ≤200 LOC (or approved exceptions up to 300 LOC).

### 🧮 Decision Matrix: “When to Use the State‑Symmetric Approach”

| Company/Scenario | Characteristics | 🧪 ROI from Symmetry|| Verdict |
| -------------------------------- | ---------------------------------------------- | ------------------- || ------------------------------------------------ |
| **Single‑product company** | One product, one SM, long lifecycle | ❌ Negative || Stick to one SM, avoid overhead |
| **Startup (MVP)** | Fast delivery, constant pivots, chaos | ❌ Negative || Symmetry wasteful, better copy‑pasting |
| **Agency (Pattern A)** | Standardized on one SM, enforce on clients | ❌ Negative || Use boilerplate, single SM expertise |
| **Agency (Pattern B)** | Tailor per client, no reuse across projects | ⚠️ Weak Positive || Symmetry not needed, better with quick templates |
| **Agency (Pattern C)** | ≥2 clients with different SMs within horizont | ✅ Positive || Break‑even from 2nd client |
| **Multi‑product company** | Multiple apps, one stack, ~70% feature overlap | ⚠️ Conditional || ROI if SMs differ (legacy/new), else no |
| **White‑label vendor** | Core + branded skins | ✅ Strong || Ideal if partners demand different SMs |
| **Platform team** | Builds modules for multiple products | ✅ Maximum || Always profitable |
| **Legacy (with CA) migration** | Clean layers, thin SM | ✅ Positive || Lazy parity = low risk, high reuse |
| **Legacy (spaghetti) migration** | Must extract core/domain first | ⚠️ Delayed || ROI only **after** cleanup |
| **Solution‑provider companies** | Prebuilt templates across SMs | ✅ Maximum || Perfect fit, but rare |

---

### 📌 Summary

Approach brings business value when **feature's reuse probabilty exceeds break-even probability** and **UI/flows overlap ≥ ~70%**.

#### Best Fits

- **Agencies (Pattern C):** ≥2 clients with different SMs → profitable from 2nd client.
- **Multi‑product companies:** similar UX with SM divergence.
- **White‑label vendors:** core product + skins, partner SM choice.
- **Platform teams:** long‑lived shared modules.
- **Legacy → new SM (Clean Arch):** low‑risk migration, high reuse.
- **Solution‑providers:** prebuilt multi‑SM templates → 85+% savings.

#### Poor Fits

- **Single‑product teams** locked to one SM.
- **Startups/MVPs** with chaotic scope.
- **Divergent UX apps** (different design systems/flows).

In other words, this is useful for teams/projects ready to pay a “overhead” as **insurance** against future reuse across SMs. For all others (single product, startups, single‑SM companies) → overhead is unjustified.

---

## Solo Development / Skilled Indie Teams

Unlike moderate applicability for general teams (< 5% niche), for **skilled solo devs or indie teams this approach is usually profitable** because:

- **Overhead/Maintenance tax ≈ <3%** — AI (with given strict requirements and criteria) can generate adapters/seams in minutes; feature test overhead rises only slightly.
- **Initial cost ≈ 0%** — developer already knows multiple SMs; principles are simple; no team sync needed.
- **Each reuse brings clean 15–85% savings**.

By applying **Lazy parity** and seeing symmetry as **cheap insurance against future reuse** (modest overhead, high code's reuse), therefore, this approach is rational for most features, built around mainstream state-model patterns (such as the Data–Error–Loading states).

## 📌 Overall Conclusion

The **State‑Symmetric Architecture** is economically justified when reuse probability exceeds **break-even probability**, offering measurable ROI and long‑term savings.

Additionally, three intangible but critical benefits:

- **Developer Experience** — one consistent coding model across state managers eliminates mental switching, improving speed and reducing errors.
- **Maintainability** — fixes and improvements are applied once in the shared layer and reused across apps/SMs, preventing divergence and lowering long-term support costs.
- **Time-to-Market** — code reuse shortens feature delivery cycles. New features ship significantly faster since ~90% of the code is already shared and validated.

## 5. Decision Framework — When Symmetry Pays Off

### ✅ **SCSM Track: Adopt by Default**

**When to use:**

- Building ≥2 features with **form inputs + submission** (auth, settings, contact, etc.)
- Reuse probability ≥10% across apps with different state managers
- UI/UX similarity ≥70% (forms follow similar patterns)

**Decision rule:**

```text
IF (
  features_with_forms ≥ 2
  AND reuse_probability ≥ 10%
  AND ui_similarity ≥ 70%
) THEN
  → Adopt SCSM Track
  → Overhead amortizes rapidly (9.8% break-even at N=4)
```

**Why it's a no-brainer:**

- Most apps need ≥4 form features (sign-in, sign-up, forgot password, profile edit)
- Break-even at 9.8% is **lower than typical reuse rates**
- Overhead **disappears** by N=10 (4.0% break-even)

---

### ⚠️ **AVLSM Track: Adopt Selectively**

**When to use:**

- Building ≥10 features that **fetch and display async data** (dashboards, lists, profiles)
- Reuse probability ≥25% across apps
- Long-lived product (3+ years) with expanding data features

**Decision rule:**

```text
IF (
  async_features ≥ 10
  AND reuse_probability ≥ 25%
  AND product_lifespan ≥ 3_years
) THEN
  → Adopt AVLSM Track
  → Break-even at 25.6% (N=10) is achievable
ELSE
  → Skip AVLSM (negative ROI)
  → Use single-SM implementation
```

**When to skip:**

- Building <10 async features (overhead exceeds savings)
- Single-product company (no cross-SM reuse)
- MVP/prototype phase (premature optimization)

---

## 8. When NOT to Use State-Symmetric Architecture

- ❌ **Anti-Pattern #1: Premature Optimization**
  _Scenario:_ Startup builds 2 features with AVLSM "just in case"
  _Result:_ 6 months later, pivots to B2B → all features scrapped
  _Cost:_ Wasted 377 LOC overhead + team learning time
  _Lesson:_ Wait until reuse probability is measurable, not speculative

- ❌ **Anti-Pattern #2: Low UI Similarity**
  _Scenario:_ E-commerce app + admin panel (radically different design systems)
  _Result:_ Presentation layer NOT reusable → overhead unjustified
  _Cost:_ 148 LOC adapters used by 0 features
  _Lesson:_ Symmetry requires ≥70% UI/UX overlap

- ❌ **Anti-Pattern #3: Single-Product Lock-In**
  _Scenario:_ Company standardized on Riverpod, no other SM apps planned
  _Result:_ Zero reuse probability → negative ROI guaranteed
  _Cost:_ 148 LOC that will never pay back
  _Lesson:_ Only adopt if cross-SM reuse is likely (not hypothetical)

**Economic Anti-Patterns (Quick Checklist)**

- ❌ Single-product company (one app, one SM)
- ❌ Reuse probability <10% (SCSM) or <25% (AVLSM)
- ❌ UI/UX similarity <70%
- ❌ Team size <3 developers
- ❌ MVP/prototype phase (aggressive pivoting)
- ❌ No Clean Architecture discipline

**Decision test:** If ≥2 anti-patterns present → skip symmetry

---

## 6. Summary & Decision Rules

### 🏆 SCSM Track (Form Features)

```yaml
Overhead: 5.2% (148 LOC for 4 features)
Savings: 53.5% (1,518 LOC per migration)
Break-even: 9.8% reuse probability
ROI: 9.2× return (924%)
Verdict: ✅ Adopt by default for multi-app scenarios
```

**Decision rule:**

```text
IF building ≥2 form features → ALWAYS adopt SCSM
```

### ⚠️ AVLSM Track (Async Data Features)

```yaml
Overhead: 21.6% (377 LOC for 2 features)
Savings: 16.8% (294 LOC per migration)
Break-even: 128.6% → 25.6% at N=10
ROI: -22% at N=2 → profitable at N≥10
Verdict: ⚠️ Adopt only with ≥10 async features
```

**Decision rule:**

```text
IF (
  roadmap shows ≥10 async features
  AND reuse_probability ≥25%
) → Adopt AVLSM
ELSE → Skip (negative ROI)
```
