# 📱 Riverpod Demo App

[coverage_badge]: #
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: ../../LICENSE

## Overview

This is **one of two fully functional, symmetric demo apps** (Cubit/BLoC and Riverpod).
This app is built with **Riverpod**, showcasing the **State‑Symmetric Architecture** in action.

It demonstrates how Riverpod plugs into the shared foundation — integrating with **`core`**, **`features`**, **`app_bootstrap`**, and **`adapters`** packages — while keeping **90%+ of the entire codebase (infrastructure + features) unchanged** vs the Cubit app. The only differences live in **thin seams/adapters (2–4 touchpoints per feature, located in `packages/riverpod_adapter`)**, providing minimal glue while preserving **UI/UX parity (95–100%)** and **presentation parity (~85–90%)**.

**Symmetry contract:** state managers **orchestrate state only**; business logic stays in **use‑cases**; UI remains **stateless**; **adapter‑facades** provide the minimal glue for StatelessWidgets and side‑effects.

**Result:** state managers are **swappable**, while **90%+ of the shared infrastructure and feature codebase remains identical**.

> Note: The goal is to **demonstrate the state‑symmetric style**, not a pixel‑perfect design.

### **Showcase features (built on top of the infra):**

- 👤 **Auth Flow** (Auth‑track seams): Sign In, Sign Out, Sign Up, Password Management (Change/Reset)
- 🪪 **Profile** (+ **Email Verification**) with async‑track seams

---

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

### Run with CLI or Melos scripts

This project uses **2 flavors**:

- development
- staging

Run the desired flavor via IDE or CLI:

```sh
flutter run --flavor development --target lib/main_development.dart # Development flavor
flutter run --flavor staging --target lib/main_staging.dart         # Staging flavor
# Currently `main_production.dart` was deleted, as there are no intentions to deploy this code
```

Or use ready Melos scripts:

```sh
# Dev flavor
melos run run:rp:dev
# Staging flavor
melos run run:rp:stg
```

---

### ⚙️ Firebase Configuration

- Firebase is configured via `.env` + `flutter_dotenv`.
- You can use the provided `.env` files or create your own. In the latter case:

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

---

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
  <string>es</string> <!-- Add this -->
</array>
```

> **Android:** no extra steps are required beyond adding the JSON file and regenerating code.

4. **App code:** no UI changes are needed, use only **generated keys** from `LocaleKeys`.

Switch language at runtime:

```dart
await context.setLocale(const Locale('es'));
```

---

## 🧠 Files Structure (app scope)

Focus on **`apps/app_on_riverpod/lib/`** — this is the Riverpod app wiring and the presentation layer. Deep layers (domain/data) live in shared packages.

```files tree
lib/
├── app_bootstrap/                                        # Startup pipeline (platform checks → env/Firebase → DI → localization → storage)
│   ├── app_bootstrap.dart                                # Orchestrates the boot sequence (DefaultAppBootstrap.initAllServices → runApp)
│   ├── di_config_sync.dart                               # Riverpod DI wiring (overrides + observers): theme/router/overlays + auth/profile
│   ├── firebase_initializer.dart                         # Env loader + Firebase init guard (current flavor) → idempotent init
│   └── local_storage_init.dart                           # Local persistence init (GetStorage) — injectable via ILocalStorage
│
├── core/
│   ├── base_modules/
│   │   └── navigation/                                   # GoRouter (Riverpod edition) — observers, routes, refresh, redirects
│   │       ├── go_router_factory.dart                    # buildGoRouter(Ref): stable router instance + StreamChangeNotifier refresh
│   │       ├── router_provider.dart                      # Public provider for UI (`ref.watch(routerProvider)`) — avoids rebuild storms
│   │       ├── routes/
│   │       │   ├── app_routes.dart                       # Central route table (GoRoute tree) + animated page builders
│   │       │   ├── route_paths.dart                      # Canonical absolute paths ("/home", "/signin", ...) used in redirects
│   │       │   └── routes_names.dart                     # Stable route names ("home", "signin", ...) for navigation APIs
│   │       └── routes_redirection_service.dart           # Pure redirect function (deterministic; shared logic with BLoC app)
│   └── shared_presentation/
│       ├── pages/
│       │   ├── home_page.dart                            # Minimal shell: theme toggle, entry to profile/settings
│       │   └── page_not_found.dart                       # Generic 404 page with "Go Home" action
│       └── utils/
│           ├── images_paths/
│           │   ├── app_icons_paths.dart                  # Generated asset paths for icons (Spider output target)
│           │   ├── flavor_x.dart                         # Flavor-based icon resolver (development/staging)
│           │   └── spider.yaml                           # Spider config to generate strongly-typed asset paths
│           ├── warmup_provider.dart                      # App warm-up (keepAlive): primes Profile on sign-in, resets on sign-out
│           └── warmup_provider.g.dart                    # Codegen for warmup provider (@riverpod)
│
├── features/                                             # Presentation layer only (UI + Riverpod). Domain/data live in packages/*
│   ├── auth/
│   │   ├── sign_in/
│   │   │   ├── providers/
│   │   │   │   ├── input_form_fields_provider.dart       # Local form state/validation (debounced updates; epoch-based rebuilds)
│   │   │   │   ├── input_form_fields_provider.g.dart     # Codegen for SignInForm provider
│   │   │   │   ├── sign_in__provider.dart                # Submission flow (Initial/Loading/Success/Error) + side-effects hooks
│   │   │   │   └── sign_in__provider.g.dart              # Codegen for sign-in submission provider
│   │   │   ├── sign_in__page.dart                        # Screen composition: listeners, layout; stateless & state-agnostic UI
│   │   │   └── widgets_for_sign_in_page.dart             # Stateless building blocks: header, inputs, submit, footer guard
│   │   ├── sign_out/
│   │   │   ├── sign_out_provider.dart                    # Async notifier for sign-out (cleans caches; GoRouter handles redirects)
│   │   │   ├── sign_out_provider.g.dart                  # Codegen for sign-out provider
│   │   │   └── sign_out_widgets.dart                     # Buttons: icon sign-out, cancel (verify-email)
│   │   └── sign_up/
│   │       ├── providers/
│   │       │   ├── input_form_fields_provider.dart       # Name/Email/Password(+confirm) fields; toggles; debounced validation
│   │       │   ├── input_form_fields_provider.g.dart     # Codegen for SignUpForm provider
│   │       │   ├── sign_up__provider.dart                # Submission flow to SignUpUseCase; error as Consumable<Failure>
│   │       │   └── sign_up__provider.g.dart              # Codegen for sign-up submission provider
│   │       ├── sign_up__page.dart                        # Screen composition + side-effects listener; stateless, reusable UI
│   │       ├── sign_up_input_fields.dart                 # Inputs split by field; focus traversal helpers
│   │       └── widgets_for_sign_up_page.dart             # Header, footer guard, submit button
│   ├── email_verification/
│   │   ├── email_verification_page.dart                  # Providers + error listeners + AsyncStateView facade
│   │   ├── provider/
│   │   │   ├── email_verification_provider.dart          # Notifier: send email + polling loop + AsyncValue<void> state
│   │   │   └── email_verification_provider.g.dart        # Codegen for email verification provider
│   │   └── widgets_for_email_verification_page.dart      # Info block (instructions, email, tips)
│   ├── password_changing_or_reset/
│   │   ├── change_password/
│   │   │   ├── change_password_page.dart                 # Providers + effects; navigation on success/reauth
│   │   │   ├── providers/
│   │   │   │   ├── change_password__provider.dart        # Submission notifier to PasswordRelatedUseCases
│   │   │   │   ├── change_password__provider.g.dart      # Codegen for change password provider
│   │   │   │   ├── input_fields_provider.dart            # Local password/confirm fields; toggles; epoch-based rebuilds
│   │   │   │   └── input_fields_provider.g.dart          # Codegen for input fields provider
│   │   │   └── widgets_for_change_password.dart          # Info block + inputs + submit button
│   │   └── reset_password/
│   │       ├── providers/
│   │       │   ├── input_fields_provider.dart            # Email field for reset; validation + epoch pattern
│   │       │   ├── input_fields_provider.g.dart          # Codegen for reset form provider
│   │       │   ├── reset_password__provider.dart         # Reset flow (email submit → success/error)
│   │       │   └── reset_password__provider.g.dart       # Codegen for reset submission provider
│   │       ├── reset_password_page.dart                  # Screen composition; effects
│   │       └── widgets_for_reset_password_page.dart      # Stateless UI parts for Reset Password
│   └── profile/
│       ├── profile_page.dart                             # Providers + AsyncStateView rendering + centralized error handling
│       ├── providers/
│       │   ├── profile_page_provider.dart                # AsyncValue<UserEntity> (prime/refresh/reset, keep-UI mode)
│       │   └── profile_page_provider.g.dart              # Codegen for profile provider
│       └── widgets_for_profile_page.dart                 # AppBar, profile card, theme section, change-password CTA
│
├── main_development.dart                                 # Entrypoint (dev flavor): sets flavor → AppLauncher.run with ProviderScope
├── main_staging.dart                                     # Entrypoint (staging flavor): same pipeline with different flavor
└── root_shell.dart                                       # Top-level shells: AppLocalizationShell → MaterialApp.router
```

> **Tip:** All feature business logic (use‑cases, repositories, gateways) lives in shared packages (`packages/features`, `packages/firebase_adapter`), while this app layer stays **presentation‑only** with thin Riverpod glue.

---

## 🔧 Built‑in Infrastructure (Demo Features)

These apps are a **foundation for small–mid size products** with a code style that’s nearly agnostic to the state manager. Built‑ins include:

- 🌐 **Localization** via `easy_localization`
  ([docs](../../packages/core/lib/src/base_modules/localization/README%28localization%29.md))

- 🎨 **Theming & unified UI/UX**
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
  [`ProviderDebugObserver`](../../packages/riverpod_adapter/lib/src/base_modules/observing/providers_debug_observer.dart),
  [`AppBlocObserver`](../../packages/bloc_adapter/lib/src/base_modules/observer/bloc_observer.dart)

---

## 🧷 DI with Riverpod (short ADR‑style)

- **Context‑free DI:** access dependencies via `ProviderScope` / `WidgetRef` — no `BuildContext` in DI.
- **Symmetry:** identical mental model to PlatIt/GetIt in the Cubit app (see ADR‑002), but here we use **native Riverpod DI**.
- **Lifecycles:** providers manage lifecycles; long‑lived services can be held by a `ProviderContainer` or top‑level overrides.
- **Clean boundaries:** presentation → use‑cases → repositories (no UI code leaking down).
- **Swap‑friendly:** backend sealed in `packages/firebase_adapter`; state manager glue in `packages/riverpod_adapter` (mirrored by `packages/bloc_adapter`).

Key files:

- Bootstrap entry: [`app_bootstrap.dart`](lib/app_bootstrap/app_bootstrap.dart)
- Global providers: see `lib/core/.../router_provider.dart` & `packages/riverpod_adapter`
- Firebase wiring: providers in `packages/riverpod_adapter`
- Navigation wiring: [`router_provider.dart`](lib/core/base_modules/navigation/router_provider.dart)
- Overlays/theming: modules in `core` + providers in `riverpod_adapter`

---

## 🧪 Running Tests

This demo focuses on the **architecture and business value measurements**, not on test coverage. Most heavy‑lift code was tested previously in production apps it originated from. The test pipeline is **wired and ready** and can be extended as time permits.

```sh
very_good test --coverage --test-randomize-ordering-seed random
# Coverage report
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

---

## 📚 Additional Docs

- ADRs: see **ADR‑001 State‑Symmetric Architecture** and supporting info from the repo root
- Packages: [`core/`](../../packages/core/), [`riverpod_adapter/`](../../packages/riverpod_adapter/), [`firebase_adapter/`](../../packages/firebase_adapter/), [`features/`](../../packages/features/)
- Root README (monorepo): [`README.md`](../../README.md)
