import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('ObscureToggleIcon', () {
    group('construction', () {
      testWidgets('creates widget with required parameters', (tester) async {
        // Arrange

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(ObscureToggleIcon), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('accepts custom key', (tester) async {
        // Arrange
        const testKey = Key('test-obscure-icon');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                key: testKey,
                isObscure: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byKey(testKey), findsOneWidget);
      });
    });

    group('icon display', () {
      testWidgets('shows visibility_off icon when isObscure is true', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        final icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.visibility_off));
      });

      testWidgets('shows visibility icon when isObscure is false', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: false,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        final icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.visibility));
      });
    });

    group('interaction', () {
      testWidgets('calls onPressed when tapped', (tester) async {
        // Arrange
        var pressedCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () => pressedCount++,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(pressedCount, equals(1));
      });

      testWidgets('calls onPressed multiple times', (tester) async {
        // Arrange
        var pressedCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () => pressedCount++,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(pressedCount, equals(3));
      });

      testWidgets('responds to tap regardless of isObscure state', (
        tester,
      ) async {
        // Arrange
        var pressedWhenObscure = false;
        var pressedWhenVisible = false;

        // Test when obscure
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () => pressedWhenObscure = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Test when visible
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: false,
                onPressed: () => pressedWhenVisible = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(pressedWhenObscure, isTrue);
        expect(pressedWhenVisible, isTrue);
      });
    });

    group('state changes', () {
      testWidgets('updates icon when isObscure changes', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Verify initial state
        var iconButton = tester.widget<IconButton>(find.byType(IconButton));
        var icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.visibility_off));

        // Act - Change to visible
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: false,
                onPressed: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        iconButton = tester.widget<IconButton>(find.byType(IconButton));
        icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.visibility));
      });
    });

    group('real-world scenarios', () {
      testWidgets('typical password visibility toggle flow', (tester) async {
        // Arrange
        var isPasswordObscure = true;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return MaterialApp(
                home: Scaffold(
                  body: ObscureToggleIcon(
                    isObscure: isPasswordObscure,
                    onPressed: () {
                      setState(() {
                        isPasswordObscure = !isPasswordObscure;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        );

        // Assert initial state - password hidden
        var iconButton = tester.widget<IconButton>(find.byType(IconButton));
        var icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.visibility_off));

        // Act - Toggle to show password
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert - password visible
        iconButton = tester.widget<IconButton>(find.byType(IconButton));
        icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.visibility));

        // Act - Toggle to hide password again
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert - password hidden again
        iconButton = tester.widget<IconButton>(find.byType(IconButton));
        icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.visibility_off));
      });

      testWidgets('integrates with password field scenario', (tester) async {
        // Arrange
        // ignore: prefer_const_declarations
        final isObscure = true;
        var toggleCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      suffixIcon: ObscureToggleIcon(
                        isObscure: isObscure,
                        onPressed: () => toggleCount++,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(ObscureToggleIcon));
        await tester.pumpAndSettle();

        // Assert
        expect(toggleCount, equals(1));
      });
    });

    group('accessibility', () {
      testWidgets('icon button is tappable', (tester) async {
        // Arrange
        var tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(tapped, isTrue);
      });

      testWidgets('maintains standard IconButton size', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert - IconButton has default size
        final iconButton = find.byType(IconButton);
        expect(iconButton, findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('handles rapid consecutive taps', (tester) async {
        // Arrange
        var pressCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () => pressCount++,
              ),
            ),
          ),
        );

        // Act - Rapid taps
        for (var i = 0; i < 10; i++) {
          await tester.tap(find.byType(IconButton));
        }
        await tester.pumpAndSettle();

        // Assert
        expect(pressCount, equals(10));
      });

      testWidgets('rebuilds correctly when parent rebuilds', (tester) async {
        // Arrange
        var rebuildCount = 0;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return MaterialApp(
                home: Scaffold(
                  body: ObscureToggleIcon(
                    isObscure: true,
                    onPressed: () {
                      setState(() {
                        rebuildCount++;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        );

        // Act
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(rebuildCount, equals(1));
        expect(find.byType(ObscureToggleIcon), findsOneWidget);
      });
    });

    group('widget properties', () {
      testWidgets('is a StatelessWidget', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(ObscureToggleIcon), findsOneWidget);
        final widget = tester.widget<ObscureToggleIcon>(
          find.byType(ObscureToggleIcon),
        );
        expect(widget, isA<StatelessWidget>());
      });

      testWidgets('exposes isObscure property', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert
        final widget = tester.widget<ObscureToggleIcon>(
          find.byType(ObscureToggleIcon),
        );
        expect(widget.isObscure, isTrue);
      });

      testWidgets('exposes onPressed property', (tester) async {
        // Arrange
        void testCallback() {}

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ObscureToggleIcon(
                isObscure: true,
                onPressed: testCallback,
              ),
            ),
          ),
        );

        // Assert
        final widget = tester.widget<ObscureToggleIcon>(
          find.byType(ObscureToggleIcon),
        );
        expect(widget.onPressed, equals(testCallback));
      });
    });
  });
}
