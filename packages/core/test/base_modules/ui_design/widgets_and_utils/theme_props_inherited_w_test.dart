import 'package:core/src/base_modules/ui_design/widgets_and_utils/theme_props_inherited_w.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeProps', () {
    late ThemeData lightTheme;
    late ThemeData darkTheme;

    setUp(() {
      lightTheme = ThemeData(brightness: Brightness.light);
      darkTheme = ThemeData(brightness: Brightness.dark);
    });

    group('construction', () {
      test('creates instance with all required parameters', () {
        // Act
        final themeProps = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        // Assert
        expect(themeProps, isNotNull);
        expect(themeProps.theme, equals(lightTheme));
        expect(themeProps.darkTheme, equals(darkTheme));
        expect(themeProps.themeMode, equals(ThemeMode.light));
      });

      test('creates instance with light theme mode', () {
        // Act
        final themeProps = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        // Assert
        expect(themeProps.themeMode, equals(ThemeMode.light));
      });

      test('creates instance with dark theme mode', () {
        // Act
        final themeProps = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          child: const SizedBox(),
        );

        // Assert
        expect(themeProps.themeMode, equals(ThemeMode.dark));
      });

      test('creates instance with system theme mode', () {
        // Act
        final themeProps = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          child: const SizedBox(),
        );

        // Assert
        expect(themeProps.themeMode, equals(ThemeMode.system));
      });
    });

    group('of method', () {
      testWidgets('retrieves ThemeProps from context', (tester) async {
        // Arrange
        late ThemeProps retrieved;

        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            child: Builder(
              builder: (context) {
                retrieved = ThemeProps.of(context);
                return const SizedBox();
              },
            ),
          ),
        );

        // Assert
        expect(retrieved, isNotNull);
        expect(retrieved.theme, equals(lightTheme));
      });

      testWidgets('retrieves correct theme from context', (tester) async {
        // Arrange
        late ThemeData retrievedTheme;

        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            child: Builder(
              builder: (context) {
                retrievedTheme = ThemeProps.of(context).theme;
                return const SizedBox();
              },
            ),
          ),
        );

        // Assert
        expect(retrievedTheme, equals(lightTheme));
      });

      testWidgets('retrieves correct dark theme from context', (tester) async {
        // Arrange
        late ThemeData retrievedDarkTheme;

        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.dark,
            child: Builder(
              builder: (context) {
                retrievedDarkTheme = ThemeProps.of(context).darkTheme;
                return const SizedBox();
              },
            ),
          ),
        );

        // Assert
        expect(retrievedDarkTheme, equals(darkTheme));
      });

      testWidgets('retrieves correct theme mode from context', (tester) async {
        // Arrange
        late ThemeMode retrievedMode;

        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            child: Builder(
              builder: (context) {
                retrievedMode = ThemeProps.of(context).themeMode;
                return const SizedBox();
              },
            ),
          ),
        );

        // Assert
        expect(retrievedMode, equals(ThemeMode.system));
      });
    });

    group('updateShouldNotify', () {
      test('returns true when theme changes', () {
        // Arrange
        final oldWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        final newTheme = ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
        );

        final newWidget = ThemeProps(
          theme: newTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        // Act
        final shouldNotify = newWidget.updateShouldNotify(oldWidget);

        // Assert
        expect(shouldNotify, isTrue);
      });

      test('returns true when dark theme changes', () {
        // Arrange
        final oldWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          child: const SizedBox(),
        );

        final newDarkTheme = ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
        );

        final newWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: newDarkTheme,
          themeMode: ThemeMode.dark,
          child: const SizedBox(),
        );

        // Act
        final shouldNotify = newWidget.updateShouldNotify(oldWidget);

        // Assert
        expect(shouldNotify, isTrue);
      });

      test('returns true when theme mode changes', () {
        // Arrange
        final oldWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        final newWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          child: const SizedBox(),
        );

        // Act
        final shouldNotify = newWidget.updateShouldNotify(oldWidget);

        // Assert
        expect(shouldNotify, isTrue);
      });

      test('returns false when nothing changes', () {
        // Arrange
        final oldWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        final newWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        // Act
        final shouldNotify = newWidget.updateShouldNotify(oldWidget);

        // Assert
        expect(shouldNotify, isFalse);
      });

      test('returns true when multiple properties change', () {
        // Arrange
        final oldWidget = ThemeProps(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          child: const SizedBox(),
        );

        final newLightTheme = ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.green,
        );
        final newDarkTheme = ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.purple,
        );

        final newWidget = ThemeProps(
          theme: newLightTheme,
          darkTheme: newDarkTheme,
          themeMode: ThemeMode.dark,
          child: const SizedBox(),
        );

        // Act
        final shouldNotify = newWidget.updateShouldNotify(oldWidget);

        // Assert
        expect(shouldNotify, isTrue);
      });
    });

    group('real-world scenarios', () {
      testWidgets('provides theme to descendant widgets', (tester) async {
        // Arrange
        late Color retrievedPrimaryColor;

        final customTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        );

        await tester.pumpWidget(
          ThemeProps(
            theme: customTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            child: Builder(
              builder: (context) {
                retrievedPrimaryColor = ThemeProps.of(
                  context,
                ).theme.colorScheme.primary;
                return Container(color: retrievedPrimaryColor);
              },
            ),
          ),
        );

        // Assert
        expect(retrievedPrimaryColor, isNotNull);
      });

      testWidgets('switches between light and dark theme', (tester) async {
        // Arrange
        var currentMode = ThemeMode.light;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: ThemeProps(
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: currentMode,
                  child: Builder(
                    builder: (context) {
                      final props = ThemeProps.of(context);
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentMode = currentMode == ThemeMode.light
                                ? ThemeMode.dark
                                : ThemeMode.light;
                          });
                        },
                        child: Text(props.themeMode.toString()),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );

        // Assert - Initially light
        expect(find.text('ThemeMode.light'), findsOneWidget);

        // Act - Toggle to dark
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert - Now dark
        expect(find.text('ThemeMode.dark'), findsOneWidget);
      });

      testWidgets('provides both themes for system mode', (tester) async {
        // Arrange
        late ThemeData retrievedLight;
        late ThemeData retrievedDark;

        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            child: Builder(
              builder: (context) {
                final props = ThemeProps.of(context);
                retrievedLight = props.theme;
                retrievedDark = props.darkTheme;
                return const SizedBox();
              },
            ),
          ),
        );

        // Assert - Both themes available
        expect(retrievedLight.brightness, equals(Brightness.light));
        expect(retrievedDark.brightness, equals(Brightness.dark));
      });
    });

    group('nested ThemeProps', () {
      testWidgets('uses nearest ThemeProps in tree', (tester) async {
        // Arrange
        late ThemeMode outerMode;
        late ThemeMode innerMode;

        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            child: Builder(
              builder: (context) {
                outerMode = ThemeProps.of(context).themeMode;
                return ThemeProps(
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: ThemeMode.dark,
                  child: Builder(
                    builder: (innerContext) {
                      innerMode = ThemeProps.of(innerContext).themeMode;
                      return const SizedBox();
                    },
                  ),
                );
              },
            ),
          ),
        );

        // Assert
        expect(outerMode, equals(ThemeMode.light));
        expect(innerMode, equals(ThemeMode.dark));
      });
    });

    group('rebuild optimization', () {
      testWidgets('only rebuilds when properties change', (tester) async {
        // Arrange
        var buildCount = 0;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: ThemeProps(
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: ThemeMode.light,
                  child: Builder(
                    builder: (context) {
                      buildCount++;
                      ThemeProps.of(context);
                      return ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Rebuild'),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );

        // Assert - Initial build
        expect(buildCount, equals(1));

        // Act - Rebuild without changing ThemeProps
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert - Should not rebuild dependent
        expect(buildCount, equals(1));
      });
    });

    group('edge cases', () {
      testWidgets('works with const child', (tester) async {
        // Act
        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            child: const SizedBox(),
          ),
        );

        // Assert - No errors
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('handles rapid theme mode changes', (tester) async {
        // Arrange
        var currentMode = ThemeMode.light;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: ThemeProps(
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: currentMode,
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentMode = currentMode == ThemeMode.light
                                ? ThemeMode.dark
                                : ThemeMode.light;
                          });
                        },
                        child: const Text('Toggle'),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );

        // Act - Rapid toggles
        for (var i = 0; i < 10; i++) {
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();
        }

        // Assert - No errors
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('type safety', () {
      testWidgets('of method returns non-nullable ThemeProps', (tester) async {
        // Arrange
        late ThemeProps props;

        await tester.pumpWidget(
          ThemeProps(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            child: Builder(
              builder: (context) {
                props = ThemeProps.of(context);
                return const SizedBox();
              },
            ),
          ),
        );

        // Assert
        expect(props, isNotNull);
        expect(props, isA<ThemeProps>());
      });
    });
  });
}
