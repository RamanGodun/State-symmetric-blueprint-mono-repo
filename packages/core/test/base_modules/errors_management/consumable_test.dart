/// Tests for `Consumable<T>` wrapper
///
/// Tests cover:
/// - One-time consumption behavior
/// - Peek without consumption
/// - Reset functionality
/// - State tracking (isConsumed)
/// - Edge cases (null values, multiple consume calls)
/// - ConsumableX extension
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Consumable<T>', () {
    group('construction', () {
      test('creates instance with value', () {
        // Arrange & Act
        final consumable = Consumable<int>(42);

        // Assert
        expect(consumable, isA<Consumable<int>>());
        expect(consumable.isConsumed, isFalse);
      });

      test('accepts null values', () {
        // Arrange & Act
        final consumable = Consumable<int?>(null);

        // Assert
        expect(consumable, isA<Consumable<int?>>());
        expect(consumable.peek(), isNull);
      });

      test('works with different types', () {
        // Arrange & Act
        final stringConsumable = Consumable<String>('test');
        final listConsumable = Consumable<List<int>>([1, 2, 3]);
        final mapConsumable = Consumable<Map<String, int>>({'a': 1});

        // Assert
        expect(stringConsumable.peek(), equals('test'));
        expect(listConsumable.peek(), equals([1, 2, 3]));
        expect(mapConsumable.peek(), equals({'a': 1}));
      });
    });

    group('consume', () {
      test('returns value on first call', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Act
        final result = consumable.consume();

        // Assert
        expect(result, equals(42));
      });

      test('returns null on second call', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Act
        final first = consumable.consume();
        final second = consumable.consume();

        // Assert
        expect(first, equals(42));
        expect(second, isNull);
      });

      test('returns null on subsequent calls', () {
        // Arrange
        final consumable = Consumable<String>('value')
          // Act
          ..consume(); // First call
        final second = consumable.consume();
        final third = consumable.consume();
        final fourth = consumable.consume();

        // Assert
        expect(second, isNull);
        expect(third, isNull);
        expect(fourth, isNull);
      });

      test('marks as consumed after first call', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Act
        expect(consumable.isConsumed, isFalse);
        consumable.consume();

        // Assert
        expect(consumable.isConsumed, isTrue);
      });

      test('handles null values correctly', () {
        // Arrange
        final consumable = Consumable<int?>(null);

        // Act
        final first = consumable.consume();
        final second = consumable.consume();

        // Assert
        expect(first, isNull);
        expect(second, isNull);
        expect(consumable.isConsumed, isTrue);
      });
    });

    group('peek', () {
      test('returns value without consuming', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Act
        final peeked = consumable.peek();

        // Assert
        expect(peeked, equals(42));
        expect(consumable.isConsumed, isFalse);
      });

      test('can be called multiple times', () {
        // Arrange
        final consumable = Consumable<String>('test');

        // Act
        final first = consumable.peek();
        final second = consumable.peek();
        final third = consumable.peek();

        // Assert
        expect(first, equals('test'));
        expect(second, equals('test'));
        expect(third, equals('test'));
        expect(consumable.isConsumed, isFalse);
      });

      test('returns value even after consumption', () {
        // Arrange
        final consumable = Consumable<int>(42)
          // Act
          ..consume();
        final peeked = consumable.peek();

        // Assert
        expect(peeked, equals(42));
        expect(consumable.isConsumed, isTrue);
      });

      test('returns null for null value without consuming', () {
        // Arrange
        final consumable = Consumable<int?>(null);

        // Act
        final peeked = consumable.peek();

        // Assert
        expect(peeked, isNull);
        expect(consumable.isConsumed, isFalse);
      });

      test('does not interfere with consume', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Act
        final peeked = consumable.peek();
        final consumed = consumable.consume();

        // Assert
        expect(peeked, equals(42));
        expect(consumed, equals(42));
        expect(consumable.isConsumed, isTrue);
      });
    });

    group('reset', () {
      test('allows value to be consumed again', () {
        // Arrange
        final consumable = Consumable<int>(42)
          ..consume()
          // Act
          ..reset();
        final result = consumable.consume();

        // Assert
        expect(result, equals(42));
        expect(consumable.isConsumed, isTrue);
      });

      test('clears consumed state', () {
        // Arrange
        final consumable = Consumable<String>('test')
          ..consume()
          // Act
          ..reset();

        // Assert
        expect(consumable.isConsumed, isFalse);
      });

      test('can be called multiple times', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Act & Assert
        for (var i = 0; i < 5; i++) {
          final value = consumable.consume();
          expect(value, equals(42));
          expect(consumable.isConsumed, isTrue);

          consumable.reset();
          expect(consumable.isConsumed, isFalse);
        }
      });

      test('does not affect unconsumed state', () {
        // Arrange
        final consumable = Consumable<int>(42)
          // Act
          ..reset();

        // Assert
        expect(consumable.isConsumed, isFalse);
        expect(consumable.consume(), equals(42));
      });

      test('preserves the value', () {
        // Arrange
        final consumable = Consumable<String>('value')
          ..consume()
          // Act
          ..reset();

        // Assert
        expect(consumable.peek(), equals('value'));
        expect(consumable.consume(), equals('value'));
      });
    });

    group('isConsumed', () {
      test('returns false initially', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Assert
        expect(consumable.isConsumed, isFalse);
      });

      test('returns true after consume', () {
        // Arrange
        final consumable = Consumable<int>(42)
          // Act
          ..consume();

        // Assert
        expect(consumable.isConsumed, isTrue);
      });

      test('returns false after reset', () {
        // Arrange
        final consumable = Consumable<int>(42)
          ..consume()
          // Act
          ..reset();

        // Assert
        expect(consumable.isConsumed, isFalse);
      });

      test('is not affected by peek', () {
        // Arrange
        final consumable = Consumable<int>(42)
          // Act
          ..peek()
          ..peek()
          ..peek();

        // Assert
        expect(consumable.isConsumed, isFalse);
      });
    });

    group('toString', () {
      test('shows value and consumed state', () {
        // Arrange
        final consumable = Consumable<int>(42);

        // Act
        final string = consumable.toString();

        // Assert
        expect(string, contains('42'));
        expect(string, contains('false'));
      });

      test('shows consumed state after consumption', () {
        // Arrange
        final consumable = Consumable<String>('test')..consume();

        // Act
        final string = consumable.toString();

        // Assert
        expect(string, contains('test'));
        expect(string, contains('true'));
      });

      test('handles null values', () {
        // Arrange
        final consumable = Consumable<int?>(null);

        // Act
        final string = consumable.toString();

        // Assert
        expect(string, contains('null'));
      });
    });

    group('edge cases', () {
      test('handles complex objects', () {
        // Arrange
        final data = {
          'key': [1, 2, 3],
        };
        final consumable = Consumable<Map<String, List<int>>>(data);

        // Act
        final consumed = consumable.consume();

        // Assert
        expect(consumed, equals(data));
        expect(consumable.consume(), isNull);
      });

      test('maintains reference to mutable objects', () {
        // Arrange
        final list = [1, 2, 3];
        final consumable = Consumable<List<int>>(list);

        // Act
        list.add(4);
        final peeked = consumable.peek();

        // Assert
        expect(peeked, equals([1, 2, 3, 4]));
      });

      test('works with custom classes', () {
        // Arrange
        final date = DateTime(2024);
        final consumable = Consumable<DateTime>(date);

        // Act
        final consumed = consumable.consume();

        // Assert
        expect(consumed, equals(date));
        expect(consumable.consume(), isNull);
      });

      test('zero is treated as valid value', () {
        // Arrange
        final consumable = Consumable<int>(0);

        // Act
        final result = consumable.consume();

        // Assert
        expect(result, equals(0));
        expect(consumable.consume(), isNull);
      });

      test('empty string is treated as valid value', () {
        // Arrange
        final consumable = Consumable<String>('');

        // Act
        final result = consumable.consume();

        // Assert
        expect(result, equals(''));
        expect(consumable.consume(), isNull);
      });

      test('false is treated as valid value', () {
        // Arrange
        final consumable = Consumable<bool>(false);

        // Act
        final result = consumable.consume();

        // Assert
        expect(result, isFalse);
        expect(consumable.consume(), isNull);
      });
    });

    group('use cases', () {
      test('prevents duplicate side effects', () {
        // Arrange
        final consumable = Consumable<String>('Show dialog');
        var sideEffectCount = 0;

        void showDialog(String? message) {
          if (message != null) sideEffectCount++;
        }

        // Act
        showDialog(consumable.consume()); // First call - should show
        showDialog(consumable.consume()); // Second call - should not show
        showDialog(consumable.consume()); // Third call - should not show

        // Assert
        expect(sideEffectCount, equals(1));
      });

      test('can be reset for testing', () {
        // Arrange
        final consumable = Consumable<String>('Error message');
        var callCount = 0;

        void handleError(String? error) {
          if (error != null) callCount++;
        }

        // Act - First test
        handleError(consumable.consume());
        expect(callCount, equals(1));

        // Act - Reset for second test
        consumable.reset();
        handleError(consumable.consume());

        // Assert
        expect(callCount, equals(2));
      });
    });
  });

  group('ConsumableX extension', () {
    group('asConsumable', () {
      test('wraps value in Consumable', () {
        // Arrange
        const value = 42;

        // Act
        final consumable = value.asConsumable();

        // Assert
        expect(consumable, isA<Consumable<int>>());
        expect(consumable.peek(), equals(42));
      });

      test('works with strings', () {
        // Arrange
        const value = 'test';

        // Act
        final consumable = value.asConsumable();

        // Assert
        expect(consumable.consume(), equals('test'));
        expect(consumable.consume(), isNull);
      });

      test('works with lists', () {
        // Arrange
        final value = [1, 2, 3];

        // Act
        final consumable = value.asConsumable();

        // Assert
        expect(consumable.consume(), equals([1, 2, 3]));
      });

      test('works with maps', () {
        // Arrange
        final value = {'key': 'value'};

        // Act
        final consumable = value.asConsumable();

        // Assert
        expect(consumable.peek(), equals({'key': 'value'}));
      });

      test('works with null', () {
        // Arrange
        const int? value = null;

        // Act
        final consumable = value.asConsumable();

        // Assert
        expect(consumable.peek(), isNull);
        expect(consumable.consume(), isNull);
        expect(consumable.isConsumed, isTrue);
      });

      test('works with custom objects', () {
        // Arrange
        final value = DateTime(2024);

        // Act
        final consumable = value.asConsumable();

        // Assert
        expect(consumable.consume(), equals(value));
      });

      test('creates independent instances', () {
        // Arrange
        const value = 'test';

        // Act
        final first = value.asConsumable();
        final second = value.asConsumable();

        first.consume();

        // Assert
        expect(first.isConsumed, isTrue);
        expect(second.isConsumed, isFalse);
        expect(second.consume(), equals('test'));
      });
    });

    group('chaining', () {
      test('can consume after wrapping', () {
        // Arrange & Act
        final result = 'value'.asConsumable().consume();

        // Assert
        expect(result, equals('value'));
      });

      test('can peek after wrapping', () {
        // Arrange & Act
        final result = 42.asConsumable().peek();

        // Assert
        expect(result, equals(42));
      });

      test('can check state after wrapping', () {
        // Arrange
        final consumable = 'test'.asConsumable()
          // Act
          ..consume();

        // Assert
        expect(consumable.isConsumed, isTrue);
      });
    });
  });
}
