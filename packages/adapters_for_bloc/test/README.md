# Tests for adapters_for_bloc Package

Comprehensive test suite following Very Good Ventures best practices.

## Test Statistics

- **Total Test Files**: 8
- **Total Tests**: 175
- **Test Pass Rate**: 100%
- **Code Coverage Goal**: High coverage of critical paths

## Test Files

### App Bootstrap Module (14 tests)

1. **`src/app_bootstrap/di/di_test.dart`** (14 tests)
   - Dependency Injection container (GetIt wrapper)
   - Service registration (singleton, lazy, factory)
   - Service retrieval and lifecycle
   - Reset functionality for testing/hot reload
   - Real-world initialization workflows
   - Named instances and async factories

### Base App Modules (48 tests)

2. **`src/base_app_modules/observer/bloc_observer_test.dart`** (16 tests)
   - BLoC lifecycle event logging
   - State change tracking (onChange, onTransition)
   - Error logging with timestamps
   - Integration with Cubit and Bloc
   - Full lifecycle observation patterns

3. **`src/base_app_modules/overlays_module/overlay_status_cubit_test.dart`** (7 tests)
   - Global overlay activity state management
   - Active/inactive state transitions
   - Distinct value emission behavior
   - Integration with overlay dispatcher
   - Real-world overlay show/hide scenarios

4. **`src/base_app_modules/theme_module/theme_cubit_test.dart`** (25 tests)
   - AppTheme state management (light/dark/system)
   - Font selection and persistence
   - Theme-font combination handling
   - Adaptive system theme behavior
   - Real-world theme switching scenarios

### Features Module (15 tests)

5. **`src/features/auth/auth_cubit_test.dart`** (15 tests)
   - Authentication state management (View pattern)
   - Gateway snapshot subscription lifecycle
   - AuthViewLoading/Ready/Error state mapping
   - Stream transformation and error handling
   - Real-world sign-in/sign-out flows
   - Equality and cleanup verification

### Presentation Shared Module (70 tests)

6. **`src/presentation_shared/async_value_state_model/async_value_for_bloc_test.dart`** (34 tests)
   - AsyncValue union type (Loading/Data/Error)
   - Loading-with-data (refreshing) state
   - Loading-with-error (reloading) state
   - Pattern matching (when, maybeWhen, map)
   - State transformations and copyWithPrevious
   - Equatable behavior and equality testing

7. **`src/presentation_shared/async_value_state_model/cubits/async_state_base_cubit_test.dart`** (36 tests)
   - Base cubit for AsyncValue state management
   - Loading/Data/Error emission helpers
   - emitGuarded pattern (unified error handling)
   - UI preservation during refresh (preserveUi)
   - Custom error mapper support
   - Lifecycle safety (no emit after close)
   - Real-world fetch/refresh/retry scenarios

### Utils Module (28 tests)

8. **`src/utils/bloc_select_x_on_context_test.dart`** (28 tests)
   - Riverpod-style watchAndSelect extension
   - Efficient state slice selection
   - Widget rebuild optimization
   - readBloc for one-time BLoC access
   - Complex state transformations
   - Real-world list rendering patterns

## Test Organization

### Structure

```
test/
├── src/
│   ├── app_bootstrap/
│   │   └── di/
│   │       └── di_test.dart
│   ├── base_app_modules/
│   │   ├── observer/
│   │   │   └── bloc_observer_test.dart
│   │   ├── overlays_module/
│   │   │   └── overlay_status_cubit_test.dart
│   │   └── theme_module/
│   │       └── theme_cubit_test.dart
│   ├── features/
│   │   └── auth/
│   │       └── auth_cubit_test.dart
│   ├── presentation_shared/
│   │   └── async_value_state_model/
│   │       ├── async_value_for_bloc_test.dart
│   │       └── cubits/
│   │           └── async_state_base_cubit_test.dart
│   └── utils/
│       └── bloc_select_x_on_context_test.dart
└── README.md
```

### Conventions

- **AAA Pattern**: All tests follow Arrange-Act-Assert
- **Descriptive Names**: Test names clearly describe what is being tested
- **Grouping**: Tests are organized in logical groups with `group()`
- **Documentation**: Each test file includes comprehensive doc comments
- **Real-World Scenarios**: Many tests include real-world usage examples
- **Widget Testing**: UI components tested with `testWidgets()`

## Testing Approach

### Unit Testing

- **Mocking**: Uses `mocktail` for external dependencies (AuthGateway, etc.)
- **Isolation**: Each test runs in isolation with its own setup
- **Fast Execution**: All tests complete in ~2 seconds
- **Stream Testing**: Comprehensive async stream behavior verification

### Widget Testing

- **Flutter Test Widgets**: Uses `WidgetTester` for UI component testing
- **Context Extensions**: Tests BLoC context extensions (watchAndSelect, readBloc)
- **Rebuild Verification**: Tests widget rebuild optimization patterns
- **Real Widget Trees**: Tests with MaterialApp and BlocProvider integration

### State Management Testing

- **BLoC/Cubit Patterns**: Comprehensive testing of state emission patterns
- **Stream Composition**: Testing of RxDart stream transformations
- **Lifecycle Testing**: Resource cleanup and disposal verification
- **Error Scenarios**: Error propagation and handling patterns

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/src/presentation_shared/async_value_state_model/async_value_for_bloc_test.dart
```

### Run with Coverage

```bash
flutter test --coverage
```

### Run in Watch Mode

```bash
flutter test --watch
```

### Run via Melos (from monorepo root)

```bash
melos run test:adapters_for_bloc
```

## Key Testing Patterns

### 1. Cubit State Testing

```dart
test('emits correct state', () {
  // Arrange
  final cubit = TestCubit();

  // Act
  cubit.performAction();

  // Assert
  expect(cubit.state, isA<ExpectedState>());
  expect(cubit.state.value, equals(42));
});
```

### 2. Stream Emission Testing

```dart
test('emits correct sequence', () async {
  // Arrange
  final states = <State>[];
  final subscription = cubit.stream.listen(states.add);
  addTearDown(subscription.cancel);

  // Act
  await cubit.performAsyncAction();
  await Future<void>.delayed(Duration.zero); // Flush microtasks

  // Assert
  expect(states, hasLength(2));
  expect(states[0], isA<LoadingState>());
  expect(states[1], isA<DataState>());
});
```

### 3. Widget Context Testing

```dart
testWidgets('widget rebuilds on state change', (tester) async {
  // Arrange
  final cubit = TestCubit();
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: cubit,
        child: TestWidget(),
      ),
    ),
  );

  // Act
  cubit.updateState();
  await tester.pumpAndSettle();

  // Assert
  expect(find.text('Updated'), findsOneWidget);
});
```

### 4. AsyncValue Pattern Testing

```dart
test('handles loading → data flow', () async {
  // Arrange
  final cubit = AsyncCubit();

  // Act
  await cubit.emitGuarded(() async => 42);

  // Assert
  expect(cubit.state.hasValue, isTrue);
  expect(cubit.state.valueOrNull, equals(42));
});
```

## Maintenance

### Adding New Tests

1. Create test file with `_test.dart` suffix
2. Follow existing file structure and naming conventions
3. Include comprehensive doc comments at file level
4. Group tests logically by feature/behavior
5. Update this README with new test statistics
6. Run all tests to ensure no regressions

### Updating Tests

1. When changing source code, update corresponding tests
2. Maintain test-to-source file ratio (ideally 1:1)
3. Keep test documentation in sync with implementation
4. Verify all tests pass after changes

### Test Quality Checklist

- [ ] Follows AAA pattern
- [ ] Has descriptive test name
- [ ] Tests one specific behavior
- [ ] Includes setup/teardown if needed
- [ ] Uses appropriate matchers
- [ ] Handles async operations correctly
- [ ] Cleans up resources (subscriptions, cubits)

## Dependencies

### Testing Libraries

- `flutter_test`: Flutter's testing framework
- `bloc_test`: BLoC-specific testing utilities
- `mocktail`: Mocking library for Dart

### Production Dependencies Tested

- `flutter_bloc`: BLoC state management
- `equatable`: Value equality
- `rxdart`: Reactive extensions for streams
- `get_it`: Service locator for dependency injection

## Test Quality Metrics

- **Comprehensiveness**: All public APIs have tests
- **Edge Cases**: Common edge cases are covered (null, empty, error states)
- **Error Paths**: Error scenarios are thoroughly tested
- **Documentation**: Tests serve as usage examples
- **Maintainability**: Tests are easy to understand and modify
- **Async Safety**: Proper handling of async operations and microtasks
- **Resource Cleanup**: All subscriptions and cubits properly disposed

## Special Testing Considerations

### Async State Management

- **Microtask Flushing**: Use `await Future.delayed(Duration.zero)` after state changes
- **Stream Subscription**: Always add tearDown for subscription cleanup
- **Widget Pumping**: Use `pumpAndSettle()` for async widget updates

### BLoC Lifecycle

- **Close Testing**: Verify no emissions after `close()` is called
- **Subscription Cleanup**: Test proper disposal of stream subscriptions
- **Error Recovery**: Test cubit behavior after error states

### Widget Testing

- **Context Access**: Test proper BLoC access via BuildContext extensions
- **Rebuild Optimization**: Verify widgets only rebuild when necessary
- **State Slicing**: Test efficient state selection patterns

## Notes

- All tests run in isolation without external dependencies
- Tests execute quickly and can run in CI/CD pipelines
- No environment setup required beyond `flutter test`
- Widget tests use `testWidgets()` for Flutter-specific testing
- Some tests removed during cleanup (legacy or duplicate coverage)

---

**Last Updated**: 2026-01-09
**Test Framework Version**: Flutter 3.x
**Coverage**: High coverage of BLoC state management patterns and async operations
