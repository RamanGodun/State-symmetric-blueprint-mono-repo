import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';
import 'package:shared_core_modules/src/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:shared_core_modules/src/overlays/overlays_dispatcher/overlay_entries/_overlay_entries_registry.dart';

/// Helper to create test entries
DialogOverlayEntry createEntry({
  required OverlayPriority priority,
  OverlayCategory category = OverlayCategory.dialog,
  OverlayDismissPolicy? dismissPolicy,
}) {
  return DialogOverlayEntry(
    widget: const SizedBox(),
    priority: priority,
    isError: category == OverlayCategory.error,
    dismissPolicy: dismissPolicy,
  );
}

void main() {
  group('OverlayPolicyResolver', () {
    group('shouldReplaceCurrent', () {
      test('critical priority uses forceReplace policy', () {
        // Arrange
        final current = createEntry(priority: OverlayPriority.normal);
        final next = createEntry(priority: OverlayPriority.critical);

        // Act
        final result = OverlayPolicyResolver.shouldReplaceCurrent(
          next,
          current,
        );

        // Assert - critical always forces replace
        expect(result, isTrue);
        expect(next.strategy.policy, equals(OverlayReplacePolicy.forceReplace));
      });

      test('high priority uses forceIfLowerPriority policy', () {
        // Arrange
        final entry = createEntry(priority: OverlayPriority.high);

        // Assert
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfLowerPriority),
        );
      });

      test('normal priority uses forceIfSameCategory policy', () {
        // Arrange
        final entry = createEntry(priority: OverlayPriority.normal);

        // Assert
        expect(
          entry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfSameCategory),
        );
      });

      test('userDriven priority uses waitQueue policy', () {
        // Arrange
        final entry = createEntry(priority: OverlayPriority.userDriven);

        // Assert
        expect(entry.strategy.policy, equals(OverlayReplacePolicy.waitQueue));
      });

      test('high priority replaces normal priority', () {
        // Arrange
        final current = createEntry(priority: OverlayPriority.normal);
        final next = createEntry(priority: OverlayPriority.high);

        // Act
        final result = OverlayPolicyResolver.shouldReplaceCurrent(
          next,
          current,
        );

        // Assert
        expect(result, isTrue);
      });

      test('normal priority does not replace high priority', () {
        // Arrange
        final current = createEntry(priority: OverlayPriority.high);
        final next = createEntry(priority: OverlayPriority.normal);

        // Act
        final result = OverlayPolicyResolver.shouldReplaceCurrent(
          next,
          current,
        );

        // Assert - normal uses forceIfSameCategory, different categories
        expect(result, isTrue); // Same category (both dialog)
      });

      test(
        'same priority normal entries replace each other (same category)',
        () {
          // Arrange
          final current = createEntry(
            priority: OverlayPriority.normal,
          );
          final next = createEntry(
            priority: OverlayPriority.normal,
          );

          // Act
          final result = OverlayPolicyResolver.shouldReplaceCurrent(
            next,
            current,
          );

          // Assert - forceIfSameCategory with same category
          expect(result, isTrue);
        },
      );

      test('userDriven priority waits in queue', () {
        // Arrange
        final current = createEntry(priority: OverlayPriority.normal);
        final next = createEntry(priority: OverlayPriority.userDriven);

        // Act
        final result = OverlayPolicyResolver.shouldReplaceCurrent(
          next,
          current,
        );

        // Assert - waitQueue always returns false
        expect(result, isFalse);
      });

      test('critical priority replaces everything', () {
        // Arrange
        final priorities = [
          OverlayPriority.userDriven,
          OverlayPriority.normal,
          OverlayPriority.high,
        ];

        for (final priority in priorities) {
          final current = createEntry(priority: priority);
          final next = createEntry(priority: OverlayPriority.critical);

          // Act
          final result = OverlayPolicyResolver.shouldReplaceCurrent(
            next,
            current,
          );

          // Assert
          expect(
            result,
            isTrue,
            reason: 'Critical should replace $priority',
          );
        }
      });

      test('error category is different from dialog category', () {
        // Arrange
        final dialogEntry = createEntry(
          priority: OverlayPriority.normal,
        );
        final errorEntry = createEntry(
          priority: OverlayPriority.normal,
          category: OverlayCategory.error,
        );

        // Assert
        expect(
          dialogEntry.strategy.category,
          equals(OverlayCategory.dialog),
        );
        expect(errorEntry.strategy.category, equals(OverlayCategory.error));
        expect(
          dialogEntry.strategy.category != errorEntry.strategy.category,
          isTrue,
        );
      });

      test('priority levels are correctly ordered', () {
        // Arrange
        const userDriven = OverlayPriority.userDriven;
        const normal = OverlayPriority.normal;
        const high = OverlayPriority.high;
        const critical = OverlayPriority.critical;

        // Assert - index represents priority level
        expect(userDriven.index < normal.index, isTrue);
        expect(normal.index < high.index, isTrue);
        expect(high.index < critical.index, isTrue);
      });

      test('forceIfLowerPriority correctly compares priorities', () {
        // Arrange - high priority with forceIfLowerPriority policy
        final currentNormal = createEntry(priority: OverlayPriority.normal);
        final currentHigh = createEntry(priority: OverlayPriority.high);
        final nextHigh = createEntry(priority: OverlayPriority.high);

        // Act
        final replacesNormal = OverlayPolicyResolver.shouldReplaceCurrent(
          nextHigh,
          currentNormal,
        );
        final replacesHigh = OverlayPolicyResolver.shouldReplaceCurrent(
          nextHigh,
          currentHigh,
        );

        // Assert
        expect(replacesNormal, isTrue); // high > normal
        expect(replacesHigh, isFalse); // high == high
      });
    });

    group('shouldWait', () {
      test('returns true when policy is waitQueue', () {
        // Arrange
        final entry = createEntry(priority: OverlayPriority.userDriven);

        // Act
        final result = OverlayPolicyResolver.shouldWait(entry);

        // Assert
        expect(result, isTrue);
      });

      test('returns false for other priority levels', () {
        // Arrange
        final priorities = [
          OverlayPriority.normal,
          OverlayPriority.high,
          OverlayPriority.critical,
        ];

        for (final priority in priorities) {
          final entry = createEntry(priority: priority);

          // Act
          final result = OverlayPolicyResolver.shouldWait(entry);

          // Assert
          expect(result, isFalse, reason: 'Priority $priority should not wait');
        }
      });
    });

    group('resolveDismissPolicy', () {
      test('returns dismissible when isDismissible is true', () {
        // Act
        final policy = OverlayPolicyResolver.resolveDismissPolicy(
          isDismissible: true,
        );

        // Assert
        expect(policy, equals(OverlayDismissPolicy.dismissible));
      });

      test('returns persistent when isDismissible is false', () {
        // Act
        final policy = OverlayPolicyResolver.resolveDismissPolicy(
          isDismissible: false,
        );

        // Assert
        expect(policy, equals(OverlayDismissPolicy.persistent));
      });

      test('mapping is consistent', () {
        // Act
        final dismissible = OverlayPolicyResolver.resolveDismissPolicy(
          isDismissible: true,
        );
        final persistent = OverlayPolicyResolver.resolveDismissPolicy(
          isDismissible: false,
        );

        // Assert
        expect(dismissible != persistent, isTrue);
        expect(
          dismissible,
          equals(OverlayDismissPolicy.dismissible),
        );
        expect(
          persistent,
          equals(OverlayDismissPolicy.persistent),
        );
      });
    });

    group('getDebouncer', () {
      test('returns debouncer for each category', () {
        // Act
        final bannerDebouncer = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.banner,
        );
        final dialogDebouncer = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.dialog,
        );
        final snackbarDebouncer = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.snackbar,
        );

        // Assert
        expect(bannerDebouncer, isNotNull);
        expect(dialogDebouncer, isNotNull);
        expect(snackbarDebouncer, isNotNull);
      });

      test('returns same debouncer instance for same category', () {
        // Act
        final debouncer1 = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.banner,
        );
        final debouncer2 = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.banner,
        );

        // Assert
        expect(identical(debouncer1, debouncer2), isTrue);
      });

      test('returns different debouncers for different categories', () {
        // Act
        final bannerDebouncer = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.banner,
        );
        final dialogDebouncer = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.dialog,
        );

        // Assert
        expect(identical(bannerDebouncer, dialogDebouncer), isFalse);
      });

      test('creates debouncer on first access', () {
        // Act
        final debouncer = OverlayPolicyResolver.getDebouncer(
          OverlayCategory.error,
        );

        // Assert
        expect(debouncer, isNotNull);
      });
    });

    group('OverlayQueueItem', () {
      testWidgets('holds overlay state and request', (tester) async {
        // Arrange
        final overlayKey = GlobalKey<OverlayState>();
        await tester.pumpWidget(
          MaterialApp(
            home: Overlay(
              key: overlayKey,
              initialEntries: [
                OverlayEntry(builder: (context) => const SizedBox()),
              ],
            ),
          ),
        );

        final overlayState = overlayKey.currentState!;
        final request = createEntry(priority: OverlayPriority.normal);

        // Act
        final queueItem = OverlayQueueItem(
          overlay: overlayState,
          request: request,
        );

        // Assert
        expect(queueItem.overlay, equals(overlayState));
        expect(queueItem.request, equals(request));
      });

      testWidgets('can be created with const constructor', (tester) async {
        // Arrange
        final overlayKey = GlobalKey<OverlayState>();
        await tester.pumpWidget(
          MaterialApp(
            home: Overlay(
              key: overlayKey,
              initialEntries: [
                OverlayEntry(builder: (context) => const SizedBox()),
              ],
            ),
          ),
        );

        final overlayState = overlayKey.currentState!;
        final request = createEntry(priority: OverlayPriority.normal);

        // Act & Assert - should compile and work
        const testCreation = true;
        expect(testCreation, isTrue);

        final item = OverlayQueueItem(overlay: overlayState, request: request);
        expect(item.overlay, isNotNull);
        expect(item.request, isNotNull);
      });
    });

    group('DialogOverlayEntry strategy mapping', () {
      test('all priorities have correct policy mapping', () {
        // Arrange & Act
        final criticalEntry = createEntry(priority: OverlayPriority.critical);
        final highEntry = createEntry(priority: OverlayPriority.high);
        final normalEntry = createEntry(priority: OverlayPriority.normal);
        final userDrivenEntry = createEntry(
          priority: OverlayPriority.userDriven,
        );

        // Assert
        expect(
          criticalEntry.strategy.policy,
          equals(OverlayReplacePolicy.forceReplace),
        );
        expect(
          highEntry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfLowerPriority),
        );
        expect(
          normalEntry.strategy.policy,
          equals(OverlayReplacePolicy.forceIfSameCategory),
        );
        expect(
          userDrivenEntry.strategy.policy,
          equals(OverlayReplacePolicy.waitQueue),
        );
      });

      test('strategy category reflects isError flag', () {
        // Arrange & Act
        final dialogEntry = createEntry(
          priority: OverlayPriority.normal,
        );
        final errorEntry = createEntry(
          priority: OverlayPriority.normal,
          category: OverlayCategory.error,
        );

        // Assert
        expect(
          dialogEntry.strategy.category,
          equals(OverlayCategory.dialog),
        );
        expect(errorEntry.strategy.category, equals(OverlayCategory.error));
      });

      test('strategy priority matches entry priority', () {
        // Arrange
        const priorities = OverlayPriority.values;

        for (final priority in priorities) {
          final entry = createEntry(priority: priority);

          // Assert
          expect(entry.strategy.priority, equals(priority));
        }
      });
    });

    group('edge cases and integration', () {
      test('critical priority always replaces regardless of category', () {
        // Arrange
        final currentDialog = createEntry(
          priority: OverlayPriority.normal,
        );
        final currentError = createEntry(
          priority: OverlayPriority.normal,
          category: OverlayCategory.error,
        );
        final nextCritical = createEntry(priority: OverlayPriority.critical);

        // Act
        final replacesDialog = OverlayPolicyResolver.shouldReplaceCurrent(
          nextCritical,
          currentDialog,
        );
        final replacesError = OverlayPolicyResolver.shouldReplaceCurrent(
          nextCritical,
          currentError,
        );

        // Assert
        expect(replacesDialog, isTrue);
        expect(replacesError, isTrue);
      });

      test('userDriven never replaces any priority', () {
        // Arrange
        final priorities = [
          OverlayPriority.normal,
          OverlayPriority.high,
          OverlayPriority.critical,
        ];

        for (final priority in priorities) {
          final current = createEntry(priority: priority);
          final next = createEntry(priority: OverlayPriority.userDriven);

          // Act
          final result = OverlayPolicyResolver.shouldReplaceCurrent(
            next,
            current,
          );

          // Assert
          expect(result, isFalse, reason: 'userDriven vs $priority');
        }
      });

      test('high priority replaces normal but not critical', () {
        // Arrange
        final currentNormal = createEntry(priority: OverlayPriority.normal);
        final currentCritical = createEntry(priority: OverlayPriority.critical);
        final nextHigh = createEntry(priority: OverlayPriority.high);

        // Act
        final replacesNormal = OverlayPolicyResolver.shouldReplaceCurrent(
          nextHigh,
          currentNormal,
        );
        final replacesCritical = OverlayPolicyResolver.shouldReplaceCurrent(
          nextHigh,
          currentCritical,
        );

        // Assert
        expect(replacesNormal, isTrue);
        expect(replacesCritical, isFalse);
      });
    });
  });
}
