## 📘 Flutter Logging Architecture Manual (EN)

This manual outlines three main architectural patterns for logging in Flutter applications. Each suits a different goal: debugging, testability, scalability, and centralized analytics.

---

### 1️⃣ **Sealed Events + AppLogger (Advanced Architecture)**

> **Best for:** large apps, centralized analytics/logging, type safety, testability

#### 📦 Structure:

- `ILogger` — base abstraction
- `AppLogger` — central logger, DI-registered with log type routing
- `OverlayLogger` — module-specific implementation
- `OverlayLogEvent` — sealed event class for structured logs
- `overlay_logging.dart` — extension-based syntactic sugar

#### 📊 Example Usage:

```dart
AppLogger.log(LogType.overlay, OverlayLogEventInserted(entry));
```

Or via extension:

```dart
AppLogger.inserted(entry);
```

#### ✅ Pros:

- Strong typing via sealed classes
- Clean DI-driven modular expansion
- Testable via mocks/spies
- Future-proof for analytics (e.g., Crashlytics, Sentry)

#### ⚠️ Cons:

- Requires 3–4 steps per new event
- Higher learning curve and verbosity

#### 🔹 Real Example:

##### `OverlayLogEvent` (sealed log events)

```dart
sealed class OverlayLogEvent {
  const OverlayLogEvent();
}

final class OverlayLogEventInserted extends OverlayLogEvent {
  final OverlayUIEntry entry;
  const OverlayLogEventInserted(this.entry);
}
```

##### `OverlayLogger` (event handling)

```dart
final class OverlayLogger implements ILogger {
  const OverlayLogger();

  @override
  void log(Object event, {StackTrace? stackTrace}) {
    if (event is! OverlayLogEvent) return;

    switch (event) {
      case OverlayLogEventInserted(:final entry):
        _log("Inserted", entry);
        break;
    }
  }

  void _log(String label, OverlayUIEntry entry) {
    debugPrint('[Overlay][${entry.runtimeType}] $label');
  }
}
```

##### `overlay_logging.dart` (extension)

```dart
extension OverlayLoggerX on AppLogger {
  static void inserted(OverlayUIEntry entry) =>
    AppLogger.log(LogType.overlay, OverlayLogEventInserted(entry));
}
```

##### `AppLogger`

```dart
final class AppLogger {
  static final _modules = <LogType, ILogger>{};

  static void register(LogType type, ILogger module) {
    _modules[type] = module;
  }

  static void log(LogType type, Object event, {StackTrace? stackTrace}) {
    _modules[type]?.log(event, stackTrace: stackTrace);
  }
}
```

---

### 2️⃣ **Lazy Singleton + DI (Central Injection)**

> **Best for:** mid-sized projects, flexible injection, minimal overhead

#### 📦 Structure:

- One `OverlayLogger` class with concrete methods
- Registered via GetIt: `di.registerLazySingleton(() => OverlayLogger())`

#### 📊 Example:

```dart
di<OverlayLogger>().inserted(entry);
```

#### ✅ Pros:

- Centralized and replaceable
- Testable via DI
- Easier to manage than sealed pattern

#### ⚠️ Cons:

- No strict type safety
- Less modular and reusable than sealed variant

---

### 3️⃣ **Static Utility Class (Simple Logger)**

> **Best for:** quick debug logs, throwaway logs, non-testable usage

#### 📦 Structure:

- Single file like `OverlayLogger` with static methods
- Private constructor to prevent instantiation

#### 📊 Example:

```dart
final class OverlayLogger {
  const OverlayLogger._();

  static void inserted(OverlayUIEntry entry) {
    debugPrint('[Overlay][${entry.runtimeType}] Inserted');
  }
}

// Usage:
OverlayLogger.inserted(entry);
```

#### ✅ Pros:

- Zero overhead
- Easiest to implement
- No dependencies

#### ⚠️ Cons:

- Not injectable or replaceable
- Not testable
- No event structure/type safety

---

## 🔍 Comparison Table

| Feature                | Sealed Events + AppLogger | Lazy Singleton + DI | Static Utility Class |
| ---------------------- | ------------------------- | ------------------- | -------------------- |
| 🧠 Type safety         | ✅ Yes                    | ❌ No               | ❌ No                |
| 🔄 Replaceable         | ✅ Via DI                 | ✅ Via DI           | ❌ No                |
| 🔮 Testable            | ✅ Yes                    | ✅ Yes              | ❌ No                |
| 🛋 Simplicity          | ❌ Complex                | ⚪ Medium           | ✅ Simple            |
| 📊 Performance         | ✅ Good (DI cache)        | ✅ Good (DI)        | ✅ Best              |
| 📂 Extensibility       | ✅ High                   | ⚪ Limited          | ❌ Minimal           |
| 📄 Centralized Logging | ✅ Full                   | ✅ Partial          | ❌ Manual only       |

---

## ✅ Recommended Usage

| Scenario                                | Recommendation               |
| --------------------------------------- | ---------------------------- |
| Using Crashlytics or Sentry             | Sealed Events + AppLogger ✅ |
| Need for mocking in tests               | Lazy Singleton + DI ✅       |
| Pure debugPrint only                    | Static Utility Class ✅      |
| High-performance, non-test environments | Static Utility Class ✅      |

---

## 📌 Final Summary

> If you just want quick console prints without testing/mocking: **use static utility classes**.
>
> If you need structure, reusability, or test coverage: **use DI with sealed events or simple injectable loggers.**
>
> This guide ensures you can **scale your logging pattern** later when needed without reworking the architecture.
