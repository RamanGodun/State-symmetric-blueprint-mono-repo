# 🎨 Theme & Preferences Module Guide

_Last updated: 2025-08-01_

---

## 🎯 Purpose

This module provides a **universal, declarative, and persistent theme system** for Flutter applications.
It encapsulates all theme logic (colors, fonts, spacing, shadows, typography)
and supports **both Riverpod and cubit/BLoC** without code duplication.

---

## 🚀 Quick Start

### With cubit:

```dart
// In MaterialApp
BlocSelector<AppThemecubit, ThemePreferences, ThemePreferences>(
  selector: (state) => state,
  builder: (context, prefs) {
    return MaterialApp(
      theme: prefs.buildLight(),
      darkTheme: prefs.buildDark(),
      themeMode: prefs.mode,
    );
  },
);
```

### With Riverpod:

```dart
// Inside ConsumerWidget
final prefs = ref.watch(themeProvider);
MaterialApp(
  theme: prefs.buildLight(),
  darkTheme: prefs.buildDark(),
  themeMode: prefs.mode,
);
```

---

## 📦 File Structure

```
ui_design/
├── module_core/                             # Core theme configuration
│   ├── app_theme_preferences.dart           # Core DTO for theme config
│   ├── theme__variants.dart                 # Enum of theme variants + color schemes
│   ├── theme_builder_x.dart                 # Extension to build ThemeData
│   └── theme_cache_mixin.dart               # Mixin for theme caching
│
├── text_theme/                              # Typography system
│   ├── font_family_enum.dart                # Font family enum (Inter, Montserrat)
│   ├── font_parser.dart                     # Font parsing utilities
│   └── text_theme_factory.dart              # Typography factory
│
├── ui_constants/                            # Design tokens & constants
│   ├── _app_constants.dart                  # Barrel for all constants
│   ├── app_colors.dart                      # Color constants
│   ├── app_icons.dart                       # Icon constants
│   ├── app_shadows.dart                     # Shadow styles
│   └── app_spacing.dart                     # Spacing & sizing constants
│
├── utils/                                   # UI utilities and helpers
│   ├── box_decorations/                     # Platform-specific box decorations
│   │   ├── _box_decorations_factory.dart    # Factory for box decorations
│   │   ├── android_card_bd.dart             # Android card decoration
│   │   ├── android_dialog_bd.dart           # Android dialog decoration
│   │   ├── ios_buttons_bd.dart              # iOS button decoration
│   │   ├── ios_card_bd.dart                 # iOS card decoration
│   │   └── ios_dialog_bd.dart               # iOS dialog decoration
│   │
│   └── extensions/                          # Extension methods
│       ├── context_extensions/              # BuildContext extensions
│       │   ├── _context_extensions.dart     # Barrel for context extensions
│       │   ├── media_query_x.dart           # MediaQuery extensions
│       │   ├── other_x.dart                 # Other context extensions
│       │   └── padding_x.dart               # Padding extensions
│       ├── extension_on_widget/             # Widget extensions
│       │   ├── _widget_aligning_x.dart      # Widget alignment extensions
│       │   ├── _widget_border_radius_x.dart # Border radius extensions
│       │   ├── _widget_padding_x.dart       # Widget padding extensions
│       │   ├── _widget_x.dart               # Barrel for widget extensions
│       │   └── widget_x.dart                # Main widget extensions
│       ├── text_style_x.dart                # TextStyle extensions
│       ├── theme_mode_x.dart                # ThemeMode extensions
│       └── theme_x.dart                     # Theme extensions
│
├── widgets/                                 # Theme-related widgets
│   ├── theme_props_inherited_w.dart         # InheritedWidget for theme props
│   └── theme_switchers/                     # Theme switching components
│       ├── theme_picker.dart                # Dropdown/list of themes
│       └── theme_toggler_icon.dart          # Toggle icon for theme switching
│
└── README__for_theme_module.md              # Module documentation

Note: Theme state management (cubit/provider) lives in adapter packages:
- adapters_for_bloc → theme_cubit.dart (with HydratedBloc)
- adapters_for_riverpod → theme_provider.dart + theme_storage_provider.dart
```

---

## 🧩 Architecture & Flow

### High-level Flow

1. `ThemePreferences` defines selected variant + font.
2. `ThemeConfigNotifier` (Riverpod) or `AppThemecubit` (cubit) updates preferences.
3. `ThemeVariantsEnum.build()` + `ThemeCacheMixin` generate ThemeData.
4. `MaterialApp.router()` consumes light/dark theme via `prefs.buildLight()`.

### Dual-State Support

| Approach | State Logic         | Persistence         |
| -------- | ------------------- | ------------------- |
| cubit    | AppThemecubit       | HydratedBloc (JSON) |
| Riverpod | ThemeConfigNotifier | GetStorage          |

---

## 📝 Usage

### Theme toggling

```dart
// cubit
context.read<AppThemecubit>().toggleTheme();

// Riverpod
ref.read(themeProvider.notifier).setTheme(ThemeVariantsEnum.dark);
```

### Font switching

```dart
ref.read(themeProvider.notifier).setFont(AppFontFamily.aeonik);
```

### UI widgets

```dart
// Theme toggler button
ThemeToggler();

// Theme picker dropdown
ThemePicker(
  onChanged: (variant) =>
    ref.read(themeProvider.notifier).setTheme(variant),
);
```

---

## ❓ FAQ

> **How do I add a new theme variant?**

- Add it to `ThemeVariantsEnum` in `app_theme_variants.dart`.
- Add color tokens to `AppColors`.

> **How to use ThemeToggler?**

- Simply place `ThemeToggler()` in your UI; it will call `toggleTheme()` internally.

> **Can I use Material 3?**

- Yes, extend `ThemeVariantX.build()` with Material3 fields.

---

## 💡 Best Practices

- Keep all colors and typography in `ui_constants/` and `text_theme/`.
- Never hardcode styles in UI.
- Use `ThemeCacheMixin` to avoid rebuild cost.
- Use extension methods (e.g., `context.theme`) for cleaner syntax.

## ⚠️ Avoid Pitfalls

- Do not bypass `themeProvider` or `AppThemecubit` directly.
- Avoid mutating `ThemePreferences` — always use `copyWith`.

---

## ✅ Final Notes

- Supports both **Riverpod** and **cubit**. Theme state saved across sessions using `GetStorage` or `HydratedBloc`.
- Easily extendable via enums/configs
- Highly testable, no context-coupling
- Fully declarative + composable UI integration
- Colors, spacing, shadows, icons defined in `ui_constants/`.
- Custom fonts via `text_theme_factory`.
- Ready-to-use components like `ThemePicker` and `ThemeToggler`.

---

> > **Happy coding! 🎬✨**

## 🏆 Build beautiful, scalable apps with consistent themes — architecture-first, UI-last.
