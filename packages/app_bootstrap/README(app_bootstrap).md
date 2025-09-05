# App Bootstrap Package

**App Bootstrap** is a shared Flutter package that standardizes application startup across all apps in the monorepo,
that keeps boot logic **consistent across apps** and **technology‑agnostic** (you can plug in any storage/remote backend).
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
├─ app_bootstrap.dart                 # 🚀 Single public barrel (clean API)
└─ src/
   ├─ bootstrap_contracts/            # 📜 Contracts (pure abstractions)
   │  ├─ bootstrap.dart               # IAppBootstrap
   │  ├─ local_storage.dart           # ILocalStorage
   │  └─ remote_database.dart         # IRemoteDataBase
   ├─ configs/                        # ⚙️ Compile-time/runtime config
   │  ├─ env.dart                     # Environment & EnvConfig
   │  ├─ flavor.dart                  # AppFlavor & FlavorConfig
   │  └─ platform_requirements.dart   # PlatformConstants (min versions)
   └─ utils/                          # 🧰 Bootstrap helpers
      ├─ app_launcher.dart            # Guarded app runner & error handling
      └─ platform_validation.dart     # PlatformValidationUtil
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

## Environment & Flags

Use `constants/environment_flags.dart` to expose **feature flags** and **flavor switches** (development/staging/production).
Couple them with `info_constants.dart` (app name, links) and `platform_requirements.dart` (min versions/devices) to produce consistent behavior across apps.

**Recommendations:**

- Prefer **compile-time** defines for critical toggles (e.g., `--dart-define=USE_FAKE_API=true`).
- Mirror them into a **typed runtime model** (`EnvConfig`) for easy consumption in UI/DI.
- Keep sensitive values in app-level secure storage or config management; do not hardcode secrets in this package.

### Flavors

```dart
FlavorConfig.current = AppFlavor.development;
final isDev = FlavorConfig.isDev;
final name  = FlavorConfig.name; // "development" | "staging"
```

### Envs (.env files)

```dart
final isDebug = EnvConfig.isDebugMode;   // true in dev
definal isStg   = EnvConfig.isStagingMode; // true in staging
```

`.env.dev` and `.env.staging` files are selected automatically based on `Environment` → `EnvFileName` mapping.

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
- Keep **contracts** (`IAppBootstrap`, `ILocalStorage`, `IRemoteDataBase`) technology-agnostic.
- Add specific implementations (Firebase, Isar, SecureStorage, etc.) in adapters, not here.
- Keep `app_bootstrap` minimal: **only startup orchestration and contracts.**
- **Pluggable**: each step (env/storage/firebase/di) is optional and replaceable.
- **Docs**: evolve `docs/` with diagrams and sample flows as features grow.

---

## License

This package is licensed under the same terms as the monorepo’s root [LICENSE](../../LICENSE).
