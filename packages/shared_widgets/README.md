# 🎨 Shared Widgets

_Last updated: 2025-08-01_

---

## 🎯 Purpose

This package provides **shared reusable widgets** for all applications in the monorepo. It contains common UI components, buttons, cards, and other widgets that are used across multiple apps, ensuring consistency and reducing code duplication.

---

## 📦 Package Structure

```
shared_widgets/
├── lib/
│   ├── shared_widgets.dart              # Main library export file
│   └── src/                             # Source directory for widgets
│       ├── buttons/                     # Button components
│       ├── cards/                       # Card components
│       ├── inputs/                      # Input components
│       └── layouts/                     # Layout components
│
├── test/                                # Unit and widget tests
├── pubspec.yaml                         # Package configuration
├── README.md                            # This file
└── analysis_options.yaml                # Linting rules

```

---

## 🚀 Getting Started

### Installation

This package is part of the monorepo and can be used by adding it to your app's `pubspec.yaml`:

```yaml
dependencies:
  shared_widgets:
    path: ../../packages/shared_widgets
```

### Usage

Import the package in your Dart files:

```dart
import 'package:shared_widgets/shared_widgets.dart';
```

---

## 🧩 Architecture

This package follows Clean Architecture principles and provides:

- **Reusable UI components** - Buttons, cards, inputs, layouts
- **Consistent styling** - Uses theme system from `shared_core_modules`
- **Accessibility** - All widgets follow accessibility best practices
- **Testability** - Fully unit and widget tested components
- **Platform-aware** - Adaptive widgets for iOS and Android

---

## 💡 Best Practices

- Keep widgets generic and configurable
- Always provide default values for optional parameters
- Use theme values from `shared_core_modules` for styling
- Write widget tests for all components
- Document all public APIs with dartdoc comments
- Follow Material Design and iOS HIG guidelines

---

## 📝 Adding New Widgets

When adding a new widget:

1. Create the widget file in appropriate category folder under `lib/src/`
2. Export the widget in `lib/shared_widgets.dart`
3. Write widget tests in `test/`
4. Document usage in this README
5. Update CHANGELOG.md

---

## ✅ Dependencies

This package depends on:

- `flutter` - Flutter SDK
- `shared_core_modules` - Core modules (theme, localization, etc.)
- `shared_layers` - Utility functions and layers

---

> **Happy coding! 🎨✨**
> Build consistent, reusable UI components for all apps in the monorepo.

---
