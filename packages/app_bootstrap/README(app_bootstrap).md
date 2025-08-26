# App_bootstrap

**App_bootstrap** provides a unified startup pipeline for Flutter apps: launch, error handling,
environment configuration (flavors, .env mapping), platform validation, and clean contracts for local/remote stacks.

- ✅ Single entrypoint for launching (`AppLauncher.run`)
- ✅ Environment & flavor configuration (`EnvConfig`, `FlavorConfig`)
- ✅ Platform pre-checks (`PlatformValidationUtil`)
- ✅ Clean contracts for local & remote stacks (`ILocalStorage`, `IRemoteDataBase`, `IAppBootstrap`)

---

## Installation

Add dependency in your app:

```yaml
dependencies:
  app_bootstrap:
    path: ../../packages/app_bootstrap
```

Import only via the public barrel:

```dart
import 'package:app_bootstrap/app_bootstrap_barrel.dart';
```

---

## Public API & Structure

```
lib/
├─ app_bootstrap_barrel.dart      # Single public barrel
├─ app_launcher.dart              # Guarded app runner & error handling
├─ bootstrap_contracts/
│   ├─ _bootstrap.dart            # IAppBootstrap
│   ├─ _local_storage.dart        # ILocalStorage
│   ├─ _remote_database.dart      # IRemoteDataBase
│   └─ contracts_barrel.dart      # Contracts barrel
├─ configs/
│   ├─ env.dart                   # Environment & EnvConfig
│   ├─ flavor.dart                # AppFlavor & FlavorConfig
│   └─ platform_requirements.dart # PlatformConstants (min versions)
└─ utils/
    └─ platform_validation.dart   # PlatformValidationUtil
```

> **Import rule:** In apps, import only `app_bootstrap_barrel.dart`.

---

## Quick Start

### 1) Select environment & launch app

```dart
import 'package:app_bootstrap/app_bootstrap_barrel.dart';

void main() async {
  FlavorConfig.current = AppFlavor.development; // select flavor

  await AppLauncher.run(
    bootstrap: MyAppBootstrap(),
    builder: () => const MyRootWidget(),
  );
}
```

### 2) Minimal `IAppBootstrap` implementation

```dart
final class MyAppBootstrap implements IAppBootstrap {
  const MyAppBootstrap();

  @override
  Future<void> initAllServices() async {
    await startUp();
    await initGlobalDIContainer();
    await initLocalStorage();
    await initRemoteDataBase();
  }

  @override
  Future<void> startUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await PlatformValidationUtil.run();
  }

  @override
  Future<void> initGlobalDIContainer() async {
    // Setup DI container (GetIt / Riverpod)
  }

  @override
  Future<void> initLocalStorage() async {
    // Initialize local storage stack
  }

  @override
  Future<void> initRemoteDataBase() async {
    // Initialize remote database stack (e.g. Firebase)
  }
}
```

---

## Environment & Flavors

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

## Platform Validation

Run pre-checks before app startup:

```dart
await PlatformValidationUtil.run();
```

Checks against `PlatformConstants`:

- `minSdkVersion` for Android
- `minIOSMajorVersion` for iOS

---

## Conventions

- Keep **contracts** (`IAppBootstrap`, `ILocalStorage`, `IRemoteDataBase`) technology-agnostic.
- Add specific implementations (Firebase, Isar, SecureStorage, etc.) in adapters, not here.
- Keep `app_bootstrap` minimal: **only startup orchestration and contracts.**

---

## Development

This repository uses [Melos](https://melos.invertase.dev/).

```bash
# bootstrap all packages
melos bootstrap

# only this package
melos exec --scope="app_bootstrap" -- flutter pub get
melos exec --scope="app_bootstrap" -- flutter analyze
melos exec --scope="app_bootstrap" -- flutter test
```

---

## License

Licensed under the same terms as the monorepo’s root [LICENSE](../../LICENSE).
