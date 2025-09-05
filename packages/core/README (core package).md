# Core

**Core** is the shared codebase for all apps in this monorepo.
It is organized by **modules** (navigation, localization, overlays, etc.) and
by **layers** (data / domain / presentation) to keep code modular, reusable, and easy to evolve.

---

## Installation

Add `core` to your app via a local path:

```yaml
# apps/<your_app>/pubspec.yaml
dependencies:
  core:
    path: ../../packages/core
```

Import only through the public barrel:

```dart
import 'package:core/core.dart';
```

> **Import rule:** In apps, never import internal files from modules directly — only the barrels.

---

## Public API & Structure

- `lib/core.dart` — the single public entry point.
- Each submodule exposes its own barrel and is re-exported from `core.dart`.

```
core/lib
├─ README (core package)
|
├─ base_modules/
|   ├─ animations.dart
|   ├─ errors_management.dart
|   ├─ forms.dart
|   ├─ localization.dart
|   ├─ navigation.dart
|   ├─ overlays.dart
|   └─ ui_design.dart
|
├─ shared_layers/
|   ├─ data.dart
|   ├─ domain.dart
|   └─ presentation.dart
|
├─ utils.dart
└─ core.dart

# Internal Sources (all implementations live here)

src/
├─ base_modules/
│   ├─ animations/
│   ├─ errors_management/
│   ├─ forms/
│   ├─ localization/
│   ├─ navigation/
│   ├─ overlays/
│   └─ ui_design/
│
├─ shared_data_layer/
├─ shared_domain_layer/
├─ shared_presentation_layer/
└─ utils_shared/
```

> **Rule of thumb:**
>
> - `base_modules/`, `shared_layers/`, `utils.dart`, and `core.dart` = **barrels only** (public API).
> - `src/` = **all real source files** (implementations).

---

## Modules

Each module in `core` has its own detailed README.
Below are entry points with direct links:

### [Animations](./lib/base_modules/animations/Animations_module_README.md)

Reusable animation engines, presets, and widget wrappers.

### [Error Handling](./lib/base_modules/errors_handling/Errors_handling_module_README.md)

Failure types, Either helpers, loggers, and UI mapping.

### [Form Fields](./lib/base_modules/form_fields/Module%20README.md)

Validators, input widgets, and submission helpers.

### [Localization](./lib/base_modules/localization/Localization_module_README.md)

EasyLocalization setup, context extensions, and language toggles.

### [Navigation](./lib/base_modules/navigation/Navigation_module_README.md)

GoRouter factory, redirects, and navigation extensions.

### [Overlays](./lib/base_modules/overlays/Overlays_module_README.md)

Dispatcher, conflict policies, dialog/banner/snackbar presets.

### [Theme](./lib/base_modules/theme/Theme_module_README.md)

Theme variants, typography (Inter/Montserrat), colors, and toggles.

---

## Layers

| Layer                       | Purpose                                                                  |
| --------------------------- | ------------------------------------------------------------------------ |
| `shared_data_layer`         | DTOs, mappers, contracts/adapters shared across features.                |
| `shared_domain_layer`       | Entities, value objects, shared use cases & domain interfaces.           |
| `shared_presentation_layer` | Shared pages/widgets (`SplashPage`, `AppBar`, `Loader`).                 |
| `utils_shared`              | Cross-cutting utilities/extensions (debouncer, context extensions, etc). |

> If something doesn’t clearly fit a layer, place it in `utils_shared` temporarily and plan a follow-up refactor.

---

## Assets & Fonts

Core ships with shared assets:

- `assets/images/` → Shared icons, logos, loaders.
- `assets/translations/` → Localizations (`en.json`, `uk.json`, `pl.json`).
- `assets/fonts/` → **Inter** (default app font) and **Montserrat** (headings/accents).

---

## Conventions

- **Barrels for public API only.** Inside `core`, prefer relative imports; in apps, import barrels.
- **Module isolation.** Modules shouldn’t depend on each other’s internals; use shared layers for common pieces.
- **Naming.** Barrels are named `<module>.dart`. Public types and factories are documented.
- **Breaking changes.** Record in `CHANGELOG.md` (see template below).

---

## Development

This repository uses [Melos](https://melos.invertase.dev/) to manage all packages.
All common tasks are automated via `melos run` scripts defined in the root `melos.yaml`.

### 🔧 Common workflows (from repo root)

```bash
# Bootstrap all packages (safe pub get)
melos bootstrap

# Clean build artifacts
melos run clean
melos run clean:deep   # ⚠️ removes untracked files too

# Format, analyze, test all packages
melos run check

# Only this package (core)
melos exec --scope="core" -- flutter pub get
melos exec --scope="core" -- flutter analyze
melos exec --scope="core" -- flutter test
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

```
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

---

## Roadmap (optional)

- [ ] Consolidate essential helpers in `utils_shared`.
- [ ] Add integration examples for each module.
- [ ] Wire up unified coverage in CI if needed.
