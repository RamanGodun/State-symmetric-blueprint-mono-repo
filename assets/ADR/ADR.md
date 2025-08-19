# 🧠 Architecture Decision Record (ADR)

## 📌 Title: Use of Clean Architecture + Riverpod for Firebase-Driven Flutter App

### 📅 Date: 2025-04-16

### 👥 Authors: Core Flutter Team

### 📈 Status: ✅ Accepted

---

## ❓ Context

The goal of this project (`firebase_with_riverpod`) is to provide a **scalable, and testable Flutter boilerplate** that integrates:

- 🔥 **Firebase** (Authentication, Firestore)
- 🧩 **Riverpod** (state management, DI, codegen)
- 🧱 **Clean Architecture** principles
- 🎯 Modern Flutter best practices (hooks, extensions, sealed types)
- 🍏 **iOS/macOS-style UX and theming**

The blueprint is optimized for cross-platform development:

- ✅ Android
- ✅ iOS
- ✅ Web (Firebase config support)

It includes full support for:

- 🆕 Sign Up
- 🔐 Sign In
- 🔁 Password Reset / Change
- ✅ Email Verification
- 🔑 Re-authentication Flow

All features are modularized and designed with **separation of concerns** and **testability** in mind.

---

## ✅ Decision

### 🧱 Architecture

- Clean Architecture with 3 main conceptual layers:
  - `data/`: Firebase repositories, serialization, sources
  - `domain/`: [Planned] Use Cases, Interfaces, Value Objects (future)
  - `presentation/`: Stateless UI with `ConsumerWidget`, feature folders

- `features/`: Modular folders (`sign_in`, `sign_up`, etc.) contain UI, providers, and states
- `core/`: Global routing, constants, theming, extensions, and reusable widgets

### ⚙️ State Management & DI

- ✅ Riverpod 2.0 with `@riverpod` codegen
- ✅ Async Notifiers (`AsyncNotifier`, `Notifier`, `FutureProvider`, etc.)
- ✅ Feature-colocated providers for modularity and scalability
- ✅ Declarative + reactive form validation via `FormStateNotifier`

### 🔐 Firebase Integration

- 🔧 Uses `firebase_auth` and `cloud_firestore`
- 🔁 Async logic wrapped in `AuthRepository` and `ProfileRepository`
- 🔐 `.env`-based config via `flutter_dotenv` for cross-platform setup
- 🔩 FirebaseOptions generated via `EnvFirebaseOptions`

### 🧪 Testing Strategy

- Unit tests (~80%) for all pure logic and providers
- Widget tests (~15%) with mocked state
- Integration tests (~5%) for flows and navigation

Tools: `mockito`, `very_good_analysis`, `build_runner`

---

## 🔍 Alternatives Considered

| Option                | ✅ Pros                                  | ❌ Cons                           |
| --------------------- | ---------------------------------------- | --------------------------------- |
| Bloc                  | Structured, event-based, well-documented | Boilerplate-heavy, verbose        |
| Provider              | Lightweight, built-in                    | Poor scalability, no async guards |
| Riverpod (no codegen) | Simpler to debug                         | More boilerplate                  |
| MVVM / MVC            | Familiar to native developers            | Less idiomatic for Flutter        |

✅ **Chosen:** Riverpod 2.0 with codegen + Clean Architecture → provides the best blend of:

- 🚀 Simplicity and power
- 🧼 Clean layering
- 🔄 Automatic DI
- 💪 Testability

---

## 💡 Consequences

- ✅ Clear separation between Firebase logic and UI
- ✅ Highly testable providers and stateless presentation
- ✅ DI and state logic colocated with features
- ⚠️ Requires onboarding for developers unfamiliar with Riverpod/codegen
- ⚠️ Riverpod codegen requires `build_runner`

---

## 🔮 Future Enhancements

1. 🧠 Introduce full `domain/` layer with `UseCases`
2. 📦 Modularize features as Dart packages
3. 🧪 Expand golden + integration test coverage
4. 🔐 Add federated login: Google, Apple, phone
5. 🔁 Add CI/CD with GitHub Actions (tests + analysis)
6. 🧭 Dynamic routing guards based on auth state
7. 📊 Include analytics and crash reporting

---

## 🏷️ Tags

`#CleanArchitecture` `#Riverpod` `#Firebase` `#Flutter` `#ModularDesign` `#StateManagement` `#ArchitectureDecisionRecord`

Все зафіксував — твій шаблон і стандарти для написання ADR для Flutter-проєкту структуровано, нічого не загубиться. Ось короткий конспект-фреймворк, який тепер буду тримати як базу для шаблонізації і перевірки майбутніх ADR (все можна доповнити під потребу):

⸻

🗂️ Структура ADR для Flutter проєкту

1. Нумерація і файлова структура
   • ADR-001, ADR-002, … (ніколи не перевикористовувати номера)
   • docs/adr/001-state-management-choice.md
   docs/adr/002-navigation-architecture.md
   docs/adr/003-offline-sync-strategy.md

2. Коли обов’язково писати ADR?
   • State management
   • Вибір архітектурного патерну
   • Навігація
   • Локалізація
   • Тестування
   • БД/Storage
   • API архітектура
   • CI/CD pipeline

3. Контент і якість
   • Конкретна проблема
   • Мінімум 2 альтернативи
   • Чіткі критерії вибору
   • Вимірювані наслідки
   • Дата перегляду/ревізії
   • Заборонено: “бо так краще”, без обґрунтування

4. Flutter-специфіка (Додавати завжди)
   • Flutter Version (Current, Minimum Supported)
   • Dependency Impact (список впроваджених пакетів)
   • Performance Considerations (build time, app size, runtime)

5. Типові помилки
   • Правильна аргументація у секції “Рішення” (WHY, не просто WHAT)

6. Процес review
   • Technical review
   • Team review
   • Stakeholder review (якщо треба)
   • Чекліст: зрозумілість, відтворюваність рішень, Flutter специфіка, план дій

7. Lifecycle/status
   • Proposed | Accepted | Deprecated | Superseded
   • Оновлення раз на 6 міс. або при major змінах

8. Інтеграція з проєктом
   • README з секцією про ADR
   • CI ADR-checker (наприклад, Github workflow на pull_request в docs/adr/\*\*)

9. Шаблони для ключових рішень
   • Testing strategy, code example, migration path
   • Mermaid/PlantUML для діаграм

10. Інструменти
    • Mermaid/PlantUML, markdown lint, template validation

⸻

📄 Короткий шаблон ADR (markdown)

# ADR-XXX: [Тема рішення]

## Статус

**Proposed** | Accepted | Deprecated | Superseded
**Дата:** YYYY-MM-DD  
**Автор:**  
**Рецензенти:**

---

## Контекст і проблема

[Описати ситуацію, чому виникла проблема, функціональні/нефункціональні вимоги, обмеження]

---

## Варіанти рішень

### 1. [Опція 1]

- Плюси:
- Мінуси:

### 2. [Опція 2]

- Плюси:
- Мінуси:

[Додати інші опції за потреби]

---

## Рішення

[Обране рішення і обґрунтування (чому це краще для проєкту)]

### Імплементація / Архітектура

- [Короткий план, структура, code sample, діаграма, міграційний шлях]

---

## Наслідки

### Позитивні

-

### Негативні

-

### Ризики і мітигація

- ***

## Відстеження

### Критерії успіху

- [ ] (чекліст)

### Дата перегляду

**YYYY-MM-DD**

---

## Flutter Version

**Current:**  
**Minimum Supported:**

## Dependency Impact

- [package1]: ^x.x.x
- [package2]: ^x.x.x

## Performance Considerations

- Build time impact:
- App size impact:
- Runtime performance:

---

## Додаткова інформація

### Посилання

- [link1](url)
- [link2](url)

### Попередні ADR

- ADR-xxx

### Пов’язані ADR

- ADR-xxx

⸻

Цей шаблон і підхід буду використовувати при будь-якому запиті на створення ADR для цього проєкту.
Ти завжди можеш кинути новий контент, і я вмонтують його у цю структуру.

Ready for next steps!
Якщо потрібно — згенерую окремий шаблон-файл (template.md) для ADR у docs/adr/ — просто скажи.
