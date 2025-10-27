# 📘 PlatIt Manual — Platform Logic Injection Toolkit for State-Symmetric Architecture

## 1. 🧭 Overview

**PlatIt (Platform Logic Injection Toolkit)** is a lightweight, modular dependency injection (DI) pattern built on top of **GetIt**, designed to bring **context-free, testable, and symmetric dependency management** to **Bloc/Cubit-based** applications.

It enables **state-symmetric architecture** by giving Bloc apps the same DI freedom and composability that Riverpod provides via its `ProviderScope` — while keeping the system lightweight, modular, and Flutter-agnostic.

PlatIt is a convention, not a framework — it leverages GetIt but enforces modular boundaries, dependency awareness, and safe registration to prevent the typical pitfalls of global DI.

---

## 2. 🎯 Design Goals

PlatIt exists to achieve **feature-level symmetry** across multiple state management technologies.

| Goal                   | Description                                                                         |
| ---------------------- | ----------------------------------------------------------------------------------- |
| **Symmetric DI Model** | Context-free dependency access in both Riverpod and Bloc-based apps.                |
| **Testability**        | Easy injection of mocks, modular testing, and clean teardown.                       |
| **Scalability**        | Seamless addition/removal of modules or features without breaking dependency order. |
| **Safety**             | Protected from double registration, circular dependencies, or unregistered access.  |
| **Simplicity**         | Minimal overhead on top of GetIt — no unnecessary abstractions.                     |

---

## 3. 🧱 Core Concepts

### 3.1 Core Components

| Component              | Responsibility                                                                    |
| ---------------------- | --------------------------------------------------------------------------------- |
| **`di`**               | Global GetIt instance shared across the app.                                      |
| **`SafeRegistration`** | Extension preventing duplicate registrations during hot reload/tests.             |
| **`SafeDispose`**      | Extension ensuring safe disposal of Blocs/Cubits.                                 |
| **`DIModule`**         | Interface defining registration/disposal logic for an isolated feature or domain. |
| **`ModuleManager`**    | Smart orchestrator registering modules in dependency-aware order.                 |

Each feature or system layer (e.g., Auth, Firebase, Profile) defines its own **DIModule**, declaring what it needs and what it registers.

---

## 4. ⚙️ Architectural Model

### 4.1 High-Level Flow

```
AppBootstrap.init()
     ↓
ModuleManager.registerModules([...])
     ↓
DIModule.register() per module
     ↓
SafeRegistration → di.registerXXXIfAbsent()
     ↓
Widgets use dependencies via di<T>()
```

### 4.2 Folder Convention

```text
lib/
├── app_bootstrap/
│   ├── di_container/
│   │   ├── modules/               # Feature-based DI modules
│   │   ├── di_container_init.dart # Entry point for module registration
│   │   └── global_di_container.dart
│   └── app_bootstrap.dart         # Startup orchestrator
├── features/
│   ├── auth/
│   │   └── cubit/
│   └── profile/
└── main.dart                      # Entry point
```

---

## 5. 🧩 Module Anatomy

### 5.1 Interface: `DIModule`

Each module implements a simple interface:

```dart
abstract interface class DIModule {
  String get name;
  List<Type> get dependencies => const [];
  Future<void> register();
  Future<void> dispose() async {}
}
```

### 5.2 Example: `AuthModule`

```dart
final class AuthModule implements DIModule {
  @override
  String get name => 'AuthModule';

  @override
  List<Type> get dependencies => [FirebaseModule];

  @override
  Future<void> register() async {
    di
      ..registerLazySingletonIfAbsent<IAuthRemoteDatabase>(() => AuthRemoteDatabaseImpl(di(), di()))
      ..registerFactoryIfAbsent(() => SignInUseCase(di()))
      ..registerLazySingletonIfAbsent(() => AuthCubit(gateway: di<AuthGateway>()));
  }

  @override
  Future<void> dispose() async {
    await di.safeDispose<AuthCubit>();
  }
}
```

### 5.3 Example: `ModuleManager`

```dart
await ModuleManager.registerModules([
  FirebaseModule(),
  AuthModule(),
  ProfileModule(),
  ThemeModule(),
]);
```

The manager will resolve dependencies automatically, ensuring that each module’s declared dependencies are registered first.

---

## 6. 🧰 SafeRegistration & SafeDispose

### 6.1 Safe Registration

PlatIt’s **SafeRegistration** prevents GetIt from throwing duplicate registration errors during hot reload or reinitialization.

```dart
extension SafeRegistration on GetIt {
  void registerLazySingletonIfAbsent<T extends Object>(T Function() factory) {
    if (!isRegistered<T>()) registerLazySingleton<T>(factory);
  }
  void registerFactoryIfAbsent<T extends Object>(T Function() factory) {
    if (!isRegistered<T>()) registerFactory<T>(factory);
  }
  void registerSingletonIfAbsent<T extends Object>(T instance) {
    if (!isRegistered<T>()) registerSingleton<T>(instance);
  }
}
```

### 6.2 Safe Disposal

Used in teardown or hot reload contexts to safely close and unregister Cubits/Blocs:

```dart
extension SafeDispose on GetIt {
  Future<void> safeDispose<T extends Object>() async {
    if (isRegistered<T>()) {
      final instance = get<T>();
      if (instance is BlocBase) await instance.close();
      unregister<T>();
    }
  }
}
```

---

## 7. 🧠 Design Principles

1. **Global Service Locator** — `GetIt.instance` aliased as `di`
2. **Modular DI** — Each domain implements its own `DIModule`
3. **Dependency-Aware Bootstrapping** — `ModuleManager` ensures proper registration order
4. **Scoped DI Support** — Use `BlocProvider(create: ...)` for UI-scoped logic
5. **Disposability** — Optional `dispose()` method for Cubits and long-lived services
6. **No Abstract Bridges** — Avoid unnecessary `IStateManager` interfaces or cross-layer wrappers

---

## 8. 💡 Usage Examples

### 8.1 Global Initialization

```dart
await ModuleManager.registerModules([
  ThemeModule(),
  FirebaseModule(),
  AuthModule(),
  ProfileModule(),
]);
```

### 8.2 Inject into Root Widget

```dart
return MultiBlocProvider(
  providers: [
    BlocProvider.value(value: di<AuthCubit>()),
    BlocProvider.value(value: di<AppThemeCubit>()),
  ],
  child: AppLocalizationShell(),
);
```

### 8.3 Scoped Injection in Feature

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => SignInCubit(di<SignInUseCase>())),
    BlocProvider(create: (_) => SignInFormCubit()),
  ],
  child: BlocAdapterForSubmissionFlowSideEffects<SignInCubit>(
    config: SubmissionSideEffectsConfig(
      onSuccess: (ctx, _) => ctx.showSnackbar(message: LocaleKeys.sign_in_success),
      onRetry: (ctx) => ctx.submitSignIn(),
    ),
    child: const _SignInScreen(),
  ),
);
```

---

## 9. 🧪 Testing and Mocking

PlatIt makes dependency injection for testing straightforward.

```dart
setUp(() async {
  await resetDI();
  di.registerLazySingleton<AuthRepo>(() => MockAuthRepo());
  di.registerFactory(() => SignInUseCase(di()));
});
```

Mocked modules can be composed just like production ones:

```dart
await ModuleManager.registerModules([
  MockFirebaseModule(),
  MockAuthModule(),
]);
```

---

## 10. ⚖️ Riverpod Parity

In Riverpod apps, PlatIt’s role is naturally replaced by **ProviderScope** and **ProviderContainer**.

```dart
final container = ProviderContainer(overrides: [...]);
ProviderScope(parent: container, child: MyApp());
```

| Concept          | Bloc / PlatIt             | Riverpod                         |
| ---------------- | ------------------------- | -------------------------------- |
| Global Container | `di` (`GetIt.instance`)   | `ProviderContainer`              |
| Registration     | via `DIModule.register()` | via Providers tree               |
| Access           | `di<T>()`                 | `ref.read(provider)`             |
| Disposal         | `safeDispose<T>()`        | automatic via provider lifecycle |

---

## 11. 📈 Benefits Summary

| Feature                          | Benefit                                                      |
| -------------------------------- | ------------------------------------------------------------ |
| **Context-Free Access**          | Works outside widget tree (e.g., overlays, background jobs). |
| **Symmetric with Riverpod**      | Identical developer experience across apps.                  |
| **Lightweight**                  | Adds minimal runtime/LOC overhead.                           |
| **Safe Reloading**               | Prevents duplicate registration on hot reload.               |
| **Modular**                      | Modules isolated and testable.                               |
| **Clean Architecture Alignment** | Mirrors domain-driven dependency flow.                       |

---

## 12. 🧩 When to Use PlatIt

PlatIt is ideal for:

- Multi-product or white-label apps with multiple state managers (Bloc/Riverpod)
- Projects requiring shared modular architecture
- Teams seeking uniformity across stacks
- Apps needing high testability and explicit dependency graphs

Avoid PlatIt if:

- You use only Riverpod — its DI system already covers these needs.
- The project is a small MVP where modular DI would be overkill.

---

## 13. 📚 References

- [GetIt](https://pub.dev/packages/get_it)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- [State-Symmetric Architecture ADR](../../../ADR/ADR-001-State-symmetric-architecture.md)

---

## 14. 🧩 Summary

> **PlatIt = Clean Architecture + State Symmetry + Pragmatic Simplicity**

It enforces modular DI boundaries, provides parity with Riverpod’s context-free model, and ensures testable, scalable dependency graphs — without adding unnecessary abstraction.

In essence:

> **Bloc gains Riverpod’s freedom, without Riverpod’s complexity.**
