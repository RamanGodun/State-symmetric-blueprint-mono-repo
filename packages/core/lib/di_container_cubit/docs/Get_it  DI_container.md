# 📦 Dependency Injection Guide with GetIt (Clean Architecture)

---

## 🌟 Purpose

Provide a **modular**, **scalable**, and **testable** way to manage dependencies using `GetIt`,
aligned with **Clean Architecture**, **SOLID**, and **Global Scoping** principles.
This guide ensures compatibility with Bloc, Cubit, and Provider patterns.

---

Only the DI container knows about concrete implementations. All other layers depend solely on abstractions.
DI is your enforcer of boundaries, not just a registry.

---

## 🧱 Folder Structure

```txt
lib/
├── core/
│   ├── app_config/bootstrap/di_container.dart  // <-- Main entry point
│   ├── utils/typedef.dart
│   └── shared_modules/logging/...
├── features/
│   └──
```

---

## 🔁 Safe Registration Extension

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

---

## 🚀 Entry Point: `AppDI`

```dart
final di = GetIt.instance;

abstract final class AppDI {
  static Future<void> init() async {
    _registerAppLogger();
    _registerOverlaysHandlers();
    _registerTheme();
    // ...
    _registerUseCases();
    _registerRepositories();
    _registerDataSources();
    // ...
  }
}
```

---

## 🧩 Module Registration Pattern

### ✅ Example: Auth Module

```dart
void _registerAuthModule() {
  di
    // Presentation
    ..registerLazySingleton(() => AuthBloc(signOutUseCase: di(), userStream: di<AuthRemoteDataSource>().user))

    // Domain UseCases
    ..registerLazySingleton(() => SignInUseCase(di()))
    ..registerLazySingleton(() => SignUpUseCase(di()))
    ..registerLazySingleton(() => SignOutUseCase(di()))
    ..registerLazySingleton(() => EnsureUserProfileCreatedUseCase(di()))

    // Repositories
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(di()))

    // DataSources
    ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di(), di()));
}
```

---

## 🌐 Global vs Local Scope

### 🧭 Global Scope via DI (Best Practice)

Used for shared Cubits/Providers across the app lifecycle:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider.value(value: di<AuthBloc>()),
    BlocProvider.value(value: di<AppThemeCubit>()),
    BlocProvider.value(value: di<OverlayStatusCubit>()),
  ],
  child: AppRootView(),
)
```

### 📦 Local Scope (Recommended for Feature-Specific State)

For isolated feature logic:

```dart
BlocProvider(
  create: (_) => LocalCubit(),
  child: FeatureView(),
)
```

---

## 🧠 Why Register UseCases?

Registering `UseCase` as `lazySingleton` gives:

- Predictable memory usage (shared, cached, not recreated)
- Easy mocking in tests
- Respect to **SRP** and **DIP**
- Reusability across multiple Cubits/Features

```dart
class SignInUseCase {
  final AuthRepo _repo;
  const SignInUseCase(this._repo);

  ResultFuture<UserCredential> call({ required String email, required String password }) {
    return _repo.signIn(email: email, password: password);
  }
}
```

✅ This class has **no UI knowledge** and is perfectly decoupled.

---

## 🧪 Unit Test Setup

```dart
setUp(() {
  di.registerLazySingleton<AuthRepo>(() => MockAuthRepo());
  di.registerLazySingleton(() => SignInUseCase(di()));
});
```

---

## 🔁 Alternative: Injectable + GetIt

If you use code generation:

```dart
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

Use annotations:

```dart
@lazySingleton
class AuthService {
  final Dio dio;
  AuthService(this.dio);
}
```

Pros:

- Less boilerplate
- Auto-generated

Cons:

- Debugging less transparent
- Slower iterations

---

## ✅ Benefits Summary

| Feature              | Benefit                                 |
| -------------------- | --------------------------------------- |
| SafeRegistration     | Prevents hot-reload conflicts           |
| Layered Registration | Aligns with Clean Architecture          |
| Global Scope via DI  | Centralized logic reuse                 |
| Testability          | Easy mocking and isolation              |
| Abstraction-only use | Fully respects **Dependency Inversion** |

---

## 🧠 Final Thought

Use GetIt not just to wire things together, but to **enforce boundaries**, **decouple logic**, and **scale safely**
— especially in BLoC/Provider layers. In Riverpod environments, skip GetIt in favor of Riverpod's native providers.

> ✅ Clean. Predictable. Professional.
