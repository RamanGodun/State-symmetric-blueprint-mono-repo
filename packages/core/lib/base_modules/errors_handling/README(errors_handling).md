# Errors Handling Module Guide

_Last updated: 2025-08-05_

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)

## 🎯 Goal

> Module was designed as a **enterprise-grade, platform-agnostic, modular, type-safe error handling system**
> for Flutter apps with clean architecture codebase, declarative error flows and easy integration of overlays, localization, logging, additional chainable logic.
> Currently it consist only a few FailureType errors (shown as an example), that easily can be extended by any specific FailureType

---

## 🚀 Quick Start

---

### Integrate Error Handling Core

- Add `core_of_module/` and `extensible_part/` to your project.\*
- No external dependencies on any state management package.

---

### Handle errors in a few steps (on profile feature example)

#### In repository Layer use `.runWithErrorHandling()`

```dart
final class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<Failure, User>> getProfile(String uid) =>
    (() async => await _api.fetchUser(uid)).runWithErrorHandling();
    // 👆 Automatically maps any exception to Failure
}
```

### In UseCase return Either

```dart
class GetUserUseCase {
  Future<Either<Failure, User>> call(String uid) =>
    _repository.getProfile(uid);
}
```

### In Presentation layer manage failures via chosen state manager and emit errors state in UI

- Riverpod as State Management

```dart
@riverpod
Future<User> user(UserRef ref, String uid) async {
  final result = await getUserUseCase(uid);
  return result.fold(
    (failure) => throw failure, // Will be caught by AsyncValue as an error
    (user) => user,
  );
}

// In UI widget
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(uid));

    // ❗️ Listen and display all async errors as overlays (single point of error feedback)
    ref.listenFailure(userProvider(uid), context);

    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      data: (user) => UserProfile(user: user),
      error: (_, __) => const SizedBox.shrink(), // Error feedback handled by overlay
    );
  }


// where:
extension FailureListenerRefX on WidgetRef {
  void listenFailure<T>(
    ProviderListenable<AsyncValue<T>> provider,
    BuildContext context, {
    ListenFailureCallback? onFailure,
  }) {
    listen<AsyncValue<T>>(provider, (prev, next) {
      final failure = next.asFailure;
      if (failure != null) {
        final failureUIEntity = failure.toUIEntity();
        context.showError(failureUIEntity);
      }
    });
  }
}
```

- BLoC/cubit as State Management

```dart
  Future<void> loadUser(String uid) async {
    emit(UserLoading());
    final result = await getUserUseCase(uid);
    result.fold(
      (failure) => emit(UserError(failure.asConsumable())),
      (user) => emit(UserLoaded(user)),
    );
  }

// In UI Widget
   BlocListener<Cubit, State>(
      listenWhen: ...,
      listener: (context, state) {
      final failure = state.failure?.consume(); // for guaranteeing one-shot feedback.
      if (failure != null) {
          final failureUIEntity = failure.toUIEntity();
          context.showError(failureUIEntity);
          ...
          context.read<Cubit>().clearFailure();
         ...
          }})

    child: BlocBuilder<UserCubit, UserState>(
    builder: (context, state) => switch (state) {
      UserLoading() => CircularProgressIndicator(),
      UserLoaded(:final user) => UserProfile(user),
      UserError() => SizedBox(), // Error handled by listener
    },
  ),
)
```

**Also notice, that:**:

- ✅ Exceptions or Failures originate strictly in the data layer. All unexpected errors are thrown only in Data layer.
- ✅ Errors in repo are automatically mapped from exceptions to to domain-level `Failure` via `.mapToFailure()` (see `_exceptions_to_failures_mapper_x`).
- ✅ Every public method returns `ResultFuture<T> = Future<Either<Failure, T>>`, no exceptions are leaked.
- ✅ Available chainable error handling (e.g. `.log()`, analytics, diagnostics, custom hooks, additional logic)
- ✅ Failure mapped to FailureUIEntity via `.toUIEntity()` for all overlays, dialogs, and user feedback.
- ✅ Automatic localization via `translationKey` in `FailureType` (see `failure_type.dart`)

---

## 🧩 Easy new Failures adding

---

### 1. Add code in `FailureCodes` and Custom Failure Types to `extensible_part/failure_types/`

```dart
// Define failure type
final class CustomApiFailureType extends FailureType {
  const CustomApiFailureType() : super(
    code: FailureCodes.customFailure,
    translationKey: 'failures.custom_api',
  );
}
```

### 2. Accordingly extend exception mapping in `extensible_part/exceptions_mapping/`

```dart
extension CustomExceptionMapper on Object {
  Failure mapToFailure([StackTrace? stackTrace]) => switch (this) {
    ...
    // Add to exception mapper
    CustomApiException e => Failure(
      type: const CustomApiFailureType(),
      message: e.message,
    ),
    _ => // ... other mappings
  };
}
```

### 3. Update (optionally) icons in `extensible_part/failure_extensions/`

```dart
IconData get icon {
  if (this is PaymentFailureType) return Icons.payment;
  // ... existing mappings
}
```

### 4. Add (optionally) logs, tests for new functionality

---

## **Explicit (classic) Either Style** VS **DSL-like Style** in STATE manager

---

This errors handling module supports two alternative paradigms:

### 🧨 **Either** — Classic, explicit and readable error flow using `Either<Failure, T>` and `.fold(...)`

✅ When to Use:

- Common simle cases in Cubit/BLoC/Riverpod state management

  🤩 Code Example:

```dart
final result = await someUseCase();
// Classic, explicit and readable error flow
result.fold(
  (failure) => emit(ErrorState(failure)),
  (data) => emit(SuccessState(data)),
);
```

### 🔗 **DSL-like style** — Declarative, chainable alternative inspired by functional programming

✅ When to Use:

- Complex cases with additional logic (including logs, side effects) with DSL-style handler (`ResultHandler`) for chaining.
- You prefer a **chainable API** with fluent handlers
- You want to reduce boilerplate (fold logic repeated often)

#### ✳️ A few variants of usage (using `ResultHandler`, `.match()` and `.matchAsync()` extensions):

- 1. `matchAsync()` Extension:

```dart
await getUserUseCase().matchAsync(
  onFailure: (f) => emit(Failed(f)),
  onSuccess: (u) => emit(Loaded(u)),
);
```

- 2. DSLLike `ResultHandler`:

```dart
await getUserUseCase().then((r) => ResultHandler(r)
  .onFailure((f) => emit(Failed(f)))
  .onSuccess((u) => emit(Loaded(u))));
```

- 3. `match()` (sync style for `Either<Failure, T>`):

```dart
final result = await getUserUseCase();
result.match(
  onFailure: (f) => emit(Failed(f)),
  onSuccess: (u) => emit(Loaded(u)),
);
```

- 4. ✨ Available Advanced Chaining:

```dart
// **DSL-like** — Declarative, chainable alternative inspired by functional programming
await getUserUseCase()
  .flatMapAsync((u) => checkAccess(u))
  .recover((f) => getGuestUser())
  .mapRightAsync((u) => saveLocally(u))
  .then((r) => ResultHandler(r).log());

await getUserUseCase()
  .flatMapAsync((user) => updateProfile(user))
  .recover((failure) => getDefaultUser())
  .then((result) => ResultHandler(result)
    .onFailure((f) => emit(ErrorState(f)))
    .onSuccess((u) => emit(SuccessState(u)))
    .log()
  );
```

---

## 🧩 Errors Handling Flow

---

### 🧩 Core Error Handling Concepts

| Concept                | Purpose                                                                                              |
| ---------------------- | ---------------------------------------------------------------------------------------------------- | ---------------------------- |
| `Failure`              | Domain-level error, type-safe, includes code, fallback message, and `translationKey` for i18n        |
| `FailureType`          | Centralized descriptor for errors: unique code + translation key for localization                    |
| `FailureUIEntity`      | UI-ready error: localized text, icon, formatted code (presentation model for overlays/dialogs)       |
| `Consumable<T>`        | Guarantees one-shot feedback trigger (overlays/dialogs), prevents duplicate side-effects             |
| `.mapToFailure()`      | Extension: maps Exception (SDK/platform) to a structured Failure (domain error)                      |
| `Failure.toUIEntity()` | Extension: maps Failure to FailureUIEntity with i18n, icon, and code for UI rendering                |
| `Either<L, R>`         | Functional result wrapper: `Left` = Failure, `Right` = Success; immutable, enables pattern matching, | chaining, and testable flows |

## 🏗️ Architecture Overview

```mermaid
graph TD
    A[Exception/Error] -->|mapToFailure()| B[Failure]
    B -->|toUIEntity()| C[FailureUIEntity]
    C -->|context.showError()| D[User Sees Dialog]

    E[DataSource] -->|throws| F[Repository]
    F -->|Either<Failure,T>| G[UseCase]
    G -->|Either<Failure,T>| H[StateManager]
    H -->|Consumable<Failure>| I[UI]
```

### Example: Error-Driven Flow (Profile Feature)

```
DataSourceImpFile:   Throws exception for unknown flow or Failures for handled cases
  ↓
RepoImpFile:         Exceptions catches and maps to Failure via `.mapToFailure()`,
  ↓                  Failures pass through, so RepoImpFile returns Either<Failure, T> to UseCase
  ↓
UseCaseFile:         Propagates Either<Failure, T>  to State manager
  ↓
State manager:       Emits error state with Failure
  ↓
UI (error listener)  Failure maps to FailureUIEntity `failure.toUIEntity()`
  ↓
                     UI observes and displays overlay/dialog via one-shot (consumable) pattern
```

### Example: UI-Driven Flow

```
User triggers action
  ↓
State manager (Cubit/Notifier) calls UseCase
  ↓
UseCase delegates to Repository
  ↓
Repository calls DataSource, get result (Either or throws)
  ↓
THEN
     the same flow as in case of "error-driven case"
```

### 🧱 Layered Responsibilities Table

| Layer                                                                                       | Responsibilities                                                      |
| ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| DataSource                                                                                  | Throws raw Exceptions or Either for handled flows                     |
| Repository                                                                                  | Converts to Either, maps Exception → Failure                          |
| UseCase                                                                                     | Delegates business logic, returns Either                              |
| StateManager                                                                                | Emits state, handles results (.fold or DSL for composite flows)       |
| UI Layer                                                                                    | Shows overlay/feedback, listens to consumable                         |
| OverlayManager                                                                              | Renders feedback centralized (via context.showError(FailureUIEntity)) |
| ------------------------------------------------------------------------------------------- |

---

## 🧩 Files structure of module

---

errors_handling/
.
├── core_of_module
| |
│ ├── \_errors_handling_entry_point.dart # Entrypoint: run error handling pipeline
| |
│ ├── core_utils
│ │ ├── errors_observing
│ │ │ ├── loggers/ # Crash analytics & error logging tools
│ │ │ └── result_loggers/ # Loggers for functional results
│ │ │ ├── async_result_logger.dart # Async result logger (for Futures)
│ │ │ └── result_logger_x.dart # Extension: result logging (sync)
│ │ ├── extensions_on_either
│ │ │ ├── either**facade.dart # Public API/facade for Either extensions
│ │ │ ├── either**x.dart # Main Either extensions (sync/async)
│ │ │ ├── either_async_x.dart # Async-specific Either extensions
│ │ │ ├── either_getters_x.dart # Helpers/getters for Either
│ │ │ └── for_tests_either_x.dart # Either utilities for tests/mocks
│ │ ├── extensions_on_failure
│ │ │ └── failure_to_either_x.dart # Failure → Either converter
│ │ ├── result_handler_async.dart # Async result handler (chainable API)
│ │ ├── result_handler.dart # Sync result handler (chainable API)
│ │ ├── specific_for_bloc
│ │ │ ├── consumable_extensions.dart # Bloc-specific: Consumable extensions
│ │ │ ├── consumable.dart # One-shot wrapper for UI feedback
│ │ │ └──One_time_error_displaying.md # Guide: one-time UI feedback (Consumable)
│ │ └── specific_for_riverpod
│ │ ├── async_value_fold_x.dart # Riverpod: AsyncValue.fold extension
│ │ └── show_dialog_when_error_x.dart # Riverpod: Overlay/dialog error ext
| |
│ ├── either.dart # Core: Either<L, R> functional type
│ ├── failure_entity.dart # Domain model for Failure
│ ├── failure_type.dart # FailureType: error code + i18n key
│ ├── failure_ui_entity.dart # UI-layer model for error feedback
│ └── failure_ui_mapper.dart # Maps Failure → FailureUIEntity
│
|
├── extensible_part
| |
│ ├── exceptions_to_failure_mapping
│ │ ├── \_exceptions_to_failures_mapper_x.dart # Central exception→failure mapping
│ │ ├── dio_exceptions_mapper.dart # Dio-specific mapping
│ │ └── firebase_exceptions_mapper.dart # Firebase-specific mapping
| |
│ ├── failure_extensions
│ │ ├── failure_diagnostics_x.dart # Diagnostics & meta for failures
│ │ ├── failure_icons_x.dart # Declarative icons for failures
│ │ └── failure_led_retry_x.dart # Retryability logic for failures
| |
│ └── failure_types
│ ├── \_failure_codes.dart # Central registry of all error codes
│ ├── firebase.dart # Firebase FailureTypes
│ ├── misc.dart # Miscellaneous FailureTypes
│ └── network.dart # Network FailureTypes
│
├── README(errors_handling).md # Main documentation for the module
└──

---

## ❓ FAQ

---

- **How do I display overlays/dialogs in Riverpod?**
  - Use `ref.listenFailure(yourProvider, context)`.

- **How do I display overlays in Cubit/BLoC?**
  - Emit `Consumable<FailureUIEntity>`, BlocListener, `context.showError(error)`.

- **How do I log or report errors?**
  - Use `failure.log()`, `failure.logCrashAnalytics()`, or a custom logger.

- **How do I test error flows and overlays?**
  - Use Either or the `.forTests` extension for test flows.

- **How do I add Retry logic?**
  - Expose `canRetry` and a retry handler in Failure or FailureUIEntity.

- **Can I use the pipeline in pure Dart/tests/CLI?**
  - Yes, everything except overlay/UI integrations.

- **What is `Consumable<T>`?**
  A one-time value wrapper for UI side effects, that: - Guarantees one-shot overlays/dialogs - Prevents duplicate feedback on rebuilds - Declarative and easily testable

- When/Which to choose between **Either (classic)** and **DSL-like** code styles
  | ✅ Criteria | Either (Classic)| DSL-like Handler |
  | ---------------------------------|----------------|-----------------------|
  | ✅ Predictable and explicit | ✔️ Yes | ❌ Less explicit |
  | ✅ Declarative & chainable | ❌ No | ✔️ Yes |
  | ✅ Requires no extra wrappers | ✔️ Yes | ❌ Needs `.then(...)` |
  | ✅ Team prefers functional style | ❌ Maybe | ✔️ Perfect fit |

> 🧠 **Recommendation:** Use Either by default for UI state management. DSL-style is best for expressive chains and functional flows.

---

## 🛠 Troubleshooting

---

- **Overlay/dialog not shown in Riverpod:**
  - Use `ref.listenFailure(yourProvider, context)`.

- **Overlay/dialog not shown in Cubit/BLoC:**
  - Use BlocListener, emit `Consumable<FailureUIEntity>`, call `context.showError(...)`.

- **Overlay/dialog duplication in Cubit/BLoC:**
  - Use `Consumable<FailureUIEntity>`

- **Failure is always generic:**
  - Check your mappers in `exceptions_to_failure_mapping/`.

- **Retry button does not appear:**
  - Ensure `canRetry = true` and provide a retry handler.

- **No logging:**
  - Use `failure.log()` or loggers from `errors_observing/loggers/`.

- **UI shows raw error or stacktrace:**
  - Always map with `toUIEntity()` and display via overlay/dialog.

  ## 🧭 Decision Matrix

| Context                 | Strategy                    | Rationale                               |
| ----------------------- | --------------------------- | --------------------------------------- |
| Complex UX flows        | ResultHandler               | Fluent, side effects, fallback, retry   |
| Simple flows            | .fold() / .match()          | Readable, concise                       |
| SDK/API errors          | ASTRODES throw              | Thrown, mapped to Failure in repo       |
| Domain failures         | Either                      | As-is, no throwing                      |
| Consistent result shape | ResultFuture<T>             | Standardized async everywhere           |
| Exception handling      | safeCall() extension        | Centralizes all error mapping           |
| Failure-to-UI           | .toUIEntity()               | UI-ready error with icons, i18n         |
| UI trigger              | context.showError()         | Declarative, one point for all overlays |
| One-time feedback       | Consumable<FailureUIEntity> | Prevents duplicate overlays             |

---

## 🏆 Best Practices

---

- **Use only Failure as the error source** — never expose raw Exception or strings in public APIs.
- **Map all exceptions to Failure ASAP** via `.mapToFailure()`.
- **Isolate mapping logic** for 3rd-party exceptions (dio, firebase, etc.) in dedicated files.
- **Never display raw errors inline in widgets** — always use overlays/dialogs via provided extensions.
- **For Cubit/BLoC:** Always use `Consumable<FailureUIEntity>` for one-shot overlays.
- **For Riverpod:** Always attach `ref.listenFailure` in your widgets.
- **Log all errors via provided extensions** (`failure.log()`) before reporting or displaying.
- **Test all error flows using functional result types (Either) or pure Dart logic.**
- **Avoid coupling error handling with business/state/UI logic:** keep overlays, mapping, and logging separate.
- **Add new failure types/extensions in `extensible_part/`.**
- **Document custom mappings or overlays for your team.**

  ### ✅ Do

* Always use `.runWithErrorHandling()` in repositories
* Return `Either<Failure, T>` from all data operations
* Use `Consumable<FailureUIEntity>` for one-shot UI feedback
* Add specific failure types for different error scenarios
* Test both success and failure paths

  ### ❌ Don't

* Let raw exceptions escape repositories
* Show error messages directly in widgets
* Ignore the `consume()` pattern for UI feedback
* Use generic error messages without context
* Skip logging errors

---

## ✅ Final Notes

---

### 🏆 **Key Principles**

- 🦾 **Universal & State-Agnostic**
  Seamlessly works with Riverpod, Cubit/BLoC, or pure Dart — zero vendor lock-in.

- 💪 **Optimized for real-world teams & codebases**
  Suitable for projects of any size or complexity.

- ⚡️ **Decoupled Error Flow**
  Mapping, logging, UI overlays, and retry logic are modular and isolated.

- 🔒 **Strictly type-safe & future-proof**
  No raw exceptions or magic strings leak outside the data layer.

- 🧩 **Single Source of Truth**
  All domain-errors are modeled as `Failure`, UI errors - as `FailureUIEntity`, enforcing clean boundaries.

- 📐 **Clean Architecture by Design**
  Each layer (DataSource, Repository, UseCase, StateManager, UI) has a clear, decoupled responsibility.

---

### 💡 **Benefits**

- 🧑‍💻 **Collaboration-Ready**
  Explicit contracts and clear boundaries make onboarding and teamwork effortless.
- 📚 **Self-Documenting & Discoverable**
  Flows, extensions, and usage are easily found and understood via intuitive docs and naming.
- 🔄 **Easy Refactoring & Maintenance**
  Change or extend any layer with confidence; no hidden coupling or side effects.
- 🚦 **Safe by Default**
  Every error is either surfaced to the user or logged/tracked — never lost.
- ⏳ **Minimal Boilerplate**
  Declarative patterns let teams focus on features, not glue spaghetti code.

> **Build robust, scalable Flutter apps with declarative error handling and architecture-first philosophy.**
> Your error handling will remain robust and maintainable — no matter how fast your product or team grows.

🧪 Happy error handling & bulletproof code! ☕️

---
