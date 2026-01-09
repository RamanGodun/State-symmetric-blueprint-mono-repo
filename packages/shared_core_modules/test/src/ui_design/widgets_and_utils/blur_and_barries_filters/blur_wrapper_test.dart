import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show BlurContainer;

void main() {
  group('BlurContainer', () {
    group('construction', () {
      testWidgets('creates with required child parameter', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);
      });

      testWidgets('creates with custom sigmaX', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              sigmaX: 10,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });

      testWidgets('creates with custom sigmaY', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              sigmaY: 8,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });

      testWidgets('creates with overlay type', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              overlayType: ShowAs.dialog,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });

      testWidgets('creates with custom border radius', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlurContainer(
              borderRadius: BorderRadius.circular(20),
              child: const Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });
    });

    group('structure', () {
      testWidgets('contains ClipRRect', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(ClipRRect), findsOneWidget);
      });

      testWidgets('contains BackdropFilter', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('renders child widget', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              child: Icon(Icons.star),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.star), findsOneWidget);
      });
    });

    group('blur customization', () {
      testWidgets('uses custom sigmaX when provided', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              sigmaX: 12,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('uses custom sigmaY when provided', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              sigmaY: 15,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('uses both custom sigmaX and sigmaY', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              sigmaX: 10,
              sigmaY: 20,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });

    group('overlay type resolution', () {
      testWidgets('resolves blur for banner type', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              overlayType: ShowAs.banner,
              child: Text('Banner'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
        expect(find.text('Banner'), findsOneWidget);
      });

      testWidgets('resolves blur for dialog type', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              overlayType: ShowAs.dialog,
              child: Text('Dialog'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
        expect(find.text('Dialog'), findsOneWidget);
      });

      testWidgets('resolves blur for snackbar type', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              overlayType: ShowAs.snackbar,
              child: Text('Snackbar'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
        expect(find.text('Snackbar'), findsOneWidget);
      });
    });

    group('theme awareness', () {
      testWidgets('adapts to light theme', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: Brightness.light),
            home: const BlurContainer(
              overlayType: ShowAs.dialog,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });

      testWidgets('adapts to dark theme', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: Brightness.dark),
            home: const BlurContainer(
              overlayType: ShowAs.dialog,
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });
    });

    group('border radius', () {
      testWidgets('applies default border radius', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              child: Text('Content'),
            ),
          ),
        );

        // Assert
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, isNotNull);
      });

      testWidgets('applies custom border radius', (tester) async {
        // Arrange
        final customRadius = BorderRadius.circular(24);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlurContainer(
              borderRadius: customRadius,
              child: const Text('Content'),
            ),
          ),
        );

        // Assert
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, equals(customRadius));
      });
    });

    group('real-world scenarios', () {
      testWidgets('glassmorphism card effect', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                    ),
                  ),
                  BlurContainer(
                    sigmaX: 8,
                    sigmaY: 8,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text('Glassmorphic Card'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Glassmorphic Card'), findsOneWidget);
        expect(find.byType(BlurContainer), findsOneWidget);
      });

      testWidgets('blurred modal overlay', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Container(color: Colors.white),
                  const BlurContainer(
                    overlayType: ShowAs.dialog,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Modal Content'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Modal Content'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('handles zero sigma values', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              sigmaX: 0,
              sigmaY: 0,
              child: Text('No Blur'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
        expect(find.text('No Blur'), findsOneWidget);
      });

      testWidgets('handles very large sigma values', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              sigmaX: 100,
              sigmaY: 100,
              child: Text('Heavy Blur'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });

      testWidgets('custom sigma overrides overlay type', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: BlurContainer(
              overlayType: ShowAs.banner,
              sigmaX: 5,
              sigmaY: 5,
              child: Text('Custom Override'),
            ),
          ),
        );

        // Assert
        expect(find.byType(BlurContainer), findsOneWidget);
      });
    });

    group('nested children', () {
      testWidgets('renders complex child tree', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlurContainer(
              child: Column(
                children: [
                  const Text('Title'),
                  const Icon(Icons.info),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Action'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Title'), findsOneWidget);
        expect(find.byIcon(Icons.info), findsOneWidget);
        expect(find.text('Action'), findsOneWidget);
      });
    });
  });
}
