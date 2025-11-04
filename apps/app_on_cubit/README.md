# 📱 Cubit Demo App

[coverage_badge]: #
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: ../../LICENSE

## Overview

This is **one of two fully functional symmetric demo apps** (Cubit/BLoC and Riverpod).
This demo app is built with **Cubit**, showcasing the **State-Symmetric** architecture in action.

It demonstrates how the Cubit state manager plugs into the shared foundation — integrating with **`core`**, **`features`**, **`app_bootstrap`**, and **`adapters`** packages — while keeping **90%+ of the entire codebase (infrastructure + features) unchanged** vs the Riverpod app.
The only differences live in **thin seams/adapters (2–4 touchpoints per feature, located in `packages/bloc_adapter`)**, providing minimal glue while preserving **UI/UX parity (95–100%)** and **presentation parity (~85–90%)**.

**Symmetry contract:** state managers **orchestrate state only**; business logic stays in **use-cases**; UI remains **stateless**; **adapter-facades** provide the minimal glue for StatelessWidgets and side-effects.

**Result:** state managers are **swappable**, while **90%+ of the shared infrastructure and feature codebase remains identical**.

> Note: The goal is to **demonstrate the state‑symmetric style**, not a perfect pixel‑polished design.

### **Showcase features (built on top of the infra):**

- 👤 **Auth Flow** (with Auth-track seams): Sign In, Sign Out, Sign Up, Password Management (Change/Reset)
- 🪪 **Profile** (+ **Email Verification**) with async‑track seams.

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

## 🧠 Files Structure (app scope)

Focus on **`apps/app_on_cubit/lib/`** — the Cubit app wiring and presentation layer. Deep layers (domain/data) live in shared packages.

```files tree
apps/app_on_cubit/lib/
├─ app_bootstrap/                                     # Startup pipeline: platform checks → Firebase/env → DI → localization → storage
│  ├─ app_bootstrap.dart                              # Orchestrates boot sequence (DefaultAppBootstrap) and calls each init step in order
│  └─ di_container/
│     ├─ di_container_init.dart                       # Aggregates DI modules and registers them (full/minimal stacks)
│     ├─ global_di_container.dart                     # Global DI accessor/re-exports (entry to GetIt via bloc_adapter’s helpers)
│     └─ modules/                                     # Modular registrations (ADR-style, small and composable)
│        ├─ auth_module.dart                          # Auth: data sources → repos → use-cases → AuthCubit/SignOutCubit bindings
│        ├─ email_verification.dart                   # Email verification: DS/Repo/UseCase + EmailVerificationCubit wiring
│        ├─ firebase_module.dart                      # Low-level Firebase instances & profile remote DB bindings (switch point)
│        ├─ form_fields_module.dart                   # Reserved for form validation services (kept minimal for symmetry)
│        ├─ navigation_module.dart                    # Creates singleton GoRouter (driven by AuthGateway) and exposes via DI
│        ├─ overlays_module.dart                      # Wires overlay status cubit + global/context resolvers into DI
│        ├─ password_module.dart                      # Password flows: DS/Repo + PasswordRelatedUseCases registration
│        ├─ profile_module.dart                       # Profile: Repo/UseCase + app-scope ProfileCubit registration
│        ├─ theme_module.dart                         # AppThemeCubit registration (used even during splash)
│        └─ warmup_module.dart                        # WarmupController: binds Auth ↔ Profile to preheat data after sign-in
│
├─ core/
│  ├─ base_modules/navigation/
│  │  ├─ go_router_factory.dart                       # GoRouter factory (Bloc edition): observers, routes, refresh, redirect
│  │  ├─ routes/
│  │  │  ├─ app_routes.dart                           # Central route table (GoRoute tree) + pages -> transitions
│  │  │  ├─ route_paths.dart                          # Canonical absolute paths ("/home", "/signin", ...)
│  │  │  └─ routes_names.dart                         # Stable route names ("home", "signin", ...) used across the app
│  │  └─ routes_redirection_service.dart              # Pure redirect logic (deterministic; shared idea across SMs)
│  └─ shared_presentation/
│     ├─ pages/
│     │  ├─ home_page.dart                            # Home screen: minimal shell, theme toggle, entry to profile/settings
│     │  └─ page_not_found.dart                       # Generic 404 page with "Go to Home" action
│     └─ utils/
│        ├─ images_paths/
│        │  ├─ app_icons_paths.dart                   # Generated asset paths class for icons (Spider output target)
│        │  ├─ flavor_x.dart                          # Flavor-based icon resolver (development/staging)
│        │  └─ spider.yaml                            # Spider config to generate strongly-typed asset paths
│        └─ warmup_controller.dart                    # App-scope preheater: keeps ProfileCubit in sync with Auth state
│
├─ features/                                          # Presentation layer only (UI + Cubit). Domain/data live in packages/*
│  ├─ auth/
│  │  ├─ sign_in/
│  │  │  ├─ cubit/
│  │  │  │  ├─ form_fields_cubit.dart                 # Local form fields/validation; debounced updates; resets via epoch
│  │  │  │  └─ sign_in_cubit.dart                     # Submit flow: ButtonSubmissionState (initial/loading/success/error)
│  │  │  ├─ sign_in__page.dart                        # Screen composition: providers, side-effects, layout
│  │  │  └─ widgets_for_sign_in_page.dart             # Stateless building blocks: header, inputs, submit, footer guard
│  │  ├─ sign_out/
│  │  │  ├─ sign_out_cubit/
│  │  │  │  └─ sign_out_cubit.dart                    # Sign-out as AsyncValueForBLoC<void>; GoRouter handles redirect
│  │  │  └─ sign_out_widgets.dart                     # Buttons: icon sign-out, cancel (verify-email)
│  │  └─ sign_up/
│  │     ├─ cubit/
│  │     │  ├─ form_fields_cubit.dart                 # Name/Email/Password(+confirm) fields; visibility toggles
│  │     │  └─ sign_up_cubit.dart                     # Submit flow to SignUpUseCase; ButtonSubmissionState
│  │     ├─ sign_up__page.dart                        # Screen composition: providers, side-effects wrapper
│  │     ├─ sign_up_input_fields.dart                 # Inputs split by field; focus traversal; validators
│  │     └─ widgets_for_sign_up_page.dart             # Header, footer guard, submit button
│  ├─ email_verification/
│  │  ├─ email_verification_cubit/
│  │  │  └─ email_verification_cubit.dart             # Bootstraps send-email + polling; exposes AsyncValueForBLoC<void>
│  │  ├─ email_verification_page.dart                 # Providers + errors listener + state → AsyncStateView facade
│  │  └─ widgets_for_email_verification_page.dart     # Info block (instructions, email, tips)
│  ├─ password_changing_or_reset/
│  │  ├─ change_password/
│  │  │  ├─ change_password_page.dart                 # Providers + side-effects wrapper; navigation on success/reauth
│  │  │  ├─ cubit/
│  │  │  │  ├─ change_password_cubit.dart             # Submit to PasswordRelatedUseCases; requires-reauth handling
│  │  │  │  └─ form_fields_cubit.dart                 # Local password/confirm fields; toggles; epoch-based rebuilds
│  │  │  └─ widgets_for_change_password.dart          # Info block + inputs + submit button
│  │  └─ reset_password/
│  │     ├─ cubits/
│  │     │  ├─ form_fields_cubit.dart                 # Email field for reset; validation/epoch pattern
│  │     │  └─ reset_password_cubit.dart              # Reset flow (email submit → success/error)
│  │     ├─ reset_password__page.dart                 # Screen composition; effects
│  │     └─ widgets_for_reset_password_page.dart      # Stateless UI parts for Reset Password
│  └─ profile/
│     ├─ cubit/
│     │  └─ profile_page_cubit.dart                   # AsyncValueForBLoC<UserEntity> (prime/refresh/reset, keep-UI mode)
│     ├─ profile_page.dart                            # Providers + AsyncStateView rendering + centralized error handling
│     └─ widgets_for_profile_page.dart                # AppBar, profile card, theme section, change-password CTA
│
├─ main_development.dart                              # Entrypoint for dev flavor: sets flavor, runs AppLauncher with DI + localization shell
├─ main_staging.dart                                  # Entrypoint for staging flavor: same pipeline with different flavor
└─ root_shell.dart                                     # Top-level providers + app shells: GlobalProviders, AppLocalizationShell, MaterialApp.router
```

> **Tip:** All feature business logic (use-cases, repositories, gateways) lives in shared packages (`packages/features`, `packages/firebase_adapter`), while this app layer stays **presentation-only** with thin Cubit glue.

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
