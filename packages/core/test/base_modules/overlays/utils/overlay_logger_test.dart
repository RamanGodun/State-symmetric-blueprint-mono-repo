import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_entries/_overlay_entries_registry.dart';
import 'package:core/src/base_modules/overlays/utils/overlay_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverlayLogger', () {
    late BannerOverlayEntry testEntry;
    late DialogOverlayEntry errorEntry;

    setUp(() {
      testEntry = BannerOverlayEntry(
        widget: const Text('Test Banner'),
        priority: OverlayPriority.normal,
      );

      errorEntry = DialogOverlayEntry(
        widget: const Text('Error Dialog'),
        priority: OverlayPriority.critical,
        isError: true,
      );
    });

    group('show', () {
      test('logs overlay show event without throwing', () {
        // Act & Assert - should not throw
        expect(() => OverlayLogger.show(testEntry), returnsNormally);
      });

      test('handles banner entry', () {
        // Arrange
        final banner = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.high,
        );

        // Act & Assert
        expect(() => OverlayLogger.show(banner), returnsNormally);
      });

      test('handles dialog entry', () {
        // Arrange
        final dialog = DialogOverlayEntry(
          widget: const Text('Dialog'),
          priority: OverlayPriority.userDriven,
        );

        // Act & Assert
        expect(() => OverlayLogger.show(dialog), returnsNormally);
      });

      test('handles snackbar entry', () {
        // Arrange
        final snackbar = SnackbarOverlayEntry(
          widget: const Text('Snackbar'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert
        expect(() => OverlayLogger.show(snackbar), returnsNormally);
      });

      test('handles critical priority', () {
        // Arrange
        final critical = BannerOverlayEntry(
          widget: const Text('Critical'),
          priority: OverlayPriority.critical,
        );

        // Act & Assert
        expect(() => OverlayLogger.show(critical), returnsNormally);
      });

      test('handles error category', () {
        // Act & Assert
        expect(() => OverlayLogger.show(errorEntry), returnsNormally);
      });
    });

    group('inserted', () {
      test('logs overlay inserted event without throwing', () {
        // Act & Assert
        expect(() => OverlayLogger.inserted(testEntry), returnsNormally);
      });

      test('handles null entry', () {
        // Act & Assert
        expect(() => OverlayLogger.inserted(null), returnsNormally);
      });

      test('handles different entry types', () {
        // Arrange
        final banner = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.normal,
        );
        final dialog = DialogOverlayEntry(
          widget: const Text('Dialog'),
          priority: OverlayPriority.high,
        );
        final snackbar = SnackbarOverlayEntry(
          widget: const Text('Snackbar'),
          priority: OverlayPriority.critical,
        );

        // Act & Assert
        expect(() => OverlayLogger.inserted(banner), returnsNormally);
        expect(() => OverlayLogger.inserted(dialog), returnsNormally);
        expect(() => OverlayLogger.inserted(snackbar), returnsNormally);
      });
    });

    group('dismissed', () {
      test('logs overlay dismissed event without throwing', () {
        // Act & Assert
        expect(() => OverlayLogger.dismissed(testEntry), returnsNormally);
      });

      test('handles null entry', () {
        // Act & Assert
        expect(() => OverlayLogger.dismissed(null), returnsNormally);
      });

      test('handles different priorities', () {
        // Arrange
        final low = BannerOverlayEntry(
          widget: const Text('Low'),
          priority: OverlayPriority.normal,
        );
        final high = BannerOverlayEntry(
          widget: const Text('High'),
          priority: OverlayPriority.high,
        );
        final critical = BannerOverlayEntry(
          widget: const Text('Critical'),
          priority: OverlayPriority.critical,
        );

        // Act & Assert
        expect(() => OverlayLogger.dismissed(low), returnsNormally);
        expect(() => OverlayLogger.dismissed(high), returnsNormally);
        expect(() => OverlayLogger.dismissed(critical), returnsNormally);
      });
    });

    group('activeExists', () {
      test('logs active exists event without throwing', () {
        // Act & Assert
        expect(() => OverlayLogger.activeExists(testEntry), returnsNormally);
      });

      test('handles null entry', () {
        // Act & Assert
        expect(() => OverlayLogger.activeExists(null), returnsNormally);
      });

      test('handles different entry types', () {
        // Arrange
        final banner = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.normal,
        );
        final dialog = DialogOverlayEntry(
          widget: const Text('Dialog'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert
        expect(() => OverlayLogger.activeExists(banner), returnsNormally);
        expect(() => OverlayLogger.activeExists(dialog), returnsNormally);
      });
    });

    group('droppedSameType', () {
      test('logs dropped same type event without throwing', () {
        // Act & Assert
        expect(OverlayLogger.droppedSameType, returnsNormally);
      });

      test('can be called multiple times', () {
        // Act & Assert
        expect(() {
          OverlayLogger.droppedSameType();
          OverlayLogger.droppedSameType();
          OverlayLogger.droppedSameType();
        }, returnsNormally);
      });
    });

    group('replacing', () {
      test('logs replacing event without throwing', () {
        // Act & Assert
        expect(OverlayLogger.replacing, returnsNormally);
      });

      test('can be called multiple times', () {
        // Act & Assert
        expect(() {
          OverlayLogger.replacing();
          OverlayLogger.replacing();
          OverlayLogger.replacing();
        }, returnsNormally);
      });
    });

    group('addedToQueue', () {
      test('logs added to queue event without throwing', () {
        // Act & Assert
        expect(() => OverlayLogger.addedToQueue(1), returnsNormally);
      });

      test('handles zero length', () {
        // Act & Assert
        expect(() => OverlayLogger.addedToQueue(0), returnsNormally);
      });

      test('handles large queue length', () {
        // Act & Assert
        expect(() => OverlayLogger.addedToQueue(1000), returnsNormally);
      });

      test('handles different queue lengths', () {
        // Act & Assert
        expect(() {
          OverlayLogger.addedToQueue(1);
          OverlayLogger.addedToQueue(2);
          OverlayLogger.addedToQueue(3);
          OverlayLogger.addedToQueue(10);
        }, returnsNormally);
      });
    });

    group('dismissAnimationError', () {
      test('logs error without exception details', () {
        // Act & Assert
        expect(
          () => OverlayLogger.dismissAnimationError(testEntry),
          returnsNormally,
        );
      });

      test('logs error with exception', () {
        // Arrange
        final error = Exception('Test error');

        // Act & Assert
        expect(
          () => OverlayLogger.dismissAnimationError(testEntry, error: error),
          returnsNormally,
        );
      });

      test('logs error with stack trace', () {
        // Arrange
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(
          () => OverlayLogger.dismissAnimationError(
            testEntry,
            error: error,
            stackTrace: stackTrace,
          ),
          returnsNormally,
        );
      });

      test('handles null entry', () {
        // Arrange
        final error = Exception('Test error');

        // Act & Assert
        expect(
          () => OverlayLogger.dismissAnimationError(null, error: error),
          returnsNormally,
        );
      });

      test('handles null error and stackTrace', () {
        // Act & Assert
        expect(
          () => OverlayLogger.dismissAnimationError(
            testEntry,
          ),
          returnsNormally,
        );
      });

      test('handles error only without stackTrace', () {
        // Arrange
        final error = StateError('Invalid state');

        // Act & Assert
        expect(
          () => OverlayLogger.dismissAnimationError(
            testEntry,
            error: error,
          ),
          returnsNormally,
        );
      });

      test('handles stackTrace only without error', () {
        // Arrange
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(
          () => OverlayLogger.dismissAnimationError(
            testEntry,
            stackTrace: stackTrace,
          ),
          returnsNormally,
        );
      });

      test('handles different error types', () {
        // Arrange
        final exception = Exception('Exception');
        final error = Error();
        final stateError = StateError('State error');

        // Act & Assert
        expect(
          () =>
              OverlayLogger.dismissAnimationError(testEntry, error: exception),
          returnsNormally,
        );
        expect(
          () => OverlayLogger.dismissAnimationError(testEntry, error: error),
          returnsNormally,
        );
        expect(
          () =>
              OverlayLogger.dismissAnimationError(testEntry, error: stateError),
          returnsNormally,
        );
      });
    });

    group('autoDismissed', () {
      test('logs auto dismissed event without throwing', () {
        // Act & Assert
        expect(() => OverlayLogger.autoDismissed(testEntry), returnsNormally);
      });

      test('handles null entry', () {
        // Act & Assert
        expect(() => OverlayLogger.autoDismissed(null), returnsNormally);
      });

      test('handles different entry types', () {
        // Arrange
        final banner = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.normal,
        );
        final dialog = DialogOverlayEntry(
          widget: const Text('Dialog'),
          priority: OverlayPriority.normal,
        );
        final snackbar = SnackbarOverlayEntry(
          widget: const Text('Snackbar'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert
        expect(() => OverlayLogger.autoDismissed(banner), returnsNormally);
        expect(() => OverlayLogger.autoDismissed(dialog), returnsNormally);
        expect(() => OverlayLogger.autoDismissed(snackbar), returnsNormally);
      });

      test('handles critical priority auto dismiss', () {
        // Arrange
        final critical = BannerOverlayEntry(
          widget: const Text('Critical'),
          priority: OverlayPriority.critical,
        );

        // Act & Assert
        expect(() => OverlayLogger.autoDismissed(critical), returnsNormally);
      });
    });

    group('lifecycle flow', () {
      test('logs complete overlay lifecycle', () {
        // Arrange
        final entry = BannerOverlayEntry(
          widget: const Text('Lifecycle Test'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert - simulate complete lifecycle
        expect(() {
          OverlayLogger.show(entry);
          OverlayLogger.addedToQueue(1);
          OverlayLogger.inserted(entry);
          OverlayLogger.autoDismissed(entry);
          OverlayLogger.dismissed(entry);
        }, returnsNormally);
      });

      test('logs replacement flow', () {
        // Arrange
        final entry1 = BannerOverlayEntry(
          widget: const Text('First'),
          priority: OverlayPriority.normal,
        );
        final entry2 = BannerOverlayEntry(
          widget: const Text('Second'),
          priority: OverlayPriority.high,
        );

        // Act & Assert - simulate replacement
        expect(() {
          OverlayLogger.show(entry1);
          OverlayLogger.inserted(entry1);
          OverlayLogger.show(entry2);
          OverlayLogger.activeExists(entry1);
          OverlayLogger.replacing();
          OverlayLogger.dismissed(entry1);
          OverlayLogger.inserted(entry2);
        }, returnsNormally);
      });

      test('logs drop same type flow', () {
        // Arrange
        final entry1 = BannerOverlayEntry(
          widget: const Text('First'),
          priority: OverlayPriority.normal,
        );
        final entry2 = BannerOverlayEntry(
          widget: const Text('Second'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert - simulate drop
        expect(() {
          OverlayLogger.show(entry1);
          OverlayLogger.inserted(entry1);
          OverlayLogger.show(entry2);
          OverlayLogger.activeExists(entry1);
          OverlayLogger.droppedSameType();
        }, returnsNormally);
      });

      test('logs error during dismiss', () {
        // Arrange
        final entry = BannerOverlayEntry(
          widget: const Text('Error Test'),
          priority: OverlayPriority.normal,
        );
        final error = Exception('Dismiss failed');

        // Act & Assert
        expect(() {
          OverlayLogger.show(entry);
          OverlayLogger.inserted(entry);
          OverlayLogger.dismissAnimationError(entry, error: error);
        }, returnsNormally);
      });
    });

    group('edge cases', () {
      test('handles rapid logging calls', () {
        // Arrange
        final entries = List.generate(
          100,
          (i) => BannerOverlayEntry(
            widget: Text('Entry $i'),
            priority: OverlayPriority.normal,
          ),
        );

        // Act & Assert
        expect(() {
          for (final entry in entries) {
            OverlayLogger.show(entry);
            OverlayLogger.inserted(entry);
            OverlayLogger.dismissed(entry);
          }
        }, returnsNormally);
      });

      test('handles concurrent logging', () {
        // Arrange
        final entry1 = BannerOverlayEntry(
          widget: const Text('Entry 1'),
          priority: OverlayPriority.normal,
        );
        final entry2 = DialogOverlayEntry(
          widget: const Text('Entry 2'),
          priority: OverlayPriority.high,
        );

        // Act & Assert - simulate concurrent operations
        expect(() {
          OverlayLogger.show(entry1);
          OverlayLogger.show(entry2);
          OverlayLogger.inserted(entry1);
          OverlayLogger.activeExists(entry1);
          OverlayLogger.replacing();
          OverlayLogger.dismissed(entry1);
          OverlayLogger.inserted(entry2);
        }, returnsNormally);
      });

      test('handles all priority levels', () {
        // Arrange
        final entries = [
          BannerOverlayEntry(
            widget: const Text('Normal'),
            priority: OverlayPriority.normal,
          ),
          BannerOverlayEntry(
            widget: const Text('High'),
            priority: OverlayPriority.high,
          ),
          BannerOverlayEntry(
            widget: const Text('Critical'),
            priority: OverlayPriority.critical,
          ),
          BannerOverlayEntry(
            widget: const Text('User'),
            priority: OverlayPriority.userDriven,
          ),
        ];

        // Act & Assert
        expect(() {
          for (final entry in entries) {
            OverlayLogger.show(entry);
            OverlayLogger.inserted(entry);
            OverlayLogger.dismissed(entry);
          }
        }, returnsNormally);
      });

      test('handles all categories', () {
        // Arrange
        final banner = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.normal,
        );
        final dialog = DialogOverlayEntry(
          widget: const Text('Dialog'),
          priority: OverlayPriority.normal,
        );
        final snackbar = SnackbarOverlayEntry(
          widget: const Text('Snackbar'),
          priority: OverlayPriority.normal,
        );
        final error = BannerOverlayEntry(
          widget: const Text('Error'),
          priority: OverlayPriority.normal,
          isError: true,
        );

        // Act & Assert
        expect(() {
          OverlayLogger.show(banner);
          OverlayLogger.show(dialog);
          OverlayLogger.show(snackbar);
          OverlayLogger.show(error);
        }, returnsNormally);
      });
    });

    group('integration with real scenarios', () {
      test('logs successful overlay display', () {
        // Arrange
        final entry = SnackbarOverlayEntry(
          widget: const Text('Success!'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert - typical success flow
        expect(() {
          OverlayLogger.show(entry);
          OverlayLogger.addedToQueue(1);
          OverlayLogger.inserted(entry);
          // Auto-dismiss after timeout
          OverlayLogger.autoDismissed(entry);
          OverlayLogger.dismissed(entry);
        }, returnsNormally);
      });

      test('logs critical error display', () {
        // Arrange
        final entry = DialogOverlayEntry(
          widget: const Text('Critical Error'),
          priority: OverlayPriority.critical,
          isError: true,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );

        // Act & Assert - critical error flow
        expect(() {
          OverlayLogger.show(entry);
          OverlayLogger.activeExists(null);
          OverlayLogger.replacing();
          OverlayLogger.addedToQueue(1);
          OverlayLogger.inserted(entry);
        }, returnsNormally);
      });

      test('logs queue management scenario', () {
        // Act & Assert - queue growing
        expect(() {
          OverlayLogger.addedToQueue(1);
          OverlayLogger.addedToQueue(2);
          OverlayLogger.addedToQueue(3);
          // Process queue
          OverlayLogger.addedToQueue(2);
          OverlayLogger.addedToQueue(1);
          OverlayLogger.addedToQueue(0);
        }, returnsNormally);
      });
    });
  });
}
