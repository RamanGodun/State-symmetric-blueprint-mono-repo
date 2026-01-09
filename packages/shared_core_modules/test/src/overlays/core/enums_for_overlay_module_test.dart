import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';

void main() {
  group('OverlayPriority', () {
    test('has all expected values in correct order', () {
      // Arrange & Act
      const values = OverlayPriority.values;

      // Assert
      expect(values, hasLength(4));
      expect(values[0], equals(OverlayPriority.userDriven));
      expect(values[1], equals(OverlayPriority.normal));
      expect(values[2], equals(OverlayPriority.high));
      expect(values[3], equals(OverlayPriority.critical));
    });

    test('priority order is correct for comparison', () {
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

    test('critical has highest priority index', () {
      // Arrange
      const critical = OverlayPriority.critical;

      // Act
      final allOtherPriorities = OverlayPriority.values
          .where((p) => p != OverlayPriority.critical)
          .toList();

      // Assert
      for (final priority in allOtherPriorities) {
        expect(critical.index > priority.index, isTrue);
      }
    });
  });

  group('OverlayCategory', () {
    test('has all expected values', () {
      // Arrange & Act
      const values = OverlayCategory.values;

      // Assert
      expect(values, hasLength(4));
      expect(values, contains(OverlayCategory.banner));
      expect(values, contains(OverlayCategory.dialog));
      expect(values, contains(OverlayCategory.snackbar));
      expect(values, contains(OverlayCategory.error));
    });

    test('can be used in switch statement', () {
      // Arrange
      const category = OverlayCategory.dialog;
      String result;

      // Act
      result = switch (category) {
        OverlayCategory.banner => 'banner',
        OverlayCategory.dialog => 'dialog',
        OverlayCategory.snackbar => 'snackbar',
        OverlayCategory.error => 'error',
      };

      // Assert
      expect(result, equals('dialog'));
    });

    test('enum values are distinct', () {
      // Arrange
      const values = OverlayCategory.values;

      // Act
      final uniqueValues = values.toSet();

      // Assert
      expect(uniqueValues.length, equals(values.length));
    });
  });

  group('OverlayDismissPolicy', () {
    test('has expected values', () {
      // Arrange & Act
      const values = OverlayDismissPolicy.values;

      // Assert
      expect(values, hasLength(2));
      expect(values, contains(OverlayDismissPolicy.dismissible));
      expect(values, contains(OverlayDismissPolicy.persistent));
    });

    test('dismissible indicates can be dismissed', () {
      // Arrange
      const policy = OverlayDismissPolicy.dismissible;

      // Act
      const isDismissible = policy == OverlayDismissPolicy.dismissible;

      // Assert
      expect(isDismissible, isTrue);
    });

    test('persistent indicates cannot be dismissed externally', () {
      // Arrange
      const policy = OverlayDismissPolicy.persistent;

      // Act
      const isPersistent = policy == OverlayDismissPolicy.persistent;

      // Assert
      expect(isPersistent, isTrue);
    });

    test('dismissible and persistent are mutually exclusive', () {
      // Arrange
      const dismissible = OverlayDismissPolicy.dismissible;
      const persistent = OverlayDismissPolicy.persistent;

      // Assert
      expect(dismissible == persistent, isFalse);
      expect(dismissible != persistent, isTrue);
    });
  });

  group('OverlayReplacePolicy', () {
    test('has all expected values', () {
      // Arrange & Act
      const values = OverlayReplacePolicy.values;

      // Assert
      expect(values, hasLength(5));
      expect(values, contains(OverlayReplacePolicy.waitQueue));
      expect(values, contains(OverlayReplacePolicy.forceReplace));
      expect(values, contains(OverlayReplacePolicy.forceIfSameCategory));
      expect(values, contains(OverlayReplacePolicy.forceIfLowerPriority));
      expect(values, contains(OverlayReplacePolicy.dropIfSameType));
    });

    test('waitQueue indicates should wait in queue', () {
      // Arrange
      const policy = OverlayReplacePolicy.waitQueue;

      // Act
      const shouldWait = policy == OverlayReplacePolicy.waitQueue;

      // Assert
      expect(shouldWait, isTrue);
    });

    test('forceReplace indicates immediate replacement', () {
      // Arrange
      const policy = OverlayReplacePolicy.forceReplace;

      // Act
      const shouldForce = policy == OverlayReplacePolicy.forceReplace;

      // Assert
      expect(shouldForce, isTrue);
    });

    test('all policies are distinct', () {
      // Arrange
      const values = OverlayReplacePolicy.values;

      // Act
      final uniqueValues = values.toSet();

      // Assert
      expect(uniqueValues.length, equals(values.length));
    });

    test('can be used in pattern matching', () {
      // Arrange
      const policy = OverlayReplacePolicy.forceIfSameCategory;
      bool result;

      // Act
      result = switch (policy) {
        OverlayReplacePolicy.waitQueue => false,
        OverlayReplacePolicy.forceReplace => true,
        OverlayReplacePolicy.forceIfSameCategory => true,
        OverlayReplacePolicy.forceIfLowerPriority => true,
        OverlayReplacePolicy.dropIfSameType => false,
      };

      // Assert
      expect(result, isTrue);
    });
  });

  group('ShowAs', () {
    test('has all expected values', () {
      // Arrange & Act
      const values = ShowAs.values;

      // Assert
      expect(values, hasLength(4));
      expect(values, contains(ShowAs.banner));
      expect(values, contains(ShowAs.snackbar));
      expect(values, contains(ShowAs.dialog));
      expect(values, contains(ShowAs.infoDialog));
    });

    test('can differentiate between dialog types', () {
      // Arrange
      const regularDialog = ShowAs.dialog;
      const infoDialog = ShowAs.infoDialog;

      // Assert
      expect(regularDialog == infoDialog, isFalse);
      expect(regularDialog != infoDialog, isTrue);
    });

    test('supports all common overlay presentation types', () {
      // Arrange & Act
      final hasBanner = ShowAs.values.contains(ShowAs.banner);
      final hasSnackbar = ShowAs.values.contains(ShowAs.snackbar);
      final hasDialog = ShowAs.values.contains(ShowAs.dialog);

      // Assert
      expect(hasBanner, isTrue);
      expect(hasSnackbar, isTrue);
      expect(hasDialog, isTrue);
    });
  });

  group('OverlayBlurLevel', () {
    test('has all expected values in intensity order', () {
      // Arrange & Act
      const values = OverlayBlurLevel.values;

      // Assert
      expect(values, hasLength(3));
      expect(values[0], equals(OverlayBlurLevel.soft));
      expect(values[1], equals(OverlayBlurLevel.medium));
      expect(values[2], equals(OverlayBlurLevel.strong));
    });

    test('blur levels have ascending intensity', () {
      // Arrange
      const soft = OverlayBlurLevel.soft;
      const medium = OverlayBlurLevel.medium;
      const strong = OverlayBlurLevel.strong;

      // Assert - index represents intensity
      expect(soft.index < medium.index, isTrue);
      expect(medium.index < strong.index, isTrue);
    });

    test('can be compared by index for intensity', () {
      // Arrange
      const levels = [
        OverlayBlurLevel.strong,
        OverlayBlurLevel.soft,
        OverlayBlurLevel.medium,
      ];

      // Act
      final sorted = levels.toList()
        ..sort((a, b) => a.index.compareTo(b.index));

      // Assert
      expect(sorted[0], equals(OverlayBlurLevel.soft));
      expect(sorted[1], equals(OverlayBlurLevel.medium));
      expect(sorted[2], equals(OverlayBlurLevel.strong));
    });
  });

  group('OverlayWiringScope', () {
    test('has all expected values', () {
      // Arrange & Act
      const values = OverlayWiringScope.values;

      // Assert
      expect(values, hasLength(3));
      expect(values, contains(OverlayWiringScope.contextOnly));
      expect(values, contains(OverlayWiringScope.globalOnly));
      expect(values, contains(OverlayWiringScope.both));
    });

    test('contextOnly targets context-aware resolver', () {
      // Arrange
      const scope = OverlayWiringScope.contextOnly;

      // Act
      const isContextOnly = scope == OverlayWiringScope.contextOnly;

      // Assert
      expect(isContextOnly, isTrue);
    });

    test('globalOnly targets global resolver', () {
      // Arrange
      const scope = OverlayWiringScope.globalOnly;

      // Act
      const isGlobalOnly = scope == OverlayWiringScope.globalOnly;

      // Assert
      expect(isGlobalOnly, isTrue);
    });

    test('both targets all resolvers', () {
      // Arrange
      const scope = OverlayWiringScope.both;

      // Act
      const isBoth = scope == OverlayWiringScope.both;

      // Assert
      expect(isBoth, isTrue);
    });

    test('all scopes are mutually exclusive', () {
      // Arrange
      const contextOnly = OverlayWiringScope.contextOnly;
      const globalOnly = OverlayWiringScope.globalOnly;
      const both = OverlayWiringScope.both;

      // Assert
      expect(contextOnly != globalOnly, isTrue);
      expect(contextOnly != both, isTrue);
      expect(globalOnly != both, isTrue);
    });
  });
}
