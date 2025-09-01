# ADR-004: Localization Strategy

**Status:** Accepted
**Date:** 2025-05-27
**Context:** Flutter App (State-agnostic, Multi-StateManager Support)

---

## 1. Context

Localization is a core requirement for modern, user-centric Flutter applications, enabling multi-language UI and consistent UX across global markets. The chosen approach must:

- Support real-time locale switching without full app reload
- Remain agnostic to the state management solution (Bloc, Riverpod, Provider, etc.)
- Enable centralized, safe, and testable localization logic
- Degrade gracefully if localization is temporarily disabled or not required (e.g., for white-label/B2B or unit-testing scenarios)
- Easily integrate into any modern codebase with minimal friction

The [easy_localization](https://pub.dev/packages/easy_localization) package is selected as the foundation due to its feature set, active maintenance, real-time switching, and codegen support.

---

## 2. Decision

- Use **EasyLocalization** as the core localization framework.
- Encapsulate all translation logic behind a **universal AppLocalizer singleton**, which supports both EasyLocalization and fallback-only modes.
- All UI widgets must use only the central `AppLocalizer` API or the custom `TextWidget` for translatable text. Never use `.tr()` directly in Text widgets.
- Provide a fallback-only localization path (`LocalesFallbackMapper`) for testing, error handling, or when localization is not used in the app.
- All domain/business logic (validation, failures, overlays, form fields) must operate on keys only; all actual translation is performed at the UI/widget layer where BuildContext is available.
- The system must support runtime locale switching and notify all downstream widgets.
- Ensure all localization setup is **modular** and compatible with any DI/container pattern.

---

## 3. Design Goals

- **State-Agnostic**: Can be used with any state management (Bloc, Riverpod, Provider, etc.) and supports global/local widget trees.
- **Fallback-Resilient**: Always resolves a string for any key, even if no localization is configured (e.g., fallback to English or a hardcoded string).
- **Centralized Resolution**: All translation lookups go through `AppLocalizer`, supporting logging and testability.
- **Extensible & Open-Close Principle**: New languages, keys, or resolution modes can be added with zero impact on existing modules.
- **Testable**: Fully mockable for unit tests, supports force-init with test/local/fake resolvers.
- **Real-Time Locale Switching**: Supports user-triggered locale changes at runtime (no app reload).
- **Separation of Concerns**: Domain/logic works with keys only, UI widgets are responsible for resolving keys.
- **Consistent API**: Unified approach for all widgets (`TextWidget`, `AppTextField`, overlays, etc.).
- **DX-Optimized**: Developers never touch raw `.tr()`/`BuildContext` in business logic or domain models.

---

## 4. Solution Details

### 4.1. Bootstrap & Initialization

At bootstrap (in `AppBootstrap`), **choose localization mode**:

```dart
// ✅ Enable when using EasyLocalization
AppLocalizer.init(resolver: (key) => key.tr());

// 🟡 Enable fallback-only mode (e.g., early error handling)
AppLocalizer.initWithFallback();
```

### 4.2. Key Components

- **AppLocalizer**: Central singleton for translation lookup. Always initialized at app start.
  - `AppLocalizer.translateSafely(String key, {String? fallback})`
  - `AppLocalizer.isInitialized`
  - Logs missing/fallback keys.

- **LocalesFallbackMapper**: Fallback Map for known keys (used when localization is disabled).
- **FallbackKeysForErrors**: Static strings for common error/failure messages.
- **TextWidget**: Replaces standard `Text`, resolves keys and applies consistent style, supports all typography/text types.
- **LanguageToggleButton**: iOS/macOS-style popup for runtime locale switching with visual feedback and overlays.
- **AppStrings**: Static non-translatable texts for tests and debug UI.

### 4.3. Usage Pattern

- **In Domain Layer**: Pass localization keys only (`LocaleKeys.*`, `'failure.auth.unauthorized'`), no `.tr()` calls.
- **In UI Layer**: Use `TextWidget`, `AppTextField`, або custom `_resolveText()` pattern, що використовує `AppLocalizer`.
- **On Error/Overlay**: Always localize failure keys at UI layer, not domain/logic.

### 4.4. Testability

- `AppLocalizer.forceInit(resolver: (key) => 'Test $key')` for tests/mocks.
- Can switch to fallback-only or any custom resolver at runtime.

### 4.5. No-Localization Mode

- If the app does not require localization, only `LocalesFallbackMapper` and `FallbackKeysForErrors` are used.
- All text is still resolved via the same API; no code changes required elsewhere.

---

## 5. Flutter Widget Localization (DatePicker, Dialogs, etc.)

❗️ **System Flutter Widgets (DatePicker, TimePicker, etc.) are NOT localized by EasyLocalization!**

By default, only the strings you pass through `.tr()` are localized via EasyLocalization.
But system widgets (DatePicker, TimePicker, Material dialogs, built-in banners, SnackBars, etc.) use Flutter’s native internationalization pipeline.

**To ensure full localization for such widgets ALWAYS set these fields in MaterialApp:**

```dart
MaterialApp(
  locale: context.locale, // from EasyLocalization
  supportedLocales: context.supportedLocales, // or a direct list
  localizationsDelegates: context.localizationDelegates, // includes both EasyLocalization & Flutter
  ...
)

// or manually:

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
```

📝 _Why is this?_
Flutter widgets rely on the standard localizationsDelegates and supportedLocales for all system text.
EasyLocalization is only a wrapper for explicit `.tr()` calls and does NOT replace or intercept these delegates.

**TL;DR:**

> If your app needs DatePicker/TimePicker/Dialog to be localized, always configure MaterialApp as above. Otherwise, you will see only default local for these widgets.

---

## 6. Rejected Alternatives

- **Flutter Intl / native flutter_gen**: Does not support live locale switching, less flexible for DI/testability.
- **Storing strings in domain models**: Prevents translation at UI layer, makes localization brittle for overlays/errors.

---

## 7. Consequences & Extension

- The system supports any future state manager, migration, or hybrid approaches (e.g., feature-based Provider + Bloc).
- New languages or fallback sets can be added via codegen/fallback maps with no architectural impact.
- Easily supports deep links, dynamic runtime changes, or B2B/white-label apps with custom string sets.

---

## 8. Sample Implementation

```dart
// AppLocalizer usage in UI:
TextWidget(LocaleKeys.profile_email, TextType.bodySmall)

// Or fallback:
TextWidget('profile.email', TextType.bodySmall, fallback: 'Email')

// In error overlays:
final uiText = AppLocalizer.translateSafely(failure.key, fallback: failure.message)
```

---

## 9. References

- [EasyLocalization](https://pub.dev/packages/easy_localization)
- [Flutter Internationalization Docs](https://docs.flutter.dev/accessibility-and-localization/internationalization)
- Project codebase, `/core/base_modules/localization/`

---

**TL;DR:**
This localization strategy ensures best-in-class DX, testability, and resilience, while being ready for any scale, future refactoring, or business requirement.
