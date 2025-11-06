# ADR-00X: Theme & Preferences — Declarative, Symmetric, Cached

## 1. 🎯 Context (Problem & Goals)

Within the **State‑Symmetric Architecture (SSA)**, apps built with different state managers (**Cubit/BLoC** and **Riverpod**) must share the same UI while keeping state orchestration isolated. Theming is a cross‑cutting concern that directly impacts:

- **Visual consistency** across all demo apps in the monorepo
- **Developer experience** when switching between state managers
- **Performance** (avoiding expensive, repeated theme rebuilds)
- **Maintainability** (single source of truth for design tokens/typography)

**Core challenge.** Traditional approaches often couple theme state to a specific state manager (context‑bound providers, manager‑specific APIs), breaking SSA: identical UI becomes impossible when theme logic is tied to one stack.

**Goals.**

- Provide **shared theme models** usable in any app
- Keep **presentation symmetric**: identical `MaterialApp.router` configuration in all apps
- Isolate **state orchestration** in **thin adapters** per state manager
- Ensure **persistence** (theme survives restarts)
- Optimize **performance** with granular subscriptions and caching
- Keep **overhead minimal** (adapters are small and local to each stack)

> Scope: This ADR documents what **already exists** in the repo (Bloc & Riverpod). Provider is **not** part of this module.

---

## 2. ✅ Decisions

### 2.1 Adopted Architecture (Three Layers)

**Presentation (Shared UI)**

- Consumes resolved `ThemeData` (light/dark) in `MaterialApp.router`
- Uses **granular selectors** for `mode`, `font`, and `theme` variant
- The root view widgets are **identical** across apps; only the _reading_ mechanism differs

**Core Domain (Shared Models & Generation)**

- `ThemePreferences` — immutable DTO with selected `ThemeVariantsEnum` and `AppFontFamily`
- `ThemeVariantsEnum` — supported variants: **light**, **dark**, **amoled**
- `TextThemeFactory` — centralized typography (primary/accent families)
- `ThemeVariantX` — builds complete `ThemeData` per variant using design tokens
- `ThemeCacheMixin` — caches `(variant, font) → ThemeData` for performance

**State‑Manager Adapters (Thin Glue)**

- **Bloc/Cubit**: `AppThemeCubit` on `HydratedCubit` for persistence
- **Riverpod**: `themeProvider` (`StateNotifier<ThemePreferences>`) + `GetStorage` for persistence

### 2.2 Design Principles

- **Separation of concerns**: core owns tokens/models/generation; adapters own orchestration/persistence; apps only consume `ThemeData`
- **Immutable configuration model**: preferences represent _what_ to render; `ThemeData` represents _how_
- **Lazy generation with caching**: avoids redundant `ThemeData` work
- **Granular subscriptions**: subscribe to `mode`, `font`, `theme` instead of entire preferences
- **Symmetric API surface**: adapters expose equivalent operations (`setTheme`, `setFont`, `toggleTheme`)

### 2.3 Integration (Current Repo State)

- **Bloc app**: `AppThemeCubit` state is read via granular selectors; themes are built once per change using cache and passed to `MaterialApp.router`
- **Riverpod app**: `themeProvider` is read with `.select(...)` for the same granular props; themes are built identically and passed to `MaterialApp.router`
- **Typography**: `TextThemeFactory` defines consistent primary/accent families used across variants
- **Design tokens**: colors/spacing/shadows live under `ui_constants/` in `core`

---

## 3. 🧨 Consequences

### ✅ Positive

- **True UI symmetry**: root view and theme building logic are identical across apps
- **Minimal adapter overhead**: thin, localized to each stack; persistence handled natively (HydratedBloc / GetStorage)
- **Performance**: cache eliminates redundant `ThemeData` work; granular selectors limit rebuilds
- **DX & testability**: shared mental model (preferences → cache → ThemeData); core logic tested once; adapters test state updates/persistence
- **Scalability**: adding a new variant or font touches only core enums/factories; no changes in adapters/UI

### ⚠️ Negative

- **Indirect access**: apps do not mutate `ThemeData` directly (must change preferences)
- **Adapter duplication**: persistence code differs between stacks and must be maintained in parallel
- **Learning curve**: three‑layer flow (preferences → cache → ThemeData) requires initial orientation
- **Cache invalidation**: when tokens change at runtime, cache must be cleared explicitly

---

## 4. 💡 Success Criteria & Alternatives

### 4.1 Success Criteria (for this module)

- **Symmetry**: identical `MaterialApp.router` wiring across Bloc & Riverpod apps
- **Overhead**: adapters remain thin (tens of LOC per stack)
- **Performance**: no observable regressions vs direct `ThemeData` usage; cache hit‑rate high during toggles
- **Reusability**: theme models/generation reusable across all apps without changes
- **Maintainability**: design token edits are localized to `core` only
- **Testing**: core theming logic covered at unit level; adapters cover persistence and state updates

### 4.2 Alternatives Considered (Rejected)

- **Abstract ThemeManager interface** — adds boilerplate and cross‑stack coupling; breaks ADR‑001’s “no global abstractions”
- **Single ThemeService with conditional logic** — mega‑adapter anti‑pattern; couples all stacks; hurts testing and modularity
- **Direct `ThemeData` state** (no preferences) — heavy copies, poor caching, harder tests; mixes _what_ and _how_
- **Build‑time-only configuration (.env)** — no runtime switching/persistence; unsuitable for user preferences

---

## 5. 📝 Summary

The module delivers **declarative, symmetric theming** with **cached `ThemeData`** generation and **thin per‑stack adapters**. UI remains identical across Bloc and Riverpod apps; orchestration/persistence is isolated to adapters; tokens and typography are centralized in `core`. The approach aligns with SSA goals: maximum shared code, minimal glue, predictable performance.

---

## 6. 🔗 Related Info

### Related ADRs

- [ADR-001 State-Symmetric Architecture](./ADR-001-State-symmetric-architecture.md)
- [ADR-002 Context-Free-DI.md](ADR-002-Context-Free-DI.md)
- [ADR-003 GoRouter-navigation](ADR-003-GoRouter-navigation.md)
- [ADR-004 EasyLocalization](ADR-004-EasyLocalization.md)
- [ADR-005 Errors-management](ADR-005-Errors-management.md)
- [ADR-006 Overlays-management](ADR-006-Overlays-management.md)

### Module Docs & Sources (current repo)

- `core/src/base_modules/ui_design/module_core/…` — preferences, variants, cache, factories
- `core/src/base_modules/ui_design/text_theme/…` — typography factory & font enums
- `core/src/base_modules/ui_design/ui_constants/…` — colors, spacing, shadows, tokens
- `bloc_adapter/src/core/base_modules/theme_module/…` — `AppThemeCubit` and widgets
- `riverpod_adapter/src/core/base_modules/theme_module/…` — `themeProvider` and widgets
- App shells (`apps/app_on_cubit/*`, `apps/app_on_riverpod/*`) — identical `MaterialApp.router` wiring
