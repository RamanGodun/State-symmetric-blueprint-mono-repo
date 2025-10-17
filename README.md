# Blueprint Monorepo

## ✨ Overview

This monorepo demonstrates a **State-Symmetric architecture code style** — a pragmatic refinement of state-agnostic principles, that keeps 85–90% of the codebase unchanged across different state managers (Riverpod, Cubit/BLoC, Provider).

**The approach combines:**

- **Clean Architecture** with strong layer separation — state managers orchestrate state only; UI remains thin and stateless.
- **Thin adapters/facades** (2–7 touchpoints per feature) that bridge shared code to specific state managers
- **Lazy Parity**: only one active state manager (and its thin facades) is implemented and compiled.
  Other SM code (their adapters + glue) is created only **on demand**, not upfront — avoiding parity maintenance cost while still enabling 90+% codebase’s reuse.

Accepted Architecture Decision Record: **[ADR-001 — State-Symmetric Architecture](ADR/ADR-001-State-symmetric-architecture.md)**

### Key Metrics (Measured)

## Aspect Target Reality

## UI parity 95–100% ✅ Widgets/screens visually identical

## Presentation parity 85–90% ✅ Thin wrappers only

## Adapter overhead ≤5–10% amortized ✅ 15–35% first feature → ≤5–10% after 3-4+ features

## Migration savings 40–80% ✅ Auth: 58–59%, Profile: 9–11% (first feature)

### **Business Value:**

State symmetry **acts as low-cost insurance (~15–35% LOC upfront, amortized to ≤5–10%) that pays off when**:

- Probability of feature's reuse (in app with another SM) ≥15–25% within planning horizon
- UI/UX feature's similarity is ≥70% across target apps

It is **most valuable for a niche (~5–10%)**: multi-product companies, white-label vendors, agencies with diverse client requirements, platform/SDK providers. **Solo developers and skilled indie teams** benefit even more. With automation and one-person context, the effective overhead often drops to **<3%**, while reuse opportunities are high across gigs/products — so, for them the approach is usually **net-positive by default** for most mainstream features.

See also:

- **Use Case Areas** → [`info-001-use-case-areas.md`](ADR/supporting_info/info-001-use-case-areas.md)
- **Business Value Estimates** → [`info-002-business-value-estimates.md`](ADR/supporting_info/info-002-business-value-estimates.md)
- **Critics reply** [`info-003-critics_reply.md`](ADR/supporting_info/info-003-critics_reply.md)

## Getting Started 🚀

Щоб запустити додатки дивись відповідні секціх Readme файлів відповідних додатків. (тут мають бути посилання на ці документи)

#### Riverpod app

```sh
# Dev flavor
melos run run:rp:dev
# Staging flavor
melos run run:rp:stg
```

## 🧠 Files structure

The monorepo is structured into **two fully symmetrical apps (BLoC/Cubit and Riverpod)** and **packages/**

```files tree
|
├── apps/                        # Symmetric demo-apps
│   ├── app_on_bloc/lib/         # BLoC/Cubit implementation
│   └── app_on_riverpod/lib/     # Riverpod implementation
│
├── packages/                    # Shared Flutter-packages, that plugs-in to apps
│   ├── app_bootstrap/           # Startup & initialization logic
│   ├── core/                    # Shared foundation (modules + layers)
│   ├── features/                # Domain & data layers for features
│   ├── firebase_adapter/        # Firebase integration layer
│   ├── bloc_adapter/            # BLoC/Cubit glue code
│   └── riverpod_adapter/        # Riverpod glue code
│
|
├── ADR/                         # Architecture Decision Records
│   ├── ADR-001-State-symmetric-architecture.md
│   └── supporting_info/
|
├── scripts/                     # Build & dev automation scripts
├── .vscode/                     # IDE launch configurations
├── melos.yaml                   # Monorepo manager
├── pubspec.yaml
├── README.md
└── LICENSE
```

### Organizational Principles

The monorepo's files structure follows an universal organizational principles applied consistently to apps and packages.

**Apps and packages share a consistent three-tier structure:**

1. **`app_bootstrap/`** → everything related to application setup and initialization
   (DI, platform validation, environment configuration, all initial app's setup/initialization). Reusable parts extracted into the [app_bootstrap] package.

2. **`core/`** → Shared foundation organized by concern:
   - `base_modules/` - Cross-cutting infrastructure (navigation, overlays, theming, localization, forms, etc.)
   - `shared_{domain|data|presentation}/` - Layer-specific reusable code (eg, shared widgets/pages in presentation layer; entities/domain_extensions - in domain; DTOs/cache managers/mappers - in data)
   - `utils/` - Generic cross-cutting helpers, that don't fit elsewhere

3. **`features/`** → Feature-scoped code with clear separation:
   - In apps: UI + presentation logic only
   - In packages: domain + data layers only
     So, deep layers (feature's use cases, repositories, gateways) live in dedicated packages (features/, firebase_adapter/).

### Key Design Decisions

- **Firebase isolation**: All Firebase code lives in `firebase_adapter/` → easy to swap backends
- **State manager adapters**: Thin glue layers (`bloc_adapter/`, `riverpod_adapter/`) bridge core/features to specific state management
- **Predictable placement**:
  - Startup code → always in `app_bootstrap/`
  - Cross-cutting modules / infra → always in `base_modules/`
  - Layer-specific shared code → in `shared_{layer}/`
  - Feature business logic → in `packages/features/`
  - Feature UI → in `apps/*/features/`

This systematic organization ensures **every piece of code has a natural home with clear boundaries**, making the codebase predictable, scalable, and maximally flexible.

## 🧩 Two Symmetric Demo Apps and shared custom packages

**Both fully functional demo apps share identical functionality, UI, and UX**, showcasing the state-symmetric architecture in action.

📱 [Cubit Demo App](apps/app_on_bloc/README.md)
Showcases how Cubit integrates with `core`, `features`, and `adapters` while keeping 85–90% of the codebase unchanged.

📱 [Riverpod Demo App](apps/app_on_riverpod/README.md)
A symmetrical demo app built with **Riverpod**, featuring the exact same functionality and UI/UX as the Cubit app.
Proves that the architecture is truly **state-symmetric** and reusable across different state managers.

The choice of Cubit and Riverpod was deliberate — it’s enough to **visualize the approach**, demonstrate interoperability and the migration path:

- **Cubit → BLoC**: replace method calls with event dispatching (swap Cubit for BLoC, add Events, adjust DI bindings).
- **Cubit → Provider**: slightly more changes. Since Provider depends on `BuildContext`, use **GetIt** (as in BLoC/Cubit apps), adjust DI bindings, replace Cubit with equivalent Providers exposing symmetric methods, and **add thin adapters**.

**Key insight:** One well-structured base is sufficient for Cubit, BLoC, Riverpod, and Provider.

## Created and used custom Flutter packages

#### 📦 [App Bootstrap].

([docs](<packages/app_bootstrap/README(app_bootstrap).md>))

<!--
Provides a deterministic startup pipeline shared by all apps — platform validation, env loading, storage init,
Firebase config, and DI setup. Keeps app bootstrapping **consistent and agnostic to state-manager technology**.
 -->

#### 📦 [Core].

([docs](<packages/core/README%20(core%20package).md>))

<!--
Holds the **base modules** (navigation, overlays, theming, localization, forms, animations, error handling)
and shared **data/domain/presentation layers**. Ensures code reusability and clean architecture boundaries.
This package is **consistent and agnostic to state-manager technology**.
 -->

#### 📦 [Features]

([docs](<packages/features/README(features).md>)).

<!--
Implements reusable **domain and data layers** for app features (Auth, Email Verification, Password Reset/Change, Profile).
Designed to be **consistent and agnostic to state-manager technology**, so features plug into Cubit, BLoC, or Riverpod apps without changes.
-->

#### 📦 [Firebase Adapter]

([docs](<packages/firebase_adapter/README(firebase_adapter).md>)).

<!--
Centralizes Firebase initialization, gateways, and utils. Prevents Firebase SDK leakage into apps/features,
making backend **swappable** (e.g., in future can be easily replaced with another remote database).
 -->

#### 📦 [BLoC Adapter]

([docs](packages/bloc_adapter/README.md)).

<!--
Provides lightweight glue between `core`/`features` and the BLoC ecosystem. Ships **observers, DI helpers, theming, overlays**,
and BLoC-friendly widgets, making BLoC/Cubit integration seamless/ergonomic and keeping business logic isolated from presentation.
 -->

#### 📦 [Riverpod Adapter]

([docs](<packages/riverpod_adapter/README(riverpod_adapter).md>)).

<!--
Supplies ready-made providers for Firebase, features, and UI modules. Adds **error handling, overlays, theming**,
and global DI container support, making Riverpod integration seamless/ergonomic and keeping business logic isolated from presentation.
 -->

---

## 📲 Tech Stack

### ⚡ State Management & DI

- 🌱 **Riverpod**: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- 🧩 **BLoC / Cubit**: `flutter_bloc`
- 🛠 **GetIt** (dependency injection)
- 🚀 **Productivity**: `equatable`, `rxdart`

  ### 🎯 Framework & Language & Navigation/Routing

- 🐦 **Flutter SDK** (>=3.22, SDK ^3.8.0)
- 🌐 **easy_localization** (with codegen & keys generation)
- 🧭 **go_router** (auth-aware navigation with declarative redirects)

  ### 🔥 Firebase & Local Storages

- 🔑 `firebase_core`
- 👤 `firebase_auth`
- 📂 `cloud_firestore`
- 📜 `flutter_dotenv` (env configs & secrets)
- 💾 `hydrated_bloc`, `get_storage`
- 📦 `path_provider`

  ### 🎨 UI & Theming

- 🎨 **Theme system** (dark/light/amoled, persistent states, text theme factories)
- 🕸 **Spider** (assets path generator)
- 🪝 **UI Hooks**: `flutter_hooks`
- 🖼 **cached_network_image**
- 📝 **Forms & Validation**: `formz`

  ### 🧪 Testing

- 🧾 **flutter_test**
- 🎭 **mocktail**
- ✅ **very_good test runner**
- 📊 Coverage reporting via **lcov**

  ### ⚙️ Tooling & Code Quality

- 📦 **Melos** (monorepo manager: bootstrap, scripts, CI)
- 🧩 **build_runner** (codegen orchestrator)
- 🖼 **flutter_launcher_icons** (per-flavor icons)
- 🔍 **very_good_analysis** (linting ruleset by Very Good Ventures)
- 📏 **custom_lint** (Riverpod-related rules)
- 📊 **dart_code_metrics** (static analysis + HTML reports)
- 📝 **commitlint** + **husky** + **lint-staged** (commit conventions, pre-commit checks)
- 🤖 **GitHub Actions CI** (tests, analysis, coverage)
- 📈 **lcov** (coverage visualization)
- 🏷 **meta** (annotations)

## 🧪 Testing Strategy

This monorepo is focused on **demonstrating the State-Symmetric architecture** and providing **business value measurements**, rather than exhaustive testing.
Most of the underlying codebase was previously tested in the production apps it originated from, so additional coverage was not the primary goal here.

👉 The testing infrastructure is already wired (unit, widget, coverage, CI). As time allows, tests will be progressively added for the code that lives in this repo (following the testing pyramid).

### Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
# Run all tests with coverage
melos run test
melos run vg:test
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/
# Open Coverage Report
$ open coverage/index.html
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This monorepo is licensed under the [![LICENSE][license_badge]](LICENSE).
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg

## 📚 Additional Resources

- 📖 [Architecture Decision Records](ADR/)
- 🎯 [Use Case Areas](ADR/supporting_info/info-001-use-case-areas.md)
- 📈 [Business Value Analysis](ADR/supporting_info/info-002-business-value-estimates.md)
- 💬 [Addressing Critics](ADR/supporting_info/info-003-critics_reply.md)
- 🔧 [Melos Configuration](melos.yaml)

**Built with 🧠❤️ to demonstrate pragmatic state-symmetric architecture**
