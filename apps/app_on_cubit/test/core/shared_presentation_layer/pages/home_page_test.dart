/// Tests for HomePage
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
///
/// Coverage:
/// - Widget construction
/// - Widget tree structure
/// - Navigation button presence
/// - Page cannot be popped (canPop: false)
library;

import 'package:app_on_cubit/core/shared_presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePage', () {
    testWidgets('builds without error', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Assert
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('contains Scaffold widget', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('contains PopScope widget with canPop false', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Assert
      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, isFalse);
    });

    testWidgets('has app bar', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has profile navigation button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.person_2), findsOneWidget);
    });

    testWidgets('has center widget in body', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Assert - HomePage body should contain a Center widget
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('creates with key parameter', (tester) async {
      // Arrange
      const testKey = Key('home_page_test_key');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(key: testKey),
        ),
      );

      // Assert
      expect(find.byKey(testKey), findsOneWidget);
    });
  });
}
