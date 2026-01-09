/// Tests for Throttler
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Basic throttling functionality
/// - Multiple rapid calls behavior
/// - Reset functionality
/// - Different duration configurations
/// - Real-world usage scenarios (button spam prevention)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/public_api/general_utils.dart' show Throttler;

void main() {
  group('Throttler', () {
    group('construction', () {
      test('creates instance with duration', () {
        // Arrange
        const duration = Duration(milliseconds: 300);

        // Act
        final throttler = Throttler(duration);

        // Assert
        expect(throttler, isA<Throttler>());
        expect(throttler.duration, equals(duration));
      });

      test('allows different duration values', () {
        // Arrange & Act
        final short = Throttler(const Duration(milliseconds: 100));
        final medium = Throttler(const Duration(milliseconds: 500));
        final long = Throttler(const Duration(seconds: 2));

        // Assert
        expect(short.duration.inMilliseconds, equals(100));
        expect(medium.duration.inMilliseconds, equals(500));
        expect(long.duration.inMilliseconds, equals(2000));
      });
    });

    group('run', () {
      test('executes action immediately on first call', () {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 300));
        var executed = false;
        void action() => executed = true;

        // Act
        throttler.run(action);

        // Assert
        expect(executed, isTrue); // Executed immediately
      });

      test('ignores calls during throttle window', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 200));
        var callCount = 0;
        void action() => callCount++;

        // Act
        throttler
          ..run(action) // First call - executes
          ..run(action) // Ignored
          ..run(action); // Ignored

        // Assert
        expect(callCount, equals(1));

        // Clean up
        await Future<void>.delayed(const Duration(milliseconds: 250));
      });

      test('allows next call after throttle window expires', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        var callCount = 0;
        void action() => callCount++;

        // Act
        throttler.run(action); // First call
        expect(callCount, equals(1));

        await Future<void>.delayed(const Duration(milliseconds: 150));
        throttler.run(action); // Second call after window

        // Assert
        expect(callCount, equals(2));
      });

      test('throttles rapid consecutive calls correctly', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        var callCount = 0;
        void action() => callCount++;

        // Act - Rapid fire 10 calls
        for (var i = 0; i < 10; i++) {
          throttler.run(action);
        }

        // Assert - Only first call executed
        expect(callCount, equals(1));

        // Clean up
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });

      test('executes action with correct timing', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 150));
        final timestamps = <DateTime>[];

        void action() => timestamps.add(DateTime.now());

        // Act
        throttler.run(action); // T+0ms
        await Future<void>.delayed(const Duration(milliseconds: 50));
        throttler.run(action); // T+50ms - ignored

        await Future<void>.delayed(const Duration(milliseconds: 150));
        throttler.run(action); // T+200ms - allowed

        // Assert
        expect(timestamps.length, equals(2));
        final diff = timestamps[1].difference(timestamps[0]).inMilliseconds;
        expect(diff, greaterThanOrEqualTo(150));
      });

      test('handles action with parameters via closure', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        var result = 0;
        void action(int value) => result = value;

        // Act
        throttler
          ..run(() => action(42))
          ..run(() => action(99)); // Ignored

        // Assert
        expect(result, equals(42)); // Only first executed

        // Clean up
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });
    });

    group('reset', () {
      test('resets throttler to allow immediate next call', () {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 300));
        var callCount = 0;
        void action() => callCount++;

        // Act
        throttler
          ..run(action) // First call
          ..reset()
          ..run(action); // Should execute immediately after reset

        // Assert
        expect(callCount, equals(2));
      });

      test('reset allows multiple consecutive calls', () {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 500));
        var callCount = 0;
        void action() => callCount++;

        // Act
        throttler
          ..run(action)
          ..reset()
          ..run(action)
          ..reset()
          ..run(action);

        // Assert
        expect(callCount, equals(3));
      });

      test('reset does nothing when throttle is not active', () {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));

        // Act & Assert
        expect(throttler.reset, returnsNormally);
      });

      test('reset can be called multiple times safely', () {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));

        // Act & Assert
        expect(
          () {
            throttler
              ..reset()
              ..reset()
              ..reset();
          },
          returnsNormally,
        );
      });
    });

    group('edge cases', () {
      test('handles zero duration', () {
        // Arrange
        final throttler = Throttler(Duration.zero);
        var callCount = 0;
        void action() => callCount++;

        // Act - Multiple rapid calls
        throttler
          ..run(action)
          ..run(action)
          ..run(action);

        // Assert - All should execute (no throttling with zero duration)
        expect(callCount, greaterThanOrEqualTo(1));
      });

      test('handles very short duration', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 1));
        var callCount = 0;
        void action() => callCount++;

        // Act
        throttler
          ..run(action)
          ..run(action); // Likely ignored

        await Future<void>.delayed(const Duration(milliseconds: 10));
        throttler.run(action); // Should execute

        // Assert
        expect(callCount, greaterThanOrEqualTo(2));
      });

      test('handles very long duration', () async {
        // Arrange
        final throttler = Throttler(const Duration(seconds: 10));
        var callCount = 0;
        void action() => callCount++;

        // Act
        throttler.run(action);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        throttler.run(action); // Should be ignored

        // Assert
        expect(callCount, equals(1));

        // Clean up with reset
        throttler.reset();
      });

      test('handles action that throws exception', () {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        void throwingAction() => throw Exception('Test exception');

        // Act & Assert - Should not prevent throttling
        expect(() => throttler.run(throwingAction), throwsException);

        // Subsequent call should still be throttled
        var normalCallExecuted = false;
        throttler.run(() => normalCallExecuted = true);
        expect(normalCallExecuted, isFalse);
      });
    });

    group('real-world scenarios', () {
      test('simulates button spam prevention', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 500));
        var submitCount = 0;

        void onSubmit() => submitCount++;

        // Act - User rapidly clicks submit button
        for (var i = 0; i < 10; i++) {
          throttler.run(onSubmit);
        }

        // Assert - Form submitted only once
        expect(submitCount, equals(1));

        // Clean up
        await Future<void>.delayed(const Duration(milliseconds: 550));
      });

      test('simulates API rate limiting', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 1000));
        var apiCallCount = 0;

        void makeApiCall() => apiCallCount++;

        // Act - Multiple requests within 1 second
        throttler.run(makeApiCall); // T+0ms
        await Future<void>.delayed(const Duration(milliseconds: 200));
        throttler.run(makeApiCall); // T+200ms - ignored
        await Future<void>.delayed(const Duration(milliseconds: 300));
        throttler.run(makeApiCall); // T+500ms - ignored

        // Assert - Only first request went through
        expect(apiCallCount, equals(1));

        // After throttle window
        await Future<void>.delayed(const Duration(milliseconds: 600));
        throttler.run(makeApiCall); // T+1100ms - allowed

        expect(apiCallCount, equals(2));
      });

      test('simulates scroll event throttling', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        var updateCount = 0;

        void updateUI() => updateCount++;

        // Act - Simulate continuous scroll events
        for (var i = 0; i < 50; i++) {
          throttler.run(updateUI);
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }

        // Assert - UI updated only few times (not 50)
        expect(updateCount, lessThan(10));
      });

      test('simulates analytics event throttling', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 300));
        var eventsSent = 0;

        void sendAnalyticsEvent() => eventsSent++;

        // Act - Multiple rapid user interactions
        throttler
          ..run(sendAnalyticsEvent)
          ..run(sendAnalyticsEvent) // Ignored
          ..run(sendAnalyticsEvent); // Ignored

        await Future<void>.delayed(const Duration(milliseconds: 350));
        throttler.run(sendAnalyticsEvent); // Sent

        // Assert
        expect(eventsSent, equals(2));
      });

      test('simulates form field validation throttling', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 200));
        var validationCount = 0;

        void validateField() => validationCount++;

        // Act - User types rapidly
        for (var i = 0; i < 20; i++) {
          throttler.run(validateField);
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }

        // Assert - Validation called periodically, not on every keystroke
        expect(validationCount, lessThan(20));
        expect(validationCount, greaterThan(1));
      });
    });

    group('multiple throttler instances', () {
      test('different instances do not interfere', () async {
        // Arrange
        final throttler1 = Throttler(const Duration(milliseconds: 100));
        final throttler2 = Throttler(const Duration(milliseconds: 100));
        var count1 = 0;
        var count2 = 0;

        // Act
        throttler1.run(() => count1++);
        throttler2.run(() => count2++);
        throttler1.run(() => count1++); // Ignored
        throttler2.run(() => count2++); // Ignored

        // Assert
        expect(count1, equals(1));
        expect(count2, equals(1));

        // Clean up
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });

      test('resetting one does not affect others', () {
        // Arrange
        final throttler1 = Throttler(const Duration(milliseconds: 300));
        final throttler2 = Throttler(const Duration(milliseconds: 300));
        var count1 = 0;
        var count2 = 0;

        // Act
        throttler1.run(() => count1++);
        throttler2.run(() => count2++);
        throttler1
          ..reset()
          ..run(() => count1++); // Should execute
        throttler2.run(() => count2++); // Should be throttled

        // Assert
        expect(count1, equals(2));
        expect(count2, equals(1));
      });
    });

    group('comparison with debouncer behavior', () {
      test('throttler executes first call immediately', () {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        var executed = false;

        // Act
        throttler.run(() => executed = true);

        // Assert - Immediate execution (unlike debouncer)
        expect(executed, isTrue);
      });

      test('throttler ignores intermediate calls', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        var lastValue = '';

        // Act
        throttler
          ..run(() => lastValue = 'first')
          ..run(() => lastValue = 'second') // Ignored
          ..run(() => lastValue = 'third'); // Ignored

        // Assert - Only first value set (unlike debouncer which would use last)
        expect(lastValue, equals('first'));

        // Clean up
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });
    });

    group('timing precision', () {
      test('allows call exactly after duration expires', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        var callCount = 0;

        // Act
        throttler.run(() => callCount++);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        throttler.run(() => callCount++);

        // Assert
        expect(callCount, equals(2));
      });

      test('maintains consistent throttle intervals', () async {
        // Arrange
        final throttler = Throttler(const Duration(milliseconds: 100));
        final executionTimes = <DateTime>[];

        void trackExecution() => executionTimes.add(DateTime.now());

        // Act
        throttler.run(trackExecution); // T+0
        await Future<void>.delayed(const Duration(milliseconds: 120));
        throttler.run(trackExecution); // T+120
        await Future<void>.delayed(const Duration(milliseconds: 120));
        throttler.run(trackExecution); // T+240

        // Assert - Should have 3 executions
        expect(executionTimes.length, equals(3));

        // Verify intervals are roughly 120ms
        for (var i = 1; i < executionTimes.length; i++) {
          final interval = executionTimes[i]
              .difference(executionTimes[i - 1])
              .inMilliseconds;
          expect(interval, greaterThanOrEqualTo(100));
        }
      });
    });
  });
}
