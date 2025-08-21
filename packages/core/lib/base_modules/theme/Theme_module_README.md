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
├── Theme_module_README.md
|
├── module_core
│   ├── app_theme_preferences.dart           # Core DTO for theme config
│   ├── theme_builder_x.dart                 # Extension to build ThemeData
│   └── theme_variants.dart                  # Enum of theme variants
|
├── text_theme                               # Fonts & typography factory
│   ├── font_family_enum.dart
│   └── text_theme_factory.dart
|
|
├── theme_providers_or_cubits                # Dual state management
│   ├── theme_cubit.dart                     # cubit with HydratedBloc (as persistant storage)
│   ├── theme_provider.dart                  # Riverpod StateNotifier
│   └── theme_storage_provider.dart          # Persistent storage provider
|
├── ui_constants                             # Colors, spacing, shadows, icons
│   ├── _app_constants.dart
│   ├── app_colors.dart
│   ├── app_icons.dart
│   ├── app_shadows.dart
│   └── app_spacing.dart
|
└── widgets_and_utils
    ├── barrier_filter.dart
    ├── blur_wrapper.dart
    ├── box_decorations
    │   ├── _box_decorations_factory.dart
    │   ├── android_card_bd.dart
    │   ├── android_dialog_bd.dart
    │   ├── ios_buttons_bd.dart
    │   ├── ios_card_bd.dart
    │   └── ios_dialog_bd.dart
    |
    ├── extensions                            # Extensions for ThemeMode, TextStyle
    │   ├── text_style_x.dart
    │   ├── theme_mode_x.dart
    │   └── theme_x.dart
    |
    ├── theme_cache_mixin.dart
    ├── theme_props_inherited_w.dart
    |
    └── theme_toggle_widgets
        ├── theme_picker.dart                 # Dropdown/list of themes
        └── theme_toggler.dart                # Toggle button for theme switching
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
