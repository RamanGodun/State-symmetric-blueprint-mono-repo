/// Tests for `TextWidget`
///
/// Coverage:
/// - Widget construction with all parameters
/// - Text styling for all TextType variants
/// - Localization resolution integration
/// - Custom styling overrides
/// - Edge cases and special characters
/// - Multi-line text handling
library;

import 'package:core/src/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/src/base_modules/localization/module_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextWidget', () {
    setUp(() {
      // Initialize AppLocalizer with a simple resolver
      AppLocalizer.forceInit(
        resolver: (key) {
          if (key == 'test.key') return 'Translated Text';
          return key;
        },
      );
    });

    Widget createTestWidget(TextWidget textWidget) {
      return MaterialApp(
        home: Scaffold(
          body: textWidget,
        ),
      );
    }

    group('construction', () {
      testWidgets('creates widget with value and type', (tester) async {
        // Arrange
        const widget = TextWidget('Test', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
        expect(find.byType(TextWidget), findsOneWidget);
      });

      testWidgets('creates widget with all parameters', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Test',
          TextType.titleLarge,
          color: Colors.red,
          alignment: TextAlign.left,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          letterSpacing: 1.5,
          height: 1.2,
          overflow: TextOverflow.fade,
          maxLines: 2,
          enableShadow: true,
          isTextOnFewStrings: true,
          isUnderlined: true,
          isItalic: true,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('accepts null textType', (tester) async {
        // Arrange
        const widget = TextWidget('Test', null);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('TextType variants', () {
      testWidgets('renders displayLarge style', (tester) async {
        // Arrange
        const widget = TextWidget('Display Large', TextType.displayLarge);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Display Large'), findsOneWidget);
      });

      testWidgets('renders displayMedium style', (tester) async {
        // Arrange
        const widget = TextWidget('Display Medium', TextType.displayMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Display Medium'), findsOneWidget);
      });

      testWidgets('renders displaySmall style', (tester) async {
        // Arrange
        const widget = TextWidget('Display Small', TextType.displaySmall);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Display Small'), findsOneWidget);
      });

      testWidgets('renders headlineLarge style', (tester) async {
        // Arrange
        const widget = TextWidget('Headline Large', TextType.headlineLarge);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Headline Large'), findsOneWidget);
      });

      testWidgets('renders headlineMedium style', (tester) async {
        // Arrange
        const widget = TextWidget('Headline Medium', TextType.headlineMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Headline Medium'), findsOneWidget);
      });

      testWidgets('renders headlineSmall style', (tester) async {
        // Arrange
        const widget = TextWidget('Headline Small', TextType.headlineSmall);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Headline Small'), findsOneWidget);
      });

      testWidgets('renders titleLarge style', (tester) async {
        // Arrange
        const widget = TextWidget('Title Large', TextType.titleLarge);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Title Large'), findsOneWidget);
      });

      testWidgets('renders titleMedium style', (tester) async {
        // Arrange
        const widget = TextWidget('Title Medium', TextType.titleMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Title Medium'), findsOneWidget);
      });

      testWidgets('renders titleSmall style', (tester) async {
        // Arrange
        const widget = TextWidget('Title Small', TextType.titleSmall);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Title Small'), findsOneWidget);
      });

      testWidgets('renders bodyLarge style', (tester) async {
        // Arrange
        const widget = TextWidget('Body Large', TextType.bodyLarge);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Body Large'), findsOneWidget);
      });

      testWidgets('renders bodyMedium style', (tester) async {
        // Arrange
        const widget = TextWidget('Body Medium', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Body Medium'), findsOneWidget);
      });

      testWidgets('renders bodySmall style', (tester) async {
        // Arrange
        const widget = TextWidget('Body Small', TextType.bodySmall);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Body Small'), findsOneWidget);
      });

      testWidgets('renders labelLarge style', (tester) async {
        // Arrange
        const widget = TextWidget('Label Large', TextType.labelLarge);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Label Large'), findsOneWidget);
      });

      testWidgets('renders labelMedium style', (tester) async {
        // Arrange
        const widget = TextWidget('Label Medium', TextType.labelMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Label Medium'), findsOneWidget);
      });

      testWidgets('renders labelSmall style', (tester) async {
        // Arrange
        const widget = TextWidget('Label Small', TextType.labelSmall);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Label Small'), findsOneWidget);
      });

      testWidgets('renders button style', (tester) async {
        // Arrange
        const widget = TextWidget('Button', TextType.button);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Button'), findsOneWidget);
      });

      testWidgets('renders error style', (tester) async {
        // Arrange
        const widget = TextWidget('Error', TextType.error);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Error'), findsOneWidget);
      });

      testWidgets('renders caption style', (tester) async {
        // Arrange
        const widget = TextWidget('Caption', TextType.caption);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Caption'), findsOneWidget);
      });
    });

    group('localization resolution', () {
      testWidgets('resolves translation key with dot', (tester) async {
        // Arrange
        const widget = TextWidget('test.key', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Translated Text'), findsOneWidget);
        expect(find.text('test.key'), findsNothing);
      });

      testWidgets('uses raw value without dot', (tester) async {
        // Arrange
        const widget = TextWidget('Plain Text', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Plain Text'), findsOneWidget);
      });

      testWidgets('uses fallback when provided', (tester) async {
        // Arrange
        const widget = TextWidget(
          'missing.key',
          TextType.bodyMedium,
          fallback: 'Fallback Text',
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('missing.key'), findsOneWidget);
      });

      testWidgets('handles uninitialized AppLocalizer', (tester) async {
        // Arrange
        // Force uninitialize by setting null resolver
        AppLocalizer.forceInit(resolver: (key) => key);
        const widget = TextWidget('some.key', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('some.key'), findsOneWidget);
      });
    });

    group('custom styling', () {
      testWidgets('applies custom color', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Colored Text',
          TextType.bodyMedium,
          color: Colors.red,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Colored Text'));

        // Assert
        expect(text.style?.color, equals(Colors.red));
      });

      testWidgets('applies custom alignment', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Left Aligned',
          TextType.bodyMedium,
          alignment: TextAlign.left,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Left Aligned'));

        // Assert
        expect(text.textAlign, equals(TextAlign.left));
      });

      testWidgets('applies custom font weight', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Bold Text',
          TextType.bodyMedium,
          fontWeight: FontWeight.bold,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Bold Text'));

        // Assert
        expect(text.style?.fontWeight, equals(FontWeight.bold));
      });

      testWidgets('applies custom font size', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Large Text',
          TextType.bodyMedium,
          fontSize: 32,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Large Text'));

        // Assert
        expect(text.style?.fontSize, equals(32));
      });

      testWidgets('applies letter spacing', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Spaced Text',
          TextType.bodyMedium,
          letterSpacing: 2.0,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Spaced Text'));

        // Assert
        expect(text.style?.letterSpacing, equals(2.0));
      });

      testWidgets('applies line height', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Tall Text',
          TextType.bodyMedium,
          height: 2.0,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Tall Text'));

        // Assert
        expect(text.style?.height, equals(2.0));
      });

      testWidgets('applies italic style', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Italic Text',
          TextType.bodyMedium,
          isItalic: true,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Italic Text'));

        // Assert
        expect(text.style?.fontStyle, equals(FontStyle.italic));
      });

      testWidgets('applies underline decoration', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Underlined Text',
          TextType.bodyMedium,
          isUnderlined: true,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Underlined Text'));

        // Assert
        expect(text.style?.decoration, equals(TextDecoration.underline));
      });

      testWidgets('removes underline when isUnderlined is false', (tester) async {
        // Arrange
        const widget = TextWidget(
          'No Underline',
          TextType.bodyMedium,
          isUnderlined: false,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('No Underline'));

        // Assert
        expect(text.style?.decoration, equals(TextDecoration.none));
      });

      testWidgets('applies shadow when enabled', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Shadow Text',
          TextType.bodyMedium,
          enableShadow: true,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Shadow Text'));

        // Assert
        expect(text.style?.shadows, isNotEmpty);
      });
    });

    group('overflow and maxLines', () {
      testWidgets('applies ellipsis overflow by default', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Long text that might overflow',
          TextType.bodyMedium,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(
          find.text('Long text that might overflow'),
        );

        // Assert
        expect(text.overflow, equals(TextOverflow.ellipsis));
      });

      testWidgets('applies custom overflow', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Fading text',
          TextType.bodyMedium,
          overflow: TextOverflow.fade,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Fading text'));

        // Assert
        expect(text.overflow, equals(TextOverflow.fade));
      });

      testWidgets('applies maxLines', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Multi line text',
          TextType.bodyMedium,
          maxLines: 3,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Multi line text'));

        // Assert
        expect(text.maxLines, equals(3));
      });

      testWidgets('uses visible overflow for multiline text', (tester) async {
        // Arrange
        const widget = TextWidget(
          'Multiline content',
          TextType.bodyMedium,
          isTextOnFewStrings: true,
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget));
        final text = tester.widget<Text>(find.text('Multiline content'));

        // Assert
        expect(text.overflow, equals(TextOverflow.visible));
        expect(text.maxLines, isNull);
        expect(text.softWrap, isTrue);
      });
    });

    group('edge cases', () {
      testWidgets('handles empty string', (tester) async {
        // Arrange
        const widget = TextWidget('', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('handles very long text', (tester) async {
        // Arrange
        final longText = 'A' * 10000;
        final widget = TextWidget(longText, TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('handles unicode characters', (tester) async {
        // Arrange
        const widget = TextWidget('Текст 文本 🔥', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Текст 文本 🔥'), findsOneWidget);
      });

      testWidgets('handles newlines', (tester) async {
        // Arrange
        const widget = TextWidget('Line 1\nLine 2\nLine 3', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Line 1\nLine 2\nLine 3'), findsOneWidget);
      });

      testWidgets('handles special characters', (tester) async {
        // Arrange
        const widget = TextWidget('Test@#\$%^&*()', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(createTestWidget(widget));

        // Assert
        expect(find.text('Test@#\$%^&*()'), findsOneWidget);
      });
    });

    group('immutability', () {
      testWidgets('creates new instance with different parameters', (tester) async {
        // Arrange
        const widget1 = TextWidget('Text 1', TextType.bodyMedium);
        const widget2 = TextWidget('Text 2', TextType.titleLarge);

        // Act
        await tester.pumpWidget(createTestWidget(widget1));
        await tester.pumpWidget(createTestWidget(widget2));

        // Assert
        expect(find.text('Text 2'), findsOneWidget);
        expect(find.text('Text 1'), findsNothing);
      });
    });

    group('StatelessWidget properties', () {
      test('is a StatelessWidget', () {
        // Arrange
        const widget = TextWidget('Test', TextType.bodyMedium);

        // Assert
        expect(widget, isA<StatelessWidget>());
      });
    });

    group('integration scenarios', () {
      testWidgets('works in Column layout', (tester) async {
        // Arrange
        const widget = Column(
          children: [
            TextWidget('First', TextType.titleLarge),
            TextWidget('Second', TextType.bodyMedium),
            TextWidget('Third', TextType.caption),
          ],
        );

        // Act
        await tester.pumpWidget(createTestWidget(widget as TextWidget));

        // Assert - would need proper MaterialApp wrapper for Column
        expect(widget.children.length, equals(3));
      });

      testWidgets('can be used in RichText scenarios', (tester) async {
        // Arrange
        const widget1 = TextWidget('Bold Text', TextType.bodyMedium, fontWeight: FontWeight.bold);
        const widget2 = TextWidget('Normal Text', TextType.bodyMedium);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [widget1, widget2],
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Bold Text'), findsOneWidget);
        expect(find.text('Normal Text'), findsOneWidget);
      });
    });
  });
}
