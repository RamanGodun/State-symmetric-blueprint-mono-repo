Flutter App Bootstrap & Lazy DI Pattern

Applies to: Flutter apps, that agnostic to state management or DI engine (Riverpod, BLoC+GetIt, Provider+GetIt etc).

⸻

## 1. Overview

This pattern provides a robust, scalable solution for Flutter app initialization that handles:
• Asynchronous dependency loading with graceful error handling
• State management abstraction (agnostic to manager)
• User-friendly startup experience with loading, progress, retry
• Testable architecture with clean separation of concerns

### Key Benefits

    •	✅ Scalable: Handles both simple and complex app initialization scenarios
    •	✅ "StateManager & DI engine Agnostic": Works with any state management/DI solution
       (Riverpod, BLoC+GetIt, Provider+GetIt).Therefore, minimal code changes when switching state management
    •	✅ Robust: Timeout, retry, fallbacks, error handling built-in
    •	✅ Testable: Clean isolation and test coverage for bootstrap logic
    •	✅ User-friendly: Immediate, meaningful feedback to user during startup
    •	✅ Clean, declarative, and highly testable. Strictly null safe when using sealed classes.

⸻

## 2. Architecture Principles

### 2.1 Centralized Readiness State (Agnostic)

    •	Maintain a single source of truth for app bootstrap status-state (loading/ready/error/progress)
    with help of sealed class or enum, and which is not tied to state manager.
    •	Bootstrap state can live in a ValueNotifier, Stream, etc — choose what fits the app.

### 2.2 Proxy/Fallback Dependency Injection

    •	All DI reads are through a proxy/provider, which:
    •	Returns a stub/fallback when real implementation not ready (never null!).
    •	Swaps to real implementation after ready.

### 2.3 Declarative, State-driven UI

    •	UI renders based only on readiness state: loader, error, app.
    •	Use Provider.select/BlocSelector/ValueListenableBuilder — minimal rebuilds.

### 2.4 Graceful Error, Retry, and Timeout Handling

    •	Bootstrap manager encapsulates error/retry/timeout logic.
    •	UI only reacts to state; all control/logic is in the bootstrap manager.

⸻

## 3. Core Implementation

### 3.1 Application Readiness State (Independent Model)

Store app readiness status in a global singleton, Sealed class pattern (recommended for strict null safety and extensibility)
and exhaustive pattern matching:

```dart
/// Represents the current state of app initialization
sealed class AppReadinessState {
  const AppReadinessState();
}

/// Initial state when app starts
final class AppInitializing extends AppReadinessState {
  const AppInitializing();
}

/// Active loading state with optional progress tracking
final class AppLoading extends AppReadinessState {
  final double? progress;
  final String? currentStep;

  const AppLoading({
    this.progress,
    this.currentStep,
  });

  AppLoading copyWith({
    double? progress,
    String? currentStep,
  }) {
    return AppLoading(
      progress: progress ?? this.progress,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

/// App is fully initialized and ready
final class AppReady extends AppReadinessState {
  const AppReady();
}

/// Error occurred during initialization
final class AppError extends AppReadinessState {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final bool canRetry;

  const AppError({
    required this.message,
    this.error,
    this.stackTrace,
    this.canRetry = true,
  });
}
```

### 3.2 Bootstrap Manager (Agnostic Bridge)

Bootstrap manager exposes an interface to manipulate/apply readiness state:

abstract interface class AppBootstrapManager {
AppReadinessState get state;
Stream<AppReadinessState> get stateStream; // or ValueListenable, or whatever fits
void updateLoading({double? progress, String? currentStep});
void setReady();
void setError(String message, {Object? error, StackTrace? stackTrace, bool canRetry});
void retry();
}

Implementation can use cubit, StateNotifier, ValueNotifier, custom — as needed.

### 3.2 State Management Implementation

#### Riverpod Implementation

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_readiness_provider.g.dart';

@riverpod
class AppReadinessNotifier extends _$AppReadinessNotifier {
  @override
  AppReadinessState build() => const AppInitializing();

  void updateLoading({double? progress, String? currentStep}) {
    state = AppLoading(progress: progress, currentStep: currentStep);
  }

  void setReady() {
    state = const AppReady();
  }

  void setError(String message, {Object? error, StackTrace? stackTrace, bool canRetry = true}) {
    state = AppError(
      message: message,
      error: error,
      stackTrace: stackTrace,
      canRetry: canRetry,
    );
  }

  void retry() {
    state = const AppInitializing();
  }
}

// Convenience providers for common use cases
@riverpod
bool isAppReady(IsAppReadyRef ref) {
  return ref.watch(appReadinessNotifierProvider) is AppReady;
}

@riverpod
bool isAppLoading(IsAppLoadingRef ref) {
  final state = ref.watch(appReadinessNotifierProvider);
  return state is AppInitializing || state is AppLoading;
}
```

#### BLoC Implementation

```dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class AppReadinesscubit extends cubit<AppReadinessState> {
  AppReadinesscubit() : super(const AppInitializing());

  void updateLoading({double? progress, String? currentStep}) {
    emit(AppLoading(progress: progress, currentStep: currentStep));
  }

  void setReady() {
    emit(const AppReady());
  }

  void setError(String message, {Object? error, StackTrace? stackTrace, bool canRetry = true}) {
    emit(AppError(
      message: message,
      error: error,
      stackTrace: stackTrace,
      canRetry: canRetry,
    ));
  }

  void retry() {
    emit(const AppInitializing());
  }
}
```

⸻

## 4. Proxy DI Pattern

All services (routers, repositories, etc) are accessed via a proxy.
Proxy can return a placeholder or a fallback implementation if main dependency is not ready.

### 4.1 Here need to add Examples (for GoRouter, etc.)

### 4.1 Router Proxy Pattern

```dart
// Riverpod example
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final readinessState = ref.watch(appReadinessNotifierProvider);

  return switch (readinessState) {
    AppReady() => ref.watch(mainRouterProvider),
    AppError() => ref.watch(errorRouterProvider),
    _ => ref.watch(loadingRouterProvider),
  };
}

@riverpod
GoRouter mainRouter(MainRouterRef ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      // ... other routes
    ],
  );
}

@riverpod
GoRouter loadingRouter(LoadingRouterRef ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoadingScreen(),
      ),
    ],
  );
}
```

### 4.2 Service Proxy Pattern

```dart
// Abstract interface for your service
abstract interface class UserRepository {
  Future<User> getCurrentUser();
  Future<void> updateUser(User user);
}

// Production implementation
class ApiUserRepository implements UserRepository {
  // ... implementation
}

// Fallback implementation
class StubUserRepository implements UserRepository {
  @override
  Future<User> getCurrentUser() async => User.guest();

  @override
  Future<void> updateUser(User user) async {
    // No-op or local storage
  }
}

// Proxy provider
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final readinessState = ref.watch(appReadinessNotifierProvider);

  return switch (readinessState) {
    AppReady() => ref.watch(apiUserRepositoryProvider),
    _ => ref.watch(stubUserRepositoryProvider),
  };
}
```

⸻

## 5. Bootstrap Lifecycle

1. Minimal bootstrap
   • Initialize Flutter, logging and debug tools, theme, local storage, etc.
   • Register baseline providers/singletons (can be GetIt or ProviderDIContainer).
2. RunApp
   • Show loader UI bound to readiness state.
3. Full/async bootstrap with timeout & retry
   • In background, load all heavy/async dependencies with timeout.
   • On failure/timeout, expose error state with a retry flag.
   • While loading, update readiness state to AppLoading(progress, step).
   • When finished, set readiness state to AppReady(). Proxies now return real dependencies.
4. Declarative UI rendering
   • UI watches readiness state and proxy providers/blocs.
   • Shows loading screen (with optional progress/step), error shell (with retry), or full app as needed.

### 5.2 Example of Asynchronous Initialization

```dart
Future<void> _initializeAppAsync(ProviderContainer container) async {
  final notifier = container.read(appReadinessNotifierProvider.notifier);

  try {
    // Step 1: Authentication
    notifier.updateLoading(
      progress: 0.2,
      currentStep: 'Checking authentication...',
    );
    await _initializeAuthentication();

    // Step 2: User data
    notifier.updateLoading(
      progress: 0.4,
      currentStep: 'Loading user data...',
    );
    await _loadUserData();

    // Step 3: App configuration
    notifier.updateLoading(
      progress: 0.6,
      currentStep: 'Loading configuration...',
    );
    await _loadConfiguration();

    // Step 4: Additional services
    notifier.updateLoading(
      progress: 0.8,
      currentStep: 'Initializing services...',
    );
    await _initializeServices();

    // Complete
    notifier.updateLoading(
      progress: 1.0,
      currentStep: 'Ready!',
    );

    // Small delay to show completion
    await Future.delayed(const Duration(milliseconds: 500));

    notifier.setReady();

  } on TimeoutException catch (e) {
    notifier.setError(
      'Initialization timed out. Please check your connection and try again.',
      error: e,
    );
  } catch (e, stackTrace) {
    notifier.setError(
      'Failed to initialize app. Please try again.',
      error: e,
      stackTrace: stackTrace,
    );
  }
}

Future<void> _initializeAuthentication() async {
  // Implementation with timeout
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
}

Future<void> _loadUserData() async {
  // Implementation with timeout
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
}

Future<void> _loadConfiguration() async {
  // Implementation with timeout
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
}

Future<void> _initializeServices() async {
  // Implementation with timeout
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
}
```

⸻

## 6. UI Shell

### 6.1 Example (using ValueListenableBuilder, BlocSelector, or Provider.select)

Agnostic

```dart
class MyApp extends StatelessWidget {
  final AppBootstrapManager manager;
  const MyApp({super.key, required this.manager});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppReadinessState>( // ? or AnimatedBuilder
      valueListenable: manager.stateListenable,
      builder: (context, state, _) {
        return MaterialApp.router(
          routerConfig: provideRouter(state),
          builder: (context, child) => switch (state) {
            AppReady() => child ?? SizedBox.shrink(),
            AppError() => AppErrorScreen(state as AppError, onRetry: manager.retry),
            AppLoading() || AppInitializing() => AppLoadingScreen(state),
          },
        );
      },
    );
  }
}
```

OR depends on state manager

```dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readinessState = ref.watch(appReadinessNotifierProvider);

    return MaterialApp.router(
     ...
      builder: (context, child) {
        return switch (readinessState) {
          AppReady() => child ?? const SizedBox.shrink(),
          AppError() => const AppErrorScreen(),
          AppLoading() => const AppLoadingScreen(),
          AppInitializing() => const AppLoadingScreen(),
        };
      },
    );
  }
}
```

⸻

## 7. Testing Best Practices

    •	Mock all possible readiness states (AppInitial, AppLoading, AppReady, AppError).
    •	For DI proxies: Test both the fallback and the real implementation.
    •	For UI: Snapshot/golden tests for loader, error, main app shells.
    •	For services: Always provide test doubles/stubs via DI (e.g., StubProfileRepo, FakeRouter).
    •	Test timeouts and retry logic explicitly.

Example (Riverpod):

testWidgets('shows retry on error', (tester) async {
final container = ProviderContainer(overrides: [
appReadyProvider.overrideWith((_) => AppError('fail', canRetry: true)),
]);
await tester.pumpWidget(ProviderScope(parent: container, child: AppBootstrapper()));
expect(find.byType(ErrorShell), findsOneWidget);
// Simulate tap on retry, test retry flow
});

### 7.1 State Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('AppReadinessNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should start in initializing state', () {
      final notifier = container.read(appReadinessNotifierProvider.notifier);
      final state = container.read(appReadinessNotifierProvider);

      expect(state, isA<AppInitializing>());
    });

    test('should update loading state with progress', () {
      final notifier = container.read(appReadinessNotifierProvider.notifier);

      notifier.updateLoading(progress: 0.5, currentStep: 'Loading...');

      final state = container.read(appReadinessNotifierProvider);
      expect(state, isA<AppLoading>());
      expect((state as AppLoading).progress, 0.5);
      expect(state.currentStep, 'Loading...');
    });

    test('should transition to ready state', () {
      final notifier = container.read(appReadinessNotifierProvider.notifier);

      notifier.setReady();

      final state = container.read(appReadinessNotifierProvider);
      expect(state, isA<AppReady>());
    });

    test('should handle error state with retry capability', () {
      final notifier = container.read(appReadinessNotifierProvider.notifier);

      notifier.setError('Test error', canRetry: true);

      final state = container.read(appReadinessNotifierProvider);
      expect(state, isA<AppError>());
      expect((state as AppError).message, 'Test error');
      expect(state.canRetry, true);
    });
  });
}
```

### 7.2 Widget Testing

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('AppLoadingScreen', () {
    testWidgets('should display loading indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appReadinessNotifierProvider.overrideWith(
              (ref) => const AppLoading(),
            ),
          ],
          child: const MaterialApp(
            home: AppLoadingScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display progress when available', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appReadinessNotifierProvider.overrideWith(
              (ref) => const AppLoading(progress: 0.5, currentStep: 'Loading...'),
            ),
          ],
          child: const MaterialApp(
            home: AppLoadingScreen(),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });
  });

  group('AppErrorScreen', () {
    testWidgets('should display error message and retry button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appReadinessNotifierProvider.overrideWith(
              (ref) => const AppError(message: 'Test error', canRetry: true),
            ),
          ],
          child: const MaterialApp(
            home: AppErrorScreen(),
          ),
        ),
      );

      expect(find.text('Test error'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Show Details'), findsOneWidget);
    });

    testWidgets('should hide retry button when canRetry is false', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appReadinessNotifierProvider.overrideWith(
              (ref) => const AppError(message: 'Test error', canRetry: false),
            ),
          ],
          child: const MaterialApp(
            home: AppErrorScreen(),
          ),
        ),
      );

      expect(find.text('Try Again'), findsNothing);
    });
  });
}
```

### 7.3 Integration Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Bootstrap Integration', () {
    testWidgets('should successfully initialize app', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should start with loading screen
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for initialization to complete
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should show main app
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should handle initialization errors gracefully', (tester) async {
      // Mock network error or service failure
      // ... setup error conditions

      app.main();
      await tester.pumpAndSettle();

      // Should show error screen
      expect(find.text('Try Again'), findsOneWidget);

      // Test retry functionality
      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      // Should restart initialization
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

⸻

## 8. Best Practices

### 8.1 General:

    •	If possible, use "AppReadinessState/Manager abstraction" (use "clean bridge" for AppReadinessState in UI)
     keep AppReadinessState and BootstrapManager decoupled from state manager/DI (state can be saved in
     ValueNotifier, ChangeNotifier, Streams or global var), UI subscribes on that is available now
    • Define sealed class/enum/abstract class AppReadinessState SEPARATELY from “presentation layer”
    •	All proxy DI uses "Stub/Loading/Fallback Service", not null, "Safe/fallback DI for all sync/async services"
      (always must be “safe-fallback” to avoid null)
    •	UI does not depend on DI or state manager, only on AppReadinessState.
    •	Retry/timeout, error, progress logic in manager, not in UI.
    •	Prepare (through  proxy/stub) minimal necessary DI (theme, router, local storage) for loader/error screens.
    • Avoid implementation in UI or DI Container
    •	Test state and transitions in isolation.
    • Use absolutely async bootstrap, all really heavy services - only after “ready”.
    Heavy services inject (through GetIt.reset() + re-register or through proxy/provider swap)

### 8.2 Performance Considerations

- **Lazy initialization**: Only initialize services when needed
- **Concurrent loading**: Use `Future.wait()` for independent operations
- **Resource cleanup**: Properly dispose of resources in error cases
- **Memory management**: Avoid memory leaks during long initialization

### 8.3 User Experience

- **Immediate feedback**: Show loading state immediately
- **Progress indication**: Provide progress updates for long operations
- **Meaningful messages**: Use clear, actionable error messages
- **Retry mechanisms**: Always provide recovery options

### 8.4 Error Handling

- **Specific error types**: Use different error states for different failure modes
- **Logging**: Log errors for debugging and monitoring
- **Graceful degradation**: Provide fallback functionality where possible
- **Timeout handling**: Set reasonable timeouts for all async operations

### 8.5 Testing

- **Mock dependencies**: Use dependency injection for testability
- **State coverage**: Test all possible states and transitions
- **Error scenarios**: Test timeout, network failure, and other edge cases
- **Integration tests**: Verify end-to-end initialization flow

### Advanced: Stepper/FSM Pipeline (Optional):

- for complex pipelines, implement a Stepper or State Machine for bootstrap process
  (make stepper/fsm/chain-of-responsibility for pipeline-bootstrap,
  etc split full bootstrap on pipeline-stages and granular error/progress control, so-called "state machine, stepper")

⸻

## 9. Adoption

### 9.1 Migration

    •	Replace bootstrap logic with BootstrapManager (ValueNotifier)
    •	Swap DI registration with proxy/fallback logic
    •	Switch UI to react to AppReadinessState only

### 9.2 Adaptation for Small Apps

    •	Keep only a centralized readiness state.
    •	Omit proxy/fallback for DI — use direct injection (e.g., always use real router/service, as no async bootstrapping is needed).
    •	Use a simple enum or sealed with only initial, ready, error states.
    •	Loader and error UI may be just a couple of widgets.

For simpler applications, you can use a minimal version:

```dart
enum AppState { loading, ready, error }

@riverpod
class SimpleAppNotifier extends _$SimpleAppNotifier {
  @override
  AppState build() => AppState.loading;

  void setReady() => state = AppState.ready;
  void setError() => state = AppState.error;
}

// Simplified UI
class SimpleApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simpleAppNotifierProvider);

    return MaterialApp(
      home: switch (state) {
        AppState.loading => const LoadingScreen(),
        AppState.error => const ErrorScreen(),
        AppState.ready => const HomeScreen(),
      },
    );
  }
}
```

### 9.3 Enterprise Apps

For larger applications, enhance with additional features:

```dart
// Enhanced state with more granular tracking
final class AppLoading extends AppReadinessState {
  final double progress;
  final String currentStep;
  final List<String> completedSteps;
  final Duration elapsedTime;

  const AppLoading({
    required this.progress,
    required this.currentStep,
    required this.completedSteps,
    required this.elapsedTime,
  });
}

// Enhanced error handling
final class AppError extends AppReadinessState {
  final String message;
  final String errorCode;
  final Map<String, dynamic> context;
  final bool canRetry;
  final int retryAttempts;

  const AppError({
    required this.message,
    required this.errorCode,
    required this.context,
    this.canRetry = true,
    this.retryAttempts = 0,
  });
}
```

⸻

## 10. References

- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Riverpod Documentation](https://riverpod.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)
- [GetIt Documentation](https://pub.dev/packages/get_it)
- [Flutter App Architecture](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)
- [Code with Andrea - App Initialization](https://codewithandrea.com/articles/robust-app-initialization-riverpod/)

Summary of the Idea (Best Practices) 1. Centralized, Framework-Agnostic Readiness State
• AppReadinessState (sealed class) — an independent model, with no ties to BLoC, Riverpod, GetIt, etc.
• The state can be stored anywhere: ValueNotifier, Stream, ChangeNotifier, cubit, StateNotifier, or a global variable.
• State updates are performed only through a dedicated manager that fires new states. 2. Proxy / Fallback DI for All Services
• Stub/Null Object/Fake pattern: every service has a minimal stub (e.g., StubUserRepository) that never returns null and never breaks the chain.
• The real DI implementation is swapped in only after entering the AppReady state. 3. Minimal Bootstrap
• Only the minimum required for displaying the loader (theme, localization stub, router stub).
• All other services go through fallback/proxy (never null). 4. Fully Declarative UI Shell
• Readiness is checked only via select/selector/ValueListenableBuilder/StreamBuilder.
• Loader, Error, and Ready UI are automatically switched based on state, not depending on DI or state manager. 5. All Error/Retry/Timeout Logic
• Is encapsulated in the BootstrapManager (an abstraction not tied to the state manager).
• The UI only triggers retry (e.g., via a callback), but the actual retry logic is the manager’s responsibility. 6. For Large Applications
• You can add a stepper/pipeline/FSM for complex scenarios (advanced use).
• The DI container, when ready, swaps all proxies for real services (using reset/replace or dynamic proxy).

⸻

🔥 Checklist for a “Clean” Bootstrap-Flow (Enterprise-Level):
• AppReadinessState — sealed class, agnostic, can be stored anywhere (ValueNotifier/Stream/Notifier).
• BootstrapManager — a bridge, does not depend on DI/StateManager, responsible for error/retry/progress logic.
• Proxy DI — always uses stubs (stub repository, router, theme, localization) before readiness.
• Loader/Error/Main UI — automatically switched, subscription via select/selector/StreamBuilder.
• No nulls, only safe stubs/fallbacks.
• All minimal DI (theme, router, overlay) — always available via fallback/proxy.
• Testing: all transitions and fallback services are easily mockable.
• Easy adaptation for any state manager (Provider, Bloc, Riverpod, GetIt, etc.).
