# ADR-004: Localization Strategy

## 1. Review and Lifecycle

_Status_: _Accepted_ (2025-09-26)
_Revision history:_ First version
_Author:_ Roman Godun

## 2. 🎯 Context

Localization (i18n) is a critical requirement for modern multi-language apps. This ADR defines a **state-symmetric, modular, and testable** localization system that acomplish next **Design Goals**:

- Enables **real-time locale switching** (without full app reload)
- Supports **both Riverpod and BLoC/Cubit/Riverpod** state managers
- Centralizes localization logic for testability and consistency
- Degrades gracefully in apps that **don’t require localization** (fallback-only mode)
- Is compatible with **background tasks**, headless/CLI modes, and widgets outside the tree

The architecture is designed to ensure **DX, runtime performance, and extensibility**.

- **State-Agnostic**: Can be used with any state management (Bloc, Riverpod, Provider, etc.) and supports global/local widget trees.
- **Fallback-Resilient**: Always resolves a string for any key, even if no localization is configured (e.g., fallback to English or a hardcoded string).
- **Centralized Resolution**: All translation lookups go through `AppLocalizer`, supporting logging and testability.
- **Extensible & Open-Close Principle**: New languages, keys, or resolution modes can be added with zero impact on existing modules.
- **Testable**: Fully mockable for unit tests, supports force-init with test/local/fake resolvers.
- **Real-Time Locale Switching**: Supports user-triggered locale changes at runtime (no app reload).
- **Separation of Concerns**: Domain/logic works with keys only, UI widgets are responsible for resolving keys.
- **Consistent API**: Unified approach for all widgets (`TextWidget`, `AppTextField`, overlays, etc.).
- **DX-Optimized**: Developers never touch raw `.tr()`/`BuildContext` in business logic or domain models.
- **Safe**: Keys are generated and strongly typed (via `LocaleKeys`)

---

## 3. ✅ Decisions, Key Principles

We adopt the following localization strategy:

- Use [`easy_localization`] package as the base engine due to its feature set, active maintenance, real-time switching, and codegen support.
- `LocalizationWrapper.configure()` is the single source of truth for app-wide localization context. Encapsulate all translation logic behind a **universal AppLocalizer singleton**, which supports both EasyLocalization and fallback-only modes (availabble easy switching between localization and fallback-only mode at bootstrap)
- All translation must go through `AppLocalizer.translateSafely(...)`. In non-i18n apps or early boot, fallback-only mode is enabled via `LocalesFallbackMapper`
- For UI text: use the `TextWidget` or `_resolveText()` wrapper — never `.tr()` directly
- All domain/business logic (validation, failures, overlays, form fields) must operate on keys only; all actual translation is performed at the UI/widget layer where BuildContext is available.
- Ensure all localization setup is **modular** and compatible with any DI/container pattern.
- All keys are accessed via `LocaleKeys` generated via codegen

---

## Solution Details

Solution Details are in [README of localization module](<../packages/core/lib/src/base_modules/localization/README(localization).md>)

---

## 4. 💡 Success Criteria and Alternatives Considered

- **Flutter Intl / native flutter_gen**: Does not support live locale switching, less flexible for DI/testability.
- **Slang**: Nice alternative. Will be considerated in next research

### 🧪 Success Criteria

- [ ] Features migrate between apps with <10% code change

---

## 5. 🧨 Consequences

### ✅ Positive

- Unified, modular localization
- Shared across state managers (Riverpod/Bloc)
- Declarative and clean usage patterns
- Runtime locale switching, error-safe
- Easy to mock/test

### ⚠️ Negative

- Requires setup at bootstrap
- Codegen step mandatory
- EasyLocalization still required under the hood (unless fallback-only mode)

---

## 6. 🔗 Related info

## 🧭 Related ADRs

- ADR-001: State-Symmetric Architecture
- ADR-002: Dependency Injection (Bloc + GetIt / Riverpod)
- ADR-003: Navigation Strategy (GoRouter)

## 📚 References

- [EasyLocalization](https://pub.dev/packages/easy_localization)
- [Flutter Internationalization Docs](https://docs.flutter.dev/accessibility-and-localization/internationalization)

---

## 7. 📌 Summary

> This localization strategy brings modularity, safety, nice DX, and state-symmetry to Flutter apps.

- ✅ Testable
- ✅ Runtime-switchable
- ✅ Clean architecture ready
- ✅ State manager independent
- ✅ Production-grade

Supports apps of any scale or architecture style, ready for any scale, future refactoring, or business requirement.

---
