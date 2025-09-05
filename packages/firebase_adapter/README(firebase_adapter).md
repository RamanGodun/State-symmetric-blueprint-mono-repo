# Firebase Adapter

**Firebase Adapter** centralizes all Firebase-related code (init, types, gateways, utils)
so that apps and feature modules never depend on Firebase SDKs directly.

Swap the backend by replacing this package (e.g., with a future `supabase_adapter`) without touching other code.

- ✅ **Single entry point** — one public barrel to import.
- ✅ **Clean boundaries** — no Firebase deps leakage into `features`/apps.
- ✅ **Composable** — inject concrete Firebase types via DI (GetIt / Riverpod).
- ✅ **Swappable** — keep domain/data contracts backend-agnostic.

---

## Installation

Add `firebase_adapter` as a local path:

```yaml
# apps/<your_app>/pubspec.yaml OR packages/<another_package>/pubspec.yaml
dependencies:
  firebase_adapter:
    path: ../../packages/firebase_adapter
```

Import via the public barrel:

```dart
import 'package:firebase_adapter/firebase_adapter.dart';
```

> If you only need types:
>
> ```dart
> import 'package:firebase_adapter/firebase_types.dart';
> ```
>
> (re-exports `typedefs/firebase.dart`)

---

## Public API & Structure

- `lib/firebase_adapter.dart` — **single public entry point** (barrel).
- Types are re-exported to keep `features` backend-agnostic.

```
firebase_adapter/lib
├─ firebase_adapter.dart                 # ← Barrel (public API)
│
└─ src
   ├─ bootstrap/
   │   ├─ env_loader.dart                # 🧪 Load .env (throw on missing keys)
   │   ├─ firebase_env_options.dart      # 🧭 FirebaseOptions from .env (per-platform)
   │   └─ firebase_init.dart             # 🛡️ Safe init (idempotent, project verification)
   │
   ├─ auth_and_firestore/
   │   ├─ auth_user_utils.dart           # 👤 currentUserOrThrow / uid / email / reload
   │   ├─ firebase_auth_gateway.dart     # 🔐 AuthGateway impl over FirebaseAuth (+stream)
   │   └─ firebase_refs.dart             # 📚 Strong refs for FirebaseAuth & Firestore collections
   │
   ├─ typedefs.dart                      # 🔤 Typedefs & curated type exports (FBException, etc.)
   │
   └─ utils/
       └─ crash_analytics_logger.dart    # 🧰 Thin wrapper for crash/analytics logging
```

> If `utils/firebase_utils.dart` duplicates initialization logic — fold it into `bootstrap/firebase_initializer.dart`
> to avoid two “init points”.

---

## Bootstrap (env + init)

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_adapter/firebase_adapter.dart';

Future<void> main() async {
  // 📀 Load env first (decides FirebaseOptions)
  await dotenv.load(fileName: '.env.development');

  /// 🛡️ Initializes Firebase once (idempotent)
  await FirebaseInitializer.run(
    options: DotenvFirebaseOptions.currentPlatform,
  );

  // runApp(...)
}
```

> On the **web** you must pass explicit `FirebaseOptions`.

---

## DI with GetIt

```dart
import 'package:get_it/get_it.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show
  FirebaseAuth, UsersCollection, FirebaseConstants;
import 'package:features/auth/data/remote_database_contract.dart';
import 'package:features/auth/data/remote_database_impl.dart';

final di = GetIt.instance;

Future<void> registerFirebaseModule() async {
  di
    // Base Firebase instances
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseConstants.fbAuthInstance)
    ..registerLazySingleton<UsersCollection>(() => FirebaseConstants.usersCollection)

    // Feature data source (Auth) — backend-agnostic
    ..registerLazySingleton<IAuthRemoteDatabase>(() => AuthRemoteDatabaseImpl(
          di<FirebaseAuth>(),
          di<UsersCollection>(),
        ));
}
```

---

## DI with Riverpod

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show
  FirebaseAuth, UsersCollection, FirebaseConstants;

part 'firebase_providers.g.dart';

/// 🔌 [firebaseAuthProvider]
@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseConstants.fbAuthInstance;

/// 🗃️ [usersCollectionProvider]
@riverpod
UsersCollection usersCollection(Ref ref) => FirebaseConstants.usersCollection;
```

---

## Conventions

- Only this package imports `firebase_*` SDKs.
- Expose abstracted types, gateways, and helpers to other packages/apps.
- Keep one public barrel (`firebase_adapter.dart`).
- For error reporting, use `CrashlyticsLogger` (debug logs + `recordError`).

---

## Development

This monorepo uses [Melos](https://melos.invertase.dev/).

```bash
# From repo root
melos bootstrap

# Only this package
melos exec --scope="firebase_adapter" -- flutter analyze
melos exec --scope="firebase_adapter" -- flutter test
```

---

## Roadmap

- [ ] Optional web FirebaseOptions in `DotenvFirebaseOptions`.
- [ ] Unified `dispose()` hooks for gateways (stream closure) via DI module.
- [ ] Example: swap to `supabase_adapter` with identical typedefs/gateways
