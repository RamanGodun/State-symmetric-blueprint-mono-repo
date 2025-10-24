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
