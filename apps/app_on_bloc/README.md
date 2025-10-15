# 📱 Cubit Demo App

![coverage][coverage_badge]
[![License: MIT][license_badge]][license_link]

## Overview

A fully functional demo built with **Cubit**, showcasing the state-symmetric architecture in action.
Demonstrates how Cubit integrates with `core`, `features`, and `adapters` while keeping **90+% of the codebase unchanged**.

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:
flutter run --flavor development --target lib/main_development.dart # Development flavor
flutter run --flavor staging --target lib/main_staging.dart # Staging flavor
# Currently `main_production.dart` was deleted, as there is no intentions to deploy this code
```

## Getting Started 🚀

```bash
# Clone the repository
git clone https://github.com/RamanGodun/State-agnostic-blueprint-mono-repo
cd blueprint_monorepo

# Install Melos (monorepo manager)
dart pub global activate melos

# Bootstrap all packages
melos bootstrap
```

### Run with VSCode / Android Studio

Use the launch configurations from [`.vscode/launch.json`].

### Run with Melos (one-liners)

The repo includes ready scripts to run each app/flavor:

```sh
# Dev flavor
melos run run:cubit:dev
# Staging flavor
melos run run:cubit:stg
```

## 🔐 Demo Features

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

---

## Working with Translations 🌐

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

To include the new locale - update the `CFBundleLocalizations` array.

```xml
    <key>CFBundleLocalizations</key>
	<array>
		...
		<string>es</string>
    ...
	</array>
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.json` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```
