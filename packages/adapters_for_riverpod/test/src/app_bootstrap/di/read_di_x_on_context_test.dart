/// Tests for ContextDI extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - readDI method functionality
/// - Integration with GlobalDIContainer
/// - Provider reading with different types
/// - Error handling when container not initialized
library;

import 'package:adapters_for_riverpod/src/app_bootstrap/di/global_di_container.dart';
import 'package:adapters_for_riverpod/src/app_bootstrap/di/read_di_x_on_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContextDI', () {
    late ProviderContainer container;
    late BuildContext context;

    setUp(() {
      container = ProviderContainer();
      GlobalDIContainer.initialize(container);
    });

    tearDown(() async {
      await GlobalDIContainer.dispose();
    });

    // Helper to create a BuildContext for testing
    Widget buildTestWidget(WidgetTester tester) {
      return MaterialApp(
        home: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
      );
    }

    group('readDI', () {
      testWidgets('reads string provider from global container', (
        tester,
      ) async {
        // Arrange
        final testProvider = Provider<String>((ref) => 'test value');
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(testProvider);

        // Assert
        expect(value, equals('test value'));
      });

      testWidgets('reads int provider from global container', (tester) async {
        // Arrange
        final testProvider = Provider<int>((ref) => 42);
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(testProvider);

        // Assert
        expect(value, equals(42));
      });

      testWidgets('reads bool provider from global container', (tester) async {
        // Arrange
        final testProvider = Provider<bool>((ref) => true);
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(testProvider);

        // Assert
        expect(value, isTrue);
      });

      testWidgets('reads custom object provider', (tester) async {
        // Arrange
        const testObject = _TestObject('test', 123);
        final testProvider = Provider<_TestObject>((ref) => testObject);
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(testProvider);

        // Assert
        expect(value, equals(testObject));
        expect(value.name, equals('test'));
        expect(value.value, equals(123));
      });

      testWidgets('reads StateProvider from global container', (tester) async {
        // Arrange
        final testProvider = StateProvider<String>((ref) => 'initial');
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(testProvider);

        // Assert
        expect(value, equals('initial'));
      });

      testWidgets('reads different providers independently', (tester) async {
        // Arrange
        final provider1 = Provider<String>((ref) => 'value1');
        final provider2 = Provider<int>((ref) => 100);
        final provider3 = Provider<bool>((ref) => false);
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value1 = context.readDI(provider1);
        final value2 = context.readDI(provider2);
        final value3 = context.readDI(provider3);

        // Assert
        expect(value1, equals('value1'));
        expect(value2, equals(100));
        expect(value3, isFalse);
      });

      testWidgets('can read same provider multiple times', (tester) async {
        // Arrange
        final testProvider = Provider<String>((ref) => 'cached value');
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value1 = context.readDI(testProvider);
        final value2 = context.readDI(testProvider);
        final value3 = context.readDI(testProvider);

        // Assert
        expect(value1, equals('cached value'));
        expect(value2, equals('cached value'));
        expect(value3, equals('cached value'));
      });

      testWidgets('reads provider with dependencies', (tester) async {
        // Arrange
        final baseProvider = Provider<int>((ref) => 10);
        final dependentProvider = Provider<int>((ref) {
          final base = ref.read(baseProvider);
          return base * 2;
        });
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(dependentProvider);

        // Assert
        expect(value, equals(20));
      });

      testWidgets('works with nullable types', (tester) async {
        // Arrange
        final nullableProvider = Provider<String?>((ref) => null);
        final nonNullProvider = Provider<String?>((ref) => 'not null');
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final nullValue = context.readDI(nullableProvider);
        final nonNullValue = context.readDI(nonNullProvider);

        // Assert
        expect(nullValue, isNull);
        expect(nonNullValue, equals('not null'));
      });

      testWidgets('works with List types', (tester) async {
        // Arrange
        final listProvider = Provider<List<String>>((ref) => ['a', 'b', 'c']);
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(listProvider);

        // Assert
        expect(value, isA<List<String>>());
        expect(value, hasLength(3));
        expect(value, equals(['a', 'b', 'c']));
      });

      testWidgets('works with Map types', (tester) async {
        // Arrange
        final mapProvider = Provider<Map<String, int>>(
          (ref) => {'a': 1, 'b': 2},
        );
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final value = context.readDI(mapProvider);

        // Assert
        expect(value, isA<Map<String, int>>());
        expect(value['a'], equals(1));
        expect(value['b'], equals(2));
      });

      testWidgets('delegates to GlobalDIContainer.instance.read', (
        tester,
      ) async {
        // Arrange
        final testProvider = Provider<String>((ref) => 'delegated');
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final contextValue = context.readDI(testProvider);
        final containerValue = GlobalDIContainer.instance.read(testProvider);

        // Assert
        expect(contextValue, equals(containerValue));
        expect(contextValue, equals('delegated'));
      });
    });

    group('error handling', () {
      testWidgets('throws when GlobalDIContainer not initialized', (
        tester,
      ) async {
        // Arrange
        await GlobalDIContainer.dispose();
        final testProvider = Provider<String>((ref) => 'test');
        await tester.pumpWidget(buildTestWidget(tester));

        // Act & Assert
        expect(
          () => context.readDI(testProvider),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('real-world scenarios', () {
      testWidgets('reading service from DI in imperative code', (tester) async {
        // Arrange
        final apiService = _MockApiService();
        final apiProvider = Provider<_MockApiService>((ref) => apiService);
        await tester.pumpWidget(buildTestWidget(tester));

        // Act - Simulating imperative code that needs the service
        final service = context.readDI(apiProvider);
        final result = await service.fetchData();

        // Assert
        expect(service, equals(apiService));
        expect(result, equals('mock data'));
      });

      testWidgets('accessing repository from context', (tester) async {
        // Arrange
        final repository = _MockRepository();
        final repoProvider = Provider<_MockRepository>((ref) => repository);
        await tester.pumpWidget(buildTestWidget(tester));

        // Act
        final repo = context.readDI(repoProvider);
        final data = await repo.getData();

        // Assert
        expect(repo, equals(repository));
        expect(data, equals('repository data'));
      });

      testWidgets('using in callback where ref is not available', (
        tester,
      ) async {
        // Arrange
        final counterProvider = StateProvider<int>((ref) => 0);
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (ctx) {
                context = ctx;
                return ElevatedButton(
                  onPressed: () {
                    // In a callback where ref might not be available
                    final currentValue = ctx.readDI(counterProvider);
                    // Use the value
                    expect(currentValue, equals(0));
                  },
                  child: const Text('Button'),
                );
              },
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert - callback executed successfully
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('reading multiple related providers', (tester) async {
        // Arrange - Setup a mini service layer
        final authProvider = Provider<bool>((ref) => true);
        final userIdProvider = Provider<String>((ref) => 'user-123');
        final tokenProvider = Provider<String>((ref) => 'token-abc');

        await tester.pumpWidget(buildTestWidget(tester));

        // Act - Read all auth-related data
        final isAuthenticated = context.readDI(authProvider);
        final userId = context.readDI(userIdProvider);
        final token = context.readDI(tokenProvider);

        // Assert
        expect(isAuthenticated, isTrue);
        expect(userId, equals('user-123'));
        expect(token, equals('token-abc'));
      });

      testWidgets('works in different widget contexts', (tester) async {
        // Arrange
        final testProvider = Provider<String>((ref) => 'context test');
        BuildContext? innerContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (outerCtx) {
                return Builder(
                  builder: (innerCtx) {
                    innerContext = innerCtx;
                    context = outerCtx;
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        );

        // Act - Read from both outer and inner contexts
        final outerValue = context.readDI(testProvider);
        final innerValue = innerContext!.readDI(testProvider);

        // Assert - Both should access same global container
        expect(outerValue, equals('context test'));
        expect(innerValue, equals('context test'));
        expect(outerValue, equals(innerValue));
      });
    });
  });
}

// Test helper classes
@immutable
class _TestObject {
  const _TestObject(this.name, this.value);
  final String name;
  final int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestObject &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

class _MockApiService {
  Future<String> fetchData() async => 'mock data';
}

class _MockRepository {
  Future<String> getData() async => 'repository data';
}
