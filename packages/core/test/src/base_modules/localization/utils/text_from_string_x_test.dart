/// Tests for `GetTextWidget` extension on String
///
/// Coverage:
/// - from method with all parameters
/// - TextWidget creation
/// - Parameter passing and defaults
/// - All TextType variants
/// - Edge cases
library;

import 'package:core/src/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/src/base_modules/localization/utils/text_from_string_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetTextWidget', () {
    group('from method', () {
      test('creates TextWidget with string and type', () {
        // Arrange
        const text = 'Test Text';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget, isA<TextWidget>());
        expect(widget.value, equals('Test Text'));
        expect(widget.textType, equals(TextType.bodyMedium));
      });

      test('creates TextWidget with all parameters', () {
        // Arrange
        const text = 'Custom Text';

        // Act
        final widget = text.from(
          TextType.titleLarge,
          color: Colors.red,
          align: TextAlign.left,
          weight: FontWeight.bold,
          size: 24,
          spacing: 1.5,
          height: 1.2,
          overflow: TextOverflow.fade,
          maxLines: 3,
          shadow: true,
          multiline: true,
          underline: true,
        );

        // Assert
        expect(widget, isA<TextWidget>());
        expect(widget.value, equals('Custom Text'));
        expect(widget.textType, equals(TextType.titleLarge));
        expect(widget.color, equals(Colors.red));
        expect(widget.alignment, equals(TextAlign.left));
        expect(widget.fontWeight, equals(FontWeight.bold));
        expect(widget.fontSize, equals(24));
        expect(widget.letterSpacing, equals(1.5));
        expect(widget.height, equals(1.2));
        expect(widget.overflow, equals(TextOverflow.fade));
        expect(widget.maxLines, equals(3));
        expect(widget.enableShadow, isTrue);
        expect(widget.isTextOnFewStrings, isTrue);
        expect(widget.isUnderlined, isTrue);
      });

      test('creates TextWidget with default parameters', () {
        // Arrange
        const text = 'Simple Text';

        // Act
        final widget = text.from(TextType.bodySmall);

        // Assert
        expect(widget.color, isNull);
        expect(widget.alignment, isNull);
        expect(widget.fontWeight, isNull);
        expect(widget.fontSize, isNull);
        expect(widget.letterSpacing, isNull);
        expect(widget.height, isNull);
        expect(widget.overflow, isNull);
        expect(widget.maxLines, isNull);
        expect(widget.enableShadow, isFalse);
        expect(widget.isTextOnFewStrings, isNull);
        expect(widget.isUnderlined, isNull);
      });
    });

    group('all TextType variants', () {
      test('creates widget with displayLarge', () {
        // Arrange
        const text = 'Display';

        // Act
        final widget = text.from(TextType.displayLarge);

        // Assert
        expect(widget.textType, equals(TextType.displayLarge));
      });

      test('creates widget with displayMedium', () {
        // Arrange
        const text = 'Display';

        // Act
        final widget = text.from(TextType.displayMedium);

        // Assert
        expect(widget.textType, equals(TextType.displayMedium));
      });

      test('creates widget with displaySmall', () {
        // Arrange
        const text = 'Display';

        // Act
        final widget = text.from(TextType.displaySmall);

        // Assert
        expect(widget.textType, equals(TextType.displaySmall));
      });

      test('creates widget with headlineLarge', () {
        // Arrange
        const text = 'Headline';

        // Act
        final widget = text.from(TextType.headlineLarge);

        // Assert
        expect(widget.textType, equals(TextType.headlineLarge));
      });

      test('creates widget with headlineMedium', () {
        // Arrange
        const text = 'Headline';

        // Act
        final widget = text.from(TextType.headlineMedium);

        // Assert
        expect(widget.textType, equals(TextType.headlineMedium));
      });

      test('creates widget with headlineSmall', () {
        // Arrange
        const text = 'Headline';

        // Act
        final widget = text.from(TextType.headlineSmall);

        // Assert
        expect(widget.textType, equals(TextType.headlineSmall));
      });

      test('creates widget with titleLarge', () {
        // Arrange
        const text = 'Title';

        // Act
        final widget = text.from(TextType.titleLarge);

        // Assert
        expect(widget.textType, equals(TextType.titleLarge));
      });

      test('creates widget with titleMedium', () {
        // Arrange
        const text = 'Title';

        // Act
        final widget = text.from(TextType.titleMedium);

        // Assert
        expect(widget.textType, equals(TextType.titleMedium));
      });

      test('creates widget with titleSmall', () {
        // Arrange
        const text = 'Title';

        // Act
        final widget = text.from(TextType.titleSmall);

        // Assert
        expect(widget.textType, equals(TextType.titleSmall));
      });

      test('creates widget with bodyLarge', () {
        // Arrange
        const text = 'Body';

        // Act
        final widget = text.from(TextType.bodyLarge);

        // Assert
        expect(widget.textType, equals(TextType.bodyLarge));
      });

      test('creates widget with bodyMedium', () {
        // Arrange
        const text = 'Body';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.textType, equals(TextType.bodyMedium));
      });

      test('creates widget with bodySmall', () {
        // Arrange
        const text = 'Body';

        // Act
        final widget = text.from(TextType.bodySmall);

        // Assert
        expect(widget.textType, equals(TextType.bodySmall));
      });

      test('creates widget with labelLarge', () {
        // Arrange
        const text = 'Label';

        // Act
        final widget = text.from(TextType.labelLarge);

        // Assert
        expect(widget.textType, equals(TextType.labelLarge));
      });

      test('creates widget with labelMedium', () {
        // Arrange
        const text = 'Label';

        // Act
        final widget = text.from(TextType.labelMedium);

        // Assert
        expect(widget.textType, equals(TextType.labelMedium));
      });

      test('creates widget with labelSmall', () {
        // Arrange
        const text = 'Label';

        // Act
        final widget = text.from(TextType.labelSmall);

        // Assert
        expect(widget.textType, equals(TextType.labelSmall));
      });

      test('creates widget with button type', () {
        // Arrange
        const text = 'Button';

        // Act
        final widget = text.from(TextType.button);

        // Assert
        expect(widget.textType, equals(TextType.button));
      });

      test('creates widget with error type', () {
        // Arrange
        const text = 'Error';

        // Act
        final widget = text.from(TextType.error);

        // Assert
        expect(widget.textType, equals(TextType.error));
      });

      test('creates widget with caption type', () {
        // Arrange
        const text = 'Caption';

        // Act
        final widget = text.from(TextType.caption);

        // Assert
        expect(widget.textType, equals(TextType.caption));
      });
    });

    group('individual parameters', () {
      test('sets color parameter', () {
        // Arrange
        const text = 'Colored';

        // Act
        final widget = text.from(TextType.bodyMedium, color: Colors.blue);

        // Assert
        expect(widget.color, equals(Colors.blue));
      });

      test('sets align parameter', () {
        // Arrange
        const text = 'Aligned';

        // Act
        final widget = text.from(TextType.bodyMedium, align: TextAlign.right);

        // Assert
        expect(widget.alignment, equals(TextAlign.right));
      });

      test('sets weight parameter', () {
        // Arrange
        const text = 'Weighted';

        // Act
        final widget = text.from(TextType.bodyMedium, weight: FontWeight.w600);

        // Assert
        expect(widget.fontWeight, equals(FontWeight.w600));
      });

      test('sets size parameter', () {
        // Arrange
        const text = 'Sized';

        // Act
        final widget = text.from(TextType.bodyMedium, size: 18);

        // Assert
        expect(widget.fontSize, equals(18));
      });

      test('sets spacing parameter', () {
        // Arrange
        const text = 'Spaced';

        // Act
        final widget = text.from(TextType.bodyMedium, spacing: 1.0);

        // Assert
        expect(widget.letterSpacing, equals(1.0));
      });

      test('sets height parameter', () {
        // Arrange
        const text = 'Height';

        // Act
        final widget = text.from(TextType.bodyMedium, height: 1.5);

        // Assert
        expect(widget.height, equals(1.5));
      });

      test('sets overflow parameter', () {
        // Arrange
        const text = 'Overflow';

        // Act
        final widget = text.from(
          TextType.bodyMedium,
          overflow: TextOverflow.clip,
        );

        // Assert
        expect(widget.overflow, equals(TextOverflow.clip));
      });

      test('sets maxLines parameter', () {
        // Arrange
        const text = 'MaxLines';

        // Act
        final widget = text.from(TextType.bodyMedium, maxLines: 5);

        // Assert
        expect(widget.maxLines, equals(5));
      });

      test('sets shadow parameter', () {
        // Arrange
        const text = 'Shadow';

        // Act
        final widget = text.from(TextType.bodyMedium, shadow: true);

        // Assert
        expect(widget.enableShadow, isTrue);
      });

      test('sets multiline parameter', () {
        // Arrange
        const text = 'Multiline';

        // Act
        final widget = text.from(TextType.bodyMedium, multiline: true);

        // Assert
        expect(widget.isTextOnFewStrings, isTrue);
      });

      test('sets underline parameter', () {
        // Arrange
        const text = 'Underline';

        // Act
        final widget = text.from(TextType.bodyMedium, underline: true);

        // Assert
        expect(widget.isUnderlined, isTrue);
      });
    });

    group('edge cases', () {
      test('handles empty string', () {
        // Arrange
        const text = '';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.value, isEmpty);
      });

      test('handles very long string', () {
        // Arrange
        final text = 'A' * 10000;

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.value, equals(text));
        expect(widget.value.length, equals(10000));
      });

      test('handles unicode characters', () {
        // Arrange
        const text = 'Текст 文本 🔥';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.value, equals('Текст 文本 🔥'));
      });

      test('handles newlines', () {
        // Arrange
        const text = 'Line 1\nLine 2\nLine 3';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.value, contains('\n'));
      });

      test('handles special characters', () {
        // Arrange
        const text = '@#\$%^&*()_+{}[]|\\:";\'<>?,./';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.value, equals(text));
      });

      test('handles whitespace-only string', () {
        // Arrange
        const text = '     ';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.value, equals('     '));
      });
    });

    group('multiple calls', () {
      test('creates independent TextWidget instances', () {
        // Arrange
        const text = 'Same Text';

        // Act
        final widget1 = text.from(TextType.bodyMedium);
        final widget2 = text.from(TextType.titleLarge);

        // Assert
        expect(identical(widget1, widget2), isFalse);
        expect(widget1.textType, isNot(equals(widget2.textType)));
      });

      test('different strings create different widgets', () {
        // Arrange
        const text1 = 'Text 1';
        const text2 = 'Text 2';

        // Act
        final widget1 = text1.from(TextType.bodyMedium);
        final widget2 = text2.from(TextType.bodyMedium);

        // Assert
        expect(widget1.value, isNot(equals(widget2.value)));
      });
    });

    group('integration with TextWidget', () {
      testWidgets('created widget renders correctly', (tester) async {
        // Arrange
        const text = 'Rendered Text';
        final widget = text.from(TextType.bodyMedium);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        expect(find.text('Rendered Text'), findsOneWidget);
      });

      testWidgets('created widget with custom color renders', (tester) async {
        // Arrange
        const text = 'Colored Text';
        final widget = text.from(TextType.bodyMedium, color: Colors.red);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        expect(find.text('Colored Text'), findsOneWidget);
        final textWidget = tester.widget<Text>(find.text('Colored Text'));
        expect(textWidget.style?.color, equals(Colors.red));
      });
    });

    group('fluent API usage', () {
      test('can be chained in a single expression', () {
        // Arrange & Act
        final widget = 'Test'.from(
          TextType.titleLarge,
          color: Colors.blue,
          weight: FontWeight.bold,
        );

        // Assert
        expect(widget.value, equals('Test'));
        expect(widget.textType, equals(TextType.titleLarge));
        expect(widget.color, equals(Colors.blue));
        expect(widget.fontWeight, equals(FontWeight.bold));
      });

      test('can be used in collection operations', () {
        // Arrange
        final texts = ['First', 'Second', 'Third'];

        // Act
        final widgets = texts
            .map((t) => t.from(TextType.bodyMedium))
            .toList();

        // Assert
        expect(widgets, hasLength(3));
        expect(widgets, everyElement(isA<TextWidget>()));
        expect(widgets[0].value, equals('First'));
        expect(widgets[1].value, equals('Second'));
        expect(widgets[2].value, equals('Third'));
      });
    });

    group('real-world scenarios', () {
      test('creates error message widget', () {
        // Arrange
        const errorMessage = 'Invalid email format';

        // Act
        final widget = errorMessage.from(
          TextType.error,
          align: TextAlign.left,
        );

        // Assert
        expect(widget.value, equals('Invalid email format'));
        expect(widget.textType, equals(TextType.error));
        expect(widget.alignment, equals(TextAlign.left));
      });

      test('creates button label widget', () {
        // Arrange
        const buttonLabel = 'Submit';

        // Act
        final widget = buttonLabel.from(
          TextType.button,
          weight: FontWeight.bold,
        );

        // Assert
        expect(widget.value, equals('Submit'));
        expect(widget.textType, equals(TextType.button));
        expect(widget.fontWeight, equals(FontWeight.bold));
      });

      test('creates caption widget', () {
        // Arrange
        const caption = 'Photo taken on 2024-01-01';

        // Act
        final widget = caption.from(
          TextType.caption,
          color: Colors.grey,
        );

        // Assert
        expect(widget.value, contains('2024-01-01'));
        expect(widget.textType, equals(TextType.caption));
        expect(widget.color, equals(Colors.grey));
      });

      test('creates multiline description', () {
        // Arrange
        const description = 'This is a long description\nthat spans multiple lines';

        // Act
        final widget = description.from(
          TextType.bodyMedium,
          multiline: true,
          align: TextAlign.justify,
        );

        // Assert
        expect(widget.value, contains('\n'));
        expect(widget.isTextOnFewStrings, isTrue);
        expect(widget.alignment, equals(TextAlign.justify));
      });
    });

    group('null handling', () {
      test('optional parameters can be null', () {
        // Arrange
        const text = 'Test';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.color, isNull);
        expect(widget.alignment, isNull);
        expect(widget.fontWeight, isNull);
      });

      test('boolean parameters default to false', () {
        // Arrange
        const text = 'Test';

        // Act
        final widget = text.from(TextType.bodyMedium);

        // Assert
        expect(widget.enableShadow, isFalse);
      });
    });
  });
}
