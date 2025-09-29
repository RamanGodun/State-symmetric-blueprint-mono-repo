# Blueprint Monorepo

![coverage][coverage_badge]
[![LICENSE][license_badge]](LICENSE)

---

## ✨ Overview

This modular showcase monorepo demonstrates how to build a **90%+ state-agnostic Flutter codebase**.
(More than 90% of the code remains unchanged, regardless of whether the app uses Riverpod, Cubit/BLoC, or Provider.)

✅ Advantages
• Code Reusability → Shared modules can be used across multiple projects, improving efficiency and saving time.
• Development Flexibility → Developers can seamlessly move between projects and teams, ensuring fast onboarding and easier scaling of teams during critical tasks.
• Scalability & Maintainability → Enforcing clean architecture naturally results in a codebase that is easier to maintain and expand.

⚠️ Trade-offs
• Increased Complexity (additional abstractions, wrappers, and files) => may add to the size of the codebase.
• Higher Initial Investment → Building such a state-agnostic architecture requires more upfront effort, resources, and a steeper learning curve for new contributors.

---

Apps designed as a **foundation for maximum state-agnostic Flutter apps** with built-in support for custom:

- 🌐 Localization via `easy_localization` (with built-in widgets auto-localization and fallbacks, as well as for errors managing and overlays flow)
- 🎨 Theming and unified UI/UX (with dark/light/amoled themes, persistent states, text theme factories)
- 🧭 Navigation via GoRouter (with declarative auth-aware redirect)
- ✨ Common animations (page transitions, overlay/widget animations)
- ⚠️ Error managing system
- 🪟 Overlays system (with quenue, overlays engine/dispatcher and police resolver)
  = 📄 Loggers (for lifecycle tracking of cubit/Bloc - [AppBlocObserver], for Riverpod - [ProviderDebugObserver])
- 🛠 FormFields System (with custom field factory + validation, localization, declarative inputs)

### 🔥 Features

---

## 📲 Tech Stack

### 🎯 Framework & Language

- 🐦 **Flutter SDK** (>=3.22, SDK ^3.8.0)
- 🎯 **Dart**

### ⚡ State Management & DI

- 🌱 **Riverpod**: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- 🧩 **BLoC / Cubit**: `flutter_bloc`
- 🛠 **GetIt** (dependency injection)
- 🚀 **Productivity**: `equatable`, `rxdart`

### 🔥 Firebase & Local Storages

- 🔑 `firebase_core`
- 👤 `firebase_auth`
- 📂 `cloud_firestore`
- 💥 `firebase_crashlytics`
- 📜 `flutter_dotenv` (env configs & secrets)
- 💾 `hydrated_bloc`, `get_storage`
- 📦 `path_provider`

### 🌐 Navigation & Routing

- 🧭 **go_router** (auth-aware navigation with declarative redirects)

### 🌍 Localization & i18n

- 🌐 **easy_localization** (with codegen & keys generation)

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
