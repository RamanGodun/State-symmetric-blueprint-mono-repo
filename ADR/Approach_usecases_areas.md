# State-Symmetric Approach Use Case Areas

## 🎯 Niche Target Teams/Projects for “Clean Architecture + Thin Adapters (Lazy Parity)”

> This approach is **business‑valuable for a niche** (optimistically ~5–8% of the market) when reuse across apps/stacks is likely and presentation stays largely similar. Below are the profiles where it shines (and where it doesn’t).

### 🎯 Agencies (Outsourcing Companies)

**When it applies:**

- The company wants to minimize feature duplication to deliver similar apps quickly with different requirements (≥2 clients within planning horizon, each requiring different state managers, e.g., one wants BLoC, another — Riverpod).

**Why it’s profitable:**

- ROI becomes positive starting with the **second client** choosing a different SM. Only a thin adapter is needed (**~5–10% LOC**).

**When it doesn’t pay off:**

- The company standardizes under one SM and enforces it on all clients (common pattern).

### 🎯 Multi‑Product Companies

**When it applies:**

- 2+ apps for different segments (e.g., consumer app + admin app + white‑label app). They share **one design system** and **similar features** (auth, profile, payments).

**Why it’s profitable:**

- Enables parallel support across **different SMs** or migration between legacy BLoC ↔ new Riverpod.

**When it doesn’t pay off:**

- Products diverge strongly in UI/UX (Material vs Cupertino, radically different flows).

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

- Ensures **consistency across apps**.

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

- Company maintains a library of ready solutions/templates (auth, payments, profile), each implemented for multiple SMs.
- Architecture follows SOLID (OCP), making layers swappable.
- Clients get SM choice with prebuilt UX/UI templates.

**Why it’s profitable:**

- Feature cost drops by 85–90%, since core/domain/data/UI are already built.
- No SM debates — company offers multiple ready options.

**When it doesn’t pay off:**

- No template library or SM diversity is irrelevant to clients.

---

### 🧮 Decision Matrix: “When to Use the State‑Symmetric Approach”

| Company/Scenario                 | Characteristics                                | Reuse Probability | ROI from Symmetry | Verdict                                          |
| -------------------------------- | ---------------------------------------------- | ----------------- | ----------------- | ------------------------------------------------ |
| **Single‑product company**       | One product, one SM, long lifecycle            | <5%               | ❌ Negative       | Stick to one SM, avoid 5–10% overhead            |
| **Startup (MVP)**                | Fast delivery, constant pivots, chaos          | <10%              | ❌ Negative       | Symmetry wasteful, better copy‑pasting           |
| **Agency (Pattern A)**           | Standardized on one SM, enforce on clients     | <10%              | ❌ Negative       | Use boilerplate, single SM expertise             |
| **Agency (Pattern B)**           | Tailor per client, no reuse across projects    | ~15%              | ⚠️ Weak Positive  | Symmetry not needed, better with quick templates |
| **Agency (Pattern C)**           | ≥2 clients with different SMs within a year    | 30–50%            | ✅ Positive       | Break‑even from 2nd client                       |
| **Multi‑product company**        | Multiple apps, one stack, ~70% feature overlap | 20–30%            | ⚠️ Conditional    | ROI if SMs differ (legacy/new), else no          |
| **White‑label vendor**           | Core + branded skins                           | 40–60%            | ✅ Strong         | Ideal if partners demand different SMs           |
| **Platform team**                | Builds modules for multiple products           | 60–80%            | ✅ Maximum        | Always profitable                                |
| **Legacy (with CA) migration**   | Clean layers, thin SM                          | ~30%              | ✅ Positive       | Lazy parity = low risk, high reuse               |
| **Legacy (spaghetti) migration** | Must extract core/domain first                 | <15%              | ⚠️ Delayed        | ROI only **after** cleanup                       |
| **Solution‑provider companies**  | Prebuilt templates across SMs                  | 90–100%           | ✅ Maximum        | Perfect fit, but rare                            |

---

### 📈 Break‑Even Graph

```
ROI
│
│                    /
│                   /
│                  /
│                 /
│                /
│               /
│______________/__________________  → P(reuse)
              0.2   0.3

```

- Reuse ≤ 20% → ❌ Negative ROI
- Reuse 20–30% → ⚠️ Conditional (depends on roadmap)
- Reuse ≥ 30% → ✅ Positive ROI

---

### 📌 Summary

Approach brings business value when **P(reuse ≥ ~0.3)** and **UI/flows overlap ≥ ~70%**.

#### Best Fits

- **Agencies (Pattern C):** ≥2 clients with different SMs → profitable from 2nd client.
- **Multi‑product companies:** similar UX with SM divergence.
- **White‑label vendors:** core product + skins, partner SM choice.
- **Platform teams:** long‑lived shared modules.
- **Legacy → new SM (Clean Arch):** low‑risk migration, high reuse.
- **Solution‑providers:** prebuilt multi‑SM templates → 85–90% savings.

#### Poor Fits

- **Single‑product teams** locked to one SM.
- **Startups/MVPs** with chaotic scope.
- **Divergent UX apps** (different design systems/flows).

In other words, this is useful for teams/projects ready to pay a “5–12% feature tax” as **insurance** against future reuse across SMs. If features with similar UX/UI are reused, savings range **30–85%**.

For all others (single product, startups, single‑SM companies) → overhead is unjustified.

---

## Solo Development / High‑Skill Indie Teams

Unlike moderate applicability for general teams (<5–7% niche), for **skilled solo devs or indie teams this approach is usually profitable** because:

- **Overhead/Maintenance tax ≈ <3%** — AI (with given strickt requirements and criteria) can generate facades/adapters in minutes; feature test overhead rises only slightly.
- **Initial cost ≈ 0%** — developer already knows multiple SMs; principles are simple; no team sync needed.
- **Each reuse brings clean 40–85% savings** (e.g., in this monorepo, auth features had 80–94% code reuse).

For frequently reused features with identical UX/UI, savings reach **~60% per feature**.

By applying **Lazy parity** and seeing symmetry as **cheap (~1–3%) insurance against future reuse**, this approach is rational for most mainstream features.

For the author of this monorepo, with AI automation, the **state‑symmetric approach is the default coding style** — modest overhead, high reuse.
