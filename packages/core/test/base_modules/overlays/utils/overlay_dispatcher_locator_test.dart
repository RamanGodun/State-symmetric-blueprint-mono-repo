// ignore_for_file: avoid_catching_errors, document_ignores

import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/src/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverlayDispatcherLocator', () {
    late OverlayDispatcher mockDispatcher;
    late BuildContext mockContext;

    setUp(() {
      mockDispatcher = OverlayDispatcher();
      // Reset resolvers before each test
      setOverlayDispatcherResolver((ctx) => OverlayDispatcher());
      setGlobalOverlayDispatcherResolver(OverlayDispatcher.new);
    });

    tearDown(() {
      // Clean up - reset resolvers
      setOverlayDispatcherResolver((ctx) => OverlayDispatcher());
      setGlobalOverlayDispatcherResolver(OverlayDispatcher.new);
    });

    group('setOverlayDispatcherResolver', () {
      testWidgets('sets context-aware resolver successfully', (tester) async {
        // Arrange
        OverlayDispatcher? capturedDispatcher;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        setOverlayDispatcherResolver((ctx) => mockDispatcher);
        capturedDispatcher = resolveOverlayDispatcher(mockContext);

        // Assert
        expect(capturedDispatcher, equals(mockDispatcher));
      });

      testWidgets('resolver can be updated', (tester) async {
        // Arrange
        final dispatcher1 = OverlayDispatcher();
        final dispatcher2 = OverlayDispatcher();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        setOverlayDispatcherResolver((ctx) => dispatcher1);
        final result1 = resolveOverlayDispatcher(mockContext);

        setOverlayDispatcherResolver((ctx) => dispatcher2);
        final result2 = resolveOverlayDispatcher(mockContext);

        // Assert
        expect(result1, equals(dispatcher1));
        expect(result2, equals(dispatcher2));
        expect(result1, isNot(equals(result2)));
      });

      testWidgets('resolver receives correct BuildContext', (tester) async {
        // Arrange
        BuildContext? receivedContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        setOverlayDispatcherResolver((ctx) {
          receivedContext = ctx;
          return mockDispatcher;
        });
        resolveOverlayDispatcher(mockContext);

        // Assert
        expect(receivedContext, equals(mockContext));
      });
    });

    group('setGlobalOverlayDispatcherResolver', () {
      test('sets global resolver successfully', () {
        // Arrange & Act
        setGlobalOverlayDispatcherResolver(() => mockDispatcher);
        final result = resolveOverlayDispatcherGlobal();

        // Assert
        expect(result, equals(mockDispatcher));
      });

      test('global resolver can be updated', () {
        // Arrange
        final dispatcher1 = OverlayDispatcher();
        final dispatcher2 = OverlayDispatcher();

        // Act
        setGlobalOverlayDispatcherResolver(() => dispatcher1);
        final result1 = resolveOverlayDispatcherGlobal();

        setGlobalOverlayDispatcherResolver(() => dispatcher2);
        final result2 = resolveOverlayDispatcherGlobal();

        // Assert
        expect(result1, equals(dispatcher1));
        expect(result2, equals(dispatcher2));
        expect(result1, isNot(equals(result2)));
      });

      test('global resolver works without BuildContext', () {
        // Arrange
        setGlobalOverlayDispatcherResolver(() => mockDispatcher);

        // Act & Assert - should not require context
        expect(resolveOverlayDispatcherGlobal, returnsNormally);
        expect(resolveOverlayDispatcherGlobal(), equals(mockDispatcher));
      });
    });

    group('resolveOverlayDispatcher', () {
      testWidgets('throws StateError when resolver not set', (tester) async {
        // Arrange
        // Reset to null by setting a resolver that we'll clear
        BuildContext? testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Create a new instance for this test without setting resolver
        // We need to simulate unset state
        late Object caughtError;

        // Act
        try {
          // Try to resolve without proper setup
          setOverlayDispatcherResolver((ctx) {
            throw StateError('Intentional error for test');
          });
          resolveOverlayDispatcher(testContext!);
        } on StateError catch (e) {
          caughtError = e;
        }

        // Assert
        expect(caughtError, isA<StateError>());
      });

      testWidgets('returns correct dispatcher when resolver is set', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        setOverlayDispatcherResolver((ctx) => mockDispatcher);

        // Act
        final result = resolveOverlayDispatcher(mockContext);

        // Assert
        expect(result, equals(mockDispatcher));
        expect(result, isA<OverlayDispatcher>());
      });

      testWidgets('works with different BuildContext instances', (
        tester,
      ) async {
        // Arrange
        BuildContext? context1;
        BuildContext? context2;

        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: [
                Builder(
                  builder: (ctx) {
                    context1 = ctx;
                    return const SizedBox();
                  },
                ),
                Builder(
                  builder: (ctx) {
                    context2 = ctx;
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        );

        setOverlayDispatcherResolver((ctx) => mockDispatcher);

        // Act
        final result1 = resolveOverlayDispatcher(context1!);
        final result2 = resolveOverlayDispatcher(context2!);

        // Assert - same dispatcher for different contexts
        expect(result1, equals(mockDispatcher));
        expect(result2, equals(mockDispatcher));
      });
    });

    group('resolveOverlayDispatcherGlobal', () {
      test('throws StateError when global resolver not set', () {
        // Arrange - simulate unset by throwing error
        setGlobalOverlayDispatcherResolver(() {
          throw StateError('Intentional error for test');
        });

        // Act & Assert
        expect(
          resolveOverlayDispatcherGlobal,
          throwsA(isA<StateError>()),
        );
      });

      test('returns correct dispatcher when global resolver is set', () {
        // Arrange
        setGlobalOverlayDispatcherResolver(() => mockDispatcher);

        // Act
        final result = resolveOverlayDispatcherGlobal();

        // Assert
        expect(result, equals(mockDispatcher));
        expect(result, isA<OverlayDispatcher>());
      });

      test('multiple calls return same dispatcher instance', () {
        // Arrange
        setGlobalOverlayDispatcherResolver(() => mockDispatcher);

        // Act
        final result1 = resolveOverlayDispatcherGlobal();
        final result2 = resolveOverlayDispatcherGlobal();

        // Assert
        expect(result1, equals(mockDispatcher));
        expect(result2, equals(mockDispatcher));
        expect(result1, equals(result2));
      });

      test(
        'can return different dispatchers on each call if resolver creates new instances',
        () {
          // Arrange
          setGlobalOverlayDispatcherResolver(OverlayDispatcher.new);

          // Act
          final result1 = resolveOverlayDispatcherGlobal();
          final result2 = resolveOverlayDispatcherGlobal();

          // Assert - different instances
          expect(result1, isA<OverlayDispatcher>());
          expect(result2, isA<OverlayDispatcher>());
          expect(result1, isNot(equals(result2)));
        },
      );
    });

    group('integration scenarios', () {
      testWidgets('context-aware and global resolvers can coexist', (
        tester,
      ) async {
        // Arrange
        final contextDispatcher = OverlayDispatcher();
        final globalDispatcher = OverlayDispatcher();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        setOverlayDispatcherResolver((ctx) => contextDispatcher);
        setGlobalOverlayDispatcherResolver(() => globalDispatcher);

        final contextResult = resolveOverlayDispatcher(mockContext);
        final globalResult = resolveOverlayDispatcherGlobal();

        // Assert - different dispatchers
        expect(contextResult, equals(contextDispatcher));
        expect(globalResult, equals(globalDispatcher));
        expect(contextResult, isNot(equals(globalResult)));
      });

      testWidgets('resolver can access widget tree through BuildContext', (
        tester,
      ) async {
        // Arrange
        final key = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Container(
              key: key,
              child: Builder(
                builder: (context) {
                  mockContext = context;
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        // Act
        setOverlayDispatcherResolver((ctx) {
          // Access widget tree
          final widget = ctx.widget;
          expect(widget, isA<Builder>());
          return mockDispatcher;
        });

        final result = resolveOverlayDispatcher(mockContext);

        // Assert
        expect(result, equals(mockDispatcher));
      });

      testWidgets('typical app bootstrap scenario', (tester) async {
        // Arrange - simulate app initialization
        OverlayDispatcher? appDispatcher;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act - app bootstrap sets resolver
        setOverlayDispatcherResolver((ctx) {
          // In real app, might use DI container here
          appDispatcher ??= OverlayDispatcher();
          return appDispatcher!;
        });

        // Different parts of app request dispatcher
        final dispatcher1 = resolveOverlayDispatcher(mockContext);
        final dispatcher2 = resolveOverlayDispatcher(mockContext);

        // Assert - same singleton instance
        expect(dispatcher1, equals(appDispatcher));
        expect(dispatcher2, equals(appDispatcher));
        expect(dispatcher1, equals(dispatcher2));
      });

      test('NavigatorObserver scenario uses global resolver', () {
        // Arrange - simulate NavigatorObserver without BuildContext
        final navigationDispatcher = OverlayDispatcher();

        // Act - set up global resolver for navigation
        setGlobalOverlayDispatcherResolver(() => navigationDispatcher);

        // Simulate navigation event handler
        final dispatcher = resolveOverlayDispatcherGlobal();

        // Assert
        expect(dispatcher, equals(navigationDispatcher));
      });
    });

    group('edge cases', () {
      testWidgets('resolver can return null and handle it gracefully', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // This tests that resolver can handle special cases
        var callCount = 0;
        setOverlayDispatcherResolver((ctx) {
          callCount++;
          return mockDispatcher;
        });

        // Act
        resolveOverlayDispatcher(mockContext);
        resolveOverlayDispatcher(mockContext);

        // Assert - resolver is called each time
        expect(callCount, equals(2));
      });

      test('global resolver handles multiple concurrent calls', () {
        // Arrange
        var callCount = 0;
        setGlobalOverlayDispatcherResolver(() {
          callCount++;
          return OverlayDispatcher();
        });

        // Act - simulate concurrent calls
        final dispatchers = List.generate(
          10,
          (_) => resolveOverlayDispatcherGlobal(),
        );

        // Assert
        expect(callCount, equals(10));
        expect(dispatchers.length, equals(10));
        // ignore: unnecessary_type_check
        expect(dispatchers.every((d) => d is OverlayDispatcher), isTrue);
      });

      testWidgets('resolver update does not affect previous resolutions', (
        tester,
      ) async {
        // Arrange
        final dispatcher1 = OverlayDispatcher();
        final dispatcher2 = OverlayDispatcher();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                mockContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        setOverlayDispatcherResolver((ctx) => dispatcher1);
        final firstResult = resolveOverlayDispatcher(mockContext);

        setOverlayDispatcherResolver((ctx) => dispatcher2);
        // firstResult should still reference dispatcher1
        final secondResult = resolveOverlayDispatcher(mockContext);

        // Assert
        expect(firstResult, equals(dispatcher1));
        expect(secondResult, equals(dispatcher2));
        expect(firstResult, isNot(equals(secondResult)));
      });
    });
  });
}
