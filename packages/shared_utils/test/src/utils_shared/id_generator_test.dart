/// Tests for Id and IdNamespace
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Global Id.next() functionality
/// - Generator swapping (pluggable design)
/// - Reset functionality
/// - IdNamespace with prefixes
/// - Real-world scenarios (overlays, users, entities)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/public_api/general_utils.dart'
    show Id, IdGenerator, IdNamespace;

void main() {
  group('Id', () {
    // Reset to default state before each test
    setUp(Id.reset);

    group('next', () {
      test('generates unique IDs', () {
        // Arrange & Act
        final id1 = Id.next();
        final id2 = Id.next();
        final id3 = Id.next();

        // Assert
        expect(id1, isNotEmpty);
        expect(id2, isNotEmpty);
        expect(id3, isNotEmpty);
        expect(id1, isNot(equals(id2)));
        expect(id2, isNot(equals(id3)));
        expect(id1, isNot(equals(id3)));
      });

      test('returns string type', () {
        // Arrange & Act
        final id = Id.next();

        // Assert
        expect(id, isA<String>());
      });

      test('generates sequential IDs with default generator', () {
        // Arrange & Act
        final id1 = Id.next();
        final id2 = Id.next();

        // Assert - Default generator uses 'loc-' prefix with counter
        expect(id1, startsWith('loc-'));
        expect(id2, startsWith('loc-'));
      });

      test('generates multiple unique IDs in loop', () {
        // Arrange
        const count = 100;
        final ids = <String>{};

        // Act
        for (var i = 0; i < count; i++) {
          ids.add(Id.next());
        }

        // Assert - All IDs should be unique (Set removes duplicates)
        expect(ids.length, equals(count));
      });
    });

    group('generator', () {
      test('allows custom generator', () {
        // Arrange
        Id.generator = () => 'custom-id';

        // Act
        final id = Id.next();

        // Assert
        expect(id, equals('custom-id'));
      });

      test('custom generator is used for all subsequent calls', () {
        // Arrange
        var counter = 0;
        Id.generator = () => 'test-${counter++}';

        // Act
        final id1 = Id.next();
        final id2 = Id.next();
        final id3 = Id.next();

        // Assert
        expect(id1, equals('test-0'));
        expect(id2, equals('test-1'));
        expect(id3, equals('test-2'));
      });

      test('can be reassigned multiple times', () {
        // Arrange & Act
        Id.generator = () => 'generator-1';
        final id1 = Id.next();

        Id.generator = () => 'generator-2';
        final id2 = Id.next();

        Id.generator = () => 'generator-3';
        final id3 = Id.next();

        // Assert
        expect(id1, equals('generator-1'));
        expect(id2, equals('generator-2'));
        expect(id3, equals('generator-3'));
      });

      test('supports UUID-style generator', () {
        // Arrange
        Id.generator = () =>
            'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
              RegExp('[xy]'),
              (match) {
                final r = (DateTime.now().millisecondsSinceEpoch * 16) % 16;
                final v = match.group(0) == 'x' ? r : (r & 0x3 | 0x8);
                return v.toRadixString(16);
              },
            );

        // Act
        final id = Id.next();

        // Assert - Should match UUID format
        expect(id, matches(RegExp(r'^[a-f0-9-]+$')));
        expect(id.length, greaterThan(20));
      });

      test('supports deterministic generator for testing', () {
        // Arrange
        final testIds = ['test-1', 'test-2', 'test-3'];
        var index = 0;
        Id.generator = () => testIds[index++ % testIds.length];

        // Act
        final id1 = Id.next();
        final id2 = Id.next();
        final id3 = Id.next();
        final id4 = Id.next(); // Wraps around

        // Assert
        expect(id1, equals('test-1'));
        expect(id2, equals('test-2'));
        expect(id3, equals('test-3'));
        expect(id4, equals('test-1'));
      });
    });

    group('reset', () {
      test('resets generator to default', () {
        // Arrange
        Id.generator = () => 'custom-id';
        expect(Id.next(), equals('custom-id'));

        // Act
        Id.reset();
        final id = Id.next();

        // Assert - Back to default 'loc-' prefix
        expect(id, startsWith('loc-'));
      });

      test('can be called multiple times safely', () {
        // Arrange & Act
        expect(
          () {
            Id.reset();
            Id.reset();
            Id.reset();
          },
          returnsNormally,
        );
      });

      test('reset allows setting new generator after', () {
        // Arrange
        Id.generator = () => 'old';
        Id.reset();

        // Act
        Id.generator = () => 'new';
        final id = Id.next();

        // Assert
        expect(id, equals('new'));
      });
    });

    group('edge cases', () {
      test('handles generator that returns empty string', () {
        // Arrange
        Id.generator = () => '';

        // Act
        final id = Id.next();

        // Assert
        expect(id, equals(''));
      });

      test('handles generator that returns very long string', () {
        // Arrange
        Id.generator = () => 'x' * 1000;

        // Act
        final id = Id.next();

        // Assert
        expect(id.length, equals(1000));
      });

      test('handles generator with special characters', () {
        // Arrange
        Id.generator = () => r'id-@#$%^&*()';

        // Act
        final id = Id.next();

        // Assert
        expect(id, equals(r'id-@#$%^&*()'));
      });

      test('handles generator that throws exception', () {
        // Arrange
        Id.generator = () => throw Exception('Generator error');

        // Act & Assert
        expect(Id.next, throwsException);
      });
    });
  });

  group('IdNamespace', () {
    setUp(Id.reset);

    group('construction', () {
      test('creates instance with generator and prefix', () {
        // Arrange
        String generator() => '123';

        // Act
        final namespace = IdNamespace(
          generator: generator,
          prefix: 'test',
        );

        // Assert
        expect(namespace, isA<IdNamespace>());
        expect(namespace, isA<IdGenerator>());
      });

      test('creates instance from global with prefix', () {
        // Arrange & Act
        final namespace = IdNamespace.fromGlobal(prefix: 'overlay');

        // Assert
        expect(namespace, isA<IdNamespace>());
      });

      test('creates instance from global without prefix', () {
        // Arrange & Act
        final namespace = IdNamespace.fromGlobal();

        // Assert
        expect(namespace, isA<IdNamespace>());
      });
    });

    group('next', () {
      test('generates ID with prefix', () {
        // Arrange
        var counter = 0;
        final namespace = IdNamespace(
          generator: () => '${counter++}',
          prefix: 'user',
        );

        // Act
        final id1 = namespace.next();
        final id2 = namespace.next();

        // Assert
        expect(id1, equals('user-0'));
        expect(id2, equals('user-1'));
      });

      test('generates ID without prefix when null', () {
        // Arrange
        var counter = 0;
        final namespace = IdNamespace(
          generator: () => 'id-${counter++}',
        );

        // Act
        final id = namespace.next();

        // Assert
        expect(id, equals('id-0')); // No prefix added
      });

      test('generates ID without prefix when empty string', () {
        // Arrange
        var counter = 0;
        final namespace = IdNamespace(
          generator: () => 'id-${counter++}',
          prefix: '',
        );

        // Act
        final id = namespace.next();

        // Assert
        expect(id, equals('id-0')); // No prefix added
      });

      test('uses global generator when from global', () {
        // Arrange
        Id.generator = () => 'global-id';
        final namespace = IdNamespace.fromGlobal(prefix: 'test');

        // Act
        final id = namespace.next();

        // Assert
        expect(id, equals('test-global-id'));
      });

      test('reflects global generator changes', () {
        // Arrange
        final namespace = IdNamespace.fromGlobal(prefix: 'entity');

        Id.generator = () => 'gen1';
        final id1 = namespace.next();

        Id.generator = () => 'gen2';
        final id2 = namespace.next();

        // Assert
        expect(id1, equals('entity-gen1'));
        expect(id2, equals('entity-gen2'));
      });

      test('generates unique IDs across calls', () {
        // Arrange
        var counter = 0;
        final namespace = IdNamespace(
          generator: () => '${counter++}',
          prefix: 'item',
        );

        // Act
        final ids = List.generate(10, (_) => namespace.next());

        // Assert
        expect(ids.toSet().length, equals(10)); // All unique
        for (final id in ids) {
          expect(id, startsWith('item-'));
        }
      });
    });

    group('different namespaces', () {
      test('different namespaces generate different IDs', () {
        // Arrange
        var counter = 0;
        String generator() => '${counter++}';

        final userIds = IdNamespace(
          generator: generator,
          prefix: 'user',
        );
        final overlayIds = IdNamespace(
          generator: generator,
          prefix: 'overlay',
        );

        // Act
        final userId = userIds.next();
        final overlayId = overlayIds.next();

        // Assert
        expect(userId, equals('user-0'));
        expect(overlayId, equals('overlay-1'));
      });

      test('namespaces with same generator share state', () {
        // Arrange
        var counter = 0;
        String generator() => '${counter++}';

        final namespace1 = IdNamespace(
          generator: generator,
          prefix: 'ns1',
        );
        final namespace2 = IdNamespace(
          generator: generator,
          prefix: 'ns2',
        );

        // Act
        final id1 = namespace1.next();
        final id2 = namespace2.next();
        final id3 = namespace1.next();

        // Assert
        expect(id1, equals('ns1-0'));
        expect(id2, equals('ns2-1'));
        expect(id3, equals('ns1-2'));
      });

      test('namespaces from global are independent', () {
        // Arrange
        Id.reset();
        final users = IdNamespace.fromGlobal(prefix: 'user');
        final items = IdNamespace.fromGlobal(prefix: 'item');

        // Act
        final userId1 = users.next();
        final itemId1 = items.next();
        final userId2 = users.next();

        // Assert
        expect(userId1, startsWith('user-'));
        expect(itemId1, startsWith('item-'));
        expect(userId2, startsWith('user-'));
        expect(userId1, isNot(equals(userId2)));
      });
    });

    group('real-world scenarios', () {
      test('overlay ID generation', () {
        // Arrange
        var counter = 0;
        Id.generator = () => 'ov${counter++}';
        final overlayIds = IdNamespace.fromGlobal(prefix: 'overlay');

        // Act
        final bannerId = overlayIds.next();
        final dialogId = overlayIds.next();
        final snackbarId = overlayIds.next();

        // Assert
        expect(bannerId, equals('overlay-ov0'));
        expect(dialogId, equals('overlay-ov1'));
        expect(snackbarId, equals('overlay-ov2'));
      });

      test('user ID generation', () {
        // Arrange
        var counter = 1000;
        final userIds = IdNamespace(
          generator: () => '${counter++}',
          prefix: 'usr',
        );

        // Act
        final user1 = userIds.next();
        final user2 = userIds.next();

        // Assert
        expect(user1, equals('usr-1000'));
        expect(user2, equals('usr-1001'));
      });

      test('entity ID generation for DI', () {
        // Arrange - Deterministic IDs for testing
        final testIds = ['a1b2', 'c3d4', 'e5f6'];
        var index = 0;
        final entityIds = IdNamespace(
          generator: () => testIds[index++],
          prefix: 'entity',
        );

        // Act
        final id1 = entityIds.next();
        final id2 = entityIds.next();

        // Assert
        expect(id1, equals('entity-a1b2'));
        expect(id2, equals('entity-c3d4'));
      });

      test('multi-tenant ID generation', () {
        // Arrange
        var counter = 0;
        String generator() => 'id${counter++}';

        final tenant1Ids = IdNamespace(
          generator: generator,
          prefix: 'tenant1',
        );
        final tenant2Ids = IdNamespace(
          generator: generator,
          prefix: 'tenant2',
        );

        // Act
        final t1Id1 = tenant1Ids.next();
        final t2Id1 = tenant2Ids.next();
        final t1Id2 = tenant1Ids.next();

        // Assert
        expect(t1Id1, equals('tenant1-id0'));
        expect(t2Id1, equals('tenant2-id1'));
        expect(t1Id2, equals('tenant1-id2'));
      });
    });

    group('edge cases', () {
      test('handles very long prefix', () {
        // Arrange
        final longPrefix = 'x' * 100;
        final namespace = IdNamespace(
          generator: () => '123',
          prefix: longPrefix,
        );

        // Act
        final id = namespace.next();

        // Assert
        expect(id, equals('$longPrefix-123'));
      });

      test('handles prefix with special characters', () {
        // Arrange
        final namespace = IdNamespace(
          generator: () => '123',
          prefix: r'test-@#$',
        );

        // Act
        final id = namespace.next();

        // Assert
        expect(id, equals(r'test-@#$-123'));
      });

      test('handles generator returning empty string with prefix', () {
        // Arrange
        final namespace = IdNamespace(
          generator: () => '',
          prefix: 'test',
        );

        // Act
        final id = namespace.next();

        // Assert
        expect(id, equals('test-'));
      });

      test('handles null prefix explicitly', () {
        // Arrange
        final namespace = IdNamespace(
          generator: () => '123',
        );

        // Act
        final id = namespace.next();

        // Assert
        expect(id, equals('123'));
      });
    });

    group('testing utilities', () {
      test('deterministic IDs for unit tests', () {
        // Arrange - Predictable IDs for testing
        const testIds = ['test-id-1', 'test-id-2', 'test-id-3'];
        var index = 0;
        Id.generator = () => testIds[index++ % testIds.length];

        // Act
        final id1 = Id.next();
        final id2 = Id.next();
        final id3 = Id.next();

        // Assert - Predictable IDs
        expect(id1, equals('test-id-1'));
        expect(id2, equals('test-id-2'));
        expect(id3, equals('test-id-3'));
      });

      test('injectable generator for mocking', () {
        // Arrange - Mock generator for tests
        var mockCallCount = 0;
        final mockIds = IdNamespace(
          generator: () {
            mockCallCount++;
            return 'mock-$mockCallCount';
          },
          prefix: 'test',
        );

        // Act
        final id1 = mockIds.next();
        final id2 = mockIds.next();

        // Assert
        expect(id1, equals('test-mock-1'));
        expect(id2, equals('test-mock-2'));
        expect(mockCallCount, equals(2));
      });

      test('reset and reconfigure for test isolation', () {
        // Arrange - First test
        Id.generator = () => 'first-test';
        final id1 = Id.next();

        // Act - Reset for next test
        Id.reset();
        final id2 = Id.next();

        // Assert
        expect(id1, equals('first-test'));
        expect(id2, startsWith('loc-')); // Back to default
      });
    });
  });

  group('IdGenerator interface', () {
    test('IdNamespace implements IdGenerator', () {
      // Arrange
      final namespace = IdNamespace(generator: () => '123');

      // Act & Assert
      expect(namespace, isA<IdGenerator>());
    });

    test('can be used polymorphically', () {
      // Arrange
      final generator = IdNamespace(
        generator: () => 'poly-123',
        prefix: 'test',
      );

      // Act
      final id = generator.next();

      // Assert
      expect(id, equals('test-poly-123'));
    });

    test('can be injected as dependency', () {
      // Arrange - Simulates dependency injection
      IdGenerator createIdGenerator() => IdNamespace(
        generator: () => 'injected',
        prefix: 'di',
      );

      final generator = createIdGenerator();

      // Act
      final id = generator.next();

      // Assert
      expect(id, equals('di-injected'));
    });
  });
}
