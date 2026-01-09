# Riverpod Adapters Package

**Riverpod Adapters** provides lightweight glue between your domain/data code and the Riverpod runtime:

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
  adapters_for_riverpod:
    path: ../../packages/adapters_for_riverpod
```

Import public pieces where needed:

```dart
// General helpers / DI / base modules
import 'package:adapters_for_riverpod/adapters_for_riverpod.dart';
```

> **Import rule:** Prefer the public barrel (`adapters_for_riverpod.dart`) instead of deep file paths.

---

## Directory Structure

```
adapters_for_riverpod/lib
├─ adapters_for_riverpod.dart                                                 # 🧱 Public barrel (facade API)
│
└─ src/
   ├─ app_bootstrap/
   │   └─ di/
   │       ├─ di_config_examples/
   │       │   ├─ di_config_async.dart                                        # Example async DI setup
   │       │   └─ di_config_sync.dart                                         # Example sync DI setup
   │       ├─ global_di_container.dart                                        # GlobalDIContainer singleton
   │       ├─ i_di_config.dart                                                # IDIConfig contract
   │       └─ read_di_x_on_context.dart                                       # Extension: context.readDI(...)
   │
   ├─ base_modules/
   │   ├─ errors_handling_module/
   │   │   └─ async_value_failure_x.dart                                      # Extract Failure from AsyncError
   │   ├─ observing/
   │   │   ├─ async_value_xx.dart                                             # Debug helpers for AsyncValue
   │   │   └─ providers_debug_observer.dart                                   # ProviderObserver with logs
   │   ├─ overlays_module/
   │   │   ├─ locker_while_active_overlay.dart                                # Overlay locker utility
   │   │   ├─ overlay_adapters_providers.dart                                 # Overlay dispatcher + status providers
   │   │   ├─ overlay_adapters_providers.g.dart                               # Generated providers
   │   │   ├─ overlay_resolver_wiring.dart                                    # Wiring overlays into lifecycle
   │   │   └─ overlay_status_x.dart                                           # Quick access helpers
   │   └─ theme_module/
   │       ├─ theme_provider.dart                                             # Theme state (Riverpod Notifier)
   │       ├─ theme_storage_provider.dart                                     # Persistence (GetStorage)
   │       └─ theme_toggle_widgets/
   │           ├─ theme_picker.dart                                           # Riverpod adapter for ThemePicker
   │           └─ theme_toggler.dart                                          # Riverpod adapter for ThemeTogglerIcon
   │
   ├─ features/
   │   ├─ auth/
   │   │   ├─ auth_gateway/
   │   │   │   ├─ auth_gateway_providers.dart                                 # Auth gateway providers
   │   │   │   └─ auth_gateway_providers.g.dart
   │   │   ├─ data_layer_providers/
   │   │   │   ├─ data_layer_providers.dart                                   # Auth data layer providers
   │   │   │   └─ data_layer_providers.g.dart
   │   │   ├─ domain_layer_providers/
   │   │   │   ├─ use_cases_providers.dart                                    # Auth use cases providers
   │   │   │   └─ use_cases_providers.g.dart
   │   │   └─ for_firebase/
   │   │       ├─ firebase_providers.dart                                     # FirebaseAuth & Users collection providers
   │   │       └─ firebase_providers.g.dart
   │   ├─ email_verification/
   │   │   ├─ data_layer_providers/
   │   │   │   ├─ data_layer_providers.dart
   │   │   │   └─ data_layer_providers.g.dart
   │   │   └─ domain_layer_providers/
   │   │       ├─ use_case_provider.dart
   │   │       └─ use_case_provider.g.dart
   │   ├─ password_changing_or_reset/
   │   │   ├─ data_layer_providers/
   │   │   │   ├─ data_layer_providers.dart
   │   │   │   └─ data_layer_providers.g.dart
   │   │   └─ domain_layer_providers/
   │   │       ├─ use_cases_provider.dart
   │   │       └─ use_cases_provider.g.dart
   │   └─ profile/
   │       ├─ data_layers_providers/
   │       │   ├─ data_layer_providers.dart
   │       │   └─ data_layer_providers.g.dart
   │       └─ domain_layer_providers/
   │           ├─ use_case_provider.dart
   │           └─ use_case_provider.g.dart
   │
   ├─ shared_presentation/
   │   ├─ async_state_model/
   │   │   ├─ async_state_introspection.dart                                  # BLoC for introspecting async state
   │   │   ├─ safe_async_state.dart                                           # Guard AsyncNotifier after dispose
   │   │   └─ deprecated/
   │   │       └─ async_error_listener.dart                                   # [Deprecated] Legacy error listener
   │   ├─ side_effects_listeners/
   │   │   ├─ adapter_for_async_value_flow.dart                               # Adapter for async value flow
   │   │   ├─ adapter_for_submission_flow.dart                                # Submission side-effects
   │   │   └─ deprecated/
   │   │       └─ show_dialog_when_error_x_on_ref.dart                        # [Deprecated] Legacy error dialog
   │   └─ widgets_shared/
   │       ├─ adapter_for_footer_guard.dart                                   # Footer guard adapter
   │       └─ adapter_for_submit_button.dart                                  # Smart submit button (Riverpod-aware)
   │
   └─ utils/
       └─ typedefs.dart                                                       # Common typedefs for callbacks & refs
```

---

## Quick Start

### 1) Create a global container in bootstrap

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adapters_for_riverpod/adapters_for_riverpod.dart';

void main() async {
  final container = ProviderContainer(
    overrides: const [], // or provided by your DI config
    observers: [ProvidersDebugObserver()],
  );

  GlobalDIContainer.initialize(container);

  runApp(UncontrolledProviderScope(
    container: GlobalDIContainer.instance,
    child: const App(),
  ));
}
```

### 2) Use DI configuration

```dart
import 'package:adapters_for_riverpod/adapters_for_riverpod.dart';

// Implement IDIConfig for your app's DI setup
class DIConfiguration implements IDIConfig {
  @override
  List<Override> get overrides => [
    // Add your provider overrides here
  ];

  @override
  List<ProviderObserver> get observers => [
    ProvidersDebugObserver(),
  ];
}
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
melos exec --scope="adapters_for_riverpod" -- flutter analyze
melos exec --scope="adapters_for_riverpod" -- flutter test

# Codegen (required for *.g.dart)
melos exec --scope="adapters_for_riverpod" -- flutter pub run build_runner build --delete-conflicting-outputs
```

---

## License

Licensed under the same terms as the monorepo’s root [LICENSE](../../LICENSE).
