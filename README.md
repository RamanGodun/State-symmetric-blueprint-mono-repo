# Blueprint Monorepo

![coverage][coverage_badge]
[![LICENSE][license_badge]](LICENSE)

---

## ✨ Overview

This modular showcase monorepo demonstrates an example of **State-symmetric architecture codestyle**.
(More than 90% of the code remains unchanged, regardless of whether the app uses **Riverpod**, **Cubit/BLoC**, or **Provider**.)

Clean Architecture + optional thin adapters (lazy parity)

### Accepted architecture decisions records

Accepted architecture decisions records are in [`ADR.md`](ADR/ADR-001-State-symmetric-architecture.md).

---

## 🧠 Files structure

The monorepo is structured into **two fully symmetrical apps (Cubit-based and Riverpod-based) and **packages/\*\*

```files tree
|
├── apps/                        # Symmetric demo-apps
│   ├── cubit_app/
│   │   ├── app_bootstrap/
│   │   ├── core/
│   │   │   ├── base_modules/
│   │   │   ├── shared_presentation/
│   │   │   └── utils/
│   │   └── features_presentation/
│   │       └── ...
|   |
│   └── riverpod_app/
│       ├── app_bootstrap/
│       ├── core/
│       │   ├── base_modules/
│       │   ├── shared_presentation/
│       │   └── utils/
│       └── features_presentation/
│           ├── ...
│
├── packages/                    # Flutter-packages, that plugs-in to apps
│   ├── app_bootstrap/
│   ├── core/
│   ├── features/
│   ├── firebase_adapter/
│   ├── bloc_adapter/
│   └── riverpod_adapter/
│
|
├── ADR/                         # Architecture Decision Records
├── melos.yaml                   # Monorepo manager
├── pubspec.yaml
├── README.md
└── LICENSE
```

The next overall structure follows a universal organizational principle applied consistently to apps and packages.
**Each object (an app or a package) is divided into three major areas**:

- **`app_bootstrap/`** → everything related to application setup and initialization
  (DI, configs, environment).
- **`core/`** → shared codebase, split into general `utils` and `base_modules`
  (navigation, overlays, localization, theming, error handling, etc.), shared layers (`presentation`, `domain`, `data`).
- **`features/`** → feature-first design containing UI, view, and state-manager logic.
  The deeper layers (use cases, repositories, gateways) live in dedicated shared Flutter packages like [`features/`] or [`firebase_adapter/`].

  In another words:

- If something relates to **app startup**, it is always in `app_bootstrap`
  (with reusable parts extracted into the [app_bootstrap] package).
- If it’s a **feature**, its **presentation layer** stays inside the app (`features_presentation/`),
  while its **domain/data layers** live in the shared [features] package.
- All **Firebase-related code** belongs exclusively to the [firebase_adapter] package,
  making it easy to swap with another backend (e.g., Supabase, Isar).

  Inside **`core/`** (both in apps and packages), files are organized with the following rules:

1. If code belongs to a **fundamental module** (localization, overlays, UI design, navigation, animations, error handling, forms, loggers, push-notification, etc)
   → **put it in** `base_modules/`.

2. If code is reused but scoped to a **single architectural layer** only (e.g., a model used only in domain, or a widget used only in presentation)
   → **put it in** `shared_domain/`, `shared_data/`, or `shared_presentation/`.

3. If the code is **generic and cross-cutting**, and does not fit the above categories
   → **put it in** `utils/`.

- This systematic organization approach ensures every piece of code has a natural home, making the monorepo's codebase
  **predictable, scalable, discoverable and maximum-possibly state-agnostic with clear boundaries**.

## 🧩 Two Symmetric Demo Apps and shared custom packages

**Both apps share identical functionality, UI, and UX**.

📱 [Cubit Demo App](apps/cubit_app/README.md)
A fully functional demo built with **Cubit**, showcasing the state-agnostic architecture in action.
Demonstrates how Cubit integrates with `core`, `features`, and `adapters` while keeping **90% of the codebase unchanged**.

📱 [Riverpod Demo App](apps/riverpod_app/README.md)
A symmetrical demo app built with **Riverpod**, featuring the exact same functionality and UI/UX as the Cubit app.
Proves that the architecture is truly **state-agnostic** and reusable across different state managers.

The choice of Cubit and Riverpod was deliberate — it’s enough to **visualize the approach** and demonstrate interoperability:

- To migrate from **Cubit → Bloc**, simply replace method calls with event dispatching (replace Cubit with BLoC, add Events and adjust the DI bindings).
- To migrate from **Cubit → Provider**, slightly more changes are required, since Provider depends on `BuildContext` => use `GetIt`.
  The migration's process includes adjusting the DI bindings and replacing Cubit with equivalent Providers exposing symmetric methods. Also there are need to develop thin adapters

(!) This shows that one well-structured base is sufficient for all these state managers.

### 🔐 Demo Features

These apps are designed as a **foundation for small-mid size apps with codestyle, almost agnostic to state-managers**, also there is built-in support for:

- 🌐 **Localization** via `easy_localization`
([docs](<packages/core/lib/src/base_modules/localization/README(localization).md>))
   <!-- (with built-in widgets auto-localization and fallbacks, as well as for errors managing and overlays flow) -->

- 🎨 **Theming** and unified UI/UX
([docs](packages/core/lib/src/base_modules/ui_design/Theme_module_README.md))
  <!-- (with dark/light/amoled themes, persistent states, text theme factories) -->

- 🧭 **Navigation** via GoRouter
([docs](<packages/core/lib/src/base_modules/navigation/README(navigation).md>))
  <!-- (with declarative auth-aware redirect) -->

- ✨ **Common animations**
([docs](<packages/core/lib/src/base_modules/animations/README(animations).md>))
  <!-- (page transitions, overlay/widget animations) -->

- ⚠️ **Error managing system**
([docs](<packages/core/lib/src/base_modules/errors_management/README(errors_handling).md>))
  <!-- (with centralized declarative functional errors handling) -->

- 🪟 **Overlays system**
([docs](<packages/core/lib/src/base_modules/overlays/README(overlays).md>))
  <!-- (with queue, overlays engine/dispatcher and policy resolver) -->

- 🛠 **FormFields System**
([docs](<packages/core/lib/src/base_modules/form_fields/README(form_fields).md>))
  <!-- (with custom field factory + validation, localization, declarative inputs) -->

- 📄 **Loggers**
  ([AppBlocObserver](packages/bloc_adapter/lib/src/base_modules/observer/bloc_observer.dart),
  [ProviderDebugObserver](packages/riverpod_adapter/lib/src/base_modules/observing/providers_debug_observer.dart))

  **To visualize the accepted approach, also the following next features were implemented**:

- 👤 **Auth Flow**: Sign In, Sign Out, Sign Up
- 📧 **E-mail Verification**
- 🔑 **Password Management**: Change password, Reset password
- 🪪 **Profile** feature

* These familiar features make it easier to understand and evaluate the **state-agnostic approach** in real-life use cases
  (⚠️ also note, that perfect UI/UX app design was not the primary goal of this monorepo)

### Created and used custom Flutter packages

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

([docs](<packages/riverpod_adapter/README(riverod_adapter).md>)).

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

---

## 🚀 Usage & Setup

### Getting Started 🚀

```bash
# Clone the repository
git clone https://github.com/RamanGodun/State-agnostic-blueprint-mono-repo
cd blueprint_monorepo
flutter run

# Install Melos (monorepo manager)
dart pub global activate melos

# Bootstrap all packages
melos bootstrap

# To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:
flutter run --flavor development --target lib/main_development.dart # Development flavor
flutter run --flavor staging --target lib/main_staging.dart # Staging flavor
# Currently `main_production.dart` was deleted, as there is no intentions to deploy this code
```

### ⚙️ Firebase Configuration

- Firebase configured via `.env` + `flutter_dotenv`
- Use granted `.env` files or create your owns, in this case:

1. ```bash
   flutterfire configure --project=<your_project_id>
   ```
2. After firebase configuration put into created `.env.dev` and/or `.env.staging` files next info:

```env
FIREBASE_API_KEY=...
FIREBASE_APP_ID=...
FIREBASE_PROJECT_ID=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_STORAGE_BUCKET=...
FIREBASE_AUTH_DOMAIN=...
FIREBASE_IOS_BUNDLE_ID=...
```

### Check supported Locales

Check the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist`, where should be included next locales:

```xml
    ...
	<!-- Localization -->
	<key>CFBundleLocalizations</key>
	<array>
   	<string>en</string>
   	<string>uk</string>
		<string>pl</string>
	</array>
	<!-- Localization -->
    ...
```

---

## 🧪 Testing Strategy

Designed with the testing pyramid in mind:

- ✅ **Unit tests**: UseCases, Repos, Providers (via injected mocks)
- 🧩 **Widget tests**: Stateless widgets & UI behavior
- 🔁 **Integration tests**: Can be added progressively

  ### Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
# Run all tests with coverage
melos run test
$ very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/
# Open Coverage Report
$ open coverage/index.html
```

\_\*Alternatively, run `flutter run` and code generation will take place automatically.

## License

This monorepo is licensed under the [LICENSE](LICENSE).

[coverage_badge]: coverage_badge.svg
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
