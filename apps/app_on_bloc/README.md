# 📱 Cubit Demo App

[coverage_badge]: #
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: ../../LICENSE

## Overview

A fully functional demo built with **Cubit**, showcasing the **State‑Symmetric** architecture in action. It demonstrates how Cubit integrates with `core`, `features`, and `adapters` flutter packages, while keeping **90%+ of the codebase unchanged** compared to the Riverpod app — differences live in **thin seams/adapters (2–4 touchpoints per feature)**.

- **Why Cubit?** To show that Cubit can plug into the shared foundation with minimal glue while preserving **UI/UX parity (95–100%)** and **presentation parity (~85–90%)**.
- **Symmetry contract:** state managers **orchestrate state only**; logic stays in **use‑cases**; UI is **stateless**; adapters-facades provide the minimal glue around StatelessWidgets and side‑effects.

### 🧩 How This App Fits the Monorepo

This is **one of two symmetric demo apps** (Cubit/BLoC and Riverpod). Both:

- share the **same core**, **features**, and **firebase_adapter** packages,
- connect through **thin adapters** (`packages/bloc_adapter` vs `packages/riverpod_adapter`),
- deliver **UI/UX parity (95–100%)** and **presentation parity (~85–90%)** with minimal glue.

The result: state managers are **swappable** while ~90% of code stays the same.

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

### Run with commands or Melos scripts

This project contains 2 flavors:

- development
- staging

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
flutter run --flavor development --target lib/main_development.dart # Development flavor
flutter run --flavor staging --target lib/main_staging.dart # Staging flavor
# Currently `main_production.dart` was deleted, as there is no intentions to deploy this code
```

Also the repo includes ready melos scripts to run each app/flavor:

```sh
# Dev flavor
melos run run:cubit:dev
# Staging flavor
melos run run:cubit:stg
```

### ⚙️ Firebase Configuration

- Firebase is configured via `.env` + `flutter_dotenv`
- Use the provided `.env` files or create your own. In the latter case:

1. ```bash
   flutterfire configure --project=<your_project_id>
   ```
2. After configuration, put the following into the created `.env.dev` and/or `.env.staging` files:

```env
FIREBASE_API_KEY=...
FIREBASE_APP_ID=...
FIREBASE_PROJECT_ID=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_STORAGE_BUCKET=...
FIREBASE_AUTH_DOMAIN=...
FIREBASE_IOS_BUNDLE_ID=...
```

### Working with Translations 🌐

This app uses **EasyLocalization** with JSON dictionaries stored **in the shared core package**:

```
packages/core/assets/translations/
  ├─ en.json
  ├─ uk.json
  └─ pl.json
```

> Assets are **already registered** in `packages/core/pubspec.yaml`, so you don’t need to modify the app’s `pubspec.yaml`.

#### iOS locales (existing)

Update (or verify) the `CFBundleLocalizations` array in `ios/Runner/Info.plist` includes the supported locales:

```xml
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>uk</string>
  <string>pl</string>
</array>
```

#### Adding a New Locale (example: Spanish `es`)

1. **Create a JSON file** with translations in the core package:
   - Path: `packages/core/assets/translations/es.json`
   - Tip: copy `en.json` and translate all keys to keep structure consistent.

2. **Regenerate code** (keys + loader) for EasyLocalization:

```sh
# From repo root
melos run localization:gen:core
```

3. **iOS only:** add the new locale to `Info.plist` → `CFBundleLocalizations`:

```xml
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>uk</string>
  <string>pl</string>
  <string>es</string> // Add this
</array>
```

> **Android:** no extra steps are required beyond adding the JSON file and regenerating code.

4. **App code:** no UI changes are needed, use only **generated keys** from `LocaleKeys`

To switch language at runtime:

```dart
await context.setLocale(const Locale('es'));
```

## 🧠 File Structure (app scope)

Focus on **`apps/app_on_bloc/lib/`** — the Cubit app wiring and presentation layer. Deep layers (domain/data) live in shared packages.

```files tree
apps/app_on_bloc/lib/
├─ app_bootstrap/                                     # Startup pipeline, env, platform checks, DI (GetIt)
│  ├─ app_bootstrap.dart
│  └─ di_container/
│     ├─ di_container_init.dart
│     ├─ global_di_container.dart
│     └─ modules/                                     # Modular registrations
│        ├─ auth_module.dart
│        ├─ email_verification.dart
│        ├─ firebase_module.dart
│        ├─ form_fields_module.dart
│        ├─ navigation_module.dart
│        ├─ overlays_module.dart
│        ├─ password_module.dart
│        ├─ profile_module.dart
│        ├─ theme_module.dart
│        └─ warmup_module.dart
│
├─ core/
│  ├─ base_modules/navigation/
│  │  ├─ go_router_factory.dart
│  │  ├─ routes/
│  │  │  ├─ app_routes.dart
│  │  │  ├─ route_paths.dart
│  │  │  └─ routes_names.dart
│  │  └─ routes_redirection_service.dart
│  └─ shared_presentation/
│     ├─ pages/
│     │  ├─ home_page.dart
│     │  └─ page_not_found.dart
│     └─ utils/
│        ├─ images_paths/
│        │  ├─ app_icons_paths.dart
│        │  ├─ flavor_x.dart
│        │  └─ spider.yaml
│        └─ warmup_controller.dart
│
├─ features/                                          # Feature UI + Cubit logic (presentation only)
│  ├─ auth/
│  │  ├─ sign_in/
│  │  │  ├─ cubit/
│  │  │  │  ├─ form_fields_cubit.dart
│  │  │  │  └─ sign_in_cubit.dart
│  │  │  ├─ sign_in__page.dart
│  │  │  └─ widgets_for_sign_in_page.dart
│  │  ├─ sign_out/
│  │  │  ├─ sign_out_cubit/
│  │  │  │  └─ sign_out_cubit.dart
│  │  │  └─ sign_out_widgets.dart
│  │  └─ sign_up/
│  │     ├─ cubit/
│  │     │  ├─ form_fields_cubit.dart
│  │     │  └─ sign_up_cubit.dart
│  │     ├─ sign_up__page.dart
│  │     ├─ sign_up_input_fields.dart
│  │     └─ widgets_for_sign_up_page.dart
│  ├─ email_verification/
│  │  ├─ email_verification_cubit/
│  │  │  └─ email_verification_cubit.dart
│  │  ├─ email_verification_page.dart
│  │  └─ widgets_for_email_verification_page.dart
│  ├─ password_changing_or_reset/
│  │  ├─ change_password/
│  │  │  ├─ change_password_page.dart
│  │  │  ├─ cubit/
│  │  │  │  ├─ change_password_cubit.dart
│  │  │  │  └─ form_fields_cubit.dart
│  │  │  └─ widgets_for_change_password.dart
│  │  └─ reset_password/
│  │     ├─ cubits/
│  │     │  ├─ form_fields_cubit.dart
│  │     │  └─ reset_password_cubit.dart
│  │     ├─ reset_password__page.dart
│  │     └─ widgets_for_reset_password_page.dart
│  └─ profile/
│     ├─ cubit/
│     │  └─ profile_page_cubit.dart
│     ├─ profile_page.dart
│     └─ widgets_for_profile_page.dart
│
├─ main_development.dart
├─ main_staging.dart
└─ root_shell.dart
```

**Roles:**

- **`app_bootstrap/`** — deterministic startup: env → platform checks → Firebase → local storage → **GetIt** DI → `runApp`
- **`core/`** — app-level codebase over shared code in [core] flatter package (`packages/core`)
- **`features/`** — feature **presentation** (UI + Cubit). Deep layers come from shared packages (`packages/features`, `packages/firebase_adapter`).

> Navigation entrypoints: [`go_router_factory.dart`](lib/core/base_modules/navigation/go_router_factory.dart), routes: [`app_routes.dart`](lib/core/base_modules/navigation/routes/app_routes.dart), [`route_paths.dart`](lib/core/base_modules/navigation/routes/route_paths.dart), [`routes_names.dart`](lib/core/base_modules/navigation/routes/routes_names.dart).

---

## 🔧 Built‑in Infrastructure (Demo Features)

These apps are a **foundation for small–mid size products** with a code style that’s nearly agnostic to the state manager. Built‑ins include:

- 🌐 **Localization** via `easy_localization`
  ([docs](../../packages/core/lib/src/base_modules/localization/README%28localization%29.md))

- 🎨 **Theming** and unified UI/UX
  ([docs](../../packages/core/lib/src/base_modules/ui_design/Theme_module_README.md))

- 🧭 **Navigation** via GoRouter
  ([docs](../../packages/core/lib/src/base_modules/navigation/README%28navigation%29.md))

- ✨ **Common animations**
  ([docs](../../packages/core/lib/src/base_modules/animations/README%28animations%29.md))

- ⚠️ **Error management system**
  ([docs](../../packages/core/lib/src/base_modules/errors_management/README%28errors_handling%29.md))

- 🪟 **Overlays system**
  ([docs](../../packages/core/lib/src/base_modules/overlays/README%28overlays%29.md))

- 🛠 **FormFields system**
  ([docs](../../packages/core/lib/src/base_modules/form_fields/README%28form_fields%29.md))

- 📄 **Loggers**:
  [`AppBlocObserver`](../../packages/bloc_adapter/lib/src/base_modules/observer/bloc_observer.dart),
  [`ProviderDebugObserver`](../../packages/riverpod_adapter/lib/src/base_modules/observing/providers_debug_observer.dart)

**Showcase features (built on top of the infra):**

- 👤 **Auth Flow** (with Auth-track seams): Sign In, Sign Out, Sign Up, Password Management (Change/Reset)
- 🪪 **Profile** (+ **Email Verification**) with async‑track seams.

> Note: The goal is to **demonstrate the state‑symmetric style**, not a perfect pixel‑polished design.

---

## 🧷 DI with GetIt (short ADR‑style)

- **Modular DI**: each module exposes a single registration entry (see `app_bootstrap/di_container/modules/*.dart`) and is composed in [`di_container_init.dart`](lib/app_bootstrap/di_container/di_container_init.dart).
- **Lifetimes**:
  - `lazySingleton` for cross‑feature services (gateways, repositories)
  - `factory` for screen‑scoped objects (Cubits) provided via `BlocProvider`

- **No `BuildContext` in DI** → DI stays independent from the widget tree
- **Clean boundaries**: presentation → use‑cases → repositories (no UI code leaks down)
- **Swap‑friendly**: backend sealed in `packages/firebase_adapter`; state manager glue in `packages/bloc_adapter` (mirrored by `packages/riverpod_adapter`)

Key files:

- Bootstrap entry: [`app_bootstrap.dart`](lib/app_bootstrap/app_bootstrap.dart)
- Global container: [`global_di_container.dart`](lib/app_bootstrap/di_container/global_di_container.dart)
- Firebase wiring: [`firebase_module.dart`](lib/app_bootstrap/di_container/modules/firebase_module.dart)
- Navigation wiring: [`navigation_module.dart`](lib/app_bootstrap/di_container/modules/navigation_module.dart)
- Overlays wiring: [`overlays_module.dart`](lib/app_bootstrap/di_container/modules/overlays_module.dart)
- Features wiring: [`auth_module.dart`](lib/app_bootstrap/di_container/modules/auth_module.dart), [`profile_module.dart`](lib/app_bootstrap/di_container/modules/profile_module.dart), [`password_module.dart`](lib/app_bootstrap/di_container/modules/password_module.dart), [`email_verification.dart`](lib/app_bootstrap/di_container/modules/email_verification.dart)

## 🧪 Running Tests

This demo focuses on the **architecture and business value measurements**, not on test coverage. Most heavy‑lift code was tested previously in production apps it originated from. The test pipeline is **wired and ready** and can be extended as time permits.

```sh
very_good test --coverage --test-randomize-ordering-seed random
# Coverage report
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

## 📚 Additional Docs

- ADRs: see **ADR-001 State‑Symmetric Architecture** and supporting info from the repo root
- Packages: [`core/`](../../packages/core/), [`bloc_adapter/`](../../packages/bloc_adapter/), [`firebase_adapter/`](../../packages/firebase_adapter/), [`features/`](../../packages/features/)
- Root README (monorepo): [`README.md`](../../README.md)
