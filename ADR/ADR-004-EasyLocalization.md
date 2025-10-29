# ADR-004: Localization Strategy — EasyLocalization in a State‑Symmetric Architecture

## 1. Context (Problem & Goals)

Localization (i18n) is a production‑grade requirement for multi‑language apps. Within the **State‑Symmetric** approach, the localization layer must remain **modular, testable, and state‑manager agnostic**, delivering identical behavior in both demo apps (Bloc/Cubit and Riverpod).

**Problems to solve**

- Enable **runtime locale switching** without a full app restart.
- Provide a **centralized API** for string resolution that works **inside and outside** the widget tree (overlays, validators, background tasks).
- Ensure **graceful degradation** in apps that **do not ship i18n** (fallback‑only mode).
- Preserve **clean architectural boundaries**: Domain/Data traffic in **keys**; Presentation resolves into **strings**.

**Design constraints**

- State‑manager symmetry (Bloc/Cubit ⇄ Riverpod) and DI‑agnostic wiring.
- Codegen‑based, strongly‑typed keys for safety and DX.
- Consistent behavior in tests, CLI, headless/background flows.

---

## 2. Decisions (Concise)

1. **Engine**
   Use **`easy_localization`** as the localization engine (live switching, plural/gender, codegen, active maintenance).

2. **Single Resolution API**
   Adopt **`AppLocalizer`** (singleton) as the _only_ public entry point for translations:
   - `AppLocalizer.init(resolver: (key) => key.tr())` — normal mode (EasyLocalization present).
   - `AppLocalizer.initWithFallback()` — fallback‑only mode (no EasyLocalization; returns predefined messages or the key itself).
   - `translateSafely(key, fallback: ...)` — safe access with logging of missing keys.
   - `forceInit(resolver: ...)` — test override for headless/CLI.

3. **Root Integration**
   Wrap the root widget with **`LocalizationWrapper.configure(child)`** to inject `supportedLocales`, `fallbackLocale`, `localizationsDelegates`, and the asset loader.

4. **Strongly‑Typed Keys & Codegen**
   Generate keys (e.g., **`LocaleKeys`**) and a `CodegenLoader`. Only generated keys are allowed in code (no magic strings).

5. **Resolve Only in Presentation**
   Domain/Data/Use‑cases/Validation pass **translation keys**; string resolution happens **only** in UI/overlays where needed. No `BuildContext` or `.tr()` in business logic.

6. **Declarative UI Primitives**
   Use safe UI wrappers (e.g., `TextWidget`, `_resolveText()`/`_resolveLabel()`) that delegate to `AppLocalizer` and always provide fallbacks.

7. **State‑Manager Symmetry**
   Same API/behavior in **Bloc/Cubit** and **Riverpod** apps; DI/container choice must not affect localization usage.

8. **Error & Overlay Localization (principle)**
   - **Domain failures carry i18n keys** via `FailureType.translationKey` (strongly typed constants, no raw strings).
   - **Presenter maps `Failure → FailureUIEntity`** resolving localized text through `AppLocalizer.translateSafely(...)` with diagnostic fallback to `Failure.message` or `type.code`.
   - **Overlay DSL consumes only localized strings**: `context.showError(FailureUIEntity, ...)` or `showAppDialog(...)` pulls confirm/cancel labels via `AppLocalizer` (never `.tr()` inline).
   - **Fallback‑only mode** still renders meaningful messages (pre‑mapped dictionary + raw message fallback).

9. **Form Field Localization**
   - **Labels**: All form labels (e.g., name, email, password) use generated `LocaleKeys.form_*` constants. Labels are resolved via `AppLocalizer.translateSafely` inside `AppFormField`.
   - **Validation Errors**: All `FormzInput` validators map enum values to keys (e.g., `LocaleKeys.form_email_is_invalid`). The UI consumes only `uiErrorKey`, which is resolved through the safe localizer.
   - **Fallback Safety**: Both labels and validation errors degrade gracefully if i18n is disabled.
   - **Symmetry**: Bloc and Riverpod apps follow the same contract — validators expose keys, presentation resolves them, no inline `.tr()` allowed.

## 3. Consequences

### Positive

- **Unified contract** across state managers and layers.
- **Runtime locale switching** without app restart.
- **High testability**: `AppLocalizer.forceInit(...)` allows fake resolvers in tests/CLI/headless tasks.
- **Graceful degradation**: apps without i18n work via the fallback resolver.
- **Observability**: missing‑key usage is logged centrally.

### Negative

- **Codegen pipeline required** (keys + loader must be generated).
- **Bootstrap discipline**: initialization order matters and must happen at the top of the tree.
- **Key drift risk** if translation JSONs are not kept in sync across locales (mitigate with CI checks).
- **Native Material/Cupertino widgets are not localized by EasyLocalization**. Flutter’s built‑in UI (e.g., DatePicker, TimePicker, some Cupertino controls) relies on Flutter’s own localization delegates. If GlobalMaterialLocalizations, GlobalWidgetsLocalizations, and GlobalCupertinoLocalizations are not wired (via context.localizationDelegates) and supportedLocales is not kept in sync with assets and iOS CFBundleLocalizations, those widgets may fall back to English or show partially localized UI. Mitigation: enforce delegates through LocalizationWrapper, keep locale lists synchronized (Android/iOS/MaterialApp), add an integration test that switches locale and opens Material/Cupertino pickers, and rebuild views after runtime switching when a platform view requires it.

## 4. Success Criteria & Alternatives

### Success Criteria

- **Single API usage**: only `AppLocalizer`/`LocaleKeys` in the codebase; no scattered `.tr()` in business logic.
- **Symmetric behavior** in both demo apps (Bloc and Riverpod) without conditional branches.
- **Stable runtime switching** validated by integration tests.
- **Fallback coverage** for critical messages (overlays, validations, form fields) so UI never breaks when i18n is absent.
- **Feature migration** between apps requires < **10%** Presentation edits (keys remain identical).
- **Error/overlay/form conformance**: failures and form inputs expose `translationKey`; UI resolves only via `AppLocalizer`.

### Alternatives Considered

- **Flutter gen‑l10n / flutter_localizations (native)**
  Official and deeply integrated; however less ergonomic for our **context‑free/symmetric** DI model and headless usage. Live switching typically needs extra wrappers.

- **Slang**
  Strong type safety and convenient API. Not part of the initial stack; requires a separate migration study and evaluation.

## 5. Summary

The adopted strategy yields **modular, symmetric, and testable** localization. `AppLocalizer` centralizes safe resolution and fallbacks; `LocalizationWrapper` cleanly injects context/delegates at the root; generated `LocaleKeys` + `CodegenLoader` provide compile‑time safety. Error handling, overlays, and form fields follow a **key‑in/domain → string‑in/presentation** pattern, ensuring consistent UX both with full i18n and in fallback‑only mode.

## 6. Related Information

**Module Docs**

- [`README(localization).md`](../packages/core/lib/src/base_modules/localization/README%28localization%29.md)
- [`README(errors_handling).md`](../packages/core/lib/src/base_modules/errors_management/README%28errors_handling%29.md)
- [`README(overlays).md`](../packages/core/lib/src/base_modules/overlays/README%28overlays%29.md)
- [`README(form_fields).md`](../packages/core/lib/src/base_modules/form_fields/README%28form_fields%29.md)

**Related ADRs**

- [ADR-001 — State-Symmetric Architecture](ADR-001-State-symmetric-architecture.md)
- [ADR-002 — Dependency Injection](ADR-002-GetIt-for-context-dependent-state-managers.md)
- [ADR-003 — Navigation & Routing](ADR-003-GoRouter-navigation.md)

**References**

- [EasyLocalization](https://pub.dev/packages/easy_localization)
- [Flutter Internationalization Docs](https://docs.flutter.dev/accessibility-and-localization/internationalization)
