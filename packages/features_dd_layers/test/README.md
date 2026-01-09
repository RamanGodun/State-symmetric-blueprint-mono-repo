# Features DD Layers - Test Suite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Comprehensive test suite for the `features_dd_layers` package, following Domain-Driven Design principles.

## 📋 Table of Contents

- [Overview](#overview)
- [Test Coverage](#test-coverage)
- [Module Documentation](#module-documentation)
- [Testing Standards](#testing-standards)
- [Running Tests](#running-tests)
- [Test Patterns](#test-patterns)
- [Contributing](#contributing)

## 🎯 Overview

This test suite provides comprehensive coverage for all feature modules in the `features_dd_layers` package. Our tests follow Clean Architecture principles with Domain-Driven Design, testing Use Cases, Repositories, and Data layers independently.

### Test Statistics

| Feature Module                    | Test Files | Tests   | Coverage | Status             |
| --------------------------------- | ---------- | ------- | -------- | ------------------ |
| [Authentication](#authentication) | 4          | 47      | 100%     | ✅ Passing         |
| [Profile](#profile)               | 1          | 34      | 100%     | ✅ Passing         |
| [Email Verification](#email)      | 1          | 17      | 100%     | ✅ Passing         |
| [Password Management](#password)  | 1          | 19      | 100%     | ✅ Passing         |
| **Total**                         | **7**      | **117** | **100%** | ✅ **All Passing** |

## 📊 Test Coverage

Our test suite maintains 100% code coverage across all modules. We test at multiple layers:

```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Highlights

- **Line Coverage**: 100%
- **Branch Coverage**: 100%
- **Function Coverage**: 100%
- **Domain Layer**: Complete use case coverage
- **Data Layer**: Full repository implementation testing
- **Error Handling**: Comprehensive failure scenario testing

## 📚 Module Documentation

### 🔐 Authentication

Complete testing of authentication flow including sign-in, sign-up, and sign-out.

**Test Files:**

- `sign_in_test.dart` (17 tests) - Sign-in use case
- `sign_up_test.dart` (16 tests) - Sign-up use case
- `sign_out_test.dart` (14 tests) - Sign-out use case
- `sign_in_repo_impl_test.dart` (16 tests) - Repository implementation

**Coverage:**

- Successful authentication flows
- Repository error handling
- Parameter validation
- Multiple sequential/concurrent calls
- Real-world scenarios (login, registration, logout)

### 👤 Profile

User profile fetching with automatic profile creation for first-time users.

**Test Files:**

- `fetch_profile_use_case_test.dart` (34 tests)

**Coverage:**

- Profile fetching (existing users)
- Profile creation (new users)
- Retry logic after creation
- Network error handling
- Edge cases (empty uid, concurrent calls)

### 📧 Email Verification

Email verification flow including sending verification emails and checking status.

**Test Files:**

- `email_verification_use_case_test.dart` (17 tests)

**Coverage:**

- Sending verification emails
- Reloading user state
- Checking verification status
- Rate limiting errors
- Real-world verification flow

### 🔒 Password Management

Password change and reset functionality.

**Test Files:**

- `password_actions_use_case_test.dart` (19 tests)

**Coverage:**

- Password changing
- Reset link sending
- Weak password rejection
- Rate limiting
- Network error handling

## 🧪 Testing Standards

We follow [Very Good Ventures testing standards][vgv_testing_link] with these principles:

### 1. AAA Pattern (Arrange-Act-Assert)

All tests follow the clear three-phase structure:

```dart
test('returns profile when found', () async {
  // Arrange
  when(() => mockRepo.getProfile(uid: any(named: 'uid')))
    .thenAnswer((_) async => const Right(testUserEntity));

  // Act
  final result = await useCase(testUserId);

  // Assert
  expect(result.isRight, isTrue);
  expect(result.rightOrNull, equals(testUserEntity));
});
```

### 2. Descriptive Test Names

Test names clearly describe what is being tested and expected outcome:

```dart
✅ GOOD: 'creates profile and retries when not found'
✅ GOOD: 'returns Left when repository fails'
❌ BAD: 'test1'
❌ BAD: 'profile test'
```

### 3. Test Organization

Tests are organized into logical groups:

```dart
group('FetchProfileUseCase', () {
  group('profile exists', () {
    test('returns profile when found', () { ... });
    test('calls repository with correct uid', () { ... });
  });

  group('profile does not exist', () {
    test('creates profile and retries when not found', () { ... });
  });

  group('error handling', () {
    test('returns failure when profile creation fails', () { ... });
  });

  group('edge cases', () {
    test('handles empty uid', () { ... });
    test('handles concurrent calls', () { ... });
  });

  group('real-world scenarios', () {
    test('simulates first-time user login', () { ... });
    test('simulates returning user login', () { ... });
  });
});
```

### 4. Mock and Dependency Management

We use `mocktail` for mocking with proper dependency injection:

```dart
// Create mocks
class MockProfileRepo extends Mock implements IProfileRepo {}

// Set up expectations
when(() => mockRepo.getProfile(uid: any(named: 'uid')))
  .thenAnswer((_) async => const Right(testUserEntity));

// Verify calls
verify(() => mockRepo.getProfile(uid: testUserId)).called(1);
```

### 5. Either Monad Testing

Our codebase uses the Either monad for error handling:

```dart
// Test success case (Right)
final result = await useCase(params);
expect(result.isRight, isTrue);
expect(result.rightOrNull, equals(expectedValue));

// Test failure case (Left)
final result = await useCase(params);
expect(result.isLeft, isTrue);
expect(result.leftOrNull, isA<Failure>());
```

### 6. Async Testing Patterns

Handle async operations correctly:

```dart
// Use counter pattern for multiple calls
var callCount = 0;
when(() => mockRepo.getProfile(uid: any(named: 'uid')))
  .thenAnswer((_) async {
    callCount++;
    return callCount == 1
      ? Left(notFoundFailure)
      : const Right(testUserEntity);
  });
```

## 🚀 Running Tests

### Run All Tests

```bash
# Navigate to package
cd packages/features_dd_layers

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run in verbose mode
flutter test --reporter expanded
```

### Run Specific Module

```bash
# Run authentication tests
flutter test test/src/auth

# Run domain tests only
flutter test test/src/auth/domain

# Run specific file
flutter test test/src/profile/domain/fetch_profile_use_case_test.dart
```

### Run Specific Test

```bash
# Run by name pattern
flutter test --plain-name "creates profile and retries"

# Run single test group
flutter test --plain-name "FetchProfileUseCase"
```

### Watch Mode

```bash
# Re-run tests on file changes (macOS/Linux)
find test -name "*.dart" | entr flutter test
```

## 🔧 Test Patterns

### 1. Repository Error Handling Pattern

**Pattern**: Testing use cases that delegate to repositories

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
  verify(() => mockRepo.operation()).called(1);
});
```

### 2. Fetch-or-Create Pattern

**Pattern**: Testing logic that creates resources if they don't exist

```dart
test('creates profile and retries when not found', () async {
  // Arrange
  var callCount = 0;
  when(() => mockRepo.getProfile(uid: any(named: 'uid')))
    .thenAnswer((_) async {
      callCount++;
      return callCount == 1
        ? Left(notFoundFailure)
        : const Right(testUserEntity);
    });
  when(() => mockRepo.createUserProfile(any()))
    .thenAnswer((_) async => const Right(null));

  // Act
  final result = await useCase(testUserId);

  // Assert
  expect(result.isRight, isTrue);
  verify(() => mockRepo.getProfile(uid: testUserId)).called(2);
  verify(() => mockRepo.createUserProfile(testUserId)).called(1);
});
```

### 3. Sequential State Changes Pattern

**Pattern**: Testing flows where state changes multiple times

```dart
test('simulates email verification flow', () async {
  // Arrange
  when(() => mockRepo.sendEmailVerification())
    .thenAnswer((_) async => const Right(null));
  when(() => mockRepo.reloadUser())
    .thenAnswer((_) async => const Right(null));

  var callCount = 0;
  when(() => mockRepo.isEmailVerified()).thenAnswer((_) async {
    callCount++;
    return callCount == 1 ? const Right(false) : const Right(true);
  });

  // Act - Send verification email
  final sendResult = await useCase.sendVerificationEmail();
  expect(sendResult.isRight, isTrue);

  // Act - Check status (not verified yet)
  final checkResult1 = await useCase.checkIfEmailVerified();
  expect(checkResult1.rightOrNull, isFalse);

  // Act - Check again after user clicks link
  final checkResult2 = await useCase.checkIfEmailVerified();
  expect(checkResult2.rightOrNull, isTrue);

  // Assert
  verify(() => mockRepo.isEmailVerified()).called(2);
});
```

### 4. Concurrent Calls Pattern

**Pattern**: Testing behavior with multiple parallel requests

```dart
test('handles concurrent calls', () async {
  // Arrange
  when(() => mockRepo.signIn(
    email: any(named: 'email'),
    password: any(named: 'password'),
  )).thenAnswer((_) async {
    await wait(shortDelayMs);
    return const Right(null);
  });

  // Act
  final futures = [
    useCase(email: validEmail, password: validPassword),
    useCase(email: validEmail, password: validPassword),
    useCase(email: validEmail, password: validPassword),
  ];
  final results = await futures.awaitAll();

  // Assert
  expect(results.length, equals(3));
  for (final result in results) {
    expect(result.isRight, isTrue);
  }
});
```

### 5. Network Error Propagation Pattern

**Pattern**: Ensure network errors are properly propagated even when code continues execution

```dart
test('propagates network errors', () async {
  // Arrange
  final networkFailure = 'Network error'.toFailure();
  when(() => mockRepo.getProfile(uid: any(named: 'uid')))
    .thenAnswer((_) async => Left(networkFailure));
  // Mock subsequent calls even though we expect early failure
  when(() => mockRepo.createUserProfile(any()))
    .thenAnswer((_) async => const Right(null));

  // Act
  final result = await useCase(testUserId);

  // Assert
  expect(result.isLeft, isTrue);
  expect(result.leftOrNull?.message, contains('Network'));
});
```

## 📖 Test File Structure

Every test file follows this structure:

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
/// - Feature 1
/// - Feature 2
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
      test('creates instance with provided repository', () {
        // Arrange & Act
        final instance = ComponentName(mockRepo);

        // Assert
        expect(instance, isA<ComponentName>());
      });
    });

    group('core functionality', () {
      // ... feature tests
    });

    group('error handling', () {
      // ... error tests
    });

    group('edge cases', () {
      // ... edge case tests
    });

    group('real-world scenarios', () {
      // ... practical usage tests
    });
  });
}
```

## 🔍 Test Helpers and Fixtures

### Test Constants (`test/fixtures/test_constants.dart`)

Centralized test data to prevent duplication:

```dart
class TestConstants {
  // Valid credentials
  static const validEmail = 'test@example.com';
  static const validPassword = 'Password123!';

  // User data
  static const testUserId = 'test-user-id-123';
  static const testUserEntity = UserEntity(
    id: testUserId,
    email: validEmail,
    name: 'Test User',
    // ...
  );
}
```

### Test Helpers (`test/helpers/test_helpers.dart`)

Utility functions for common test operations:

```dart
// Create test failures
extension TestFailureX on String {
  Failure toFailure() => Failure(
    message: this,
    type: const UnknownFailureType(),
  );
}

// Wait for async operations
Future<void> wait([int milliseconds = 100]) =>
  Future<void>.delayed(Duration(milliseconds: milliseconds));

// Await multiple futures in parallel
extension FutureListX<T> on List<Future<T>> {
  Future<List<T>> awaitAll() => Future.wait(this);
}
```

## 🤝 Contributing

When adding new tests, please follow these guidelines:

### 1. Test Coverage Requirements

- All new code must have 100% test coverage
- All branches must be tested
- Edge cases must be covered
- Real-world scenarios should be included

### 2. Test File Organization

```
test/
├── fixtures/
│   └── test_constants.dart         # Shared test data
├── helpers/
│   └── test_helpers.dart           # Test utilities
└── src/
    └── [feature]/
        ├── domain/
        │   └── use_cases/
        │       └── [use_case]_test.dart
        └── data/
            └── [repository]_test.dart
```

### 3. Documentation Requirements

- Every test file must have a documentation header
- Document the coverage areas
- Add comments for complex test scenarios
- Update this README when adding new modules

### 4. Code Review Checklist

- [ ] All tests follow AAA pattern
- [ ] Test names are descriptive
- [ ] Tests are properly grouped
- [ ] No flaky tests (run multiple times to verify)
- [ ] Coverage is 100%
- [ ] Documentation is updated
- [ ] Mocks are properly set up
- [ ] Async operations are properly awaited
- [ ] Either monad is tested correctly (Left/Right)

## 📖 Additional Resources

- [Very Good Ventures Testing Guide][vgv_testing_link]
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
- [Clean Architecture Testing](https://blog.cleancoder.com/uncle-bob/2017/03/03/TDD-Harms-Architecture.html)

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

---

**Last updated:** 2026-01-02
**Total test files:** 7
**Total tests:** 117
**Total coverage:** 100%
**Status:** ✅ All tests passing

Built with ❤️ following [Very Good Ventures][vgv_link] standards and Clean Architecture principles

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[vgv_link]: https://verygood.ventures
[vgv_testing_link]: https://verygood.ventures/blog/guide-to-flutter-testing
