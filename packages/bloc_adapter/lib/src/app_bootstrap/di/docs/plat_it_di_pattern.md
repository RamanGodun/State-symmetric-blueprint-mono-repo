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
