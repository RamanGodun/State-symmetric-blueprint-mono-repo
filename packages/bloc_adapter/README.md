# BLoC Adapter

**BLoC Adapter** is a lightweight integration layer that connects your app’s core ports to the BLoC/Cubit ecosystem.
It ships opinionated but minimal glue for DI, theming, overlays, observers, and a few UI helpers — all focused on BLoC-first apps.

- ✅ **Adapter, not framework** — complements your domain/core packages without coupling
- ✅ **Clean boundaries** — presentation glue lives here, domain stays in `core`
- ✅ **Production‑ready defaults** — HydratedCubit for theme, overlay status, safe DI helpers
- ✅ **Composable DI** — modular registration via GetIt with dependency checks

---

## Installation

Add the package to your app or feature module:

```yaml
# apps/<your_app>/pubspec.yaml OR packages/<another_package>/pubspec.yaml
dependencies:
  bloc_adapter:
    path: ../../packages/bloc_adapter
```

Import via the public barrel you expose (recommended: `lib/bloc_adapter.dart`).
If you prefer direct imports, use the paths shown in **Public API & Structure**.

---

## Public API & Structure

```
bloc_adapter/lib/
├─ bloc_adapter.dart                  # 🧱 Single public barrel (facade API)
└─ src/
   ├─ base_modules/
   │  ├─ observer/
   │  │   └─ bloc_observer.dart      # Global BLoC observer (logging/diagnostics)
   │  ├─ overlays_module/
   │  │   ├─ overlay_status_cubit.dart   # Overlay visibility state (active/inactive)
   │  │   ├─ overlay_activity_port_bloc.dart # Bridge: dispatcher ⇄ bloc status port
   │  │   └─ overlay_resolver_wiring.dart   # Wiring overlays into app lifecycle (DI hook)
   │  └─ theme_module/
   │      ├─ theme_cubit.dart        # Theme state (persisted), API used in UI
   │      └─ theme_toggle_widgets/
   │          ├─ theme_toggler.dart  # Thin adapter widget (toggle dark/light)
   │          └─ theme_picker.dart   # Thin adapter widget (pick ThemeVariant)
   │
   ├─ di/
   │  ├─ core/
   │  │   ├─ di.dart                 # Global GetIt accessor (di), base registrations
   │  │   ├─ di_module_interface.dart# DIModule contract (register/dispose)
   │  │   └─ di_module_manager.dart  # ModuleManager (batch register + lifecycle)
   │  ├─ x_on_get_it.dart            # Safe helpers: registerIfAbsent, etc.
   │  └─ docs/                       # (internal) notes, guides — not exported
   │
   └─ presentation_shared/
      ├─ cubits/
      │   └─ auth_cubit.dart         # Thin auth view-state Cubit (AuthReady/Loading/Error)
      └─ widgets_shared/
          └─ form_submit_button.dart # Reusable, bloc-aware submit button
```

> Tip: keep a single public barrel `bloc_adapter.dart` that re-exports the pieces you consider public.

---

## Quick Start

### 1) Enable the observer

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_adapter/base_modules/observer/bloc_observer.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  // runApp(...)
}
```

### 2) Register DI modules (GetIt)

```dart
import 'package:bloc_adapter/di/di.dart';
import 'package:bloc_adapter/di/di_module_manager.dart';
import 'package:bloc_adapter/di/di_module_interface.dart';

final class ThemeModule implements DIModule {
  @override
  String get name => 'ThemeModule';

  @override
  Future<void> register() async {
    // di.registerLazySingletonIfAbsent<AppThemeCubit>(() => AppThemeCubit());
  }
}

Future<void> configureDi() async {
  await ModuleManager.registerModules([
    ThemeModule(),
    // ... other modules
  ]);
}
```

### 3) Use `FormSubmitButton` in BLoC forms

```dart
FormSubmitButton<LoginCubit, LoginState>(
  label: 'Sign in',
  statusSelector: (s) => s.status,           // FormzSubmissionStatus
  isValidatedSelector: (s) => s.canSubmit,   // bool
  onPressed: (ctx) => ctx.read<LoginCubit>().submit(),
)
```

It automatically:

- shows a loader while submitting
- disables itself if the form is invalid or an overlay is active
- rebuilds only when submission status or validation changes

### 4) Track overlays to prevent double submits

```dart
// Wire overlay dispatcher (e.g., in your UI shell)
final isActive = context.select<OverlayStatusCubit, bool>((c) => c.state);
```

---

## Safe DI Helpers (GetIt)

- `registerLazySingletonIfAbsent<T>()`, `registerFactoryIfAbsent<T>()`, `registerSingletonIfAbsent<T>()`
  — avoid double-registration crashes on hot-reload/tests.
- `safeDispose<T>()` — disposes and unregisters BLoC/Cubit singletons safely.

```dart
import 'package:bloc_adapter/di/di.dart';
import 'package:bloc_adapter/di/di_extensions.dart';

void setup() {
  di.registerLazySingletonIfAbsent<AppThemeCubit>(() => AppThemeCubit());
}

Future<void> tearDown() async {
  await di.safeDispose<AppThemeCubit>();
}
```

---

## Theming (Hydrated)

`AppThemeCubit` stores `ThemePreferences` (variant + font) using HydratedCubit. You can:

```dart
context.read<AppThemeCubit>().toggleTheme();
context.read<AppThemeCubit>().setFont(AppFontFamily.montserrat);
```

State is persisted across sessions and supports a tiny legacy migration for font names.

---

## Conventions

- Keep domain-facing contracts and business logic in `core`; this package is presentation/adapter glue.
- Re-export only what you consider stable in your public barrel.
- Prefer feature folders under `presentation/widgets/…` for UI pieces.
- Use `ModuleManager.registerModules([...])` to keep DI deterministic and dependency-checked.

---

## Development

This monorepo uses **Melos**.

```bash
# From repo root
melos bootstrap

# Only this package
melos exec --scope="bloc_adapter" -- flutter analyze
melos exec --scope="bloc_adapter" -- flutter test
```

---

## License

Licensed under the same terms as the monorepo’s root [LICENSE](../../LICENSE).
