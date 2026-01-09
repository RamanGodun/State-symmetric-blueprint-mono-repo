# Shared Layers and Utils Package

**Shared Layers and Utils** provides shared implementations across **data**, **domain**, and **presentation** layers,
plus cross-cutting utilities. This package was split from the original `core` package to separate layer-specific code
from the fundamental modules in `shared_core_modules`.

- ✅ **Layer-organized** — clear separation of data, domain, and presentation concerns.
- ✅ **State-agnostic contracts** — defines interfaces implemented by state-specific adapters.
- ✅ **Adapter pattern** — contracts here, implementations in `adapters_for_riverpod` / `adapters_for_bloc`.
- ✅ **Utilities** — context extensions, timing control, auth contracts, stream helpers.
- ✅ **Reusable** — shared entities, DTOs, widgets, and utilities.

---

## Installation

Add `shared_layers` to your app via local path:

```yaml
# apps/<your_app>/pubspec.yaml
dependencies:
  shared_layers:
    path: ../../packages/shared_layers
```

Import through the public barrels:

```dart
// Import all
import 'package:shared_layers/public_api/shared_layers.dart';

// Or import specific layers
import 'package:shared_layers/public_api/data_layer_shared.dart';
import 'package:shared_layers/public_api/domain_layer_shared.dart';
import 'package:shared_layers/public_api/presentation_layer_shared.dart';
import 'package:shared_layers/public_api/utils.dart';
```

> **Import rule:** In apps, never import internal files from `src/` directly — only use the public barrels.

---

## Public API & Structure

```
shared_layers/lib
├─ public_api/
│   ├─ data_layer_shared.dart                  # Barrel for shared data layer
│   ├─ domain_layer_shared.dart                # Barrel for shared domain layer
│   ├─ presentation_layer_shared.dart          # Barrel for shared presentation layer
│   ├─ utils.dart                              # Barrel for cross-cutting utilities
│   └─ shared_layers.dart            # 🧱 Main public entry point (re-exports all barrels)
│
└─ src/                                        # 🧱 Internal Sources (implementations)
    ├─ shared_data_layer/
    │   ├─ user_data_transfer_objects/
    │   │   ├─ _user_dto.dart                  # UserDTO model
    │   │   ├─ user_dto_x.dart                 # UserDTO extensions
    │   │   ├─ user_dto_factories_x.dart       # Factory extensions
    │   │   └─ user_dto_list_x.dart            # List extensions
    │   └─ cache_manager/
    │       ├─ cache_manager.dart              # Simple cache manager
    │       └─ cache_items.dart                # Cache item types
    │
    ├─ shared_domain_layer/
    │   └─ shared_entities/
    │       ├─ _user_entity.dart               # UserEntity model
    │       ├─ user_entity_x.dart              # UserEntity extensions
    │       └─ user_entity_factories_x.dart    # Factory extensions
    │
    ├─ shared_presentation_layer/
    │   ├─ pages_shared/
    │   │   └─ splash_page.dart                # Shared splash page
    │   ├─ shared_state_models/
    │   │   ├─ submission_state.dart           # Submission state model
    │   │   └─ deprecated/
    │   │       └─ async_state_view_as_shared_abstraction/  # Deprecated async state views
    │   ├─ side_effects_listeners/
    │   │   └─ submission_side_effects_config.dart  # Side effects configuration
    │   └─ widgets_shared/
    │       ├─ buttons/
    │       │   ├─ filled_button.dart          # Filled button widget
    │       │   ├─ text_button.dart            # Text button widget
    │       │   └─ submit_button.dart          # Submit button widget
    │       ├─ footer/
    │       │   ├─ footer_guard_while_loading.dart  # Footer guard widget
    │       │   └─ inherited_footer_guard.dart      # Inherited footer guard
    │       ├─ app_bar.dart                    # Shared app bar
    │       ├─ divider.dart                    # Divider widget
    │       ├─ key_value_text_widget.dart      # Key-value text display
    │       └─ loader.dart                     # Loading indicator
    │
    └─ utils_shared/
        ├─ auth/
        │   ├─ auth_gateway.dart               # AuthGateway contract (state-agnostic)
        │   └─ auth_snapshot.dart              # Auth snapshot model
        ├─ extensions/
        │   ├─ general_extensions/
        │   │   ├─ datetime_x.dart             # DateTime extensions
        │   │   ├─ number_formatting_x.dart    # Number formatting
        │   │   └─ string_x.dart               # String extensions
        ├─ timing_control/
        │   ├─ timing_control_barrel.dart      # Timing control barrel
        │   ├─ debouncer.dart                  # Debouncer utility
        │   ├─ throttler.dart                  # Throttler utility
        │   ├─ duration_x.dart                 # Duration extensions
        │   └─ verification_poller.dart        # Polling utility
        ├─ stream_change_notifier.dart         # Stream-based change notifier
        └─ type_definitions.dart               # Common typedefs
```

---

## Architecture: Contracts & Adapters

This package defines **state-agnostic contracts and interfaces** that are implemented by state-specific adapters:

```
┌─────────────────────────────────────────────────────────────┐
│  shared_layers (this package)                    │
│  ├─ AuthGateway (contract)                                 │
│  ├─ SubmissionSideEffectsConfig (interface)                │
│  └─ Other state-agnostic contracts...                      │
└─────────────────────────────────────────────────────────────┘
                          ▲
                          │ implements
         ┌────────────────┴────────────────┐
         │                                  │
┌────────────────────┐          ┌──────────────────────┐
│ adapters_for_bloc  │          │ adapters_for_riverpod│
│ (BLoC-specific     │          │ (Riverpod-specific   │
│  implementations)  │          │  implementations)    │
└────────────────────┘          └──────────────────────┘
```

### Example: AuthGateway Contract

**Contract** (in `shared_layers`):

```dart
// packages/shared_layers/lib/src/utils_shared/auth/auth_gateway.dart
abstract class AuthGateway {
  Stream<AuthSnapshot> get authSnapshot;
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}
```

**Implementation** (in state-specific adapters):

- `adapters_for_firebase` → `FirebaseAuthGateway` (Firebase-specific implementation)
- Apps use the contract, adapters provide the implementation

### Example: Side Effects Configuration

**Interface** (in `shared_layers`):

```dart
// packages/shared_layers/lib/src/shared_presentation_layer/side_effects_listeners/submission_side_effects_config.dart
abstract class SubmissionSideEffectsConfig {
  // State-agnostic interface for submission side effects
}
```

**Implementations** (in state-specific adapters):

- `adapters_for_riverpod` → Riverpod-specific listeners using `ref.listen`
- `adapters_for_bloc` → BLoC-specific listeners using `BlocListener`

### Benefits of This Architecture

1. **Flexibility** — Switch state management without changing core logic
2. **Testability** — Mock contracts easily in tests
3. **Separation of Concerns** — Business logic stays independent of state management
4. **Reusability** — Same contracts work across multiple apps with different state managers

---

## Key Features

### State-Agnostic Auth Contract

`AuthGateway` is a technology-agnostic contract that works with any state management.

```dart
abstract class AuthGateway {
  Stream<AuthSnapshot> get authSnapshot;
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<void> signUp(String email, String password);
  // ... other auth methods
}
```

---

## Conventions

- **Barrels for public API only.** Apps should only import from `public_api/` barrels.
- **Layer separation.** Keep data, domain, and presentation concerns separated.
- **Contracts, not implementations.** This package defines interfaces; adapters provide implementations.
- **State-agnostic.** All code here must work with any state management (Riverpod, BLoC, etc.).
- **No business logic.** This package is for shared utilities and contracts, not feature-specific logic.
- **Adapter pattern.** For state-specific behavior, implement contracts in `adapters_for_*` packages.

---

## Development

This repository uses [Melos](https://melos.invertase.dev/) to manage all packages.

```bash
# Bootstrap all packages
melos bootstrap

# Only this package
melos exec --scope="shared_layers" -- flutter analyze
melos exec --scope="shared_layers" -- flutter test
```

---

## License

This package is licensed under the same terms as the [root LICENSE](../../LICENSE) of this monorepo.
