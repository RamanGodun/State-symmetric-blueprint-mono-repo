# Riverpod Adapter

**Riverpod Adapter** provides lightweight glue between your domain/data code and the Riverpod runtime:

- ✅ Ready‑made providers for Firebase (auth, users collection) via `firebase_adapter`.
- ✅ Feature‑level provider bundles (Auth, Email verification, Password reset/change, Profile) that wire **domain contracts** from `features` to concrete infra.
- ✅ Base utilities for async/error handling, overlays, theming, and structured provider logging.
- ✅ Global DI container you can use **outside** widget tree and pass as `ProviderScope.parent`.

This keeps apps and feature modules backend‑agnostic while staying ergonomic in Riverpod.

---

## Installation

Add the package via local path:

```yaml
# apps/<your_app>/pubspec.yaml or packages/<another_package>/pubspec.yaml
dependencies:
  riverpod_adapter:
    path: ../../packages/riverpod_adapter
```

Import public pieces where needed:

```dart
// General helpers / DI / base modules
import 'package:riverpod_adapter/riverpod_adapter.dart';

// Firebase bindings (Auth, Users collection)
import 'package:riverpod_adapter/auth/firebase_providers.dart';

// Feature bundles (Auth, Profile, etc.)
import 'package:riverpod_adapter/features_providers/auth/data_layer_providers.dart';
```

> **Import rule:** Prefer the provided barrels (e.g. `riverpod_adapter.dart`, module barrels) instead of deep file paths.

---

## Directory Structure

```
lib/
├─ riverpod_adapter.dart              # ← single public barrel
│
├─ src/
│  ├─ utils/
│  │   ├─ auth/
│  │   │   ├─ auth_stream_adapter.dart              # AuthGateway ⇢ Stream<AuthSnapshot>
│  │   │   └─ firebase_providers.dart               # FirebaseAuth & Users collection providers
│  │   ├─ safe_async_state.dart                     # Guard AsyncNotifier updates after dispose
│  │   └─ typedefs.dart                             # Common typedefs for callbacks & refs
│  │
│  ├─ base_modules/
│  │   ├─ errors_handling_module/
│  │   │   ├─ async_value_failure_x.dart            # Extract Failure from AsyncError
│  │   │   ├─ async_value_match_x.dart              # Declarative fold(success/error/loading)
│  │   │   └─ show_dialog_when_error_x_on_ref.dart  # Show Failure via overlay
│  │   ├─ observing/
│  │   │   ├─ async_value_xx.dart                   # Debug helpers for AsyncValue
│  │   │   └─ providers_debug_observer.dart         # ProviderObserver with structured logs
│  │   ├─ overlays_module/
│  │   │   ├─ overlay_adapters_providers.dart       # Overlay dispatcher + status (Riverpod DI)
│  │   │   ├─ overlay_resolver_wiring.dart          # Global & context-based resolver wiring
│  │   │   └─ overlay_status_x.dart                 # Quick access to overlay flag
│  │   └─ theme_module/
│  │       ├─ theme_provider.dart                   # StateNotifier + preferences
│  │       ├─ theme_storage_provider.dart           # GetStorage binding
│  │       └─ theme_toggle_widgets/
│  │           ├─ theme_picker.dart                 # Riverpod adapter for ThemePicker
│  │           └─ theme_toggler.dart                # Riverpod adapter for ThemeTogglerIcon
│  │
│  ├─ di/
│  │   ├─ global_di_container.dart                  # GlobalDIContainer singleton
│  │   ├─ i_di_config.dart                          # IDIConfig contract
│  │   ├─ read_di_x_on_context.dart                 # context.readDI(...) extension
│  │   └─ di_config_examples/
│  │       ├─ di_config_sync.dart                   # Example sync DI setup
│  │       └─ di_config_async.dart                  # Example async DI setup
│  │
│  └─ features_providers/
│      ├─ auth/                                     # Wires features/auth
│      │   ├─ data_layer_providers/
│      │   └─ domain_layer_providers/
│      ├─ email_verification/                       # Wires features/email_verification
│      ├─ password_changing_or_reset/               # Wires features/password flows
│      └─ profile/                                  # Wires features/profile
```

---

## Quick Start

### 1) Create a global container in bootstrap

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/di_container/di_container.dart';

void main() async {
  final parent = ProviderContainer(
    overrides: const [], // or provided by your DI config
    observers: [RiverpodLogger()],
  );

  GlobalDIContainer.initialize(parent);

  runApp(ProviderScope(
    parent: GlobalDIContainer.instance,
    child: const App(),
  ));
}
```

### 2) Provide Firebase bindings (once)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_adapter/auth/firebase_providers.dart';

// then simply `ref.watch(firebaseAuthProvider)` or `ref.watch(usersCollectionProvider)` wherever needed
```

### 3) Use feature bundles

```dart
import 'package:riverpod_adapter/features_providers/auth/data_layer_providers.dart';
import 'package:riverpod_adapter/features_providers/auth/domain_layer_providers.dart';

final signIn = ref.watch(signInUseCaseProvider);
await signIn('email', 'password');
```

---

## Error Handling & Overlays

Use the provided extensions to keep UI tidy and consistent:

```dart
ref.listenFailureWithAction(
  someAsyncProvider,
  context,
  onConfirmed: () => ref.refresh(someAsyncProvider.future),
);

// Or simple fold
ref.watch(someAsyncProvider).fold(
  onSuccess: (data) => ...,
  onError: (failure) => context.showError(failure.toUIEntity()),
  onLoading: () => ...,
);
```

Overlay status is exposed via `overlayStatusProvider` and updates automatically through `overlayDispatcherProvider`.

---

## Theming

```dart
final theme = ref.watch(themeProvider);
ref.read(themeProvider.notifier).toggleTheme();
```

The notifier persists theme/font to `GetStorage` via `theme_storage_provider.dart`.

---

## Conventions

- Only Riverpod‑specific glue lives here; domain contracts/implementations remain in `features`.
- All Firebase SDK access goes through `firebase_adapter` — this package only consumes its types/providers.
- Prefer **providers/overrides** over global singletons; when needed, use `GlobalDIContainer` for non‑widget code.
- Keep generated files (`*.g.dart`) out of VCS if your repo policy requires; they are produced by `riverpod_generator`.

---

## Development

This monorepo uses [Melos](https://melos.invertase.dev/).

```bash
# From repo root
melos bootstrap

# Only this package
melos exec --scope="riverpod_adapter" -- flutter analyze
melos exec --scope="riverpod_adapter" -- flutter test

# Codegen (required for *.g.dart)
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## License

Licensed under the same terms as the monorepo’s root [LICENSE](../../LICENSE).
