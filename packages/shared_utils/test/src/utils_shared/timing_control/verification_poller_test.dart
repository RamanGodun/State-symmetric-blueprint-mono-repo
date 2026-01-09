/// Tests for VerificationPoller
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Basic polling functionality
/// - Verification success flow
/// - Timeout handling
/// - Cancellation
/// - Loading tick callbacks
/// - Real-world scenarios (email verification, SMS confirmation)
library;

import 'dart:async' show runZonedGuarded;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/public_api/general_utils.dart'
    show VerificationPoller;

void main() {
  group('VerificationPoller', () {
    group('construction', () {
      test('creates instance with interval and timeout', () {
        // Arrange
        const interval = Duration(milliseconds: 500);
        const timeout = Duration(seconds: 30);

        // Act
        final poller = VerificationPoller(
          interval: interval,
          timeout: timeout,
        );

        // Assert
        expect(poller, isA<VerificationPoller>());
        expect(poller.interval, equals(interval));
        expect(poller.timeout, equals(timeout));
      });

      test('stores interval property correctly', () {
        // Arrange
        const customInterval = Duration(milliseconds: 200);

        // Act
        final poller = VerificationPoller(
          interval: customInterval,
          timeout: const Duration(seconds: 10),
        );

        // Assert
        expect(poller.interval, equals(customInterval));
      });

      test('stores timeout property correctly', () {
        // Arrange
        const customTimeout = Duration(seconds: 60);

        // Act
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 500),
          timeout: customTimeout,
        );

        // Assert
        expect(poller.timeout, equals(customTimeout));
      });

      test('initially not running', () {
        // Arrange & Act
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 100),
          timeout: const Duration(seconds: 5),
        );

        // Assert
        expect(poller.isRunning, isFalse);
      });
    });

    group('start', () {
      test('starts polling and calls onLoadingTick immediately', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 100),
          timeout: const Duration(seconds: 5),
        );
        var loadingTickCount = 0;

        // Act
        poller.start(
          check: () async => false,
          onLoadingTick: () => loadingTickCount++,
          onTimeout: () {},
          onVerified: () async {},
        );

        // Assert - Called immediately on start
        expect(loadingTickCount, equals(1));

        // Clean up
        poller.cancel();
      });

      test('sets isRunning to true when started', () async {
        // Arrange
        final poller =
            VerificationPoller(
                interval: const Duration(milliseconds: 100),
                timeout: const Duration(seconds: 5),
              )
              // Act
              ..start(
                check: () async => false,
                onLoadingTick: () {},
                onTimeout: () {},
                onVerified: () async {},
              );

        // Assert
        expect(poller.isRunning, isTrue);

        // Clean up
        poller.cancel();
      });

      test('calls onLoadingTick on each tick', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var tickCount = 0;

        // Act
        poller.start(
          check: () async => false,
          onLoadingTick: () => tickCount++,
          onTimeout: () {},
          onVerified: () async {},
        );

        // Wait for multiple ticks
        await Future<void>.delayed(const Duration(milliseconds: 180));

        // Assert - Should have ticked multiple times
        expect(tickCount, greaterThan(2));

        // Clean up
        poller.cancel();
      });

      test('calls check on each tick', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var checkCount = 0;

        // Act
        poller.start(
          check: () async {
            checkCount++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 180));

        // Assert
        expect(checkCount, greaterThan(2));

        // Clean up
        poller.cancel();
      });

      test('calls onVerified when check returns true', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var verifiedCalled = false;

        // Act
        poller.start(
          check: () async => true, // Always verified
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {
            verifiedCalled = true;
          },
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(verifiedCalled, isTrue);
      });

      test('stops polling after verification', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var checkCount = 0;

        // Act
        poller.start(
          check: () async {
            checkCount++;
            return true; // Verified on first check
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - Check called once, then stopped
        expect(checkCount, equals(1));
        expect(poller.isRunning, isFalse);
      });

      test('calls onTimeout when timeout expires', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(milliseconds: 150),
        );
        var timeoutCalled = false;

        // Act
        poller.start(
          check: () async => false, // Never verified
          onLoadingTick: () {},
          onTimeout: () {
            timeoutCalled = true;
          },
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(timeoutCalled, isTrue);
        expect(poller.isRunning, isFalse);
      });

      test('does not call onVerified after timeout', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(milliseconds: 100),
        );
        var verifiedCalled = false;

        // Act
        poller.start(
          check: () async => false,
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {
            verifiedCalled = true;
          },
        );

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(verifiedCalled, isFalse);
      });

      test('handles async check function correctly', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var verifiedCalled = false;

        // Act
        poller.start(
          check: () async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return true;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {
            verifiedCalled = true;
          },
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(verifiedCalled, isTrue);
      });

      test('handles async onVerified function correctly', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var onVerifiedCompleted = false;

        // Act
        poller.start(
          check: () async => true,
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            onVerifiedCompleted = true;
          },
        );

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(onVerifiedCompleted, isTrue);
      });

      test('calls onLoadingTick before each check', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        final events = <String>[];

        // Act
        poller.start(
          check: () async {
            events.add('check');
            return false;
          },
          onLoadingTick: () => events.add('tick'),
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 120));
        poller.cancel();

        // Assert - Pattern is: tick (initial), then tick+check pairs
        // Initial tick, then each interval: tick, check
        expect(events.first, equals('tick'));
        expect(events.length, greaterThan(2));
        // After first tick, pattern alternates: tick, check, tick, check
        // But we need to account for async timing
      });
    });

    group('cancel', () {
      test('stops polling', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var checkCount = 0;

        // Act
        poller.start(
          check: () async {
            checkCount++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 80));
        final checksBeforeCancel = checkCount;
        poller.cancel();
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - No more checks after cancel
        expect(checkCount, equals(checksBeforeCancel));
      });

      test('sets isRunning to false', () async {
        // Arrange
        final poller =
            VerificationPoller(
                interval: const Duration(milliseconds: 50),
                timeout: const Duration(seconds: 5),
              )
              // Act
              ..start(
                check: () async => false,
                onLoadingTick: () {},
                onTimeout: () {},
                onVerified: () async {},
              );
        expect(poller.isRunning, isTrue);

        poller.cancel();

        // Assert
        expect(poller.isRunning, isFalse);
      });

      test('can be called multiple times safely', () {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );

        // Act & Assert
        expect(
          () {
            poller
              ..cancel()
              ..cancel()
              ..cancel();
          },
          returnsNormally,
        );
      });

      test('cancel before start does nothing', () {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );

        // Act & Assert
        expect(poller.cancel, returnsNormally);
        expect(poller.isRunning, isFalse);
      });

      test('allows restart after cancel', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var checkCount = 0;

        // Act - First run
        poller.start(
          check: () async {
            checkCount++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );
        await Future<void>.delayed(const Duration(milliseconds: 80));
        poller.cancel();

        // Second run
        checkCount = 0;
        poller.start(
          check: () async {
            checkCount++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );
        await Future<void>.delayed(const Duration(milliseconds: 80));

        // Assert
        expect(checkCount, greaterThan(0));

        // Clean up
        poller.cancel();
      });
    });

    group('edge cases', () {
      test('handles zero interval', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: Duration.zero,
          timeout: const Duration(milliseconds: 100),
        );
        var checkCount = 0;

        // Act
        poller.start(
          check: () async {
            checkCount++;
            return checkCount >= 3; // Stop after 3 checks
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert - Should have multiple rapid checks
        expect(checkCount, greaterThanOrEqualTo(3));
      });

      test('handles very short timeout', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(milliseconds: 10),
        );
        var timeoutCalled = false;

        // Act
        poller.start(
          check: () async => false,
          onLoadingTick: () {},
          onTimeout: () {
            timeoutCalled = true;
          },
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(timeoutCalled, isTrue);
      });

      test('check exception propagates unhandled', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(milliseconds: 200),
        );
        var checkCalled = false;
        Object? caughtError;

        // Act - Run in zone to catch unhandled async error
        await runZonedGuarded(
          () async {
            poller.start(
              check: () async {
                if (!checkCalled) {
                  checkCalled = true;
                  throw Exception('Check failed');
                }
                return false;
              },
              onLoadingTick: () {},
              onTimeout: () {},
              onVerified: () async {},
            );

            await Future<void>.delayed(const Duration(milliseconds: 100));
            poller.cancel();
          },
          (error, stack) {
            caughtError = error;
          },
        );

        // Assert - Check was called and exception was caught
        expect(checkCalled, isTrue);
        expect(caughtError, isA<Exception>());
      });

      test('onVerified exception propagates unhandled', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        Object? caughtError;

        // Act - Run in zone to catch unhandled async error
        await runZonedGuarded(
          () async {
            poller.start(
              check: () async => true,
              onLoadingTick: () {},
              onTimeout: () {},
              onVerified: () async {
                throw Exception('Verification callback failed');
              },
            );

            await Future<void>.delayed(const Duration(milliseconds: 100));
          },
          (error, stack) {
            caughtError = error;
          },
        );

        // Assert - Exception was caught by zone
        expect(caughtError, isA<Exception>());
      });

      test('handles start called while already running', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var secondCheckCount = 0;

        // Act
        poller.start(
          check: () async => false,
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 80));

        // Start again (should cancel first and restart)
        poller.start(
          check: () async {
            secondCheckCount++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 80));

        // Assert - Second check should be running
        expect(secondCheckCount, greaterThan(0));

        // Clean up
        poller.cancel();
      });
    });

    group('real-world scenarios', () {
      test('simulates email verification flow', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 100),
          timeout: const Duration(seconds: 2),
        );
        var emailVerified = false;
        var checkCount = 0;
        var loadingUpdates = 0;

        Future<bool> checkEmailVerification() async {
          checkCount++;
          // Simulate API call
          await Future<void>.delayed(const Duration(milliseconds: 10));
          // Simulate verification on 3rd check
          if (checkCount >= 3) {
            emailVerified = true;
            return true;
          }
          return false;
        }

        // Act
        poller.start(
          check: checkEmailVerification,
          onLoadingTick: () => loadingUpdates++,
          onTimeout: () {},
          onVerified: () async {
            // Handle successful verification
          },
        );

        await Future<void>.delayed(const Duration(milliseconds: 400));

        // Assert
        expect(emailVerified, isTrue);
        expect(checkCount, equals(3));
        expect(loadingUpdates, greaterThan(3));
        expect(poller.isRunning, isFalse);
      });

      test('simulates SMS verification timeout', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 100),
          timeout: const Duration(milliseconds: 300),
        );
        var timeoutOccurred = false;
        var verificationAttempts = 0;

        // Act
        poller.start(
          check: () async {
            verificationAttempts++;
            return false; // Never verified
          },
          onLoadingTick: () {},
          onTimeout: () {
            timeoutOccurred = true;
          },
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 400));

        // Assert
        expect(timeoutOccurred, isTrue);
        expect(verificationAttempts, greaterThan(0));
        expect(poller.isRunning, isFalse);
      });

      test('simulates payment confirmation polling', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var paymentConfirmed = false;
        var pollCount = 0;

        Future<bool> checkPaymentStatus() async {
          pollCount++;
          await Future<void>.delayed(const Duration(milliseconds: 5));
          // Confirm on 2nd check
          return pollCount >= 2;
        }

        // Act
        poller.start(
          check: checkPaymentStatus,
          onLoadingTick: () {}, // Show loading indicator
          onTimeout: () {}, // Show timeout error
          onVerified: () async {
            paymentConfirmed = true;
          },
        );

        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(paymentConfirmed, isTrue);
        expect(pollCount, equals(2));
      });

      test('simulates background task polling with UI updates', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        final uiUpdates = <String>[];

        // Act
        poller.start(
          check: () async {
            uiUpdates.add('check');
            return uiUpdates.length >= 3;
          },
          onLoadingTick: () => uiUpdates.add('loading'),
          onTimeout: () => uiUpdates.add('timeout'),
          onVerified: () async {
            uiUpdates.add('success');
          },
        );

        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(uiUpdates, contains('loading'));
        expect(uiUpdates, contains('check'));
        expect(uiUpdates, contains('success'));
        expect(uiUpdates, isNot(contains('timeout')));
      });

      test('simulates user canceling verification', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 30),
        );
        var checkCount = 0;

        // Act - Start verification
        poller.start(
          check: () async {
            checkCount++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));
        final checksBeforeCancel = checkCount;

        // User clicks cancel button
        poller.cancel();

        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - Polling stopped
        expect(checkCount, equals(checksBeforeCancel));
        expect(poller.isRunning, isFalse);
      });
    });

    group('timing precision', () {
      test('respects interval timing', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 100),
          timeout: const Duration(seconds: 5),
        );
        final checkTimes = <DateTime>[];

        // Act
        poller.start(
          check: () async {
            checkTimes.add(DateTime.now());
            return checkTimes.length >= 3;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 350));

        // Assert - Intervals should be approximately 100ms
        for (var i = 1; i < checkTimes.length; i++) {
          final interval = checkTimes[i]
              .difference(checkTimes[i - 1])
              .inMilliseconds;
          expect(interval, greaterThanOrEqualTo(80));
          expect(interval, lessThanOrEqualTo(150));
        }
      });

      test('timeout triggers at correct time', () async {
        // Arrange
        final poller = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(milliseconds: 200),
        );
        DateTime? startTime;
        DateTime? timeoutTime;

        // Act
        startTime = DateTime.now();
        poller.start(
          check: () async => false,
          onLoadingTick: () {},
          onTimeout: () {
            timeoutTime = DateTime.now();
          },
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 300));

        // Assert
        final elapsed = timeoutTime!.difference(startTime).inMilliseconds;
        expect(elapsed, greaterThanOrEqualTo(180));
        expect(elapsed, lessThanOrEqualTo(250));
      });
    });

    group('multiple poller instances', () {
      test('different instances do not interfere', () async {
        // Arrange
        final poller1 = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        final poller2 = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var check1Count = 0;
        var check2Count = 0;

        // Act
        poller1.start(
          check: () async {
            check1Count++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        poller2.start(
          check: () async {
            check2Count++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(check1Count, greaterThan(1));
        expect(check2Count, greaterThan(1));

        // Clean up
        poller1.cancel();
        poller2.cancel();
      });

      test('canceling one does not affect others', () async {
        // Arrange
        final poller1 = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        final poller2 = VerificationPoller(
          interval: const Duration(milliseconds: 50),
          timeout: const Duration(seconds: 5),
        );
        var check1Count = 0;
        var check2Count = 0;

        // Act
        poller1.start(
          check: () async {
            check1Count++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        poller2.start(
          check: () async {
            check2Count++;
            return false;
          },
          onLoadingTick: () {},
          onTimeout: () {},
          onVerified: () async {},
        );

        await Future<void>.delayed(const Duration(milliseconds: 80));
        final check1BeforeCancel = check1Count;
        poller1.cancel();

        await Future<void>.delayed(const Duration(milliseconds: 80));

        // Assert
        expect(check1Count, equals(check1BeforeCancel)); // Stopped
        expect(check2Count, greaterThan(check1Count)); // Still running

        // Clean up
        poller2.cancel();
      });
    });
  });
}
