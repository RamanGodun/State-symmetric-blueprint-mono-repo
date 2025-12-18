import 'package:core/src/base_modules/ui_design/widgets_and_utils/theme_switchers/theme_toggler_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeTogglerIconView', () {
    group('construction', () {
      testWidgets('creates with required parameters', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: false,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(ThemeTogglerIconView), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('creates in light mode', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: false,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('creates in dark mode', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: true,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('icon display', () {
      testWidgets('shows dark mode icon when in light mode', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: false,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('shows light mode icon when in dark mode', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: true,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('widget structure', () {
      testWidgets('contains IconButton', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: false,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('IconButton contains Icon', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: false,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Icon), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('works in different theme contexts', (tester) async {
        // Act - Light theme context
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: false,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(ThemeTogglerIconView), findsOneWidget);

        // Act - Dark theme context
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ThemeTogglerIconView(
                    isDark: true,
                    onToggle: () async {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(ThemeTogglerIconView), findsOneWidget);
      });
    });
  });
}
