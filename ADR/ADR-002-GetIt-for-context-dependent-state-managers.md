# ADR-002: Dependency Injection Pattern (via GetIt or native ProviderScope in Riverpod) in Symmetric State Management

---

## Status

Accepted

---

## Context

Our Flutter monorepo architecture aims for:

- 🔁 _Shared logic and code reuse_ across apps with different state managers (Bloc/Riverpod, with easy migration support).
- ✅ _Clean architecture principles_ (testability, separation of concerns, thin UI).
- 🧩 _State-Symmetric pattern_ (see ADR-001) with pragmatic dependency injection (DI).

In **Riverpod apps**, DI is inherently contextless via native `ProviderContainer` or `.ref.read(...)` access.

In **Bloc-based apps**, we adopt `GetIt` to replicate the same level of **context independence**, enabling shared modules, consistent state orchestration, and global availability for features like theming, overlays, routing, and background tasks.

This ADR formalizes **PlatIt (Platform Logic Injection Toolkit)** — a modular, scalable DI convention built on top of `GetIt`, powered by `SafeRegistration`, `DIModule`s and `ModuleManager`.

---

## Problem

- Bloc and Cubit do not support global DI out of the box.
- DI by `BuildContext` is problematic for:
  - cross-feature orchestration (theme, router, overlays)
  - shared widgets outside widget tree (e.g., notifications, background workers)
  - testing and mocking
- Riverpod solves this with `ProviderContainer`, but Bloc-based apps need structured DI management.

---

## Decision

We adopt a **dual-platform DI strategy**:

1. **For Bloc-based apps** → use **PlatIt**, a custom DI pattern built on top of `GetIt`
2. **For Riverpod-based apps** → use **native Riverpod ProviderContainer** and `.ref.read()` pattern

This ensures full platform symmetry and maximum portability across apps.

---

## PlatIt (Bloc-based DI via GetIt)

### 🧱 PlatIt Design Principles

1. _Global Service Locator_ → `GetIt.instance` (aliased as `di`)
2. _Modular DI_ → Each domain (e.g., `AuthModule`, `ThemeModule`) implements `DIModule`
3. _Dependency-Aware Bootstrapping_ → `ModuleManager.registerModules([...])` resolves and registers in order
4. _Safe Registration_ → via `SafeRegistration` extensions (`registerLazySingletonIfAbsent`, etc.)
5. _No Bridges_ → Avoid abstract interfaces unless necessary for migration
6. _Scoped DI Support_ → Use `BlocProvider(create: ...)` for screen-specific logic
7. _Disposability_ → Optional `.safeDispose()` supported for Cubits and Blocs

### 🧩 Example Usage (Bloc + PlatIt)

#### 📦 Global Initialization

```dart
await ModuleManager.registerModules([
  ThemeModule(),
  AuthModule(),
  FirebaseModule(),
  NavigationModule(),
]);
```

#### 🧭 Inject into Root Widget

```dart
return MultiBlocProvider(
  providers: [
    BlocProvider.value(value: di<AuthCubit>()),
    BlocProvider.value(value: di<AppThemeCubit>()),
  ],
  child: AppLocalizationShell(),
);
```

#### 🧑‍💻 Scoped Injection in Screens

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => SignInCubit(di<SignInUseCase>())),
    BlocProvider(create: (_) => SignInFormCubit()),
  ],
  child: SubmissionStateSideEffects<SignInCubit>(
    onSuccess: (ctx, _) => ctx.showSnackbar(...),
    onRetry: (ctx) => ctx.submitSignIn(),
    child: const _SignInScreen(),
  ),
);
```

---

## Riverpod DI Strategy

Riverpod provides **native context-independent DI** via `ProviderContainer` or `.ref.read()`.

### 💡 Global DI Container

```dart
final container = ProviderContainer(overrides: [...]);
GlobalDIContainer.initialize(container);
```

Used as parent:

```dart
ProviderScope(parent: GlobalDIContainer.instance, child: MyApp())
```

### 💬 Reading Dependencies (examples)

- Inside widget: `ref.read(routerProvider)`
- Outside widget tree: `GlobalDIContainer.instance.read(routerProvider)`

### 🌍 App-wide injection

- Works in overlays, background isolates, and pre-runApp bootstrapping.

---

## Rationale

- **Platform Symmetry**: Riverpod and Bloc achieve same benefits — global, context-free access to shared dependencies
- **Scalability**: Add/remove feature modules independently
- **Testability**: Inject mocks or override providers/registrations easily
- **Stability**: Supports clean hot reload, reduces chance of registration errors
- **No Over-engineering**: No interface bridges unless necessary
- **Consistency**: Same mental model in Riverpod and Bloc apps

---

## Consequences

- Requires discipline around `DIModule` dependencies and registration order
- `GetIt` container must be initialized before use (during bootstrap)
- Riverpod DI assumes clear separation between `ProviderScope` and overrides
- PlatIt is minimal yet extensible, but not fully auto-magical (no auto-dispose)

---

## Terminology

> **PlatIt** = **Platform Logic Injection Toolkit** — a convention for structured, testable, and context-free service injection in Bloc-based apps.

---

## See Also

- ADR-001: State-Symmetric Architecture
- ADR-003: Navigation & Routing Strategy
- ADR-004: Localization & Overlay Strategy

---

## References

- [get_it](https://pub.dev/packages/get_it)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- [State-Symmetric Architecture](./ADR-001-State-symmetric-architecture.md)

---
