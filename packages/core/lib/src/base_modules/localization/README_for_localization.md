# 🌍 Localization Module Guide

_Last updated: 2026-01-03_

---

## 1. 🎯 GOAL

This module provides a **universal, modular, and scalable localization system** for Flutter apps, based on `EasyLocalization`.
It supports both **Riverpod** and **cubit/BLoC** without code duplication and enables fully declarative, testable, and fallback-ready i18n.

- 🧩 Designed for Clean Architecture and state-agnostic flows
- 🌐 Built for modular codebases: localization is completely isolated
- ⚙️ Supports pluralization and boot-time and fallback initialization modes
- 🧪 Works in tests, CLI, and no-context environments

---

## 2. 🚀 Quick Start (in this monorepo)

1.  Generate All Localizations

```bash
# Generate everything (Core + All Apps)
melos run localization:gen:all

# Or use the alias
melos run locale:regen
```

2.  Generate Only Core

```bash
melos run localization:gen:core
```

3.  Generate Only App-Specific

```bash
# For Cubit app
melos run localization:gen:cubit

# For Riverpod app
melos run localization:gen:riverpod

# For all apps
melos run localization:gen:apps
```

### 📊 Available Melos Commands

| Command                               | Description                                  |
| ------------------------------------- | -------------------------------------------- |
| `melos run localization:gen:all`      | Generate EVERYTHING (Core + All Apps)        |
| `melos run locale:regen`              | Alias for `localization:gen:all`             |
| `melos run localization:gen:core`     | Generate only CoreLocaleKeys                 |
| `melos run localization:gen:cubit`    | Generate only AppLocaleKeys for Cubit app    |
| `melos run localization:gen:riverpod` | Generate only AppLocaleKeys for Riverpod app |
| `melos run localization:gen:apps`     | Generate AppLocaleKeys for all apps          |

---

## 3. 🚀 Localization Setup (from scratch) Guide

1.  Add Dependency

```yaml
dependencies:
  easy_localization: ^3.0.0
```

---

2.  Create JSON Files in `assets/translations/`:

```
assets/translations/
  - en.json
  - uk.json
  - pl.json
```

---

3.  Register Assets in `pubspec.yaml`

```yaml
flutter:
  assets:
    - assets/translations/
```

---

4.  iOS Setup

```xml
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>uk</string>
  <string>pl</string>
</array>
```

---

### 5. ⚙️ Bootstrap Integration (before `runApp()`)

📌 This logic goes in `AppBootstrap._initLocalization()`.
You MUST choose your mode manually in the bootstrap phase:

```dart
Future<void> initEasyLocalization() async {
  await EasyLocalization.ensureInitialized();

  /// 🌍 Sets up the global localization resolver for the app (when using EasyLocalization)
  AppLocalizer.init(resolver: (key) => key.tr());
    // ? when app without localization, then instead previous method use next:
    // AppLocalizer.initWithFallback();

  // 🟡 Enable fallback-only mode (e.g., early error handling)
  AppLocalizer.init(resolver: (key) => LocalesFallbackMapper.resolveFallback(key));
}
```

---

### 6. Wrap App in `EasyLocalization`

#### In app with Riverpod as state manager:

```dart
runApp(
  ProviderScope(
    parent: GlobalDIContainer.instance,
    child: AppLocalizationShell(),
  ),
);
```

#### In app with cubit/BLoC as state manager:

```dart
runApp(GlobalProviders(child: AppLocalizationShell()));
```

---

### 7. Call `LocalizationWrapper.configure` in `AppLocalizationShell`

```dart
class AppLocalizationShell extends StatelessWidget {
  const AppLocalizationShell({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizationWrapper.configure(const AppRootViewShell());
  }
}
```

---

### 8. Configure `MaterialApp`

```dart
MaterialApp.router(
  locale: context.locale,
  supportedLocales: context.supportedLocales,
  localizationsDelegates: context.localizationDelegates,
  // ...theme, router, overlays
);
```

Localization is injected into `MaterialApp.router()` for hot reload support.

---

### ⚙️ 9. Use Code Generation or melos scripts

You MUST generate keys + loader:

- 🧬 Install build_runner

```bash
flutter pub add --dev build_runner
```

- 🧬 Run generators

```bash
dart run easy_localization:generate \
  -S assets/translations \
  -O lib/core/base_modules/localization/generated \
  -o codegen_loader.g.dart

dart run easy_localization:generate \
  -f keys \
  -S assets/translations \
  -O lib/core/base_modules/localization/generated \
  -o locale_keys.g.dart
```

---

## 📝 Usage general examples

- Use only generated keys — never hardcode translation keys or locale codes in the UI/business logic.

---

### Accessing Translations

```dart
Text(LocaleKeys.profile_username.tr()),
Text(LocaleKeys.welcome_message.tr(args: [userName])),
```

---

### Switching Languages

```dart
// Switch to Ukrainian, for example:
context.setLocale(const Locale('uk', 'UA'));
```

---

### Pluralization & Contextualization

```dart
LocaleKeys.items_count.trPlural(count),
LocaleKeys.welcome_gender.tr(gender: user.gender),
```

---

### ✅ Shared Pattern: `_resolveText()` or `_resolveLabel()`

All UI components MUST use this pattern for safe localization fallback:

```dart
  String _resolveText(String raw, String? fallback) {
    final isLocalCaseKey = raw.contains('.');
    if (isLocalCaseKey && AppLocalizer.isInitialized) {
      return AppLocalizer.translateSafely(raw, fallback: fallback ?? raw);
    }
    return raw;
  }
```

---

### 🔤 `TextWidget`

```dart
TextWidget(LocaleKeys.profile_email, TextType.bodySmall)
```

- Safe wrapper over `Text()` with styling + localization fallback

### ✍️ `AppTextField`

```dart
AppTextField(label: LocaleKeys.form_email, fallback: 'Email', ...)
```

- Uses `_resolveLabel()` internally for label safety

---

## 🧾 Usage in Localizing Form Validation

Your form inputs (email, name, password, etc.) can expose **localization-ready validation keys**,
which are resolved into readable messages only at the UI level.

---

#### 🔁 Key Strategy

- Each `FormzInput` (e.g. `EmailInputValidation`) contains a computed field:

```dart
String? get uiErrorKey => isPure || isValid ? null : errorKey;
```

- The `errorKey` returns a constant from `LocaleKeys`, based on the input error enum.

```dart
String? get errorKey => switch (error) {
  EmailValidationError.empty => LocaleKeys.form_email_is_empty,
  EmailValidationError.invalid => LocaleKeys.form_email_is_invalid,
  _ => null,
};
```

---

#### 🌐 UI-Level Localization

In UI widgets such as `AppTextField`, this key is converted to a readable string:

```dart
final String message = AppLocalizer.translateSafely(uiErrorKey, fallback: fallback);
```

Or using `_resolveText()` pattern:

```dart
String _resolveText(String? key, String fallback) {
  if (key != null && AppLocalizer.isInitialized) {
    return AppLocalizer.translateSafely(key, fallback: fallback);
  }
  return fallback;
}
```

---

#### 🧪 No-Context Support

Because the key is passed as a string constant, validation logic and `FormzInput` classes:

- ✅ Do not depend on `BuildContext`
- ✅ Are usable in pure Dart tests, CLI, or headless logic

---

### 🔥 Usage in Overlays flow

In addition to regular UI strings, this module supports full localization of error messages coming from
your app’s failure-handling system. All domain or infrastructure errors (e.g. Firebase, HTTP)
can be automatically translated via their `translationKey`.

---

#### 💡 How it works

- All errors are wrapped in a `Failure` model.
- Each `Failure` can include an optional `translationKey`.
- A `FailureToUIEntityX` extension maps a `Failure` to a `FailureUIEntity`, including localized message via `AppLocalizer.translateSafely(...)`.
- This UI entity is then passed to overlay utilities such as `context.showError(...)`.

```dart
final uiText = AppLocalizer.t(failure.translationKey!, fallback: failure.message);
```

> Fallback mechanism ensures that even if the key is missing or not found, the raw `message` is displayed instead.

#### 🛡️ Best Practices for Error Localization

- Always assign `translationKey` inside domain or data layer when throwing a `Failure`.
- Use fallback `message` to show something meaningful if localization fails.
- Group all error-related keys under a namespace like `errors_`.
- Keep overlay and errors handling logic fully decoupled from localization.

---

## 🧩 Architecture & Flow

> **Declarative, DI-agnostic, and robust — designed for production & multi-language growth.**

- **Single entrypoint:** All localization setup and context integration flows through `LocalizationWrapper.configure(...)`.
- **App-level injection:** Locale and delegates always injected at the highest possible widget (usually `MaterialApp.router`).
- **Generated keys:** Access all translations via generated constants (`LocaleKeys`) — never use hardcoded keys.
- **Hot reload & async switching:** Language/locale can be switched at runtime, with instant app reload. Supports both sync and async switching.
- **Fallbacks & custom resolvers:** Built-in fallback for missing translations; allows for custom resolution logic per app or module.
- **Pluralization/context:** Supports plural, gender, and context-based translations out-of-the-box.
- **Modular:** Localization is completely isolated and testable — no hidden app dependencies.
- **Hot reload support** Locale, supportedLocales, and delegates are always injected into MaterialApp using `context.*` for hot reload support.

### Typical Localization Flow

1. **App bootstraps**, ensuring EasyLocalization is initialized before app launch.
2. **LocalizationWrapper** injects all context and translation delegates.
3. **MaterialApp.router** is configured with locale, supportedLocales, and delegates from context.
4. **Keys are used via LocaleKeys** everywhere in code (no magic strings).
5. **Language can be switched** at runtime — UI reloads automatically.

---

### 🌍📋 Dual-Layer Localization Guide

This monorepo uses a **dual-layer localization strategy**:

1. **Core Layer** (`CoreLocaleKeys`) — Shared translations in `packages/shared_core_modules`
   - Errors, validation messages, common UI labels
   - Used by all apps and reusable packages

2. **App Layer** (`AppLocaleKeys`) — App-specific translations in `apps/*/`
   - Features, screens, business logic specific to each app
   - Each app has its own set of AppLocaleKeys

### Translation Resolution Order

```
User requests translation for key "auth.sign_in_title"
    ↓
1. Check app-specific translations (AppLocaleKeys)
    ↓ (if not found)
2. Check core shared translations (CoreLocaleKeys)
    ↓ (if not found)
3. Fallback to fallback locale (en)
```

## 📦 File Structure

- No tight coupling with app-level DI or state management. Only localization logic inside this module.
  Each folder and file is strictly responsible for a single concern (core, assets, extensions, context, keys, etc). Example structure:

```regarding dual layer
monorepo/
├── packages/shared_core_modules/
│   ├── assets/translations/                     # CORE translations
│   │   ├── en.json                              # { "errors": {...}, "validation": {...} }
│   │   ├── uk.json
│   │   └── pl.json
│   └── lib/src/localization/generated/
│       ├── core_locale_keys.g.dart              # CoreLocaleKeys class
│       └── codegen_loader.g.dart
│
└── apps/
    ├── state_symmetric_on_cubit/
    │   ├── assets/translations/                 # APP translations
    │   │   ├── en.json                          # { "home": {...}, "auth": {...} }
    │   │   ├── uk.json
    │   │   └── pl.json
    │   └── lib/core/base_modules/localization/
    │       ├── localization_wrapper.dart        # EasyLocalization config
    │       └── generated/
    │           ├── app_locale_keys.g.dart       # AppLocaleKeys class
    │           └── codegen_loader.g.dart
    │
    └── state_symmetric_on_riverpod/
        └── (same structure)
```

```localization module files structure
localization/
      .
      ├── core_of_module
      │   ├── init_localization.dart        # Central public API for resolving localization keys
      │   └── localization_wrapper.dart     # App-level wrapper injecting context
      |
      ├── generated                         # must be created via easy\_localization codegen
      │   ├── codegen_loader.g.dart
      │   └── locale_keys.g.dart
      |
      ├── module_widgets
      │   ├── key_value_text_widget.dart
      │   ├── language_toggle_button
      │   │   ├── language_option.dart
      │   │   └── toggle_button.dart
      │   └── text_widget.dart
      |
      ├── utils                             # Utils, including declarative translation access (tr, plural, args)
      │   ├── localization_logger.dart
      │   ├── string_x.dart
      │   └── text_from_string_x.dart
      |
      ├── without_localization_case
      |   ├── app_strings.dart              # For static, non-translatable strings (e.g., test labels, debug UI text)
      |   └── fallback_keys.dart            # Constants used in tests or fallback mode
      |
      └── README(localization)s.md
```

- Also there is assets/translations folder with all locale JSON files

---

## ❓ FAQ

> **How do I use custom pluralization or context?**

- Use `.trPlural()`, `.tr(gender: ...)`, or context-based `.tr(context: ...)` on LocaleKeys.
- See EasyLocalization docs for advanced syntax.

---

> **How do I unit-test translations?**

- Access all translations via generated keys (`LocaleKeys`).
- Use EasyLocalization's testing utilities, or mock context/locale for custom unit tests.

---

> **Can I lazy-load or split translation files?**

- Yes, EasyLocalization supports async/custom loaders and modular asset splits.
- Configure loaders in the module's init code if needed.

---

> **How do I add keys?**

- Add to all translation files and regenerate `locale_keys.g.dart`.
- Use keys everywhere for full compile-time safety.

---

> **How perform Error Handling Integration?**

````dart
final uiText = AppLocalizer.t(failure.key!, fallback: failure.message);
    - Used in `FailureToUIModelX`
    - Always returns readable message
    - Logs missing or raw strings



> **How do I add a new language?**

1. Add JSON files
**Core:**
```bash
cp packages/shared_core_modules/assets/translations/en.json \
   packages/shared_core_modules/assets/translations/es.json
# Edit es.json with Spanish translations
```

**Apps:**
```bash
cp apps/state_symmetric_on_cubit/assets/translations/en.json \
   apps/state_symmetric_on_cubit/assets/translations/es.json
# Edit es.json with Spanish translations
```

2. Update `localization_wrapper.dart`

```dart
// apps/state_symmetric_on_cubit/lib/core/base_modules/localization/localization_wrapper.dart
abstract final class LocalizationWrapper {
  static const supportedLocales = [
    Locale('en'),
    Locale('uk'),
    Locale('pl'),
    Locale('es'),  // ← Add this
  ];
  // ...
}
```

3. Regenerate keys

```bash
melos run localization:gen:all
```

4. Update iOS Info.plist

```xml
<!-- apps/state_symmetric_on_cubit/ios/Runner/Info.plist -->
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>uk</string>
  <string>pl</string>
  <string>es</string>  <!-- Add this -->
</array>
```


-----------

> **Do this module localize system widgets?**

* `EasyLocalization` does not localize system widgets (DatePickers, TimePickers, Built-in material widgets, etc).
❗️ By default, only the strings you pass through .tr() are localized via EasyLocalization.

To ensure full localization for such widgets ALWAYS set these fields in MaterialApp:
```dart
MaterialApp(
  locale: context.locale, // from EasyLocalization
  supportedLocales: context.supportedLocales, // or a direct list
  localizationsDelegates: context.localizationDelegates, // includes both EasyLocalization & Flutter
  ...
)

or manually:

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    EasyLocalization.of(context)!.delegate,
  ],
  supportedLocales: [
    const Locale('en'),
    const Locale('uk'),
    const Locale('pl'),
  ],
  ...
)
````

This injects both EasyLocalization and native ones:

- GlobalMaterialLocalizations
- GlobalCupertinoLocalizations
- GlobalWidgetsLocalizations

---

## 💡 Best Practices

- Always pass localization keys instead of raw error messages, and always use `CoreLocaleKeys/AppLocaleKeys` — never hardcode translation keys in code.
- Inject localization context/delegates as high as possible in the widget tree (`MaterialApp.router`).
- Use extension methods for context locale access and switching — never call EasyLocalization statically in UI.
- Place all translation assets in `/assets/translations/` for easy scaling/maintenance.
- Always regenerate keys after editing of JSON files with translations (melos run locale:regen)
- Prefer context-based pluralization and gender forms for natural language.
- Keep translation files clean and consistent across languages — avoid key drift or inconsistent structure.
- Document custom logic, pluralization rules, or loaders at module level.
- Implement `_resolveText()` in custom widgets
- Always provide a `fallback:` in `AppLocalizer.translateSafely(...)` to ensure graceful degradation.
- Keep core translations keys file minimal (only truly shared content, avoid feature-specific text keys), group related translations, document special translations
- Keep overlay and errors handling logic fully decoupled from localization.
- Always assign `translationKey` inside domain or data layer when throwing a `Failure`.
- Convert to localized string only in widgets or overlay builders.
- Use fallback `message` to show something meaningful if localization fails.

---

### ⚠️ Avoid Pitfalls

- Never use hardcoded strings or keys for translations — always use `LocaleKeys`.
- Never inject locale, delegates, or supportedLocales manually — always use context extensions.
- Never couple localization logic with business/state logic — always keep this module isolated.
- Don’t add translation keys in only one language — always update all translation files in sync.
- Never override built-in EasyLocalization logic unless absolutely necessary.
- Avoid large, monolithic translation files — modularize by features for scale.

> ✅ This approach keeps your validation logic clean, testable, and localization-aware without tight UI coupling.

---

## ✅ Final Notes

- Fully modular: works with both Riverpod and cubit/BLoC — no code duplication
- Highly testable: all logic and context extensions are isolated
- Built for scale: add/remove languages and keys with minimal friction
- Compile-time safety: all translation keys are generated and type-safe and fallback aware
  All translations are strongly typed via `LocaleKeys`
- Production-ready: supports async switching, fallbacks, pluralization, and context
- Clean separation: all localization code, assets, and logic live in this module only

---

> **Happy coding! 🌍✨**
> Build robust, scalable Flutter apps for every market, language, and audience and ... architecture-first.

---
