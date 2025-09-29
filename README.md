# Blueprint Monorepo

![coverage][coverage_badge]
[![LICENSE][license_badge]](LICENSE)

---

## ✨ Overview

This modular showcase monorepo demonstrates an example of **90%+ state-agnostic Flutter codebase**.
(More than 90% of the code remains unchanged, regardless of whether the app uses **Riverpod**, **Cubit/BLoC**, or **Provider**.)

### ✅ Advantages

- **Code Reusability** → Shared modules can be reused across projects, improving efficiency and reducing time-to-market.
- **Development Flexibility** → Developers can seamlessly move between projects/teams with minimal context-switch overhead => easier scaling of teams during critical tasks
- **Scalability & Maintainability** → This approach requires/enforced clean architecture, that makes the codebase easier to maintain and extend.

### ⚠️ **Trade-offs**

- **Increased Complexity** (additional abstractions, wrappers, and files) => may add to the size of the codebase.
- **Higher Initial Investment** → More effort and resources are required upfront; onboarding may be slower for new contributors.

---

### 🧩 Two Identical Demo Apps

The repository includes **two demo applications**:

- One built with **Cubit**
- One built with **Riverpod**

Both apps share **identical functionality, UI, and UX**. The choice of Cubit and Riverpod was deliberate — it’s enough to **visualize the approach** and demonstrate interoperability:

- To migrate from **Cubit → Bloc**, simply replace method calls with event dispatching (replace Cubit with BLoC, add Events and adjust the DI bindings).
- To migrate from **Cubit → Provider**, slightly more changes are required, since Provider depends on `BuildContext` and usually integrates with `GetIt`. The process includes adjusting the DI bindings and replacing Cubit with equivalent Providers exposing symmetric methods.
- **Riverpod** stays the most state-agnostic, as it requires no external DI and integrates seamlessly.

(!) This shows that one well-structured base is sufficient for all these state managers.

### 🛠️ Foundation for State-Agnostic Apps

These apps are designed as a **foundation for maximum state-agnostic Flutter development**, with built-in support for:

- 🌐 **Localization** via `easy_localization` (with built-in widgets auto-localization and fallbacks, as well as for errors managing and overlays flow)
- 🎨 **Theming** and unified UI/UX (with dark/light/amoled themes, persistent states, text theme factories)
- 🧭 **Navigation** via GoRouter (with declarative auth-aware redirect)
- ✨ **Common animations** (page transitions, overlay/widget animations)
- ⚠️ **Error managing system** (with centralized declarative functional errors handling)
- 🪟 **Overlays system** (with queue, overlays engine/dispatcher and policy resolver)
  = 📄 **Loggers** (for lifecycle tracking of cubit/Bloc - [AppBlocObserver], for Riverpod - [ProviderDebugObserver])
- 🛠 **FormFields System** (with custom field factory + validation, localization, declarative inputs)

### 🔐 Demo Features

To visualize the accepted approach, the following **next features** were implemented:

- 👤 **Auth Flow**: Sign In, Sign Out, Sign Up
- 📧 **E-mail Verification**
- 🔑 **Password Management**: Change password, Reset password
- 🪪 **Profile** feature

These familiar features make it easier to understand and evaluate the **state-agnostic approach** in real-life use cases.

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
- 💥 `firebase_crashlytics`
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

## 🧠 Concept of State-Agnostic Style

The approach is based on strict separation of concerns:

- 🧱 **Core**: Logging, routing, DI, overlays, error handling
- **Core Layer** → reusable modules (DI, theming, overlays, navigation, forms, localization, error handling).
- **Features Layer** → feature-driven modules (`auth`, `profile`, `password actions`, etc).
- **Adapters Layer** → thin bridges to chosen state manager (`bloc_adapter`, `riverpod_adapter`).
- **App Bootstrap** → environment configs & initialization.
- **Firebase Adapter** → seamless Firebase integration.

### Key Architectural Decisions

- Shared layers (`data → domain → presentation`) are **state-independent**.
- Adapters only implement bindings for a specific state manager.
- Dependency injection handled via **GetIt**.
- Navigation unified with **GoRouter factories** per adapter.
- Unified error handling & overlays system.

See [`ADR.md`](ADR/ADR.md) for full decision records.

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

#### Firebase configured via `.env` + `flutter_dotenv`

Use granted `.env` files or create your owns, in this case:

1. ```bash
   flutterfire configure --project=<your_project_id>
   ```

````
2. After firebase configuration put into created `.env` files next info:
```env
FIREBASE_API_KEY=...
FIREBASE_APP_ID=...
FIREBASE_PROJECT_ID=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_STORAGE_BUCKET=...
FIREBASE_AUTH_DOMAIN=...
FIREBASE_IOS_BUNDLE_ID=...
````

---

## 🧪 Testing Strategy

Designed with the testing pyramid in mind:

- ✅ **Unit tests**: UseCases, Repos, Providers (via injected mocks)
- 🧩 **Widget tests**: Stateless widgets & UI behavior
- 🔁 **Integration tests**: Can be added progressively

---

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
