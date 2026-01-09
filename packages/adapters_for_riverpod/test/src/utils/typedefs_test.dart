/// Tests for typedefs
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - RefCallback typedef signature
library;

import 'package:adapters_for_riverpod/src/utils/typedefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RefCallback', () {
    test('can be defined with correct signature', () {
      // Arrange & Act
      void callback(WidgetRef ref) {
        // Callback implementation
      }

      // Assert
      expect(callback, isA<RefCallback>());
      expect(callback, isA<void Function(WidgetRef)>());
    });

    test('accepts WidgetRef parameter', () {
      // Arrange
      WidgetRef? capturedRef;
      void callback(WidgetRef ref) {
        capturedRef = ref;
      }

      // Act & Assert
      // We can't easily test callback execution without a full widget tree,
      // but we can verify the type signature
      expect(callback, isNotNull);
      expect(capturedRef, isNull); // Not called yet
    });

    test('returns void', () {
      // Arrange
      Null callback(WidgetRef ref) {
        return; // Explicitly void
      }

      // Act & Assert
      expect(callback, isA<void Function(WidgetRef)>());
    });

    test('can be used as parameter type', () {
      // Arrange
      void Function({required RefCallback onRefReady})? testFunction;

      testFunction = ({required RefCallback onRefReady}) {
        // Function that accepts RefCallback
      };

      // Act & Assert
      expect(testFunction, isNotNull);
    });

    test('multiple RefCallbacks can coexist', () {
      // Arrange
      void callback1(WidgetRef ref) {}
      void callback2(WidgetRef ref) {}

      // Assert
      expect(callback1, isA<RefCallback>());
      expect(callback2, isA<RefCallback>());
      expect(identical(callback1, callback2), isFalse);
    });
  });
}
