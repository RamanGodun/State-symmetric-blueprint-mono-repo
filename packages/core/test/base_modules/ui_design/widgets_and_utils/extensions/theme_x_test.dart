import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeXOnContext', () {
    testWidgets('theme getter returns ThemeData', (tester) async {
      // Arrange
      late ThemeData capturedTheme;
      final testTheme = ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: testTheme,
          home: Builder(
            builder: (context) {
              capturedTheme = context.theme;
              return const Scaffold();
            },
          ),
        ),
      );

      // Assert
      expect(capturedTheme, isA<ThemeData>());
      expect(capturedTheme.brightness, equals(Brightness.light));
    });

    testWidgets('isDarkMode returns false for light theme', (tester) async {
      // Arrange
      late bool isDark;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) {
              isDark = context.isDarkMode;
              return const Scaffold();
            },
          ),
        ),
      );

      // Assert
      expect(isDark, isFalse);
    });

    testWidgets('isDarkMode returns true for dark theme', (tester) async {
      // Arrange
      late bool isDark;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (context) {
              isDark = context.isDarkMode;
              return const Scaffold();
            },
          ),
        ),
      );

      // Assert
      expect(isDark, isTrue);
    });

    testWidgets('textTheme getter returns TextTheme', (tester) async {
      // Arrange
      late TextTheme capturedTextTheme;
      final customTextTheme = ThemeData.light().textTheme.copyWith(
        bodyLarge: const TextStyle(fontSize: 20),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(textTheme: customTextTheme),
          home: Builder(
            builder: (context) {
              capturedTextTheme = context.textTheme;
              return const Scaffold();
            },
          ),
        ),
      );

      // Assert
      expect(capturedTextTheme, isA<TextTheme>());
      expect(capturedTextTheme.bodyLarge!.fontSize, equals(20));
    });

    testWidgets('colorScheme getter returns ColorScheme', (tester) async {
      // Arrange
      late ColorScheme capturedColorScheme;
      final testColorScheme = ColorScheme.fromSeed(
        seedColor: Colors.purple,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: testColorScheme),
          home: Builder(
            builder: (context) {
              capturedColorScheme = context.colorScheme;
              return const Scaffold();
            },
          ),
        ),
      );

      // Assert
      expect(capturedColorScheme, isA<ColorScheme>());
      expect(capturedColorScheme.brightness, equals(Brightness.light));
    });

    testWidgets('platform getter returns TargetPlatform', (tester) async {
      // Arrange
      late TargetPlatform capturedPlatform;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Builder(
            builder: (context) {
              capturedPlatform = context.platform;
              return const Scaffold();
            },
          ),
        ),
      );

      // Assert
      expect(capturedPlatform, isA<TargetPlatform>());
      expect(capturedPlatform, equals(TargetPlatform.iOS));
    });

    group('real-world scenarios', () {
      testWidgets('accessing theme colors in widget', (tester) async {
        // Arrange
        late Color primaryColor;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            home: Builder(
              builder: (context) {
                primaryColor = context.colorScheme.primary;
                return Container(color: primaryColor);
              },
            ),
          ),
        );

        // Assert
        expect(primaryColor, isNotNull);
      });

      testWidgets('using text theme for typography', (tester) async {
        // Arrange
        late TextStyle headlineStyle;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                headlineStyle = context.textTheme.headlineLarge!;
                return Text('Headline', style: headlineStyle);
              },
            ),
          ),
        );

        // Assert
        expect(headlineStyle, isNotNull);
        expect(find.text('Headline'), findsOneWidget);
      });

      testWidgets('conditional UI based on dark mode', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: Brightness.dark),
            home: Builder(
              builder: (context) {
                return context.isDarkMode
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode);
              },
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.dark_mode), findsOneWidget);
        expect(find.byIcon(Icons.light_mode), findsNothing);
      });

      testWidgets('platform-specific styling', (tester) async {
        // Arrange
        late bool isIOS;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                isIOS = context.platform == TargetPlatform.iOS;
                return isIOS
                    ? const Text('iOS Style')
                    : const Text('Android Style');
              },
            ),
          ),
        );

        // Assert
        expect(find.text('iOS Style'), findsOneWidget);
      });
    });

    group('theme switching', () {
      testWidgets('reflects theme changes', (tester) async {
        // Arrange
        var brightness = Brightness.light;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return MaterialApp(
                theme: ThemeData(brightness: brightness),
                home: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          brightness = Brightness.dark;
                        });
                      },
                      child: Text(
                        context.isDarkMode ? 'Dark' : 'Light',
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );

        // Assert - Initially light
        expect(find.text('Light'), findsOneWidget);

        // Act - Switch to dark
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert - Now dark
        expect(find.text('Dark'), findsOneWidget);
      });
    });

    group('nested themes', () {
      testWidgets('uses nearest theme in tree', (tester) async {
        // Arrange
        late bool outerIsDark;
        late bool innerIsDark;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: Brightness.light),
            home: Builder(
              builder: (context) {
                outerIsDark = context.isDarkMode;
                return Theme(
                  data: ThemeData(brightness: Brightness.dark),
                  child: Builder(
                    builder: (innerContext) {
                      innerIsDark = innerContext.isDarkMode;
                      return const Scaffold();
                    },
                  ),
                );
              },
            ),
          ),
        );

        // Assert
        expect(outerIsDark, isFalse);
        expect(innerIsDark, isTrue);
      });
    });

    group('consistency', () {
      testWidgets('all getters access same theme', (tester) async {
        // Arrange
        late ThemeData themeViaExtension;
        late ThemeData themeViaOf;
        late TextTheme textThemeViaExtension;
        late ColorScheme colorSchemeViaExtension;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                themeViaExtension = context.theme;
                themeViaOf = Theme.of(context);
                textThemeViaExtension = context.textTheme;
                colorSchemeViaExtension = context.colorScheme;
                return const Scaffold();
              },
            ),
          ),
        );

        // Assert - Extension matches Theme.of()
        expect(themeViaExtension, equals(themeViaOf));
        expect(textThemeViaExtension, equals(themeViaOf.textTheme));
        expect(colorSchemeViaExtension, equals(themeViaOf.colorScheme));
      });
    });

    group('edge cases', () {
      testWidgets('works with default MaterialApp theme', (tester) async {
        // Arrange
        late ThemeData defaultTheme;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                defaultTheme = context.theme;
                return const Scaffold();
              },
            ),
          ),
        );

        // Assert
        expect(defaultTheme, isNotNull);
        expect(defaultTheme.textTheme, isNotNull);
        expect(defaultTheme.colorScheme, isNotNull);
      });

      testWidgets('isDarkMode handles Material 3 themes', (tester) async {
        // Arrange
        late bool isDark;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            home: Builder(
              builder: (context) {
                isDark = context.isDarkMode;
                return const Scaffold();
              },
            ),
          ),
        );

        // Assert
        expect(isDark, isTrue);
      });
    });
  });
}
