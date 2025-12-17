import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_entries/_overlay_entries_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BannerOverlayEntry', () {
    group('construction', () {
      test('creates instance with required parameters', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Test Banner'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.widget, isA<Text>());
        expect(entry.priority, equals(OverlayPriority.normal));
        expect(entry.isError, isFalse);
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.dismissible));
      });

      test('creates error banner when isError is true', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Error'),
          priority: OverlayPriority.high,
          isError: true,
        );

        // Assert
        expect(entry.isError, isTrue);
        expect(entry.strategy.category, equals(OverlayCategory.error));
      });

      test('accepts custom dismiss policy', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Persistent'),
          priority: OverlayPriority.normal,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );

        // Assert
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.persistent));
      });

      test('generates unique ID for each instance', () {
        // Arrange & Act
        final entry1 = BannerOverlayEntry(
          widget: const Text('Banner 1'),
          priority: OverlayPriority.normal,
        );
        final entry2 = BannerOverlayEntry(
          widget: const Text('Banner 2'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry1.id, isNotEmpty);
        expect(entry2.id, isNotEmpty);
        expect(entry1.id, isNot(equals(entry2.id)));
      });
    });

    group('strategy configuration', () {
      test('critical priority uses forceReplace policy', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Critical'),
          priority: OverlayPriority.critical,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.critical));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceReplace),
        );
      });

      test('high priority uses forceIfLowerPriority policy', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('High'),
          priority: OverlayPriority.high,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.high));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfLowerPriority),
        );
      });

      test('normal priority uses forceIfSameCategory policy', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Normal'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.normal));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfSameCategory),
        );
      });

      test('userDriven priority uses waitQueue policy', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('User'),
          priority: OverlayPriority.userDriven,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.userDriven));
        expect(entry.strategy.policy, equals(OverlayReplacePolicy.waitQueue));
      });

      test('non-error banner uses banner category', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Info'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.strategy.category, equals(OverlayCategory.banner));
      });

      test('error banner uses error category', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Error'),
          priority: OverlayPriority.normal,
          isError: true,
        );

        // Assert
        expect(entry.strategy.category, equals(OverlayCategory.error));
      });
    });

    group('behavior', () {
      test('tap passthrough is enabled', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.tapPassthroughEnabled, isTrue);
      });

      test('buildWidget returns provided widget', () {
        // Arrange
        const testWidget = Text('Test Widget');
        final entry = BannerOverlayEntry(
          widget: testWidget,
          priority: OverlayPriority.normal,
        );

        // Act
        final result = entry.buildWidget();

        // Assert
        expect(result, equals(testWidget));
      });

      test('onAutoDismissed can be called without error', () {
        // Arrange
        final entry = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert - should not throw
        expect(entry.onAutoDismissed, returnsNormally);
      });
    });

    group('integration scenarios', () {
      test('creates success banner with correct configuration', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Success!'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.isError, isFalse);
        expect(entry.priority, equals(OverlayPriority.normal));
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.dismissible));
        expect(entry.strategy.category, equals(OverlayCategory.banner));
        expect(entry.tapPassthroughEnabled, isTrue);
      });

      test('creates critical error banner with correct configuration', () {
        // Arrange & Act
        final entry = BannerOverlayEntry(
          widget: const Text('Critical Error!'),
          priority: OverlayPriority.critical,
          isError: true,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );

        // Assert
        expect(entry.isError, isTrue);
        expect(entry.priority, equals(OverlayPriority.critical));
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.persistent));
        expect(entry.strategy.category, equals(OverlayCategory.error));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceReplace),
        );
      });
    });
  });

  group('DialogOverlayEntry', () {
    group('construction', () {
      test('creates instance with required parameters', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Test Dialog'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.widget, isA<Text>());
        expect(entry.priority, equals(OverlayPriority.normal));
        expect(entry.isError, isFalse);
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.dismissible));
      });

      test('creates error dialog when isError is true', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Error Dialog'),
          priority: OverlayPriority.high,
          isError: true,
        );

        // Assert
        expect(entry.isError, isTrue);
        expect(entry.strategy.category, equals(OverlayCategory.error));
      });

      test('accepts custom dismiss policy', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Persistent Dialog'),
          priority: OverlayPriority.normal,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );

        // Assert
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.persistent));
      });

      test('generates unique ID for each instance', () {
        // Arrange & Act
        final entry1 = DialogOverlayEntry(
          widget: const Text('Dialog 1'),
          priority: OverlayPriority.normal,
        );
        final entry2 = DialogOverlayEntry(
          widget: const Text('Dialog 2'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry1.id, isNotEmpty);
        expect(entry2.id, isNotEmpty);
        expect(entry1.id, isNot(equals(entry2.id)));
      });
    });

    group('strategy configuration', () {
      test('critical priority uses forceReplace policy', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Critical'),
          priority: OverlayPriority.critical,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.critical));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceReplace),
        );
      });

      test('high priority uses forceIfLowerPriority policy', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('High'),
          priority: OverlayPriority.high,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.high));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfLowerPriority),
        );
      });

      test('normal priority uses forceIfSameCategory policy', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Normal'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.normal));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfSameCategory),
        );
      });

      test('userDriven priority uses waitQueue policy', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('User'),
          priority: OverlayPriority.userDriven,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.userDriven));
        expect(entry.strategy.policy, equals(OverlayReplacePolicy.waitQueue));
      });

      test('non-error dialog uses dialog category', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Info'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.strategy.category, equals(OverlayCategory.dialog));
      });

      test('error dialog uses error category', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Error'),
          priority: OverlayPriority.normal,
          isError: true,
        );

        // Assert
        expect(entry.strategy.category, equals(OverlayCategory.error));
      });
    });

    group('behavior', () {
      test('tap passthrough is disabled by default', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Dialog'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.tapPassthroughEnabled, isFalse);
      });

      test('buildWidget returns provided widget', () {
        // Arrange
        const testWidget = Text('Test Widget');
        final entry = DialogOverlayEntry(
          widget: testWidget,
          priority: OverlayPriority.normal,
        );

        // Act
        final result = entry.buildWidget();

        // Assert
        expect(result, equals(testWidget));
      });

      test('onAutoDismissed can be called without error', () {
        // Arrange
        final entry = DialogOverlayEntry(
          widget: const Text('Dialog'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert - should not throw
        expect(entry.onAutoDismissed, returnsNormally);
      });
    });

    group('integration scenarios', () {
      test('creates info dialog with correct configuration', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Information'),
          priority: OverlayPriority.userDriven,
        );

        // Assert
        expect(entry.isError, isFalse);
        expect(entry.priority, equals(OverlayPriority.userDriven));
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.dismissible));
        expect(entry.strategy.category, equals(OverlayCategory.dialog));
        expect(entry.tapPassthroughEnabled, isFalse);
      });

      test('creates critical error dialog with correct configuration', () {
        // Arrange & Act
        final entry = DialogOverlayEntry(
          widget: const Text('Critical Error!'),
          priority: OverlayPriority.critical,
          isError: true,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );

        // Assert
        expect(entry.isError, isTrue);
        expect(entry.priority, equals(OverlayPriority.critical));
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.persistent));
        expect(entry.strategy.category, equals(OverlayCategory.error));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceReplace),
        );
      });
    });
  });

  group('SnackbarOverlayEntry', () {
    group('construction', () {
      test('creates instance with required parameters', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Test Snackbar'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.widget, isA<Text>());
        expect(entry.priority, equals(OverlayPriority.normal));
        expect(entry.isError, isFalse);
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.dismissible));
      });

      test('creates error snackbar when isError is true', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Error Snackbar'),
          priority: OverlayPriority.high,
          isError: true,
        );

        // Assert
        expect(entry.isError, isTrue);
        expect(entry.strategy.category, equals(OverlayCategory.error));
      });

      test('accepts custom dismiss policy', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Persistent Snackbar'),
          priority: OverlayPriority.normal,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );

        // Assert
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.persistent));
      });

      test('generates unique ID for each instance', () {
        // Arrange & Act
        final entry1 = SnackbarOverlayEntry(
          widget: const Text('Snackbar 1'),
          priority: OverlayPriority.normal,
        );
        final entry2 = SnackbarOverlayEntry(
          widget: const Text('Snackbar 2'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry1.id, isNotEmpty);
        expect(entry2.id, isNotEmpty);
        expect(entry1.id, isNot(equals(entry2.id)));
      });
    });

    group('strategy configuration', () {
      test('critical priority uses forceReplace policy', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Critical'),
          priority: OverlayPriority.critical,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.critical));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceReplace),
        );
      });

      test('high priority uses forceIfLowerPriority policy', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('High'),
          priority: OverlayPriority.high,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.high));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfLowerPriority),
        );
      });

      test('normal priority uses forceIfSameCategory policy', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Normal'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.normal));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfSameCategory),
        );
      });

      test('userDriven priority uses waitQueue policy', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('User'),
          priority: OverlayPriority.userDriven,
        );

        // Assert
        expect(entry.strategy.priority, equals(OverlayPriority.userDriven));
        expect(entry.strategy.policy, equals(OverlayReplacePolicy.waitQueue));
      });

      test('non-error snackbar uses snackbar category', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Info'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.strategy.category, equals(OverlayCategory.snackbar));
      });

      test('error snackbar uses error category', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Error'),
          priority: OverlayPriority.normal,
          isError: true,
        );

        // Assert
        expect(entry.strategy.category, equals(OverlayCategory.error));
      });
    });

    group('behavior', () {
      test('tap passthrough is enabled', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Snackbar'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.tapPassthroughEnabled, isTrue);
      });

      test('buildWidget returns provided widget', () {
        // Arrange
        const testWidget = Text('Test Widget');
        final entry = SnackbarOverlayEntry(
          widget: testWidget,
          priority: OverlayPriority.normal,
        );

        // Act
        final result = entry.buildWidget();

        // Assert
        expect(result, equals(testWidget));
      });

      test('onAutoDismissed can be called without error', () {
        // Arrange
        final entry = SnackbarOverlayEntry(
          widget: const Text('Snackbar'),
          priority: OverlayPriority.normal,
        );

        // Act & Assert - should not throw
        expect(entry.onAutoDismissed, returnsNormally);
      });
    });

    group('integration scenarios', () {
      test('creates success snackbar with correct configuration', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Success!'),
          priority: OverlayPriority.normal,
        );

        // Assert
        expect(entry.isError, isFalse);
        expect(entry.priority, equals(OverlayPriority.normal));
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.dismissible));
        expect(entry.strategy.category, equals(OverlayCategory.snackbar));
        expect(entry.tapPassthroughEnabled, isTrue);
      });

      test('creates critical error snackbar with correct configuration', () {
        // Arrange & Act
        final entry = SnackbarOverlayEntry(
          widget: const Text('Critical Error!'),
          priority: OverlayPriority.critical,
          isError: true,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );

        // Assert
        expect(entry.isError, isTrue);
        expect(entry.priority, equals(OverlayPriority.critical));
        expect(entry.dismissPolicy, equals(OverlayDismissPolicy.persistent));
        expect(entry.strategy.category, equals(OverlayCategory.error));
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceReplace),
        );
      });
    });
  });

  group('OverlayConflictStrategy', () {
    test('creates instance with all parameters', () {
      // Arrange & Act
      const strategy = OverlayConflictStrategy(
        priority: OverlayPriority.high,
        policy: OverlayReplacePolicy.forceReplace,
        category: OverlayCategory.banner,
      );

      // Assert
      expect(strategy.priority, equals(OverlayPriority.high));
      expect(strategy.policy, equals(OverlayReplacePolicy.forceReplace));
      expect(strategy.category, equals(OverlayCategory.banner));
    });

    test('can be created as const', () {
      // Arrange & Act
      const strategy1 = OverlayConflictStrategy(
        priority: OverlayPriority.normal,
        policy: OverlayReplacePolicy.waitQueue,
        category: OverlayCategory.dialog,
      );
      const strategy2 = OverlayConflictStrategy(
        priority: OverlayPriority.normal,
        policy: OverlayReplacePolicy.waitQueue,
        category: OverlayCategory.dialog,
      );

      // Assert - identical const instances
      expect(identical(strategy1, strategy2), isTrue);
    });
  });

  group('Cross-entry comparisons', () {
    test('different entry types have different runtime types', () {
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

      // Assert
      expect(banner.runtimeType, isNot(equals(dialog.runtimeType)));
      expect(banner.runtimeType, isNot(equals(snackbar.runtimeType)));
      expect(dialog.runtimeType, isNot(equals(snackbar.runtimeType)));
    });

    test(
      'different entry types with same priority have different tap behavior',
      () {
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

        // Assert
        expect(banner.tapPassthroughEnabled, isTrue);
        expect(dialog.tapPassthroughEnabled, isFalse);
        expect(snackbar.tapPassthroughEnabled, isTrue);
      },
    );

    test(
      'entries with same priority but different types have different categories',
      () {
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

        // Assert
        expect(banner.strategy.category, equals(OverlayCategory.banner));
        expect(dialog.strategy.category, equals(OverlayCategory.dialog));
        expect(snackbar.strategy.category, equals(OverlayCategory.snackbar));
      },
    );

    test('error entries of different types all use error category', () {
      // Arrange
      final banner = BannerOverlayEntry(
        widget: const Text('Banner'),
        priority: OverlayPriority.normal,
        isError: true,
      );
      final dialog = DialogOverlayEntry(
        widget: const Text('Dialog'),
        priority: OverlayPriority.normal,
        isError: true,
      );
      final snackbar = SnackbarOverlayEntry(
        widget: const Text('Snackbar'),
        priority: OverlayPriority.normal,
        isError: true,
      );

      // Assert
      expect(banner.strategy.category, equals(OverlayCategory.error));
      expect(dialog.strategy.category, equals(OverlayCategory.error));
      expect(snackbar.strategy.category, equals(OverlayCategory.error));
    });
  });
}
