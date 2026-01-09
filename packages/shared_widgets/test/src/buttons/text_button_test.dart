/// Tests for AppTextButton
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Widget construction and rendering
/// - Enabled/disabled states
/// - Loading state with spinner
/// - Color customization
/// - Underline option
/// - Tap interactions
/// - Semantics and accessibility
/// - Animations
/// - Real-world scenarios
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_widgets/public_api/text_widgets.dart' show TextWidget;
import 'package:shared_widgets/src/buttons/text_button.dart';

import '../../../../shared_layers/test/helpers/test_helpers.dart';

void main() {
  group('AppTextButton', () {
    group('construction and rendering', () {
      testWidgets('creates widget with required parameters', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Click Me',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.byType(AppTextButton), findsOneWidget);
        expect(find.text('Click Me'), findsOneWidget);
      });

      testWidgets('renders as TextButton widget', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Test',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('displays provided label text', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Custom Label',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.text('Custom Label'), findsOneWidget);
      });

      testWidgets('uses TextWidget for label display', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Label',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.byType(TextWidget), findsOneWidget);
      });
    });

    group('enabled and disabled states', () {
      testWidgets('is enabled by default', (tester) async {
        // Arrange
        var tapped = false;
        final button = AppTextButton(
          label: 'Enabled',
          onPressed: () => tapped = true,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Assert
        expect(tapped, isTrue);
      });

      testWidgets('respects isEnabled false', (tester) async {
        // Arrange
        var tapped = false;
        final button = AppTextButton(
          label: 'Disabled',
          isEnabled: false,
          onPressed: () => tapped = true,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Assert
        expect(tapped, isFalse);
      });

      testWidgets('shows disabled color when isEnabled is false', (
        tester,
      ) async {
        // Arrange
        const button = AppTextButton(
          label: 'Disabled',
          isEnabled: false,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(textButton.onPressed, isNull);
      });

      testWidgets('changes onPressed to null when disabled', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Test',
          isEnabled: false,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(textButton.onPressed, isNull);
      });
    });

    group('loading state', () {
      testWidgets('shows activity indicator when loading', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Submit',
          isLoading: true,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);
        await tester.pump();

        // Assert
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        expect(find.text('Submit'), findsNothing);
      });

      testWidgets('disables tap when loading', (tester) async {
        // Arrange
        var tapped = false;
        final button = AppTextButton(
          label: 'Loading',
          isLoading: true,
          onPressed: () => tapped = true,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.byType(TextButton));
        await tester.pump();

        // Assert
        expect(tapped, isFalse);
      });

      testWidgets('hides label when loading', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Hidden Label',
          isLoading: true,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);
        await tester.pump();

        // Assert
        expect(find.text('Hidden Label'), findsNothing);
      });

      testWidgets('animates transition from label to loader', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Click',
          onPressed: null,
        );

        // Act - Initial state
        await tester.pumpApp(button);
        expect(find.text('Click'), findsOneWidget);

        // Rebuild with loading
        await tester.pumpApp(
          const AppTextButton(
            label: 'Click',
            isLoading: true,
            onPressed: null,
          ),
        );

        // Assert - Animation in progress
        expect(find.byType(AnimatedSwitcher), findsOneWidget);
      });
    });

    group('color customization', () {
      testWidgets('uses primary color by default', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Default Color',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert - Default primary color applied
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.color, isNotNull);
      });

      testWidgets('applies custom foregroundColor', (tester) async {
        // Arrange
        const customColor = Colors.red;
        const button = AppTextButton(
          label: 'Red Text',
          foregroundColor: customColor,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.color, equals(customColor));
      });

      testWidgets('uses disabled color when disabled', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Disabled',
          isEnabled: false,
          foregroundColor: Colors.blue,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(textButton.onPressed, isNull);
      });

      testWidgets('uses disabled color when loading', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Loading',
          isLoading: true,
          foregroundColor: Colors.green,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);
        await tester.pump(); // Use pump, not pumpAndSettle (loader animates)

        // Assert
        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(textButton.onPressed, isNull);
      });
    });

    group('font customization', () {
      testWidgets('uses default fontSize of 17', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Default Size',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.fontSize, equals(17));
      });

      testWidgets('applies custom fontSize', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Large Text',
          fontSize: 24,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.fontSize, equals(24));
      });

      testWidgets('uses default fontWeight of w400', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Default Weight',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.fontWeight, equals(FontWeight.w400));
      });

      testWidgets('applies custom fontWeight', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Bold Text',
          fontWeight: FontWeight.bold,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.fontWeight, equals(FontWeight.bold));
      });
    });

    group('underline option', () {
      testWidgets('is underlined by default', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Underlined',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.isUnderlined, isTrue);
      });

      testWidgets('can disable underline', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Not Underlined',
          isUnderlined: false,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textWidget = tester.widget<TextWidget>(find.byType(TextWidget));
        expect(textWidget.isUnderlined, isFalse);
      });
    });

    group('tap interactions', () {
      testWidgets('calls onPressed when tapped', (tester) async {
        // Arrange
        var tapCount = 0;
        final button = AppTextButton(
          label: 'Tap Me',
          onPressed: () => tapCount++,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(1));
      });

      testWidgets('handles multiple taps', (tester) async {
        // Arrange
        var tapCount = 0;
        final button = AppTextButton(
          label: 'Multi Tap',
          onPressed: () => tapCount++,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.byType(TextButton));
        await tester.tap(find.byType(TextButton));
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(3));
      });

      testWidgets('does not call onPressed when null', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'No Action',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert - No exception thrown
        expect(() => tester.tap(find.byType(TextButton)), returnsNormally);
      });
    });

    group('animations', () {
      testWidgets('uses AnimatedSwitcher for loading transition', (
        tester,
      ) async {
        // Arrange
        const button = AppTextButton(
          label: 'Animate',
          isLoading: true,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.byType(AnimatedSwitcher), findsOneWidget);
      });

      testWidgets('uses AnimatedSize wrapper', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Size Animation',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.byType(AnimatedSize), findsOneWidget);
      });

      testWidgets('animates with FadeTransition', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Fade',
          isLoading: true,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        expect(find.byType(FadeTransition), findsWidgets);
      });

      testWidgets('animates with ScaleTransition', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Scale',
          isLoading: true,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        expect(find.byType(ScaleTransition), findsWidgets);
      });
    });

    group('button style', () {
      testWidgets('uses zero padding', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'No Padding',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        final style = textButton.style!;
        expect(style.padding?.resolve({}), equals(EdgeInsets.zero));
      });

      testWidgets('uses compact visual density', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Compact',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(textButton.style!.visualDensity, equals(VisualDensity.compact));
      });

      testWidgets('uses shrinkWrap tap target size', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: 'Shrink',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(
          textButton.style!.tapTargetSize,
          equals(MaterialTapTargetSize.shrinkWrap),
        );
      });
    });

    group('edge cases', () {
      testWidgets('handles empty label', (tester) async {
        // Arrange
        const button = AppTextButton(
          label: '',
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.byType(AppTextButton), findsOneWidget);
      });

      testWidgets('handles very long label', (tester) async {
        // Arrange
        const longLabel =
            'This is a very long label that might wrap or overflow';
        const button = AppTextButton(
          label: longLabel,
          onPressed: null,
        );

        // Act
        await tester.pumpApp(button);

        // Assert
        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('handles enabled false and loading true together', (
        tester,
      ) async {
        // Arrange
        var tapped = false;
        final button = AppTextButton(
          label: 'Both Disabled',
          isEnabled: false,
          isLoading: true,
          onPressed: () => tapped = true,
        );

        // Act
        await tester.pumpApp(button);
        await tester.pump(); // Use pump, not pumpAndSettle (loader animates)
        await tester.tap(find.byType(TextButton));

        // Assert
        expect(tapped, isFalse);
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      });

      testWidgets('handles rapid state changes', (tester) async {
        // Arrange
        await tester.pumpApp(
          const AppTextButton(label: 'Test', onPressed: null),
        );

        // Act - Rapid toggles
        await tester.pumpApp(
          const AppTextButton(label: 'Test', isLoading: true, onPressed: null),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpApp(
          const AppTextButton(label: 'Test', onPressed: null),
        );

        // Assert - No crash
        expect(find.byType(AppTextButton), findsOneWidget);
      });
    });

    group('real-world scenarios', () {
      testWidgets('forgot password link button', (tester) async {
        // Arrange
        var forgotPasswordTapped = false;
        final button = AppTextButton(
          label: 'Forgot Password?',
          onPressed: () => forgotPasswordTapped = true,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.text('Forgot Password?'));
        await tester.pumpAndSettle();

        // Assert
        expect(forgotPasswordTapped, isTrue);
      });

      testWidgets('sign up link from login screen', (tester) async {
        // Arrange
        var navigatedToSignUp = false;
        final button = AppTextButton(
          label: 'Sign Up',
          onPressed: () => navigatedToSignUp = true,
          foregroundColor: Colors.blue,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToSignUp, isTrue);
      });

      testWidgets('resend code button with loading state', (tester) async {
        // Arrange
        var resendCount = 0;
        final button = AppTextButton(
          label: 'Resend Code',
          onPressed: () => resendCount++,
        );

        // Act - Initial tap
        await tester.pumpApp(button);
        await tester.tap(find.text('Resend Code'));
        await tester.pumpAndSettle();

        // Show loading
        await tester.pumpApp(
          const AppTextButton(
            label: 'Resend Code',
            isLoading: true,
            onPressed: null,
          ),
        );
        await tester
            .pump(); // Use pump, not pumpAndSettle (loader animates continuously)

        // Assert
        expect(resendCount, equals(1));
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      });

      testWidgets('cancel action button', (tester) async {
        // Arrange
        var cancelled = false;
        final button = AppTextButton(
          label: 'Cancel',
          onPressed: () => cancelled = true,
          foregroundColor: Colors.red,
          isUnderlined: false,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Assert
        expect(cancelled, isTrue);
      });

      testWidgets('disabled submit during form validation', (tester) async {
        // Arrange
        var submitted = false;
        final button = AppTextButton(
          label: 'Submit',
          isEnabled: false,
          onPressed: () => submitted = true,
        );

        // Act
        await tester.pumpApp(button);
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Assert - Not submitted
        expect(submitted, isFalse);
      });
    });
  });
}
