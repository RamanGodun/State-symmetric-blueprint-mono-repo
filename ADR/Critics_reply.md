# State‑Symmetric Monorepo: Business Value, Critique & Rebuttal

This is a concise, business‑facing summary of the approach where a shared Core and Features layer is reused across apps, with _thin_ adapters for different state managers (BLoC or Riverpod). In production, **only one adapter is compiled**; others remain for education/migration. The observed delta between adapters is **<5%** of total Dart code.

---

## 1) Executive Summary

Regarding the critique that “state‑symmetric architectures are outdated / over‑engineered”: the approach produces **low operational overhead** (≈5–10%) and **very high reuse** of business logic/UI components across apps and clients. It is **not** the heavy, state‑agnostic pattern the critique targets.

---

## 2) What the Critics Claim vs. What We Actually Do

| Topic        | Critique (generic)                          | Our Implementation                                                                                       |
| ------------ | ------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Purpose      | "Abstraction for its own sake"              | Reuse Core across teams/clients; adapters exist only where switching SM brings ROI.                      |
| Overhead     | +25–50% maintenance; ~10–15% duplicate code | **Observed:** adapters & app shells are **at 5% LOC**; single‑adapter prod builds; parity CI is minimal. |
| Team Impact  | High cognitive load; high entry point       | Indeed for new developer, but after reaching of plato of education curve approach brings significant ROI |
| Runtime Cost | Larger binaries, slower apps                | Tree‑shaking keeps only the selected adapter; no runtime penalty.                                        |
| Scalability  | "More layers ≠ more scalable"               | Approach foundation - enforced clean clen architecture, adapters are thin and localized, not the case    |

> **Bottom line:** The critique is valid for _heavy, state‑agnostic_ stacks. It **does not** apply to a **thin‑adapter monorepo** with one adapter per prod flavor.

---

## 3) Cost Model (Realistic)

**Assumptions (observed):**

- Adapter LOC across repo: **~3–5%**.
- Parity operations (tests, CI matrix) when both adapters matter: **+5–10%** overhead.
- Production uses **one** adapter → parity cost approaches **0–3%** (smoke only).

**Implication:** The economics the critique relies on (10–15% duplicate code → 25–50% overhead) **don’t hold** for this repo.

---

## 4) Where the Approach Pays Off

**A. Outsourcing/Agencies**

- Different clients pick different SMs. We reuse 95%+ of code, write a **thin facade** once per SM and reuse thereafter.
- On a second client, net savings are immediate: contracts & use cases drop in unchanged; only the adapter shell is swapped.

**B. Migrations & Experiments**

- Want to trial Riverpod on a single feature? Implement the thin facade in `riverpod_adapter` while preserving BLoC prod. Roll back risk‑free.

**C. Education & Hiring**

- Side‑by‑side adapters help onboarding and architectural literacy **without** burdening prod builds.

---

## 5) Where It Doesn’t (and What We Do Instead)

- **Single product, stable team, no client variability:** lock to one SM; keep the other adapter **disabled**. The monorepo still yields value via Core/Features reuse.
- **If parity pain grows:** freeze the non‑prod adapter (tag as experimental), keep only smoke CI on it.

---

## 6) Concrete Example: Shipping a Reusable Feature

**Goal:** Add a new Profile feature (domain + UI) and ship it to two apps: one BLoC, one Riverpod.

1. **Core/Features (shared):**
   - Define `ProfileRepo` contract, DTOs, use cases in `features/`.
   - Add localization keys, theming tokens (if needed) to `core/`.

2. **UI (shared):**
   - Stateless screen widgets & view components live in `core` (design system) or `features` presentation.
3. **Adapters (thin):**
   - `bloc_adapter`: a small Cubit/Bloc + a facade widget that wires the stateless view to Cubit.
   - `riverpod_adapter`: a small Notifier/Providers + a facade widget wiring the same stateless view.

4. **Apps:**
   - `app_on_bloc` depends on `bloc_adapter` only; `app_on_riverpod` depends on `riverpod_adapter` only.

**Net add:** Two tiny facades, **0 duplication** of use cases, DTOs, contracts, or Stateless "dumb" UI.

---

## 7) Metrics to Track (for Business Value)

- **Reuse Rate:** % of features ported to a new client with **no domain changes**.
- **Adapter Delta:** LOC and file count in adapters / total LOC (**target ≤5%**).
- **Lead Time for New Client:** time from contract signed → feature parity app.
- **Defect Rate in Adapters:** issues per 1k LOC (should be near‑zero if facades stay thin).

---

## 10) Conclusion for Stakeholders

- The state‑symmetric monorepo **is not** a heavy “state‑agnostic” stack; it’s **clean architecture + thin adapters**.
- With one adapter compiled per prod build and adapter code **<5%**, the overhead is modest while reuse is high.
- In agencies and multi‑client contexts, this is **direct business value** (faster delivery, consistent UX, better DX, safer migrations). In single‑product contexts, keep the second adapter disabled and still benefit from Core/Features discipline.

---

## Appendix: Why This Isn’t “Over‑Engineering”

- The heavy patterns critics cite add new abstraction layers everywhere. Here, we place **adapters only at the edge**, keeping domain and UI stateless and shared.
- The Core already centralizes localization, theming, navigation rules, overlays and error handling—**the parts that actually change least** and deliver maximum reuse.
- The result is a practical, evolvable codebase that aligns with how top product teams treat platforms: **shared kernel + edge adapters**, with production compiling **one** path.

Як посилити аргумент
• Введи жорсткі обмеження симетрії:
• Симетризуємо тільки 3–4 горизонталі з доведеним reuse-ROI : «side-effects/listeners», «async action/result», «UI events → domain commands», «screen lifecycle hooks».
• Заборона на «повну» симетрію (жодних універсальних VM/Store).
• Покажи SLOC-дельту: +N рядків/фіча для адаптерів і доведи, що це <5% від вартості фічі.
• Формалізуй «Symmetry Contract»: один markdown із 6–8 правил API-паритету + чекліст рев’ю.
