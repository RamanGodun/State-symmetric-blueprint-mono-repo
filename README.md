# Blueprint monorepo

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[!LICENSE]([license_badge] LICENSE).

---

A **modular starter project** with Clean Architecture and 90%+ state-agnostic codebase (works with cubit/BLoC/Riverpod)
Might be as base for apps with built-in support for **localization**, **theming**, **GoRouter navigation**,
**animations**, **custom error handling system**, **custom overlays system** and more.

---

## ✨ Overview

This project acts as a robust foundation for Flutter apps that require:

- ✅ Fully structured Clean Architecture
- ✅ Ready-to-use systems: overlays, theming, localization, error handling, navigation, animations
- ✅ Scalable modularity and dependency injection via GetIt
- ✅ In one app Riverpod as state management, in another - cubit/BLoC
- ✅ A few features (auth, profile, password actions, etc...)

> Perfect for rapid prototyping or extending into a complex production app.

---

## 🔥 Features

- 🧱 **Core**: Logging, routing, DI, overlays, error handling
- 🎨 **Theme System**: dark/light theme, persistent state
- 🌐 **Localization**: Code-generated with `easy_localization`
- 🧭 **Navigation**: `GoRouter` with auth-aware redirect
- 🧰 **Overlays**: Snackbars, dialogs, banners via overlay engine
- 🛠 **Form System**: Validated, declarative inputs with custom field factory
- 📄 **Custom Loggers**: for lifecycle tracking of cubit/Bloc - `AppBlocObserver`, for Riverpod - `Logger`

- 🧪 **Firebase Config**: via `.env` + `flutter_dotenv`
- 🧬 **Code Generation**: `JsonSerializable`, `Spider`, `EasyLocalization`, etc.

---

## 🧩 Tech Stack

## add here...

## 🧠 Architecture

### 🧾 ADR / Architecture Philosophy

See [`ADR.md`](ADR/ADR.md) for:

- ...

The app is built with strict **Modular and Clean Architecture**, following AMC principles:

```
lib/
|
├── app_bootstrap_and_config
├── core/                     # Global systems (di, overlays, navigation, theme, etc)
│   └── base_modules/         # Reusable modules: errors, localization, forms, etc
├── features/                 # Feature-driven modular structure (auth, profile...)
│   └── feature_name/         # Follows Domain → Data → Presentation layering
└── main.dart                 # App entry point with DI + observers setup
```

## Getting Started 🚀

```bash
git clone https://github.com/....git
flutter pub get
flutter run
```

For localization/codegen:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart
# Staging
$ flutter run --flavor staging --target lib/main_staging.dart
# Production
$ flutter run --flavor production --target lib/main_production.dart
```

\_\*Currently `main_production.dart` was deleted, as there is no intentions to deploy this code

## ⚙️ Firebase Configuration

1. Install deps and configure:

````bash
flutter pub get
flutterfire configure --project=<your_project_id>

2. Create `.env` file:
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

---

## 🧪 Testing Strategy

Designed with the testing pyramid in mind:

- ✅ **Unit tests**: UseCases, Repos, Providers (via injected mocks)
- 🧩 **Widget tests**: Stateless widgets & UI behavior
- 🔁 **Integration tests**: Can be added progressively

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
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

> Built with ❤️ for clean, scalable and robust Flutter apps.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
