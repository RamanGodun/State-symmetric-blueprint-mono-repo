# Quick Reference - Features DD Layers Testing

Quick commands, patterns, and solutions for testing the `features_dd_layers` package.

## 🚀 Quick Commands

### Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific file
flutter test test/src/auth/domain/use_cases/sign_in_test.dart

# Run by pattern
flutter test --plain-name "SignInUseCase"

# Verbose output
flutter test --reporter expanded
```

### Coverage

```bash
# Generate coverage
flutter test --coverage

# View HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🧪 Common Test Patterns

### Basic Use Case Test

```dart
test('returns Right on successful operation', () async {
  // Arrange
  when(() => mockRepo.operation()).thenAnswer((_) async => const Right(null));

  // Act
  final result = await useCase();

  // Assert
  expect(result.isRight, isTrue);
  verify(() => mockRepo.operation()).called(1);
});
```

### Error Handling Test

```dart
test('returns Left when repository fails', () async {
  // Arrange
  final failure = 'Operation failed'.toFailure();
  when(() => mockRepo.operation()).thenAnswer((_) async => Left(failure));

  // Act
  final result = await useCase();

  // Assert
  expect(result.isLeft, isTrue);
  expect(result.leftOrNull, equals(failure));
});
```

### Multiple Sequential Calls

```dart
test('handles multiple sequential calls', () async {
  // Arrange
  var callCount = 0;
  when(() => mockRepo.operation()).thenAnswer((_) async {
    callCount++;
    return callCount == 1
      ? Left(failure)
      : const Right(data);
  });

  // Act
  final result1 = await useCase();
  final result2 = await useCase();

  // Assert
  expect(result1.isLeft, isTrue);
  expect(result2.isRight, isTrue);
  verify(() => mockRepo.operation()).called(2);
});
```

### Concurrent Calls

```dart
test('handles concurrent calls', () async {
  // Arrange
  when(() => mockRepo.operation()).thenAnswer((_) async {
    await wait(100);
    return const Right(data);
  });

  // Act
  final futures = [
    useCase(),
    useCase(),
    useCase(),
  ];
  final results = await futures.awaitAll();

  // Assert
  expect(results.length, equals(3));
  for (final result in results) {
    expect(result.isRight, isTrue);
  }
});
```

### Parameter Verification

```dart
test('calls repository with correct parameters', () async {
  // Arrange
  when(() => mockRepo.operation(
    param1: any(named: 'param1'),
    param2: any(named: 'param2'),
  )).thenAnswer((_) async => const Right(null));

  // Act
  await useCase(param1: value1, param2: value2);

  // Assert
  verify(() => mockRepo.operation(
    param1: value1,
    param2: value2,
  )).called(1);
});
```

## 🎯 Test Helpers

### Creating Test Failures

```dart
final failure = 'Error message'.toFailure();
```

### Waiting for Async Operations

```dart
await wait(100); // Wait 100ms
```

### Awaiting Multiple Futures

```dart
final results = await [future1, future2, future3].awaitAll();
```

### Using Test Constants

```dart
TestConstants.validEmail        // 'test@example.com'
TestConstants.validPassword     // 'Password123!'
TestConstants.testUserId        // 'test-user-id-123'
TestConstants.testUserEntity    // Full user entity
```

## 🏗️ Test Structure Template

```dart
/// Tests for [ComponentName]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Core functionality
/// - Error handling
/// - Edge cases
/// - Real-world scenarios
library;

import 'package:features_dd_layers/src/module/component.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../fixtures/test_constants.dart';
import '../../../helpers/test_helpers.dart';

class MockRepository extends Mock implements IRepository {}

void main() {
  group('ComponentName', () {
    late IRepository mockRepo;
    late ComponentName component;

    setUp(() {
      mockRepo = MockRepository();
      component = ComponentName(mockRepo);
    });

    group('constructor', () {
      test('creates instance with provided dependencies', () {
        // Arrange & Act
        final instance = ComponentName(mockRepo);

        // Assert
        expect(instance, isA<ComponentName>());
      });
    });

    group('core functionality', () {
      // Main feature tests
    });

    group('error handling', () {
      // Error scenario tests
    });

    group('edge cases', () {
      // Boundary and edge case tests
    });

    group('real-world scenarios', () {
      // Practical usage tests
    });
  });
}
```

## 🔧 Common Mock Setups

### Mock Repository Method

```dart
when(() => mockRepo.method())
  .thenAnswer((_) async => const Right(data));
```

### Mock with Parameters

```dart
when(() => mockRepo.method(
  param: any(named: 'param'),
)).thenAnswer((_) async => const Right(data));
```

### Mock Multiple Return Values

```dart
var callCount = 0;
when(() => mockRepo.method()).thenAnswer((_) async {
  callCount++;
  return callCount == 1 ? Left(failure) : const Right(data);
});
```

### Mock with Delay

```dart
when(() => mockRepo.method()).thenAnswer((_) async {
  await wait(100);
  return const Right(data);
});
```

## ✅ Verification Examples

### Verify Called Once

```dart
verify(() => mockRepo.method()).called(1);
```

### Verify Called Multiple Times

```dart
verify(() => mockRepo.method()).called(3);
```

### Verify Never Called

```dart
verifyNever(() => mockRepo.method());
```

### Verify with Specific Arguments

```dart
verify(() => mockRepo.method(
  param: specificValue,
)).called(1);
```

## 🎨 Assertion Examples

### Either Right (Success)

```dart
expect(result.isRight, isTrue);
expect(result.rightOrNull, equals(expectedValue));
```

### Either Left (Failure)

```dart
expect(result.isLeft, isTrue);
expect(result.leftOrNull, isA<Failure>());
expect(result.leftOrNull?.message, contains('error'));
```

### Type Checking

```dart
expect(instance, isA<ComponentName>());
```

### Equality

```dart
expect(value, equals(expectedValue));
expect(list, equals([item1, item2]));
```

### Collection Matchers

```dart
expect(list.length, equals(3));
expect(list, contains(item));
expect(list, isEmpty);
expect(list, isNotEmpty);
```

## 🐛 Troubleshooting

### Test Timeout

**Problem**: Test hangs or times out

**Solution**: Check for missing `await` on async operations

```dart
// ❌ Bad - missing await
test('async test', () {
  useCase(); // Missing await!
  expect(result, isNotNull);
});

// ✅ Good
test('async test', () async {
  await useCase();
  expect(result, isNotNull);
});
```

### Mock Not Set Up

**Problem**: `Bad state: No stub was found`

**Solution**: Always set up mocks before using them

```dart
// Set up ALL methods that will be called
when(() => mockRepo.method1()).thenAnswer((_) async => const Right(null));
when(() => mockRepo.method2()).thenAnswer((_) async => const Right(null));
```

### Verify Failed

**Problem**: `No matching calls`

**Solution**: Check that the exact same parameters are used

```dart
// Make sure parameters match exactly
when(() => mockRepo.method(param: 'value'))
  .thenAnswer((_) async => const Right(null));

verify(() => mockRepo.method(param: 'value')).called(1);
```

### Multiple Calls with Counter Pattern

**Problem**: Need different return values on subsequent calls

**Solution**: Use counter pattern

```dart
var callCount = 0;
when(() => mockRepo.method()).thenAnswer((_) async {
  callCount++;
  if (callCount == 1) return Left(failure);
  if (callCount == 2) return const Right(data);
  return const Right(otherData);
});
```

## 📝 Best Practices Checklist

Before committing tests:

- [ ] All tests pass locally
- [ ] Tests follow AAA pattern
- [ ] Test names are descriptive
- [ ] Tests are properly grouped
- [ ] Edge cases are covered
- [ ] Real-world scenarios included
- [ ] All mocks are set up correctly
- [ ] All async operations are awaited
- [ ] Verifications check correct call counts
- [ ] Documentation header is present
- [ ] No flaky tests (run multiple times)

## 📚 Quick Links

- [Full README](README.md) - Complete test documentation
- [Test Helpers](helpers/test_helpers.dart) - Utility functions
- [Test Constants](fixtures/test_constants.dart) - Test data
- [VGV Testing Guide](https://verygood.ventures/blog/guide-to-flutter-testing)

---

**Last updated:** 2026-01-02
