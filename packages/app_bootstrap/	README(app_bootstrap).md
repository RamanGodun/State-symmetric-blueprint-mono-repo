# App Bootstrap Package

**App Bootstrap** is a shared Flutter package that standardizes application startup across all apps in the monorepo.
It centralizes platform checks, dependency injection wiring, Firebase configuration, local storage initialization,
and environment-driven flags — so each app can boot consistently with minimal boilerplate.

---

## Installation

Add the package to your app's `pubspec.yaml`:

```yaml
# apps/<your_app>/pubspec.yaml
dependencies:
  app_bootstrap:
    path: ../../packages/app_bootstrap
```

Import the public API only:

```dart
import 'package:app_bootstrap/app_bootstrap.dart';
```

> **Import rule:** Do not import internal files directly (e.g. `di_container/…`, `firebase_config/…`).
> Always go through the package’s public API.

---

## Directory Structure

```
lib/
├─ app_bootstrap/
│  ├─ app_bootstrap.dart           # Single entry-point / orchestrator
│  ├─ bootstrap_interface.dart     # Abstractions for boot steps
│  ├─ local_storage_init.dart      # Local storage init (e.g., SharedPreferences/Hive)
│  ├─ platform_validation.dart     # Runtime platform requirements checks
│  ├─ remote_db_init.dart          # Remote DB init hooks (e.g., Firestore/REST)
│  └─ docs/
│     ├─ bootstrap_with_splash_screen.md
│     └─ advanced_bootstrap.md
|
├─ constants/
│  ├─ config_constants_barrel.dart # Re-exports of flags/requirements/info
│  ├─ environment_flags.dart       # Feature flags & env switches
│  ├─ info_constants.dart          # App name, versions, urls, etc.
│  └─ platform_requirements.dart   # Min OS/SDK constraints and checks
|
├─ di_container/
|
└─ firebase_config/
   ├─ env_config.dart              # Environment model (api keys, endpoints, flavors)
   ├─ env_firebase_options.dart    # Source-of-truth for FirebaseOptions per env
   ├─ firebase_constants.dart      # Namespaces/collection names, etc.
   ├─ firebase_utils.dart          # `Firebase.initializeApp` helpers
   └─ user_auth_provider/
      ├─ firebase_auth_providers.dart   # Auth providers (anonymous, email, etc.)
      └─ firebase_auth_providers.g.dart # Generated code (keep out of VCS if needed)
```

> The exact file names may evolve; this README describes the intended responsibilities and boundaries of each area.

---

## What It Does

App Bootstrap orchestrates a **deterministic startup pipeline**:

1. **Platform validation** – assert OS/SDK/device requirements (e.g., Android min SDK, iOS version).
2. **Environment & flags** – read flavor and env variables, expose feature flags.
3. **Local storage** – initialize storage engines (SharedPreferences/Hive/SecureStorage).
4. **Remote/Firebase** – initialize Firebase (via `firebase_config`) or other remote backends.
5. **Dependency Injection** – register sync/async services in a single place.
6. **Run app** – hand control to your root `Widget` (optionally showing a splash screen during boot).

This isolates “how to start an app” from the app’s UI/business logic.

---

## Quick Start

Below is a **generic** usage sketch. Adapt function names to your package’s actual API (see file names above).

```dart
import 'package:flutter/widgets.dart';
import 'package:app_bootstrap/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Validate platform requirements (throws/asserts on unsupported setups)
  await validatePlatformRequirements();

  // 2) Load env & feature flags (from flavors, dotenv, or compile-time defines)
  final env = await loadEnvironment(); // e.g., from env_config.dart

  // 3) Init local storage
  await initLocalStorage(); // e.g., SharedPreferences/Hive

  // 4) Init remote backends / Firebase (no-op if not used)
  await initFirebaseFrom(env); // wraps Firebase.initializeApp(options: ...)

  // 5) Wire DI (sync + async registrations)
  configureDependenciesSync();
  await configureDependenciesAsync();

  // 6) Run the app
  runApp(const App());
}
```

> If you use a splash/loader during async boot, see `docs/bootstrap_with_splash_screen.md` for
> a pattern that displays a placeholder while steps 2–5 complete.

---

## Firebase (Optional)

If your app uses Firebase, **App Bootstrap** provides thin utilities to keep initialization **environment-driven**:

- `env_firebase_options.dart` – define `FirebaseOptions` per environment (development/staging/production).
- `env_config.dart` – a typed model for the chosen environment & flags.
- `firebase_utils.dart` – safe wrappers around `Firebase.initializeApp`, crashlytics toggles, etc.
- `user_auth_provider/` – optional providers for common auth flows (anonymous/email/oauth).

**Typical flow:**

```dart
final env = await loadEnvironment();
await initFirebaseFrom(env);
```

Keep `google-services.json` / `GoogleService-Info.plist` in the app targets as usual;
this package only centralizes **runtime wiring**, not project files.

---

## Dependency Injection

The `di_container/` folder consolidates DI setup:

- **`di_container.dart`** – the service locator or registrar API.
- **`di_config_sync.dart`** – pure Dart, fast registrations (e.g., value types, synchronous services).
- **`di_config_async.dart`** – async registrations (e.g., databases, secure storage, network clients).
- **`read_di_x_on_context.dart`** – convenience extensions for accessing DI from `BuildContext` (optional).

> Keep cross-cutting services (logging, analytics, http clients, repositories) here to avoid duplication across apps.

---

## Environment & Flags

Use `constants/environment_flags.dart` to expose **feature flags** and **flavor switches** (development/staging/production).
Couple them with `info_constants.dart` (app name, links) and `platform_requirements.dart` (min versions/devices) to produce consistent behavior across apps.

**Recommendations:**

- Prefer **compile-time** defines for critical toggles (e.g., `--dart-define=USE_FAKE_API=true`).
- Mirror them into a **typed runtime model** (`EnvConfig`) for easy consumption in UI/DI.
- Keep sensitive values in app-level secure storage or config management; do not hardcode secrets in this package.

---

## Integration in Apps

### BLoC or Riverpod — both supported

This package is agnostic to state management. You can register either BLoC observers or Riverpod providers inside `di_config_*` and use them from the app.

### Example (with splash)

See `app_bootstrap/docs/bootstrap_with_splash_screen.md` for a splash-first approach:

1. Render a lightweight splash/root shell.
2. Kick off the boot pipeline (env → storage → firebase → DI).
3. Swap to the real `App()` once ready.

---

## Testing

- Keep generated files (e.g., `*.g.dart`) **excluded** from analysis/coverage.
- Unit-test each boot step in isolation (e.g., platform validator, env loader, DI registrars).
- Provide small fakes for `EnvConfig` and storage to keep tests hermetic.

Example (pseudo):

```dart
void main() {
  test('platform validator throws on unsupported iOS version', () {
    expect(() => validatePlatformRequirements(fake: IOS_12), throwsA(isA<PlatformError>()));
  });
}
```

---

## Development

From the monorepo root:

```bash
# Format + analyze + test everything
melos run check

# Only this package
melos exec --scope="app_bootstrap" -- dart format .
melos exec --scope="app_bootstrap" -- flutter analyze
melos exec --scope="app_bootstrap" -- flutter test --coverage --no-pub
```

---

## Conventions

- **Single entry point**: expose a small, stable API from `app_bootstrap.dart`.
- **No app secrets**: keep credentials in app targets or CI, not in this package.
- **Deterministic boot**: fail fast on unsupported platforms; log clear diagnostics.
- **Pluggable**: each step (env/storage/firebase/di) is optional and replaceable.
- **Docs**: evolve `docs/` with diagrams and sample flows as features grow.

---

## License

This package is licensed under the same terms as the monorepo’s root [LICENSE](../../LICENSE).
