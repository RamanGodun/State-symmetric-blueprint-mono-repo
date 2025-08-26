# Flutter App Bootstrap & Lazy DI — Pro Manual

**Applies to:** Any Flutter app, regardless of state management or DI engine (Riverpod, Bloc, Provider, GetIt, etc).

---

## 1. Core Principles

- **Centralized App Readiness State:**
  Maintain a single source of truth for bootstrap status (`loading`/`ready`/`error`/`progress`) using a sealed class or enum, fully independent from your state management choice.
- **Proxy/Fallback DI:**
  Access all services via proxies, returning stubs before the app is ready—never `null`.
- **Declarative, State-Driven UI:**
  UI reacts only to readiness state: shows loader, error, or main app shell as needed.
- **Robust Error/Retry/Timeout Logic:**
  Bootstrap manager encapsulates all side-effects, error and retry handling.
- **Testable and Agnostic:**
  Architecture is decoupled from DI/state manager and easily testable at every level.

---

## 2. Minimal Bootstrap Lifecycle

1. **Minimal Bootstrap in `main()`**
   - Only critical, synchronous setup:

     ```dart
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     ```

2. **Single `runApp()` Call**
   - Use a native splash screen (`flutter_native_splash`) for instant feedback.
   - Never use multiple `runApp()` calls—this is not recommended by Flutter team.

3. **Async Bootstrap After `runApp()`**
   - App initialization runs asynchronously in a manager/provider/cubit/notifier.
   - UI listens to readiness state and displays Splash, Error, or Main UI.

---

## 3. Architecture: Key Patterns

### 3.1 App Readiness State (Sealed Class/Enum)

```dart
sealed class AppReadinessState {
  const AppReadinessState();
}
final class AppInitializing extends AppReadinessState { const AppInitializing(); }
final class AppLoading extends AppReadinessState {
  final double? progress; final String? step;
  const AppLoading({this.progress, this.step});
}
final class AppReady extends AppReadinessState { const AppReady(); }
final class AppError extends AppReadinessState {
  final String message; final bool canRetry;
  const AppError({required this.message, this.canRetry = true});
}
```

### 3.2 Readiness State Manager (Agnostic Example)

```dart
abstract interface class AppBootstrapManager {
  AppReadinessState get state;
  Stream<AppReadinessState> get stateStream;
  void updateLoading({double? progress, String? step});
  void setReady();
  void setError(String message, {bool canRetry});
  void retry();
}
```

### 3.3 Riverpod/BLoC Integration (Example)

```dart
// Riverpod
@riverpod
class AppReadinessNotifier extends _$AppReadinessNotifier {
  @override AppReadinessState build() => const AppInitializing();
  void updateLoading({double? progress, String? step}) => state = AppLoading(progress: progress, step: step);
  void setReady() => state = const AppReady();
  void setError(String message, {bool canRetry = true}) => state = AppError(message: message, canRetry: canRetry);
  void retry() => state = const AppInitializing();
}
```

```dart
// Bloc
class AppReadinesscubit extends cubit<AppReadinessState> {
  AppReadinesscubit() : super(const AppInitializing());
  void updateLoading(...) => emit(...);
  void setReady() => emit(const AppReady());
  void setError(String msg, {bool canRetry = true}) => emit(AppError(message: msg, canRetry: canRetry));
  void retry() => emit(const AppInitializing());
}
```

---

## 4. Proxy/Fallback DI Pattern

- All services are accessed via a proxy provider.
- Before app is ready, proxy returns a stub (safe fallback, never null).
- When ready, proxy swaps to real service.

**Example:**

```dart
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final state = ref.watch(appReadinessNotifierProvider);
  return state is AppReady
    ? ref.watch(realUserRepoProvider)
    : const StubUserRepository();
}
```

---

## 5. UI Shell Example

**Riverpod:**

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appReadinessNotifierProvider);
    return MaterialApp(
      home: switch (state) {
        AppReady()        => MainScreen(),
        AppError()        => ErrorScreen(),
        AppLoading()      => SplashScreen(),
        AppInitializing() => SplashScreen(),
      },
    );
  }
}
```

---

## 6. Best Practices

- Use **only one** `runApp()` call.
- Show splash screen via native splash + Flutter loader UI.
- All services must be "safe" (stub/fallback) before app is ready (no nulls).
- Encapsulate error, retry, timeout logic in bootstrap manager, not UI.
- Write tests for all states and transitions, and for fallback/proxy services.

---

## 7. Migration Steps

- Extract bootstrap logic to an independent manager.
- Swap DI to proxy/fallback pattern.
- Switch UI to render by readiness state only.
- Use simplified enum or sealed class for small apps.

---

## 8. Splash Screen & Initialization (Recommended)

1. **Native splash (`flutter_native_splash`):**
   Fast, flicker-free first paint.
2. **Minimal `main()`:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}
```

3. **Async Initialization via Provider/cubit:**

```dart
final initializationProvider = FutureProvider<void>((ref) async {
  await ref.read(authServiceProvider).initialize();
  await ref.read(dbServiceProvider).initialize();
  await Future.delayed(const Duration(milliseconds: 1200));
});
```

4. **UI Example:**

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(initializationProvider);
    return MaterialApp(
      home: init.when(
        loading: () => SplashScreen(),
        error: (_, __) => ErrorScreen(),
        data: (_) => MainScreen(),
      ),
    );
  }
}
```

---

## 9. Why not multiple `runApp()` calls?

- Not recommended by Flutter team.
- Causes unpredictable behavior, resets state and context.
- Use native splash + state-driven UI instead.

---

## 10. Checklist for Clean Bootstrap Flow

- Centralized readiness state (sealed class/enum).
- Manager handles progress/error/retry.
- Proxy DI pattern with stub fallback.
- UI is fully declarative, depends only on readiness state.
- Only one runApp().
- Full test coverage for states and transitions.

---

## Reference

- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Riverpod](https://riverpod.dev/)
- [BLoC](https://bloclibrary.dev/)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
- [Code with Andrea](https://codewithandrea.com/articles/robust-app-initialization-riverpod/)

---

## Summary

Centralized, state-driven bootstrap logic + lazy, proxy-based DI + declarative UI = robust, scalable, and testable Flutter app startup.

---

**🎯 Never use multiple `runApp()` , because of Unpredictable behavior, Loss of context, Testing issues! Always use native splash (flutter_native_splash) for instant load, centralized readiness state, and a single state-driven UI tree for loading/error/main flows.**
