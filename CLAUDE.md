# Flutter Monorepo - Архітектурна документація

> **Монорепозиторій для розробки Flutter додатків з підтримкою множинних state management рішень**
>
> **Основна філософія**: State-Symmetric Architecture - єдина кодова база для BLoC/Cubit та Riverpod через адаптери

---

## 🏗️ Структура монорепо

### Загальна організація

```
playground_monorepo/
├── apps/                              # Фінальні Flutter додатки
│   ├── state_symmetric_on_cubit/     # Додаток на BLoC/Cubit
│   └── state_symmetric_on_riverpod/  # Додаток на Riverpod
├── packages/                          # Переиспользуємі модулі
│   ├── adapters_for_bloc/            # BLoC-специфічні адаптери
│   ├── adapters_for_riverpod/        # Riverpod-специфічні адаптери
│   ├── adapters_for_firebase/        # Firebase інтеграція
│   ├── shared_layers/                # Спільні Domain/Data/Presentation шари
│   ├── shared_core_modules/          # Базові модулі (Theme, Navigation, Errors)
│   ├── shared_utils/                 # Утиліти (extensions, timing control)
│   ├── shared_widgets/               # UI компоненти
│   ├── features_dd_layers/           # Фічі (Domain+Data шари)
│   └── app_bootstrap/                # Ініціалізація додатку
├── scripts/                           # Bash скрипти для автоматизації
├── melos.yaml                         # Конфігурація Melos workspace
└── analysis_options.yaml              # Dart лінтер правила
```

### Packages dependency graph (спрощено)

```
apps (cubit/riverpod)
  ↓
adapters_for_[bloc|riverpod] + features_dd_layers + app_bootstrap
  ↓
shared_layers + shared_core_modules
  ↓
shared_utils + shared_widgets
```

**Принцип залежностей**:

- Адаптери залежать від shared_layers (але shared_layers НЕ залежить від адаптерів)
- Shared пакети не знають про конкретні state managers
- Apps знають про адаптери та збирають все разом

---

## 🎯 Архітектурні патерни

### 1. State-Symmetric Architecture

**Концепція**: Один і той самий бізнес-код працює з різними state managers через адаптери.

**Ключові елементи**:

#### Layered Architecture (Data → Domain → Presentation)

**Domain Layer** (technology-agnostic):

```dart
// packages/features_dd_layers/lib/src/auth/domain/

// Контракти (абстрактні інтерфейси)
abstract interface class ISignUpRepo {
  ResultFuture<void> signup({
    required String name,
    required String email,
    required String password,
  });
}

// Use Cases
final class SignUpUseCase {
  const SignUpUseCase(this.repo);
  final ISignUpRepo repo;

  ResultFuture<void> call({...}) => repo.signup(...)
    ..log()
    ..logSuccess('SignUpUseCase success');
}
```

**Data Layer** (implementations):

```dart
// packages/features_dd_layers/lib/src/auth/data/

// Repository Implementation
final class SignUpRepoImpl implements ISignUpRepo {
  const SignUpRepoImpl(this.remote);
  final IAuthRemoteDatabase remote;

  @override
  ResultFuture<void> signup({...}) async {
    return ResultHandler.handle(() async {
      final uid = await remote.signUp(email: email, password: password);
      final dto = UserDto.fromSignup(uid: uid, name: name, email: email);
      await remote.saveUserData(uid, dto.toJson());
    });
  }
}
```

**Presentation Layer** (state + UI):

- **Shared state models**: `SubmissionState`, `AsyncValue`
- **Adapters translate** між shared моделями та конкретними state managers

#### BLoC Adapter Pattern

```dart
// packages/adapters_for_bloc/lib/src/features/auth/auth_cubit.dart

final class AuthCubit extends Cubit<AuthViewState> {
  AuthCubit({required AuthGateway gateway}) : super(const AuthViewLoading()) {
    _sub = gateway.snapshots$.listen((snap) {
      switch (snap) {
        case AuthLoading(): emit(const AuthViewLoading());
        case AuthFailure(:final error): emit(AuthViewError(error));
        case AuthReady(:final session): emit(AuthViewReady(session));
      }
    });
  }
  // ...
}
```

#### Riverpod Adapter Pattern

```dart
// packages/adapters_for_riverpod/lib/src/features/auth/

@riverpod
Stream<AuthSnapshot> authGatewaySnapshots(AuthGatewaySnapshotsRef ref) {
  final gateway = ref.watch(authGatewayProvider);
  return gateway.snapshots$;
}
```

**Результат**: 90%+ переиспользання коду між apps, різниця тільки в адаптерах.

---

### 2. Error Handling Pattern: Either Monad

**Філософія**: Ніколи не кидаємо exceptions в domain/data шарах, використовуємо `Either<Failure, Success>`.

#### Type Definitions

```dart
// packages/shared_core_modules/lib/src/errors_management/

typedef Result<T> = Either<Failure, T>;
typedef ResultFuture<T> = Future<Either<Failure, T>>;
```

#### Either Implementation

```dart
sealed class Either<L, R> {
  const Either();

  // Pattern matching
  T fold<T>(T Function(L) onLeft, T Function(R) onRight);

  // Getters
  bool get isLeft;
  bool get isRight;
  L? get leftOrNull;
  R? get rightOrNull;
}

final class Left<L, R> extends Either<L, R> { ... }
final class Right<L, R> extends Either<L, R> { ... }
```

#### Usage Pattern

```dart
// Repository method
ResultFuture<void> signUp(...) async {
  return ResultHandler.handle(() async {
    // business logic that may throw
    await firebaseAuth.createUserWithEmailAndPassword(...);
  });
}

// Use case
final result = await signUpUseCase(name: name, email: email, password: password);

result.fold(
  (failure) => showError(failure.message),
  (success) => navigateToHome(),
);
```

#### Failure Types

```dart
sealed class FailureType {
  const FailureType();
}

final class ServerFailure extends FailureType { ... }
final class NetworkFailure extends FailureType { ... }
final class CacheFailure extends FailureType { ... }
final class ValidationFailure extends FailureType { ... }
```

**Переваги**:

- Explicit error handling (компілятор гарантує обробку помилок)
- Type-safe (помилки є частиною типу функції)
- Logging and observability через extensions (`..log()`, `..logSuccess()`)

---

### 3. Dependency Injection

**Підхід**: Manual DI через factory functions та provider pattern.

#### For BLoC (GetIt)

```dart
// apps/state_symmetric_on_cubit/lib/app_bootstrap/di_container.dart

final getIt = GetIt.instance;

void setupDependencies() {
  // Singletons
  getIt.registerSingleton<AuthGateway>(FirebaseAuthGateway());

  // Factories
  getIt.registerFactory<ISignUpRepo>(() => SignUpRepoImpl(
    getIt<IAuthRemoteDatabase>(),
  ));

  getIt.registerFactory<SignUpUseCase>(() => SignUpUseCase(
    getIt<ISignUpRepo>(),
  ));
}
```

#### For Riverpod (Providers)

```dart
// packages/adapters_for_riverpod/lib/src/features/auth/

@riverpod
ISignUpRepo signUpRepo(SignUpRepoRef ref) {
  final remote = ref.watch(authRemoteDatabaseProvider);
  return SignUpRepoImpl(remote);
}

@riverpod
SignUpUseCase signUpUseCase(SignUpUseCaseRef ref) {
  final repo = ref.watch(signUpRepoProvider);
  return SignUpUseCase(repo);
}
```

---

### 4. Navigation Pattern: GoRouter

**Конфігурація**: Declarative routing з типобезпекою.

```dart
// apps/state_symmetric_on_cubit/lib/core/navigation/

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: 'sign-up',
          builder: (context, state) => const SignUpPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      redirect: (context, state) {
        final isAuthenticated = context.read<AuthCubit>().state is AuthViewReady;
        return isAuthenticated ? null : '/auth';
      },
      builder: (context, state) => const ProfilePage(),
    ),
  ],
  redirect: (context, state) {
    // Global auth guard
    final isAuthenticated = context.read<AuthCubit>().state is AuthViewReady;
    if (!isAuthenticated && !state.matchedLocation.startsWith('/auth')) {
      return '/auth';
    }
    return null;
  },
);
```

**Features**:

- Typed routes
- Auth guards через `redirect`
- Deep linking support
- Browser history (web)

---

### 5. Feature Structure Pattern

**Організація features** за vertical slices:

```
features/auth/
├── data/                    # Data layer
│   ├── remote_database_contract.dart      # abstract interface
│   ├── remote_database_impl.dart          # Firebase implementation
│   └── auth_repo_implementations/
│       ├── sign_in_repo_impl.dart
│       ├── sign_up_repo_impl.dart
│       └── sign_out_repo_impl.dart
├── domain/                  # Domain layer
│   ├── repo_contracts.dart              # ISignInRepo, ISignUpRepo, etc.
│   └── use_cases/
│       ├── sign_in.dart                 # SignInUseCase
│       ├── sign_up.dart                 # SignUpUseCase
│       └── sign_out.dart                # SignOutUseCase
└── presentation/            # Presentation layer (in app, not package)
    ├── pages/
    │   ├── sign_in_page.dart
    │   └── sign_up_page.dart
    ├── widgets/
    │   ├── email_input_field.dart
    │   └── password_input_field.dart
    └── cubit/  (or notifier/)
        ├── sign_in_cubit.dart           # BLoC app
        └── sign_in_notifier.dart        # Riverpod app
```

**Правила**:

- Data та Domain в shared package (`features_dd_layers`)
- Presentation в app-specific code (різна для BLoC/Riverpod)
- Адаптери перекладають між shared models та конкретним state manager

---

## 📋 Code Style & Conventions

### Dart 3 Features

#### Class Modifiers (широко використовуються!)

```dart
// final class - не можна extends або implement
final class AuthCubit extends Cubit<AuthViewState> { ... }
final class SignUpUseCase { ... }

// sealed class - pattern matching
sealed class AuthViewState { ... }
sealed class Either<L, R> { ... }
sealed class FailureType { ... }

// abstract interface class - чистий контракт
abstract interface class ISignUpRepo { ... }
abstract interface class IAuthRemoteDatabase { ... }
```

**Правило**:

- `final class` для implementations (не потрібно наслідування)
- `sealed class` для discriminated unions (pattern matching)
- `abstract interface class` для contracts (тільки implements)
- `base class`, `mixin class` - НЕ використовуються

#### Pattern Matching (Dart 3)

```dart
// Switch expressions з exhaustiveness check
switch (authSnapshot) {
  case AuthLoading():
    emit(const AuthViewLoading());
  case AuthFailure(:final error):
    emit(AuthViewError(error));
  case AuthReady(:final session):
    emit(AuthViewReady(session));
}

// Destructuring
final AuthReady(:session) = authState;
print(session.email);
```

#### Records (Dart 3)

```dart
// Tuple-like values
(String, int) getUserInfo() => ('John Doe', 25);

final (name, age) = getUserInfo();
```

---

### Naming Conventions

#### Files

- `snake_case.dart` (стандарт Dart)
- Приклади: `sign_up_repo_impl.dart`, `auth_cubit.dart`, `user_entity_x.dart`

#### Classes

- `PascalCase` для class names
- Prefix patterns:
  - `I` для інтерфейсів: `ISignUpRepo`, `IAuthRemoteDatabase`
  - Suffix `Impl` для implementations: `SignUpRepoImpl`
  - Suffix `UseCase` для use cases: `SignUpUseCase`
  - Suffix `Cubit` для cubits: `AuthCubit`, `AppThemeCubit`
  - Suffix `Notifier` для Riverpod notifiers

#### Variables & Functions

- `camelCase` (стандарт)
- Private: `_leadingUnderscore`
- Приклади: `signUpUseCase`, `_authSubscription`, `getUserProfile`

#### Constants

- `camelCase` для const values (NOT SCREAMING_SNAKE_CASE)
- Приклади: `const primaryColor = ...`, `const maxRetries = 3`

#### State Management Naming

**BLoC/Cubit**:

```dart
// State classes: [Feature]ViewState base + specific states
sealed class AuthViewState { ... }
final class AuthViewLoading extends AuthViewState { ... }
final class AuthViewReady extends AuthViewState { ... }
final class AuthViewError extends AuthViewState { ... }

// Cubit
final class AuthCubit extends Cubit<AuthViewState> { ... }
```

**Riverpod**:

```dart
// Providers: [feature][Type]Provider
@riverpod
AuthGateway authGateway(AuthGatewayRef ref) { ... }

@riverpod
Stream<AuthSnapshot> authGatewaySnapshots(AuthGatewaySnapshotsRef ref) { ... }
```

---

### Code Organization

#### File Structure

**Single public export file**:

```dart
// package/lib/package_name.dart
export 'public_api/domain_layer.dart';
export 'public_api/data_layer.dart';
export 'public_api/presentation_layer.dart';

// package/lib/public_api/domain_layer.dart
export '../src/domain/repo_contracts.dart';
export '../src/domain/use_cases/sign_up.dart';
// ...

// Internal implementation
// package/lib/src/domain/repo_contracts.dart
```

**Правило**: Завжди експортувати через `public_api/`, ніколи не імпортувати `src/` напряму з інших пакетів.

#### Import Order & Style

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:collection';

// 2. Flutter framework
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. External packages (alphabetically)
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// 4. Internal packages (монорепо)
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/domain_layer_shared.dart';

// 5. Relative imports (якщо потрібно)
import '../data/remote_database_contract.dart';
import 'repo_contracts.dart';
```

**Show/hide для granular imports**:

```dart
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;

import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show AppThemeCubit, BlocWatchSelectX;
```

---

### Formatting Rules

#### Line Length

- **Code**: 120 characters (VSCode налаштування: `"dart.lineLength": 120`)
- **Comments**: 80 characters (для читабельності)

```dart
// ❌ BAD: Over 120 characters
final result = await signUpUseCase.call(name: userName, email: userEmail, password: userPassword, confirmPassword: userConfirmPassword);

// ✅ GOOD: Multi-line with trailing comma
final result = await signUpUseCase.call(
  name: userName,
  email: userEmail,
  password: userPassword,
  confirmPassword: userConfirmPassword,
);
```

#### Trailing Commas

**ЗАВЖДИ** використовувати trailing commas для multi-line constructs:

```dart
// ✅ GOOD
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Title'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    ),
    body: Column(
      children: [
        const Text('Line 1'),
        const Text('Line 2'),
      ],
    ),
  );
}
```

**Переваги**:

- Автоформатування працює краще
- Diff'и чистіші (один рядок змінився)
- Легше додавати нові параметри

#### Indentation

- **2 spaces** (стандарт Dart, НЕ tabs)
- Auto-formatting: `dart format .`

---

### Const Usage

**Правило**: Використовувати `const` скрізь, де можливо.

```dart
// ✅ GOOD
const Text('Hello')
const SizedBox(height: 16)
const EdgeInsets.all(8)

// Widget constructors
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});  // const constructor

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Collections
const primaryColors = [
  Color(0xFF2196F3),
  Color(0xFF64B5F6),
];
```

**Linter rule**: `prefer_const_literals_to_create_immutables: true`

---

### Comments & Documentation

#### Dart Doc для public APIs

````dart
/// 🔐 [ISignUpRepo] — contract for user registration logic
///
/// Defines the interface for creating new user accounts and storing
/// additional user data in the remote database.
abstract interface class ISignUpRepo {
  /// 🆕 Creates a new user and stores additional info in Remote database
  ///
  /// Returns [Right] with void on success, or [Left] with [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await repo.signup(
  ///   name: 'John Doe',
  ///   email: 'john@example.com',
  ///   password: 'SecurePass123!',
  /// );
  /// ```
  ResultFuture<void> signup({
    required String name,
    required String email,
    required String password,
  });
}
````

#### Inline Comments Style

```dart
// ✅ GOOD: Короткі, змістовні
final uid = await remote.signUp(email: email, password: password);  // Create Firebase user
final dto = UserDto.fromSignup(uid: uid, name: name, email: email); // Build DTO
await remote.saveUserData(uid, dto.toJson());                        // Save to Firestore

// ❌ BAD: Очевидні коментарі (не потрібні)
final uid = await remote.signUp(email: email, password: password);  // Call signUp method

// ✅ GOOD: Section headers
// -------- Dependencies --------
final authGateway = getIt<AuthGateway>();
final signUpUseCase = getIt<SignUpUseCase>();

// -------- UI State --------
final isLoading = state is AuthViewLoading;
final error = state is AuthViewError ? state.error : null;
```

#### Emoji Usage in Comments

**Проект використовує емоджі** для швидкої візуальної навігації:

```dart
/// 🔐 Auth-related
/// 📦 Data/Domain objects
/// 🌍 Localization
/// 🎨 Theme/UI
/// 🧩 Widget/Component
/// 🧭 Navigation
/// ⚙️ Configuration
/// ✅ Success case
/// ❌ Error case
/// ⏳ Loading state
/// 🔗 Connection/Stream
/// 🧹 Cleanup
```

**Приклад**:

```dart
/// 🔐 [AuthCubit] — Bloc wrapper around [AuthGateway] snapshots
final class AuthCubit extends Cubit<AuthViewState> {
  /// 🔗 Active subscription to auth state stream
  late final StreamSubscription<AuthSnapshot> _sub;

  /// 🧹 Cancels subscription and disposes cubit
  @override
  Future<void> close() async { ... }
}
```

---

### Type Annotations

**Правило**: Завжди явні типи для public APIs, можна опустити для local variables якщо очевидно.

```dart
// ✅ GOOD: Explicit return types
ResultFuture<void> signUp({...}) async { ... }
AuthViewState get currentState => state;

// ✅ GOOD: Explicit parameter types
void handleSubmit({
  required String email,
  required String password,
}) { ... }

// ✅ OK: Inferred local variables (якщо очевидно)
final user = await getUserProfile();  // Type inferred from function
final count = items.length;           // Obviously int

// ❌ BAD: var для public APIs
var getUserProfile() async { ... }  // NEVER do this
```

---

## 🧪 Testing Strategy

### Test Coverage

**Current stats**:

- **167 test files** в монорепо
- Організація: AAA pattern (Arrange-Act-Assert)
- Frameworks: `flutter_test`, `bloc_test`, `mocktail`

**Target coverage**:

- Business logic (domain/data): **80%+**
- Critical user flows: **100%**
- UI widgets: **60%+** (складні widgets)

---

### Test Structure & Naming

#### File Organization

**Mirror source structure**:

```
lib/src/auth/data/sign_up_repo_impl.dart
→ test/src/auth/data/sign_up_repo_impl_test.dart

lib/src/utils/debouncer.dart
→ test/src/utils/debouncer_test.dart
```

#### Test Grouping

```dart
void main() {
  group('SignUpRepoImpl', () {
    late IAuthRemoteDatabase mockRemote;
    late ISignUpRepo repo;

    setUp(() {
      mockRemote = MockAuthRemoteDatabase();
      repo = SignUpRepoImpl(mockRemote);
    });

    group('constructor', () {
      test('creates instance with provided remote database', () {
        // Arrange & Act
        final repo = SignUpRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<SignUpRepoImpl>());
        expect(repo, isA<ISignUpRepo>());
      });
    });

    group('signup', () {
      group('successful sign-up', () {
        test('calls signUp and saveUserData in sequence', () async {
          // Arrange
          when(() => mockRemote.signUp(...)).thenAnswer((_) async => 'uid-123');
          when(() => mockRemote.saveUserData(...)).thenAnswer((_) async {});

          // Act
          await repo.signup(name: 'John', email: 'john@example.com', password: 'Pass123!');

          // Assert
          verify(() => mockRemote.signUp(...)).called(1);
          verify(() => mockRemote.saveUserData(...)).called(1);
        });

        test('returns Right on successful sign-up and data save', () async { ... });
      });

      group('failed sign-up', () {
        test('returns Left when signUp throws exception', () async { ... });
        test('does not save data if signUp fails', () async { ... });
      });

      group('edge cases', () {
        test('handles very long user names', () async { ... });
        test('handles special characters in name', () async { ... });
      });
    });
  });
}
```

**Best Practices**:

- 3-4 рівні `group()` для організації
- Описові назви тестів: `should do X when Y`
- AAA pattern: `// Arrange`, `// Act`, `// Assert` коментарі
- `setUp()` / `tearDown()` для shared setup

---

### Testing Tools

#### BLoC Testing

```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<AuthCubit, AuthViewState>(
  'emits [AuthViewLoading, AuthViewReady] when auth succeeds',
  build: () {
    when(() => mockGateway.snapshots$).thenAnswer(
      (_) => Stream.value(AuthReady(session: mockSession)),
    );
    return AuthCubit(gateway: mockGateway);
  },
  expect: () => [
    const AuthViewLoading(),
    AuthViewReady(mockSession),
  ],
);
```

#### Mocking (Mocktail)

```dart
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatabase extends Mock implements IAuthRemoteDatabase {}

void main() {
  late MockAuthRemoteDatabase mockRemote;

  setUp(() {
    mockRemote = MockAuthRemoteDatabase();

    // Setup default behavior
    when(() => mockRemote.signUp(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => 'test-uid');
  });

  test('example', () async {
    // Act
    await repo.signup(...);

    // Assert with verify
    verify(() => mockRemote.signUp(email: 'test@example.com', password: 'Pass123!')).called(1);
    verifyNever(() => mockRemote.saveUserData(any(), any()));
  });
}
```

#### Widget Testing

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SignUpButton calls onPressed when tapped', (tester) async {
    // Arrange
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignUpButton(onPressed: () => pressed = true),
        ),
      ),
    );

    // Act
    await tester.tap(find.byType(SignUpButton));
    await tester.pump();

    // Assert
    expect(pressed, isTrue);
  });
}
```

---

### Coverage Reports

**Генерація**:

```bash
# All apps
melos run coverage

# Specific app
melos run coverage:cubit
melos run coverage:riverpod

# Specific package
./scripts/tests/run_coverage.sh shared_utils
```

**Output**:

- `coverage/lcov.info` - raw coverage data
- `coverage/html/index.html` - HTML звіт (автоматично відкривається)

**CI Integration**: Coverage reports генеруються в GitHub Actions.

---

## 🛠️ Tooling & Scripts

### Melos Configuration

**Workspace management**: `melos.yaml` визначає 65+ scripts для автоматизації.

#### Key Commands

**Bootstrap & Maintenance**:

```bash
melos bootstrap              # Initialize workspace (pub get for all packages)
melos clean                  # flutter clean для всіх
melos clean:deep             # git clean -xfd (DANGEROUS: видаляє untracked files)
melos pub:upgrade            # flutter pub upgrade для всіх
melos pub:outdated           # Check outdated dependencies
```

**Code Quality**:

```bash
melos run check              # format:check + analyze + test (CI equivalent)
melos run format:write       # dart format . (fix formatting)
melos run format:check       # dart format --set-exit-if-changed (CI check)
melos run analyze            # flutter analyze для всіх packages
melos run fix:apply          # dart fix --apply (auto-fix lints)
```

**Testing**:

```bash
melos run test               # Run all tests
melos run test:apps          # Only apps
melos run test:packages      # Only packages
melos run test:cubit         # Specific app
melos run coverage           # Generate coverage reports
```

**Code Generation**:

```bash
melos run gen                # build_runner для всіх packages
melos run gen:packages       # Тільки packages
melos run gen:apps           # Тільки apps
melos run gen:clean          # build_runner clean
melos run watch:apps         # build_runner watch (live reload)

melos run localization:gen:all   # Generate localization files
melos run spider:gen             # Generate asset paths (images/icons)
melos run icons:gen              # Generate app icons
```

**Dart Code Metrics (DCM)**:

```bash
melos run dcm                # Analyze all with DCM
melos run dcm:html           # Generate HTML report and open
melos run dcm:apps           # Only apps
melos run dcm:packages       # Only packages
melos run dcm:changed        # Only changed since last commit
```

**iOS Troubleshooting**:

```bash
melos run kill:xcode                # Kill all xcodebuild processes
melos run clean:ios:state_symmetric_on_cubit    # Clean iOS build artifacts
melos run reset:ios:state_symmetric_on_riverpod # Full iOS reset (+ DerivedData)
melos run fix:ios                   # Quick fix for "concurrent builds" error
```

---

### Custom Scripts

**Location**: `scripts/` directory

#### Test Runner (`scripts/tests/run_tests.sh`)

```bash
./scripts/tests/run_tests.sh all               # All packages + apps
./scripts/tests/run_tests.sh apps              # Only apps
./scripts/tests/run_tests.sh packages          # Only packages
./scripts/tests/run_tests.sh cubit             # Specific app
./scripts/tests/run_tests.sh shared_utils      # Specific package
```

**Features**:

- Concurrency: `flutter test --concurrency=4`
- Color-coded output (Green ✅, Red ❌, Yellow ⚠️)
- Exit on first failure: `--fail-fast`

#### Coverage Generator (`scripts/tests/run_coverage.sh`)

```bash
./scripts/tests/run_coverage.sh all
./scripts/tests/run_coverage.sh cubit
./scripts/tests/run_coverage.sh shared_layers
```

**Features**:

- Generates `coverage/lcov.info`
- Converts to HTML via `genhtml`
- Auto-opens browser (macOS: `open`, Linux: `xdg-open`, Windows: `start`)

#### Code Generation (`scripts/gen_code/`)

- `gen_codegen.sh` - build_runner для packages/apps
- `gen_localization.sh` - flutter gen-l10n
- `gen_icons.sh` - flutter_launcher_icons
- `gen_spider.sh` - spider для assets paths

---

### Linter Configuration

**Base**: `very_good_analysis` (Very Good Ventures rules)

**Overrides** (`analysis_options.yaml`):

```yaml
linter:
  rules:
    prefer_const_literals_to_create_immutables: true
    curly_braces_in_flow_control_structures: false # Allow single-line ifs

custom_lint:
  enabled_all_lint_rules: false
  rules:
    missing_provider_scope: false # Don't enforce ProviderScope
    generated_provider_dependency: false # Don't require @riverpod deps

analyzer:
  plugins:
    - custom_lint

  exclude:
    - "**/*.freezed.dart"
    - "**/*.g.dart"
    - "**/firebase_options.dart"
    - "**/app_images_paths.dart"

  errors:
    invalid_annotation_target: warning
    deprecated_member_use: ignore
```

**CI Check**: `melos run format:check && melos run analyze` (fails on any violations)

---

### VSCode Configuration

**Settings** (`.vscode/settings.json`):

```json
{
  "dart.lineLength": 120,
  "dart.previewFlutterUiGuides": true,
  "editor.foldingImportsByDefault": true,

  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnSaveMode": "file",
    "editor.codeActionsOnSave": {
      "source.fixAll": "explicit",
      "source.organizeImports": "explicit"
    }
  },

  "dart.flutterHotReloadOnSave": "all",
  "dart.runPubGetOnPubspecChanges": "always",

  "explorer.fileNesting.enabled": true,
  "explorer.fileNesting.patterns": {
    "*.dart": "${capture}.g.dart, ${capture}.freezed.dart, ${capture}.mocks.dart"
  }
}
```

**Переваги**:

- Auto-format on save
- Auto-organize imports
- Auto pub get on pubspec changes
- File nesting (hide generated files)

---

## 🔥 Firebase Integration

### Setup

**Package**: `adapters_for_firebase`

**Responsibilities**:

- Firebase initialization
- Re-export Firebase types для use в features
- Platform-specific configuration

### Usage

```dart
// apps/.../lib/main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

### Services

**Auth**: `FirebaseAuth` через `IAuthRemoteDatabase` contract
**Firestore**: `FirebaseFirestore` через remote database contracts
**Crashlytics**: Error reporting (planned)

---

## 🌍 Localization

### Setup

**Package**: `easy_localization` + Flutter's `flutter_localizations`

**Location**:

- Core translations: `packages/shared_core_modules/assets/translations/`
- App-specific: `apps/.../assets/translations/`

### File Structure

```
assets/translations/
├── en.json
├── uk.json
└── pl.json
```

**Example** (`en.json`):

```json
{
  "app_title": "My Flutter App",
  "auth": {
    "sign_in": "Sign In",
    "sign_up": "Sign Up",
    "email": "Email",
    "password": "Password"
  },
  "errors": {
    "invalid_email": "Invalid email format",
    "weak_password": "Password is too weak"
  }
}
```

### Usage

```dart
import 'package:easy_localization/easy_localization.dart';

// In build()
Text('auth.sign_in'.tr())
Text('errors.invalid_email'.tr())
```

### Code Generation

```bash
melos run localization:gen:all    # Generate for all
melos run localization:gen:core   # Core only
melos run localization:gen:apps   # Apps only
```

**Output**: `generated/app_locale_keys.g.dart` (typed keys)

```dart
// Generated code
abstract class AppLocaleKeys {
  static const app_title = 'app_title';
  static const auth_sign_in = 'auth.sign_in';
  static const errors_invalid_email = 'errors.invalid_email';
}

// Usage with safety
Text(AppLocaleKeys.auth_sign_in.tr())
```

---

## 🎨 Theming

### Design System

**Location**: `packages/shared_core_modules/lib/src/ui_design/`

**Components**:

- Color palette (light/dark themes)
- Typography (Inter, Montserrat fonts)
- Spacing/sizing constants
- Theme switching logic

### Theme Management

**State**: `AppThemeCubit` (BLoC) or `AppThemeNotifier` (Riverpod)

```dart
// Change theme
context.read<AppThemeCubit>().setTheme(ThemeVariantsEnum.dark);
context.read<AppThemeCubit>().setFont(AppFontFamily.montserrat);

// Watch theme
final themeMode = context.watch<AppThemeCubit>().state.mode;
```

### Custom Theme

```dart
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16),
  ),
);
```

**Persistence**: `hydrated_bloc` (BLoC) or `get_storage` (Riverpod) зберігає preferences.

---

## 🚀 Build & Deployment

### Environment Flavors

**Setup**: `.env.dev`, `.env.staging` files

```bash
# .env.dev
API_URL=https://dev-api.example.com
ENABLE_LOGGING=true

# .env.staging
API_URL=https://staging-api.example.com
ENABLE_LOGGING=false
```

**Entry points**:

- `lib/main_development.dart`
- `lib/main_staging.dart`

**Run**:

```bash
flutter run -t lib/main_development.dart
flutter run -t lib/main_staging.dart
```

### App Icons Generation

```bash
melos run icons:gen              # All apps, all flavors
melos run icons:gen:cubit        # Cubit app only
melos run icons:gen:dev          # Development flavor only
melos run icons:gen:stg          # Staging flavor only
```

**Config**: `flutter_launcher_icons` в `pubspec.yaml`

### Build Commands

**Android**:

```bash
flutter build apk --release -t lib/main_production.dart
flutter build appbundle --release -t lib/main_production.dart
```

**iOS**:

```bash
flutter build ios --release -t lib/main_production.dart
flutter build ipa --release -t lib/main_production.dart
```

**Web**:

```bash
flutter build web --release -t lib/main_production.dart
```

---

## 📊 Dependencies

### Core Dependencies (shared across both apps)

**State Management**:

- `flutter_bloc: ^9.1.1` (BLoC app)
- `bloc_test: ^10.0.0` (testing)
- `flutter_riverpod: ^2.6.1` (Riverpod app)
- `riverpod_annotation: ^2.6.1` + `riverpod_generator: ^2.6.5` (codegen)

**State Persistence**:

- `hydrated_bloc: ^10.1.1` (BLoC app)
- `get_storage: ^2.1.1` (Riverpod app)

**Navigation**:

- `go_router: ^16.1.0` (both apps)

**Forms & Validation**:

- `formz: ^0.8.0` (form field states)
- `validators: ^3.0.0` (email, URL, etc.)

**Localization**:

- `easy_localization: ^3.0.8`
- `flutter_localizations` (SDK)

**Utilities**:

- `equatable: ^2.0.7` (value equality)
- `flutter_hooks: ^0.21.3` (hooks pattern)
- `cached_network_image: ^3.4.1` (image loading)

**Linting & Quality**:

- `very_good_analysis: ^9.0.0` (lint rules)
- `custom_lint: ^0.7.1` (custom rules)

**Testing**:

- `mocktail: ^1.0.4` (mocking)
- `flutter_test` (SDK)

**Tooling**:

- `melos: ^3.0.0` (monorepo management)
- `build_runner: ^2.5.4` (code generation)

---

### Version Constraints

**Strategy**: Caret ranges for stability

```yaml
# ✅ GOOD
equatable: ^2.0.7         # Allows 2.0.7 to <3.0.0
flutter_bloc: ^9.1.1      # Allows 9.1.1 to <10.0.0

# ❌ AVOID
equatable: any            # Too loose
equatable: 2.0.7          # Too strict (no updates)
```

**Update Process**:

1. Check outdated: `melos pub:outdated`
2. Review CHANGELOG for breaking changes
3. Update constraints in `pubspec.yaml`
4. Test: `melos run check`
5. Commit: `git commit -m "chore: update dependencies"`

---

## 🔒 Security Best Practices

### Secrets Management

**NEVER commit**:

- `.env` files with real secrets
- `google-services.json` / `GoogleService-Info.plist` (production)
- API keys in code

**Use**:

- `.env.dev` / `.env.staging` with dummy values (safe to commit)
- Environment variables in CI/CD
- Firebase Remote Config for runtime secrets

### Error Handling

**No leaked exceptions**:

```dart
// ❌ BAD: Exception propagates
Future<void> signUp() async {
  await firebaseAuth.createUserWithEmailAndPassword(...);  // May throw
}

// ✅ GOOD: Wrapped in Either
ResultFuture<void> signUp() async {
  return ResultHandler.handle(() async {
    await firebaseAuth.createUserWithEmailAndPassword(...);
  });
}
```

### Input Validation

**Always validate** user input before business logic:

```dart
// Form field validation
final emailField = EmailFormField.dirty(email);
if (!emailField.isValid) {
  return Left(ValidationFailure('Invalid email'));
}

// Repository level (secondary check)
ResultFuture<void> signUp({required String email}) async {
  if (!EmailValidator.isValid(email)) {
    return Left(ValidationFailure('Invalid email format'));
  }
  // ... continue
}
```

---

## 📝 Git Workflow

### Branch Strategy

**Main branches**:

- `main` - production-ready code
- `develop` - integration branch

**Feature branches**:

- `feature/description` (e.g., `feature/auth-flow`)
- `fix/description` (e.g., `fix/login-button`)
- `refactor/description` (e.g., `refactor/error-handling`)

### Commit Message Format

**Convention**: Conventional Commits

```
type: brief description

Longer description if needed (optional)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Types**:

- `feat:` - новий функціонал
- `fix:` - баг фікс
- `refactor:` - рефакторінг (без зміни поведінки)
- `test:` - додавання/оновлення тестів
- `docs:` - документація
- `chore:` - maintenance (dependencies, tooling)
- `style:` - форматування, linting
- `perf:` - оптимізація

**Examples**:

```
feat: add email verification flow
fix: resolve login button not responding
refactor: extract auth logic to use case
test: add unit tests for sign up repository
docs: update architecture diagram
chore: update dependencies to latest versions
```

### Pre-commit Hooks (recommended)

```bash
# Install husky or lefthook
npm install -g husky

# .husky/pre-commit
#!/bin/sh
melos run format:check
melos run analyze
```

---

## 🎓 Learning Resources

### Architecture Patterns

**Clean Architecture**:

- Robert C. Martin's "Clean Architecture" book
- Reso Coder's Flutter Clean Architecture tutorials

**BLoC Pattern**:

- Official docs: https://bloclibrary.dev
- Felix Angelov's courses

**Riverpod**:

- Official docs: https://riverpod.dev
- Remi Rousselet's videos

### Project-Specific Docs

**Internal documentation**:

- `packages/shared_core_modules/lib/src/errors_management/README__for_errors_management_module.md`
- `TODO.md` (project roadmap and tasks)

---

## 🚧 Known Issues & Limitations

### Current State

**✅ Working**:

- Dual state management (BLoC + Riverpod) через adapters
- 90%+ code reuse between apps
- Test coverage 70%+ для core packages
- CI/CD pipelines (GitHub Actions)
- Localization (3 languages: en, uk, pl)

**⚠️ In Progress**:

- Firebase Crashlytics integration
- Push notifications
- Offline-first architecture (local DB sync)

**❌ Known Issues**:

- iOS build sometimes fails with "concurrent builds" error
  - **Workaround**: `melos run fix:ios` (kills xcodebuild processes)
- Riverpod codegen може згенерувати застарілі файли
  - **Fix**: `melos run gen:clean` потім `melos run gen`

---

## 🔮 Future Improvements

### Planned Features

1. **Offline-first architecture**
   - Local database (Drift or Hive)
   - Sync strategy
   - Conflict resolution

2. **Advanced error tracking**
   - Firebase Crashlytics
   - Sentry integration
   - Custom error dashboard

3. **Performance monitoring**
   - Firebase Performance
   - Custom analytics
   - Build time optimization

4. **Code generation improvements**
   - Freezed for immutable models
   - Auto-routing generation
   - API client generation (Retrofit)

5. **CI/CD enhancements**
   - Automated releases
   - Staging deployments
   - A/B testing infrastructure

---

## 📞 Development Guidelines

### Before Starting Work

1. **Pull latest**: `git pull origin develop`
2. **Bootstrap**: `melos bootstrap`
3. **Check status**: `melos run check`
4. **Create branch**: `git checkout -b feature/your-feature`

### During Development

1. **Run tests frequently**: `melos run test`
2. **Check lints**: `melos run analyze`
3. **Format code**: `melos run format:write`
4. **Update tests** when changing logic

### Before Committing

1. **Full check**: `melos run check`
2. **Review changes**: `git diff`
3. **Commit with convention**: `git commit -m "feat: your change"`
4. **Push**: `git push origin feature/your-feature`

### Code Review Checklist

**Reviewer should verify**:

- [ ] Tests pass (`melos run test`)
- [ ] Lints pass (`melos run analyze`)
- [ ] Code formatted (`melos run format:check`)
- [ ] No hardcoded secrets
- [ ] Descriptive commit messages
- [ ] Documentation updated (if needed)
- [ ] No breaking changes (or documented)

---

## 🎯 Quick Reference

### Most Used Commands

```bash
# Daily workflow
melos bootstrap              # Setup workspace
melos run check              # Full quality check
melos run test               # Run all tests
melos run format:write       # Format code

# Development
flutter run -t lib/main_development.dart     # Run dev build
melos run gen:watch          # Live codegen
melos run localization:gen:all               # Update translations

# Debugging
melos run dcm:html           # Code metrics report
melos run coverage:cubit     # Coverage report
melos run fix:ios            # iOS build issues
```

### Project Structure at a Glance

```
монорепо
├── apps (2)          → state_symmetric_on_cubit, state_symmetric_on_riverpod
├── packages (9)      → adapters, shared modules, features
├── scripts           → bash automation
├── melos.yaml        → workspace config (65+ scripts)
├── analysis_options  → lint rules (very_good_analysis)
└── .vscode           → editor settings
```

### Architecture Layers

```
Presentation → adapters_for_[bloc|riverpod] → UI logic
     ↓
Domain → features_dd_layers → use cases + contracts
     ↓
Data → features_dd_layers → repositories + DTOs
     ↓
Infrastructure → adapters_for_firebase → Firebase calls
```

### Key Principles

1. **Technology-agnostic domain**: Domain layer не знає про BLoC/Riverpod
2. **Adapter pattern**: Adapters translate між shared models та state managers
3. **Either monad**: No thrown exceptions в domain/data
4. **Explicit types**: Public APIs завжди типізовані
5. **Const everything**: Performance через compile-time constants
6. **Test-first**: 80%+ coverage для business logic

---

**Last Updated**: 2026-01-12
**Maintained By**: Roman Godun (Senior Flutter Developer)
**Project Status**: Active Development
