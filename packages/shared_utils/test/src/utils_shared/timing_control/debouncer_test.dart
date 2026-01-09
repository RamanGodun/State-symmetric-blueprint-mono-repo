/// Tests for Debouncer
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Basic debouncing functionality
/// - Multiple rapid calls behavior
/// - Cancellation
/// - Different duration configurations
/// - Real-world usage scenarios
library;

import 'dart:async' show runZonedGuarded;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/public_api/general_utils.dart' show Debouncer;

void main() {
  group('Debouncer', () {
    group('construction', () {
      test('creates instance with duration', () {
        // Arrange
        const duration = Duration(milliseconds: 300);

        // Act
        final debouncer = Debouncer(duration);

        // Assert
        expect(debouncer, isA<Debouncer>());
        expect(debouncer.duration, equals(duration));
      });

      test('stores duration property', () {
        // Arrange
        const duration = Duration(milliseconds: 500);

        // Act
        final debouncer = Debouncer(duration);

        // Assert
        expect(debouncer.duration, equals(duration));
      });

      test('allows different duration values', () {
        // Arrange & Act
        final shortDebouncer = Debouncer(const Duration(milliseconds: 100));
        final mediumDebouncer = Debouncer(const Duration(milliseconds: 300));
        final longDebouncer = Debouncer(const Duration(milliseconds: 1000));

        // Assert
        expect(shortDebouncer.duration.inMilliseconds, equals(100));
        expect(mediumDebouncer.duration.inMilliseconds, equals(300));
        expect(longDebouncer.duration.inMilliseconds, equals(1000));
      });
    });

    group('run', () {
      test('executes action after delay', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer.run(action);
        expect(executed, isFalse); // Not executed immediately

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(executed, isTrue); // Executed after delay
      });

      test('does not execute action immediately', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer.run(action);

        // Assert - Immediately after call
        expect(executed, isFalse);

        // Clean up
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });

      test('executes action with correct delay timing', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 200));
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer.run(action);

        // Check before delay expires
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(executed, isFalse);

        // Check after delay expires
        await Future<void>.delayed(const Duration(milliseconds: 150));
        expect(executed, isTrue);
      });

      test('executes action with parameters via closure', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var result = 0;
        void action() => result = 42;

        // Act
        debouncer.run(action);
        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(result, equals(42));
      });

      test('cancels previous timer on new call', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var firstCallExecuted = false;
        var secondCallExecuted = false;

        void firstAction() => firstCallExecuted = true;
        void secondAction() => secondCallExecuted = true;

        // Act
        debouncer.run(firstAction);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        debouncer.run(secondAction); // This should cancel first timer

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(firstCallExecuted, isFalse); // First action cancelled
        expect(secondCallExecuted, isTrue); // Second action executed
      });

      test('handles multiple rapid calls correctly', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var callCount = 0;
        void action() => callCount++;

        // Act - Call rapidly 5 times
        for (var i = 0; i < 5; i++) {
          debouncer.run(action);
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert - Only last call should execute
        expect(callCount, equals(1));
      });

      test('executes latest action when called multiple times', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var result = '';

        // Act
        debouncer.run(() => result = 'first');
        await Future<void>.delayed(const Duration(milliseconds: 30));
        debouncer.run(() => result = 'second');
        await Future<void>.delayed(const Duration(milliseconds: 30));
        debouncer.run(() => result = 'third');

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert - Only last action executed
        expect(result, equals('third'));
      });

      test('allows action to execute after full delay passes', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 50));
        var firstExecuted = false;
        var secondExecuted = false;

        // Act - First call
        debouncer.run(() => firstExecuted = true);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Second call after first completed
        debouncer.run(() => secondExecuted = true);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(firstExecuted, isTrue);
        expect(secondExecuted, isTrue);
      });
    });

    group('cancel', () {
      test('cancels pending action', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer
          ..run(action)
          ..cancel();

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(executed, isFalse); // Action was cancelled
      });

      test('cancel does nothing when no action is pending', () {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));

        // Act & Assert
        expect(debouncer.cancel, returnsNormally);
      });

      test('allows new action after cancel', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var firstExecuted = false;
        var secondExecuted = false;

        // Act
        debouncer
          ..run(() => firstExecuted = true)
          ..cancel()
          ..run(() => secondExecuted = true);

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(firstExecuted, isFalse);
        expect(secondExecuted, isTrue);
      });

      test('can be called multiple times safely', () {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));

        // Act & Assert
        expect(
          () {
            debouncer
              ..cancel()
              ..cancel()
              ..cancel();
          },
          returnsNormally,
        );
      });

      test('cancels timer immediately', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer.run(action);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        debouncer.cancel();
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(executed, isFalse);
      });
    });

    group('edge cases', () {
      test('handles zero duration', () async {
        // Arrange
        final debouncer = Debouncer(Duration.zero);
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer.run(action);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(executed, isTrue); // Executes almost immediately
      });

      test('handles very short duration', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 1));
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer.run(action);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(executed, isTrue);
      });

      test('handles very long duration', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(seconds: 10));
        var executed = false;
        void action() => executed = true;

        // Act
        debouncer.run(action);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(executed, isFalse); // Should not execute yet

        // Clean up by canceling
        debouncer.cancel();
      });

      test('action exception propagates unhandled', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var actionCalled = false;
        Object? caughtError;
        void throwingAction() {
          actionCalled = true;
          throw Exception('Test exception');
        }

        // Act - Run in zone to catch unhandled error
        await runZonedGuarded(
          () async {
            debouncer.run(throwingAction);
            await Future<void>.delayed(const Duration(milliseconds: 150));
          },
          (error, stack) {
            caughtError = error;
          },
        );

        // Assert - Action was called and exception was caught by zone
        expect(actionCalled, isTrue);
        expect(caughtError, isA<Exception>());
      });

      test('handles rapid cancel and run cycles', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 100));
        var executeCount = 0;
        void action() => executeCount++;

        // Act
        for (var i = 0; i < 10; i++) {
          debouncer
            ..run(action)
            ..cancel();
        }
        debouncer.run(action); // Final run

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(executeCount, equals(1)); // Only final run executed
      });
    });

    group('real-world scenarios', () {
      test('simulates search input debouncing', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 300));
        var searchApiCallCount = 0;
        var searchTerm = '';

        void searchAction(String term) {
          searchApiCallCount++;
          searchTerm = term;
        }

        // Act - Simulate user typing "flutter"
        debouncer.run(() => searchAction('f'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        debouncer.run(() => searchAction('fl'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        debouncer.run(() => searchAction('flu'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        debouncer.run(() => searchAction('flutt'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        debouncer.run(() => searchAction('flutter'));

        // Wait for debounce
        await Future<void>.delayed(const Duration(milliseconds: 350));

        // Assert - API called only once with final search term
        expect(searchApiCallCount, equals(1));
        expect(searchTerm, equals('flutter'));
      });

      test('simulates window resize debouncing', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 200));
        var layoutRecalculations = 0;

        void recalculateLayout() => layoutRecalculations++;

        // Act - Simulate rapid resize events
        for (var i = 0; i < 20; i++) {
          debouncer.run(recalculateLayout);
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }

        await Future<void>.delayed(const Duration(milliseconds: 250));

        // Assert - Layout recalculated only once
        expect(layoutRecalculations, equals(1));
      });

      test('simulates auto-save debouncing', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 500));
        var saveCallCount = 0;
        var documentContent = '';

        void saveDocument(String content) {
          saveCallCount++;
          documentContent = content;
        }

        // Act - User types multiple characters
        debouncer.run(() => saveDocument('H'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        debouncer.run(() => saveDocument('He'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        debouncer.run(() => saveDocument('Hel'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        debouncer.run(() => saveDocument('Hell'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        debouncer.run(() => saveDocument('Hello'));

        await Future<void>.delayed(const Duration(milliseconds: 600));

        // Assert - Document saved only once with final content
        expect(saveCallCount, equals(1));
        expect(documentContent, equals('Hello'));
      });

      test('simulates scroll event debouncing', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 150));
        var scrollEndCallbacks = 0;

        void onScrollEnd() => scrollEndCallbacks++;

        // Act - Simulate continuous scrolling
        for (var i = 0; i < 50; i++) {
          debouncer.run(onScrollEnd);
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }

        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert - Callback fired only once when scrolling stopped
        expect(scrollEndCallbacks, equals(1));
      });

      test('simulates API request debouncing with user pause', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 300));
        var apiCalls = 0;

        void makeApiCall() => apiCalls++;

        // Act - User types, pauses, types again
        debouncer.run(makeApiCall);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        debouncer.run(makeApiCall);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // First API call should trigger
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(apiCalls, equals(1));

        // User types again after pause
        debouncer.run(makeApiCall);
        await Future<void>.delayed(const Duration(milliseconds: 350));

        // Assert - Second API call triggered
        expect(apiCalls, equals(2));
      });
    });

    group('integration with different durations', () {
      test('short duration for fast feedback', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 50));
        var executed = false;

        // Act
        debouncer.run(() => executed = true);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(executed, isTrue);
      });

      test('medium duration for balanced UX', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 300));
        var count = 0;

        // Act - Multiple rapid calls
        for (var i = 0; i < 5; i++) {
          debouncer.run(() => count++);
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }

        await Future<void>.delayed(const Duration(milliseconds: 350));

        // Assert
        expect(count, equals(1));
      });

      test('long duration for expensive operations', () async {
        // Arrange
        final debouncer = Debouncer(const Duration(milliseconds: 1000));
        var executed = false;

        // Act
        debouncer.run(() => executed = true);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        expect(executed, isFalse); // Not executed yet

        await Future<void>.delayed(const Duration(milliseconds: 600));

        // Assert
        expect(executed, isTrue);
      });
    });

    group('multiple debouncer instances', () {
      test('different instances do not interfere', () async {
        // Arrange
        final debouncer1 = Debouncer(const Duration(milliseconds: 100));
        final debouncer2 = Debouncer(const Duration(milliseconds: 100));
        var count1 = 0;
        var count2 = 0;

        // Act
        debouncer1.run(() => count1++);
        debouncer2.run(() => count2++);

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(count1, equals(1));
        expect(count2, equals(1));
      });

      test('canceling one does not affect others', () async {
        // Arrange
        final debouncer1 = Debouncer(const Duration(milliseconds: 100));
        final debouncer2 = Debouncer(const Duration(milliseconds: 100));
        var executed1 = false;
        var executed2 = false;

        // Act
        debouncer1.run(() => executed1 = true);
        debouncer2.run(() => executed2 = true);
        debouncer1.cancel();

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(executed1, isFalse);
        expect(executed2, isTrue);
      });
    });
  });
}
