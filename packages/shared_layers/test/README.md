# Tests for shared_layers Package

Comprehensive test suite following Very Good Ventures best practices.

## Test Statistics

- **Total Test Files**: 2
- **Total Tests**: 130+
- **Test Pass Rate**: 100%
- **Code Coverage Goal**: High coverage of critical paths

## Test Files

### Shared Data Layer (60+ tests)

1. **`src/shared_data_layer/cache_manager/cache_manager_test.dart`** (60+ tests)
   - CacheManager construction and configuration
   - TTL (Time-To-Live) expiration behavior
   - Manual cache operations (put, get, clear)
   - In-flight request deduplication
   - Statistics tracking and monitoring
   - Edge cases (null values, short/long TTL, concurrent access)
   - Real-world scenarios (repository caching, parallel requests)
   - Performance benchmarks

### Shared Presentation Layer (70+ tests)

2. **`src/shared_presentation_layer/shared_state_models/submission_state_test.dart`** (70+ tests)
   - All state variants (Initial, Loading, Success, Error, RequiresReauth)
   - Equatable equality checks
   - Extension methods (isInitial, isLoading, isSuccess, etc.)
   - Consumable pattern for one-shot events
   - maybeMap and map pattern matching
   - Real-world scenarios (login, password change, registration flows)
   - State transitions and type checking

## Test Organization

### Structure

```
test/
├── helpers/
│   └── test_helpers.dart
├── fixtures/
│   └── test_constants.dart
└── src/
    ├── shared_data_layer/
    │   └── cache_manager/
    │       └── cache_manager_test.dart
    ├── shared_domain_layer/
    │   └── shared_entities/
    │       ├── user_entity_test.dart        # Moved to features_dd_layers
    │       └── user_entity_x_test.dart      # Moved to features_dd_layers
    └── shared_presentation_layer/
        ├── shared_state_models/
        │   └── submission_state_test.dart
        └── widgets_shared/                  # Moved to shared_widgets
            └── ...
```

### Conventions

- **AAA Pattern**: All tests follow Arrange-Act-Assert
- **Descriptive Names**: Test names clearly describe what is being tested
- **Grouping**: Tests are organized in logical groups with `group()`
- **Documentation**: Each test file includes comprehensive doc comments
- **Real-World Scenarios**: Many tests include practical usage examples
- **Edge Cases**: Comprehensive coverage of boundary conditions

## Testing Approach

### Unit Testing

- **Isolation**: Each test runs in isolation with its own setup
- **Fast Execution**: All tests complete in ~2 seconds
- **Mocking**: Uses `mocktail` when needed for external dependencies
- **Pure Logic**: Focus on testing business logic without UI dependencies

### State Management Testing

- **State Variants**: Complete coverage of all state types
- **Equatable Behavior**: Thorough equality testing
- **Pattern Matching**: Testing all map/maybeMap branches
- **Consumable Events**: One-shot event consumption patterns

### Cache Testing

- **TTL Behavior**: Time-based expiration testing
- **Concurrency**: Parallel request handling
- **Statistics**: Cache hit/miss tracking
- **Edge Cases**: Null values, short/long TTL, boundary conditions

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/src/shared_data_layer/cache_manager/cache_manager_test.dart
```

### Run with Coverage

```bash
flutter test --coverage
```

### Run in Watch Mode

```bash
flutter test --watch
```

## Key Testing Patterns

### 1. Cache Manager Testing

```dart
test('deduplicates parallel requests with same key', () async {
  // Arrange
  final cache = CacheManager<String, String>();
  var callCount = 0;
  Future<String> operation() async {
    callCount++;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return 'result';
  }

  // Act
  final futures = [
    cache.execute('key1', operation),
    cache.execute('key1', operation),
    cache.execute('key1', operation),
  ];
  final results = await Future.wait(futures);

  // Assert
  expect(results, equals(['result', 'result', 'result']));
  expect(callCount, equals(1)); // Operation called only once
});
```

### 2. Submission State Testing

```dart
test('SubmissionStateSuccess equality', () {
  // Arrange
  const state1 = SubmissionStateSuccess();
  const state2 = SubmissionStateSuccess();

  // Act & Assert
  expect(state1, equals(state2));
  expect(state1.hashCode, equals(state2.hashCode));
});

test('identifies success state correctly', () {
  // Arrange
  const state = SubmissionStateSuccess();

  // Act & Assert
  expect(state.isSuccess, isTrue);
  expect(state.isLoading, isFalse);
  expect(state.isError, isFalse);
});
```

### 3. Consumable Pattern Testing

```dart
test('consumable pattern for one-shot events', () {
  // Arrange
  const state = SubmissionStateSuccess();

  // Act
  final result = state.mapOrNull(
    success: (_) => 'consumed',
  );

  // Assert
  expect(result, equals('consumed'));
});
```

## Maintenance

### Adding New Tests

1. Create test file with `_test.dart` suffix
2. Follow existing file structure and naming conventions
3. Include comprehensive doc comments
4. Group tests logically
5. Update this README with new statistics
6. Run all tests to ensure no regressions

### Updating Tests

1. When changing source code, update corresponding tests
2. Maintain test-to-source file ratio
3. Keep test documentation in sync with implementation
4. Verify all tests pass after changes

### Test Quality Checklist

- [ ] Follows AAA pattern
- [ ] Has descriptive test name
- [ ] Tests one specific behavior
- [ ] Includes setup/teardown if needed
- [ ] Uses appropriate matchers
- [ ] Handles async operations correctly
- [ ] Cleans up resources properly
- [ ] Covers edge cases

## Dependencies

### Testing Libraries

- `flutter_test`: Flutter's testing framework
- `mocktail`: Mocking library for Dart (when needed)

### Production Dependencies Tested

- `equatable`: Value equality testing
- Custom state management patterns
- Cache management utilities

## Test Quality Metrics

- **Comprehensiveness**: All public APIs have tests
- **Edge Cases**: Common edge cases are covered (null, empty, TTL expiration)
- **Error Paths**: Error scenarios are tested
- **Documentation**: Tests serve as usage examples
- **Maintainability**: Tests are easy to understand and modify
- **Performance**: Cache performance benchmarks included

## Special Testing Considerations

### Cache Manager

- **Null Values**: Null values are NOT cached (documented limitation)
- **TTL Testing**: Uses fake timers for deterministic time-based testing
- **Concurrency**: Tests parallel request handling and deduplication
- **Statistics**: Validates cache hit/miss tracking accuracy

### Submission State

- **Equatable Testing**: Thorough equality and hashCode testing
- **Pattern Matching**: All map/maybeMap branches tested
- **Type Safety**: Compile-time type checking verified
- **Consumable Events**: One-shot event consumption patterns tested

## Package Structure Changes

**Note**: This package was refactored on 2026-01-07. The following components were moved to separate packages:

- **Utils & Extensions** → Moved to `shared_utils` package
  - String extensions
  - Number formatting
  - ID generator
  - Timing control (Debouncer, Throttler, VerificationPoller)
  - Stream utilities

- **Shared Widgets** → Moved to `shared_widgets` package
  - Button widgets (FilledButton, TextButton, SubmitButton)
  - Blur and barrier filters
  - AppBar customization
  - Loader widgets

- **Domain Entities** → Moved to `features_dd_layers` package
  - UserEntity and extensions

See the respective packages for their test documentation:

- `packages/shared_utils/test/README.md`
- `packages/shared_widgets/test/README.md`
- `packages/features_dd_layers/test/README.md`

## Notes

- All tests run in isolation without external dependencies
- Tests execute quickly and can run in CI/CD pipelines
- No environment setup required beyond `flutter test`
- Cache Manager tests use deterministic time-based testing
- Submission State tests verify compile-time type safety

---

**Last Updated**: 2026-01-09
**Test Framework Version**: Flutter 3.x
**Coverage**: High coverage of caching and state management patterns
