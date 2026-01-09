# Shared Core Modules Package

**Shared Core Modules** provides fundamental, technology-agnostic building blocks for all apps in this monorepo.
It contains **base modules** (UI design, navigation, forms, localization, overlays, animations, error handling)
that work with any state management solution (Riverpod, BLoC, or others).

- ✅ **State-agnostic** — works with Riverpod, BLoC, or vanilla Flutter.
- ✅ **Modular** — each module is self-contained with its own barrel.
- ✅ **Production-ready** — includes theming, forms, navigation, overlays, error handling.
- ✅ **Reusable** — shared across all apps in the monorepo.

---

## Installation

Add `shared_core_modules` to your app via local path:

```yaml
# apps/<your_app>/pubspec.yaml
dependencies:
  shared_core_modules:
    path: ../../packages/shared_core_modules
```

Import through the public barrels:

```dart
// Import all modules
import 'package:shared_core_modules/public_api/shared_core_modules.dart';

// Or import specific modules
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';
import 'package:shared_core_modules/public_api/base_modules/navigation.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';
```

> **Import rule:** In apps, never import internal files from `src/` directly — only use the public barrels.

---

## Public API & Structure

```
shared_core_modules/lib
├─ shared_core_modules.dart                    # 🧱 Root barrel (convenience)
│
├─ public_api/
│   ├─ base_modules/
│   │   ├─ animations.dart                     # Barrel for animations module
│   │   ├─ errors_management.dart              # Barrel for error handling module
│   │   ├─ forms.dart                          # Barrel for form fields module
│   │   ├─ localization.dart                   # Barrel for localization module
│   │   ├─ navigation.dart                     # Barrel for navigation module
│   │   ├─ overlays.dart                       # Barrel for overlays module
│   │   └─ ui_design.dart                      # Barrel for theme & UI design module
│   │
│   └─ shared_core_modules.dart                # 🧱 Main public entry point (re-exports all barrels)
│
└─ src/                                        # 🧱 Internal Sources (implementations)
    ├─ animations/
    │   ├─ module_core/                        # Core animation utilities
    │   ├─ overlays_animation/                 # Animations for overlays
    │   └─ widget_animations/                  # Widget animation helpers
    │
    ├─ errors_management/
    │   ├─ core_of_module/                     # Failure, Either, error handling core
    │   │   ├─ core_utils/                     # Extensions, loggers, result handlers
    │   │   ├─ either.dart                     # Either<Failure, Success> type
    │   │   ├─ failure_entity.dart             # Failure entity
    │   │   ├─ failure_ui_entity.dart          # UI representation of failures
    │   │   └─ failure_type.dart               # Failure type enum
    │   └─ extensible_part/                    # Failure types, mappers, extensions
    │       ├─ failure_types/                  # Firebase, network, misc failure types
    │       ├─ failure_extensions/             # Diagnostics extensions
    │       └─ exceptions_to_failure_mapping/  # Exception to Failure mappers
    │
    ├─ form_fields/
    │   ├─ input_validation/                   # Formz validators (email, password, name)
    │   ├─ shared_form_fields_states/          # SignIn, SignUp, ChangePassword, ResetPassword
    │   ├─ widgets/                            # AppFormField, PasswordVisibilityIcon
    │   ├─ utils/                              # Focus nodes, keys, typedefs
    │   └─ form_field_factory.dart             # Factory for creating form fields
    │
    ├─ localization/
    │   ├─ core_of_module/                     # AppLocalizer, localization setup
    │   ├─ generated/                          # Generated localization files
    │   ├─ module_widgets/                     # LanguageToggleButton
    │   ├─ utils/                              # Localization utilities
    │   └─ without_localization_case/          # Fallback when no localization
    │
    ├─ navigation/
    │   ├─ module_core/
    │   │   ├─ routes/                         # Route definitions
    │   │   ├─ specific_for_bloc/              # BLoC-specific navigation
    │   │   └─ specific_for_riverpod/          # Riverpod-specific navigation
    │   └─ utils/                              # Navigation extensions, helpers
    │
    ├─ overlays/
    │   ├─ core/                               # Overlay types, enums
    │   ├─ overlays_dispatcher/                # Dispatcher, overlay entries
    │   ├─ overlays_presentation/              # Overlay widgets, presets
    │   │   ├─ overlay_presets/                # Preset configurations
    │   │   └─ widgets/                        # Android, iOS, banner widgets
    │   └─ utils/                              # Ports, utilities
    │
    └─ ui_design/
        ├─ module_core/                        # Theme variants, color schemes, theme builders
        ├─ text_theme/                         # Typography (Inter, Montserrat)
        ├─ ui_constants/                       # UI constants (spacing, sizes)
        └─ widgets_and_utils/                  # Theme switchers, box decorations, extensions
```

---

## Modules

Each module has its own focused responsibility:
Each module in `core` has its own detailed README.
Below are docs with direct links:

### [Animations](./lib/src/animations/animations_module__README.md)

Reusable animation engines, presets, and widget wrappers.

### [Error Handling](./lib/src/errors_management/errors_management_module__README.md)

Failure types, Either helpers, loggers, and UI mapping.

### [Form Fields](./lib/src/form_fields/form_fields_module__README.md)

Validators, input widgets, and submission helpers.

### [Localization](./lib/src/localization/localization_module__README.md)

EasyLocalization setup, context extensions, and language toggles.

### [Navigation](./lib/src/navigation/navigation_module__README.md)

GoRouter factory, redirects, and navigation extensions.

### [Overlays](./lib/src/overlays/overlays_module_README.md)

Dispatcher, conflict policies, dialog/banner/snackbar presets.

### [Theme](./lib/src/ui_design/theme_module_README.md)

Theme variants, typography (Inter/Montserrat), colors, and toggles.

---

## Assets & Fonts

Shared Core Modules ships with shared assets:

- `assets/images/` → Shared icons, logos, loaders.
- `assets/translations/` → Localizations (`en.json`, `uk.json`, `pl.json`).
- `assets/fonts/` → **Inter** (default app font) and **Montserrat** (headings/accents).

---

## Conventions

- **Barrels for public API only.** Apps should only import from `public_api/` barrels.
- **Module isolation.** Modules don't depend on each other's internals.
- **State-agnostic.** Works with any state management (Riverpod, BLoC, etc.).
- **Technology-agnostic.** No Firebase, no specific backend — pure Flutter/Dart.

---

## Development

This repository uses [Melos](https://melos.invertase.dev/) to manage all packages.
All common tasks are automated via `melos run` scripts defined in the root `melos.yaml`.

```bash
# Bootstrap all packages
melos bootstrap

# Clean build artifacts
melos run clean
melos run clean:deep   # ⚠️ removes untracked files too

# Format, analyze, test all packages
melos run check

# Only this package
melos exec --scope="shared_core_modules" -- flutter analyze
melos exec --scope="shared_core_modules" -- flutter test
```

### (Optional) Generate an HTML coverage report with `lcov`:

```bash
# Run all tests
melos run test

# Run tests with Very Good CLI (randomized order + coverage)
melos run vg:test

# Generate coverage (lcov + HTML report)
melos run coverage

# once: brew install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Code Metrics (DCM) and code quality

```bash
# Auto-fix Dart hints
melos run fix:apply

# Apply formatting
melos run format:write
melos run format:check   # fails CI if formatting is wrong

# Analyze all packages
melos run dcm

# Generate HTML report
melos run dcm:html

# Analyze only changed files since last commit
melos run dcm:changed

# Per package
melos run dcm:core
```

### Adding a new module

1. Create a folder under `lib/base_modules/<module_name>/`.
2. Add `<module_name>.dart` exporting the module’s public surface.
3. Re-export the module barrel from `lib/core_barrel.dart`.
4. Document the module in this README (section above).

### Versioning & Changelog

We follow **SemVer**: `MAJOR.MINOR.PATCH`. Keep a `CHANGELOG.md` in the package root.

**Entry template:**

```md
## [0.1.0] — 2025-08-15

### Added

- <module>: short list of features.

### Changed

- ...

### Fixed

- ...
```

---

## License

This package is licensed under the same terms as the [root LICENSE](../../LICENSE) of this monorepo.

## Roadmap (optional)

- [ ] To achieve 100% tests coverage
