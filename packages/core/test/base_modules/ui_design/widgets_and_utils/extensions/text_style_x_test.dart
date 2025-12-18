import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/text_style_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextStyleX', () {
    late TextStyle baseStyle;

    setUp(() {
      baseStyle = const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      );
    });

    group('withWeight method', () {
      test('sets font weight to bold', () {
        // Act
        final styled = baseStyle.withWeight(FontWeight.bold);

        // Assert
        expect(styled.fontWeight, equals(FontWeight.bold));
      });

      test('sets font weight to w300', () {
        // Act
        final styled = baseStyle.withWeight(FontWeight.w300);

        // Assert
        expect(styled.fontWeight, equals(FontWeight.w300));
      });

      test('preserves other properties', () {
        // Act
        final styled = baseStyle.withWeight(FontWeight.w600);

        // Assert
        expect(styled.fontSize, equals(14));
        expect(styled.color, equals(Colors.black));
      });
    });

    group('withSize method', () {
      test('sets font size to 18', () {
        // Act
        final styled = baseStyle.withSize(18);

        // Assert
        expect(styled.fontSize, equals(18));
      });

      test('sets font size to 24', () {
        // Act
        final styled = baseStyle.withSize(24);

        // Assert
        expect(styled.fontSize, equals(24));
      });

      test('preserves other properties', () {
        // Act
        final styled = baseStyle.withSize(20);

        // Assert
        expect(styled.fontWeight, equals(FontWeight.normal));
        expect(styled.color, equals(Colors.black));
      });
    });

    group('withColor method', () {
      test('sets color to red', () {
        // Act
        final styled = baseStyle.withColor(Colors.red);

        // Assert
        expect(styled.color, equals(Colors.red));
      });

      test('sets color to blue', () {
        // Act
        final styled = baseStyle.withColor(Colors.blue);

        // Assert
        expect(styled.color, equals(Colors.blue));
      });

      test('preserves other properties', () {
        // Act
        final styled = baseStyle.withColor(Colors.green);

        // Assert
        expect(styled.fontSize, equals(14));
        expect(styled.fontWeight, equals(FontWeight.normal));
      });
    });

    group('withSpacing method', () {
      test('sets letter spacing to 1.5', () {
        // Act
        final styled = baseStyle.withSpacing(1.5);

        // Assert
        expect(styled.letterSpacing, equals(1.5));
      });

      test('sets letter spacing to 0.5', () {
        // Act
        final styled = baseStyle.withSpacing(0.5);

        // Assert
        expect(styled.letterSpacing, equals(0.5));
      });

      test('sets negative letter spacing', () {
        // Act
        final styled = baseStyle.withSpacing(-0.5);

        // Assert
        expect(styled.letterSpacing, equals(-0.5));
      });

      test('preserves other properties', () {
        // Act
        final styled = baseStyle.withSpacing(2);

        // Assert
        expect(styled.fontSize, equals(14));
        expect(styled.color, equals(Colors.black));
      });
    });

    group('withFont method', () {
      test('sets font family to Roboto', () {
        // Act
        final styled = baseStyle.withFont('Roboto');

        // Assert
        expect(styled.fontFamily, equals('Roboto'));
      });

      test('sets font family to Inter', () {
        // Act
        final styled = baseStyle.withFont('Inter');

        // Assert
        expect(styled.fontFamily, equals('Inter'));
      });

      test('preserves other properties', () {
        // Act
        final styled = baseStyle.withFont('Montserrat');

        // Assert
        expect(styled.fontSize, equals(14));
        expect(styled.fontWeight, equals(FontWeight.normal));
      });
    });

    group('italic method', () {
      test('sets font style to italic', () {
        // Act
        final styled = baseStyle.italic();

        // Assert
        expect(styled.fontStyle, equals(FontStyle.italic));
      });

      test('preserves other properties', () {
        // Act
        final styled = baseStyle.italic();

        // Assert
        expect(styled.fontSize, equals(14));
        expect(styled.fontWeight, equals(FontWeight.normal));
        expect(styled.color, equals(Colors.black));
      });
    });

    group('bold method', () {
      test('sets font weight to bold', () {
        // Act
        final styled = baseStyle.bold();

        // Assert
        expect(styled.fontWeight, equals(FontWeight.bold));
      });

      test('overrides existing font weight', () {
        // Arrange
        const lightStyle = TextStyle(fontWeight: FontWeight.w300);

        // Act
        final styled = lightStyle.bold();

        // Assert
        expect(styled.fontWeight, equals(FontWeight.bold));
      });

      test('preserves other properties', () {
        // Act
        final styled = baseStyle.bold();

        // Assert
        expect(styled.fontSize, equals(14));
        expect(styled.color, equals(Colors.black));
      });
    });

    group('method chaining', () {
      test('chains withSize and withColor', () {
        // Act
        final styled = baseStyle.withSize(18).withColor(Colors.red);

        // Assert
        expect(styled.fontSize, equals(18));
        expect(styled.color, equals(Colors.red));
      });

      test('chains withWeight and withSize', () {
        // Act
        final styled = baseStyle.withWeight(FontWeight.bold).withSize(20);

        // Assert
        expect(styled.fontWeight, equals(FontWeight.bold));
        expect(styled.fontSize, equals(20));
      });

      test('chains bold and italic', () {
        // Act
        final styled = baseStyle.bold().italic();

        // Assert
        expect(styled.fontWeight, equals(FontWeight.bold));
        expect(styled.fontStyle, equals(FontStyle.italic));
      });

      test('chains multiple methods', () {
        // Act
        final styled = baseStyle
            .withSize(18)
            .withColor(Colors.blue)
            .withWeight(FontWeight.w600)
            .withSpacing(1.2)
            .withFont('Roboto');

        // Assert
        expect(styled.fontSize, equals(18));
        expect(styled.color, equals(Colors.blue));
        expect(styled.fontWeight, equals(FontWeight.w600));
        expect(styled.letterSpacing, equals(1.2));
        expect(styled.fontFamily, equals('Roboto'));
      });

      test('chains all methods together', () {
        // Act
        final styled = baseStyle
            .withSize(24)
            .withColor(Colors.green)
            .withWeight(FontWeight.w700)
            .withSpacing(0.8)
            .withFont('Inter')
            .italic();

        // Assert
        expect(styled.fontSize, equals(24));
        expect(styled.color, equals(Colors.green));
        expect(styled.fontWeight, equals(FontWeight.w700));
        expect(styled.letterSpacing, equals(0.8));
        expect(styled.fontFamily, equals('Inter'));
        expect(styled.fontStyle, equals(FontStyle.italic));
      });
    });

    group('real-world scenarios', () {
      test('creates heading style from base', () {
        // Arrange
        const bodyStyle = TextStyle(fontSize: 14, color: Colors.black87);

        // Act - Create heading from body
        final heading = bodyStyle.withSize(24).withWeight(FontWeight.bold);

        // Assert
        expect(heading.fontSize, equals(24));
        expect(heading.fontWeight, equals(FontWeight.bold));
        expect(heading.color, equals(Colors.black87));
      });

      test('creates caption style with custom spacing', () {
        // Arrange
        const baseStyle = TextStyle(fontSize: 16);

        // Act - Create caption
        final caption = baseStyle
            .withSize(12)
            .withColor(Colors.grey)
            .withSpacing(0.4);

        // Assert
        expect(caption.fontSize, equals(12));
        expect(caption.color, equals(Colors.grey));
        expect(caption.letterSpacing, equals(0.4));
      });

      test('creates emphasized text style', () {
        // Arrange
        const normalText = TextStyle(
          fontSize: 14,
          color: Colors.black,
        );

        // Act - Emphasize
        final emphasized = normalText.bold().italic();

        // Assert
        expect(emphasized.fontWeight, equals(FontWeight.bold));
        expect(emphasized.fontStyle, equals(FontStyle.italic));
      });

      test('customizes button text style', () {
        // Arrange
        const defaultButton = TextStyle(fontSize: 14);

        // Act - Customize for CTA button
        final ctaButton = defaultButton
            .withSize(16)
            .withWeight(FontWeight.w600)
            .withColor(Colors.white)
            .withSpacing(0.5);

        // Assert
        expect(ctaButton.fontSize, equals(16));
        expect(ctaButton.fontWeight, equals(FontWeight.w600));
        expect(ctaButton.color, equals(Colors.white));
        expect(ctaButton.letterSpacing, equals(0.5));
      });

      test('applies brand font to style', () {
        // Arrange
        const systemStyle = TextStyle(fontSize: 16);

        // Act - Apply brand font
        final brandStyle = systemStyle.withFont('Montserrat');

        // Assert
        expect(brandStyle.fontFamily, equals('Montserrat'));
        expect(brandStyle.fontSize, equals(16));
      });
    });

    group('edge cases', () {
      test('works with empty TextStyle', () {
        // Arrange
        const emptyStyle = TextStyle();

        // Act
        final styled = emptyStyle.withSize(16).withColor(Colors.red);

        // Assert
        expect(styled.fontSize, equals(16));
        expect(styled.color, equals(Colors.red));
      });

      test('overwrites previous values in chain', () {
        // Act
        final styled = baseStyle
            .withSize(18)
            .withSize(24) // Overwrite
            .withColor(Colors.red)
            .withColor(Colors.blue); // Overwrite

        // Assert
        expect(styled.fontSize, equals(24));
        expect(styled.color, equals(Colors.blue));
      });

      test('handles zero letter spacing', () {
        // Act
        final styled = baseStyle.withSpacing(0);

        // Assert
        expect(styled.letterSpacing, equals(0));
      });

      test('handles large font sizes', () {
        // Act
        final styled = baseStyle.withSize(100);

        // Assert
        expect(styled.fontSize, equals(100));
      });

      test('handles small font sizes', () {
        // Act
        final styled = baseStyle.withSize(8);

        // Assert
        expect(styled.fontSize, equals(8));
      });
    });

    group('immutability', () {
      test('original style is not mutated', () {
        // Arrange
        const original = TextStyle(fontSize: 14, color: Colors.black);

        // Act
        original.withSize(18).withColor(Colors.red);

        // Assert - Original unchanged
        expect(original.fontSize, equals(14));
        expect(original.color, equals(Colors.black));
      });

      test('each method returns new instance', () {
        // Arrange
        final style1 = baseStyle;

        // Act
        final style2 = style1.withSize(18);
        final style3 = style2.withColor(Colors.red);

        // Assert - All different instances
        expect(identical(style1, style2), isFalse);
        expect(identical(style2, style3), isFalse);
        expect(identical(style1, style3), isFalse);
      });
    });

    group('consistency with copyWith', () {
      test('withWeight behaves like copyWith', () {
        // Act
        final extended = baseStyle.withWeight(FontWeight.bold);
        final manual = baseStyle.copyWith(fontWeight: FontWeight.bold);

        // Assert
        expect(extended.fontWeight, equals(manual.fontWeight));
      });

      test('withSize behaves like copyWith', () {
        // Act
        final extended = baseStyle.withSize(20);
        final manual = baseStyle.copyWith(fontSize: 20);

        // Assert
        expect(extended.fontSize, equals(manual.fontSize));
      });

      test('withColor behaves like copyWith', () {
        // Act
        final extended = baseStyle.withColor(Colors.red);
        final manual = baseStyle.copyWith(color: Colors.red);

        // Assert
        expect(extended.color, equals(manual.color));
      });
    });
  });
}
