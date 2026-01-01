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
riverpod_adapter/lib
├─ riverpod_adapter.dart                                                      # 🧱 Public barrel (facade API)
│
└─ src/
   ├─ app_bootstrap/
   │   ├─ di/
   │   │   ├─ di_config_examples/
   │   │   │   ├─ di_config_async.dart                                        # Example async DI setup
   │   │   │   └─ di_config_sync.dart                                         # Example sync DI setup
   │   │   ├─ global_di_container.dart                                        # GlobalDIContainer singleton
   │   │   ├─ i_di_config.dart                                                # IDIConfig contract
   │   │   └─ read_di_x_on_context.dart                                       # Extension: context.readDI(...)
   │   └─ placeholder.dart                                                    # 📌 Placeholder for bootstrap hooks
   │
   ├─ core/
   │   ├─ base_modules/
   │   │   ├─ errors_handling_module/
   │   │   │   └─ async_value_failure_x.dart                                  # Extract Failure from AsyncError
   │   │   ├─ observing/
   │   │   │   ├─ async_value_xx.dart                                         # Debug helpers for AsyncValue
   │   │   │   └─ providers_debug_observer.dart                               # ProviderObserver with logs
   │   │   ├─ overlays_module/
   │   │   │   ├─ overlay_adapters_providers.dart                             # Overlay dispatcher + status providers
   │   │   │   ├─ overlay_adapters_providers.g.dart                           # Generated providers
   │   │   │   ├─ overlay_resolver_wiring.dart                                # Wiring overlays into lifecycle
   │   │   │   └─ overlay_status_x.dart                                       # Quick access helpers
   │   │   └─ theme_module/
   │   │       ├─ theme_provider.dart                                         # Theme state (Riverpod Notifier)
   │   │       ├─ theme_storage_provider.dart                                 # Persistence (GetStorage)
   │   │       └─ theme_toggle_widgets/
   │   │           ├─ theme_picker.dart                                       # Riverpod adapter for ThemePicker
   │   │           └─ theme_toggler.dart                                      # Riverpod adapter for ThemeTogglerIcon
   │   │
   │   ├─ shared_presentation/
   │   │   ├─ async_state/
   │   │   │   ├─ async_state_view_for_riverpod.dart                          # AsyncLike facade for Riverpod AsyncValue
   │   │   │   ├─ async_value_match_x.dart                                    # fold(success/error/loading) extension
   │   │   │   ├─ deprecated/
   │   │   │   │   └─ async_error_listener.dart                               # Legacy error listener (to be removed)
   │   │   │   └─ safe_async_state.dart                                       # Guard AsyncNotifier after dispose
   │   │   │
   │   │   ├─ shared_widgets/
   │   │   │   └─ form_submit_button.dart                                     # Smart submit button (Riverpod-aware)
   │   │   │
   │   │   └─ side_effects_listeners/
   │   │       ├─ async_multi_errors_listener.dart                            # Listen multiple AsyncValue errors
   │   │       ├─ deprecated/
   │   │       │   └─ show_dialog_when_error_x_on_ref.dart                    # Legacy error dialog
   │   │       └─ side_effect_listener_for_submission_state__x_on_ref.dart    # Submission side-effects
   │   │
   │   └─ utils/
   │       ├─ auth/
   │       │   ├─ auth_stream_adapter.dart                                    # AuthGateway ⇢ Stream<AuthSnapshot>
   │       │   ├─ auth_stream_adapter.g.dart                                  # Generated provider code
   │       │   ├─ firebase_providers.dart                                     # FirebaseAuth & Users collection providers
   │       │   └─ firebase_providers.g.dart                                   # Generated provider code
   │       └─ typedefs.dart                                                   # Common typedefs for callbacks & refs
   │
   ├─ features/
   │   ├─ features_providers/
   │   │   ├─ auth/
   │   │   │   ├─ data_layer_providers/                                       # Auth data providers
   │   │   │   └─ domain_layer_providers/                                     # Auth domain providers
   │   │   ├─ email_verification/                                             # Email verification providers
   │   │   ├─ password_changing_or_reset/                                     # Password reset/change providers
   │   │   └─ profile/                                                        # Profile feature providers
   │   └─ placeholder.dart
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
