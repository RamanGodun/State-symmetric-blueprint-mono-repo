import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core_modules/public_api/base_modules/navigation.dart';

void main() {
  group('NavigationX', () {
    group('goTo', () {
      testWidgets('navigates to named route successfully', (tester) async {
        // Arrange
        var navigatedTo = '';
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(
                body: Text('Home'),
              ),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                navigatedTo = 'profile';
                return const Scaffold(body: Text('Profile'));
              },
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
          ),
        );

        await tester.pumpAndSettle();

        // Act
        tester.element(find.byType(Scaffold)).goTo('profile');

        await tester.pumpAndSettle();

        // Assert
        expect(navigatedTo, equals('profile'));
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('navigates with path parameters', (tester) async {
        // Arrange
        String? receivedUserId;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
            GoRoute(
              path: '/user/:userId',
              name: 'userProfile',
              builder: (context, state) {
                receivedUserId = state.pathParameters['userId'];
                return Scaffold(
                  body: Text('User: ${state.pathParameters['userId']}'),
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        tester
            .element(find.byType(Scaffold))
            .goTo('userProfile', pathParameters: {'userId': '123'});

        await tester.pumpAndSettle();

        // Assert
        expect(receivedUserId, equals('123'));
        expect(find.text('User: 123'), findsOneWidget);
      });

      testWidgets('navigates with query parameters', (tester) async {
        // Arrange
        String? receivedQuery;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
            GoRoute(
              path: '/search',
              name: 'search',
              builder: (context, state) {
                receivedQuery = state.uri.queryParameters['q'];
                return Scaffold(
                  body: Text('Search: ${state.uri.queryParameters['q']}'),
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        tester
            .element(find.byType(Scaffold))
            .goTo('search', queryParameters: {'q': 'flutter'});

        await tester.pumpAndSettle();

        // Assert
        expect(receivedQuery, equals('flutter'));
        expect(find.text('Search: flutter'), findsOneWidget);
      });

      testWidgets('falls back to pageNotFound on navigation error', (
        tester,
      ) async {
        // Arrange
        var navigatedToError = false;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
            GoRoute(
              path: '/error',
              name: 'pageNotFound',
              builder: (context, state) {
                navigatedToError = true;
                return const Scaffold(body: Text('Page Not Found'));
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act - try to navigate to non-existent route
        tester.element(find.byType(Scaffold)).goTo('nonExistentRoute');

        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToError, isTrue);
        expect(find.text('Page Not Found'), findsOneWidget);
      });
    });

    group('goPushTo', () {
      testWidgets('pushes named route onto stack', (tester) async {
        // Arrange
        var pushedToProfile = false;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(
                body: Text('Home'),
              ),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                pushedToProfile = true;
                return const Scaffold(body: Text('Profile'));
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        tester.element(find.byType(Scaffold)).goPushTo('profile');

        await tester.pumpAndSettle();

        // Assert
        expect(pushedToProfile, isTrue);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('pushes route with path parameters', (tester) async {
        // Arrange
        String? receivedId;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
            GoRoute(
              path: '/item/:id',
              name: 'item',
              builder: (context, state) {
                receivedId = state.pathParameters['id'];
                return Scaffold(body: Text('Item: $receivedId'));
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        tester
            .element(find.byType(Scaffold))
            .goPushTo('item', pathParameters: {'id': '456'});

        await tester.pumpAndSettle();

        // Assert
        expect(receivedId, equals('456'));
        expect(find.text('Item: 456'), findsOneWidget);
      });

      testWidgets('pushes route with query parameters', (tester) async {
        // Arrange
        String? receivedFilter;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
            GoRoute(
              path: '/list',
              name: 'list',
              builder: (context, state) {
                receivedFilter = state.uri.queryParameters['filter'];
                return Scaffold(body: Text('Filter: $receivedFilter'));
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        tester
            .element(find.byType(Scaffold))
            .goPushTo('list', queryParameters: {'filter': 'active'});

        await tester.pumpAndSettle();

        // Assert
        expect(receivedFilter, equals('active'));
        expect(find.text('Filter: active'), findsOneWidget);
      });

      testWidgets('falls back to pageNotFound on push error', (tester) async {
        // Arrange
        var navigatedToError = false;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
            GoRoute(
              path: '/error',
              name: 'pageNotFound',
              builder: (context, state) {
                navigatedToError = true;
                return const Scaffold(body: Text('Page Not Found'));
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        tester.element(find.byType(Scaffold)).goPushTo('invalidRoute');

        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToError, isTrue);
        expect(find.text('Page Not Found'), findsOneWidget);
      });
    });

    group('popView', () {
      testWidgets('pops current view from stack', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: const Text('First Page'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    unawaited(
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => Scaffold(
                            body: const Text('Second Page'),
                            floatingActionButton: FloatingActionButton(
                              onPressed: () => context.popView(),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
        );

        // Push to second page
        await tester.tap(find.byIcon(Icons.arrow_forward));
        await tester.pumpAndSettle();
        expect(find.text('Second Page'), findsOneWidget);

        // Act - pop back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('First Page'), findsOneWidget);
        expect(find.text('Second Page'), findsNothing);
      });

      testWidgets('pops with result value', (tester) async {
        // Arrange
        String? result;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Text('Result: ${result ?? "none"}'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final value = await Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          body: const Text('Dialog Page'),
                          floatingActionButton: FloatingActionButton(
                            onPressed: () => context.popView('success'),
                            child: const Icon(Icons.check),
                          ),
                        ),
                      ),
                    );
                    result = value;
                    // Trigger rebuild
                    (context as Element).markNeedsBuild();
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
        );

        // Push to dialog page
        await tester.tap(find.byIcon(Icons.arrow_forward));
        await tester.pumpAndSettle();

        // Act - pop with result
        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        // Assert
        expect(result, equals('success'));
      });
    });

    group('pushTo', () {
      testWidgets('pushes custom widget via MaterialPageRoute', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: const Text('Home'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    unawaited(
                      context.pushTo<void>(
                        const Scaffold(body: Text('Custom Page')),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Custom Page'), findsOneWidget);
      });

      testWidgets('returns result from pushed page', (tester) async {
        // Arrange
        int? result;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Text('Result: ${result ?? "none"}'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final value = await context.pushTo<int>(
                      Scaffold(
                        body: const Text('Value Page'),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () => Navigator.of(context).pop(42),
                          child: const Icon(Icons.check),
                        ),
                      ),
                    );
                    result = value;
                    (context as Element).markNeedsBuild();
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        );

        // Push page
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Act - pop with result
        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        // Assert
        expect(result, equals(42));
      });
    });

    group('replaceWith', () {
      testWidgets('replaces current view with new widget', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: const Text('First Page'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    unawaited(
                      context.replaceWith<void>(
                        const Scaffold(body: Text('Replacement Page')),
                      ),
                    );
                  },
                  child: const Icon(Icons.swap_horiz),
                ),
              ),
            ),
          ),
        );

        expect(find.text('First Page'), findsOneWidget);

        // Act
        await tester.tap(find.byIcon(Icons.swap_horiz));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Replacement Page'), findsOneWidget);
        expect(find.text('First Page'), findsNothing);
      });

      testWidgets('returns result from replacement', (tester) async {
        // Arrange
        String? result;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Text('Result: ${result ?? "none"}'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final value = await context.replaceWith<String>(
                      Builder(
                        builder: (newContext) => Scaffold(
                          body: const Text('Replacement'),
                          floatingActionButton: FloatingActionButton(
                            onPressed: () =>
                                Navigator.of(newContext).pop('replaced'),
                            child: const Icon(Icons.check),
                          ),
                        ),
                      ),
                    );
                    result = value;
                  },
                  child: const Icon(Icons.swap_horiz),
                ),
              ),
            ),
          ),
        );

        // Replace page
        await tester.tap(find.byIcon(Icons.swap_horiz));
        await tester.pumpAndSettle();

        // Act - pop with result
        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        // Assert
        expect(result, equals('replaced'));
      });
    });

    group('goIfMounted', () {
      testWidgets('navigates only if context is mounted', (tester) async {
        // Arrange
        var navigated = false;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                navigated = true;
                return const Scaffold(body: Text('Profile'));
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        tester.element(find.byType(Scaffold)).goIfMounted('profile');

        await tester.pumpAndSettle();

        // Assert - context was mounted, so navigation should occur
        expect(navigated, isTrue);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('does not navigate if context is not mounted', (
        tester,
      ) async {
        // Arrange
        var navigated = false;
        BuildContext? savedContext;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) {
                savedContext = context;
                return const Scaffold(body: Text('Home'));
              },
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                navigated = true;
                return const Scaffold(body: Text('Profile'));
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Remove the widget tree to unmount context
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        // Act - try to navigate with unmounted context
        savedContext?.goIfMounted('profile');
        await tester.pumpAndSettle();

        // Assert - navigation should not occur
        expect(navigated, isFalse);
      });
    });

    group('globalRouterContext', () {
      testWidgets('returns global router context from navigatorKey', (
        tester,
      ) async {
        // Arrange
        final navigatorKey = GlobalKey<NavigatorState>();
        final router = GoRouter(
          navigatorKey: navigatorKey,
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Scaffold(body: Text('Home')),
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Act
        final context = tester.element(find.byType(Scaffold));
        final globalContext = context.globalRouterContext;

        // Assert
        expect(globalContext, isNotNull);
        expect(globalContext, equals(navigatorKey.currentContext));
      });

      testWidgets('returns null on error', (tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Text('Home')),
          ),
        );

        await tester.pumpAndSettle();

        // Act - try to get global router context without GoRouter
        final context = tester.element(find.byType(Scaffold));
        final globalContext = context.globalRouterContext;

        // Assert - should return null or handle error gracefully
        expect(globalContext, isNull);
      });
    });
  });
}
