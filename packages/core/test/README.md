# Core Package Tests

Тести для пакету `core` написані у стилі **Very Good Ventures**.

## 📊 Поточний прогрес

### Створені тести

✅ **Either<L,R>** (52 тести)

- Construction (Left/Right)
- Type checking (isLeft, isRight)
- Pattern matching (fold)
- Mapping operations (map, mapBoth, mapLeft, mapRight)
- FlatMap (thenMap)
- Immutability
- Edge cases

✅ **Consumable<T>** (45+ тестів)

- One-time consumption
- Peek without consumption
- Reset functionality
- State tracking (isConsumed)
- ConsumableX extension
- Edge cases

### В розробці

⏳ **Form Validators** (наступний пріоритет)

- EmailInputValidation
- PasswordInputValidation
- NameInputValidation
- PasswordConfirmValidation

⏳ **Debouncer/Throttler**

⏳ **Form States**

## 🚀 Запуск тестів

### Всі тести пакету core

```bash
# З кореня монорепо
melos run test --scope="core"

# Або з директорії пакету
cd packages/core
flutter test

# З very good test runner
very_good test --coverage
```

### Окремі тестові файли

```bash
cd packages/core

# Either тести
flutter test test/base_modules/errors_management/either_test.dart

# Consumable тести
flutter test test/base_modules/errors_management/consumable_test.dart
```

### Генерація coverage

```bash
cd packages/core

# Згенерувати coverage
flutter test --coverage

# Відкрити HTML звіт (потребує lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

## 📁 Структура тестів

```
test/
├── helpers/
│   └── test_helpers.dart          # Загальні утиліти для тестів
├── fixtures/
│   └── test_constants.dart        # Тестові константи
├── base_modules/
│   ├── errors_management/
│   │   ├── either_test.dart       # ✅ 52 тести
│   │   └── consumable_test.dart   # ✅ 45+ тестів
│   └── form_fields/               # ⏳ В розробці
└── README.md                      # Цей файл
```

## 🎯 Стандарти тестування VGV

### Структура тесту

```dart
void main() {
  group('ClassName', () {
    group('methodName', () {
      test('should do X when Y', () {
        // Arrange

        // Act

        // Assert
      });
    });
  });
}
```

### Naming conventions

- ✅ **GOOD**: `test('returns Right when credentials are valid')`
- ❌ **BAD**: `test('test1')`

### AAA Pattern

Всі тести слідують **Arrange-Act-Assert** pattern:

```dart
test('description', () {
  // Arrange - підготовка даних
  const input = 'test';

  // Act - виконання дії
  final result = sut.method(input);

  // Assert - перевірка результату
  expect(result, equals('expected'));
});
```

### Групування тестів

```dart
group('ClassName', () {
  group('construction', () {
    test('creates instance with valid params', () {});
  });

  group('methodName', () {
    test('does X when Y', () {});
    test('does Z when W', () {});
  });

  group('edge cases', () {
    test('handles null values', () {});
  });
});
```

## 📝 Helpers

### WidgetTesterX

```dart
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

testWidgets('test', (tester) async {
  // Pump app with MaterialApp wrapper
  await tester.pumpApp(MyWidget());

  // Find by key
  final widget = tester.findByKey('myKey');

  // Enter text
  await tester.enterTextByKey('inputKey', 'text');

  // Tap
  await tester.tapByKey('buttonKey');
});
```

### TestConstants

```dart
import '../fixtures/test_constants.dart';

test('example', () {
  expect(email, TestConstants.validEmail);
  expect(password, TestConstants.validPassword);
});
```

## 🎨 Coverage Goals

| Модуль            | Цільовий % | Поточний % |
| ----------------- | ---------- | ---------- |
| errors_management | 90%+       | ~85%       |
| form_fields       | 90%+       | 0%         |
| overlays          | 75%+       | 0%         |
| navigation        | 75%+       | 0%         |
| ui_design         | 70%+       | 0%         |
| **ЗАГАЛЬНИЙ**     | **80%+**   | **~15%**   |

## 📚 Додаткові ресурси

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Very Good Ventures Testing](https://verygood.ventures/blog/flutter-test-best-practices)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)

## 🔄 Наступні кроки

1. ✅ Either tests - DONE
2. ✅ Consumable tests - DONE
3. ⏳ Form Validators tests - IN PROGRESS
4. ⏳ Form States tests
5. ⏳ Debouncer/Throttler tests
6. ⏳ Extensions tests

---

**Last updated:** 2025-12-15
**Test count:** 97+ тестів
**Coverage:** ~15%
