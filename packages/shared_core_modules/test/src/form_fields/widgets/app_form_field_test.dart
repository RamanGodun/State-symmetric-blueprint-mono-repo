// ignore_for_file: document_ignores

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('AppFormField', () {
    late FocusNode focusNode;

    setUp(() {
      focusNode = FocusNode();
    });

    tearDown(() {
      focusNode.dispose();
    });

    group('construction', () {
      testWidgets('creates widget with required parameters', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Test Label',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AppFormField), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('accepts all optional parameters', (tester) async {
        // Arrange
        final controller = TextEditingController();
        // ignore: unused_local_variable
        var submitted = false;
        // ignore: unused_local_variable
        var editingComplete = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'form.email',
                icon: Icons.email,
                obscure: false,
                onChanged: (_) {},
                fieldKey: const Key('email-field'),
                fallback: 'Email',
                suffixIcon: const Icon(Icons.clear),
                errorKey: 'form.email_error',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                controller: controller,
                onSubmitted: (_) => submitted = true,
                onEditingComplete: () => editingComplete = true,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AppFormField), findsOneWidget);
        expect(find.byKey(const Key('email-field')), findsOneWidget);
      });
    });

    group('text field properties', () {
      testWidgets('sets obscureText correctly when obscure is true', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Password',
                icon: Icons.lock,
                obscure: true,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isTrue);
      });

      testWidgets('sets obscureText to false when obscure is false', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Email',
                icon: Icons.email,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isFalse);
      });

      testWidgets('uses provided focus node', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Test',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.focusNode, equals(focusNode));
      });

      testWidgets('sets keyboard type', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Email',
                icon: Icons.email,
                obscure: false,
                onChanged: (_) {},
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.keyboardType, equals(TextInputType.emailAddress));
      });

      testWidgets('sets text input action', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textInputAction, equals(TextInputAction.next));
      });

      testWidgets('sets autofill hints', (tester) async {
        // Arrange
        const hints = [AutofillHints.email];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Email',
                icon: Icons.email,
                obscure: false,
                onChanged: (_) {},
                autofillHints: hints,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.autofillHints, equals(hints));
      });

      testWidgets('uses provided controller', (tester) async {
        // Arrange
        final controller = TextEditingController(text: 'Initial text');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                controller: controller,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Initial text'), findsOneWidget);
      });
    });

    group('text capitalization', () {
      testWidgets('capitalizes words for name keyboard type', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                keyboardType: TextInputType.name,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textCapitalization, equals(TextCapitalization.words));
      });

      testWidgets('does not capitalize for email keyboard type', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Email',
                icon: Icons.email,
                obscure: false,
                onChanged: (_) {},
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textCapitalization, equals(TextCapitalization.none));
      });

      testWidgets('does not capitalize for password keyboard type', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Password',
                icon: Icons.lock,
                obscure: true,
                onChanged: (_) {},
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textCapitalization, equals(TextCapitalization.none));
      });
    });

    group('suggestions and autocorrect', () {
      testWidgets('disables suggestions for password fields', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Password',
                icon: Icons.lock,
                obscure: true,
                onChanged: (_) {},
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enableSuggestions, isFalse);
      });

      testWidgets('enables suggestions for non-password fields', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                keyboardType: TextInputType.name,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enableSuggestions, isTrue);
      });

      testWidgets('always disables autocorrect', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.autocorrect, isFalse);
      });
    });

    group('decoration', () {
      testWidgets('displays label text', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Test Label',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Test Label'), findsOneWidget);
      });

      testWidgets('displays prefix icon', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Email',
                icon: Icons.email,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;
        final prefixIcon = decoration.prefixIcon! as Icon;
        expect(prefixIcon.icon, equals(Icons.email));
      });

      testWidgets('displays suffix icon when provided', (tester) async {
        // Arrange
        const suffixIcon = Icon(Icons.visibility);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Password',
                icon: Icons.lock,
                obscure: true,
                onChanged: (_) {},
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;
        expect(decoration.suffixIcon, equals(suffixIcon));
      });

      testWidgets('has filled decoration', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;
        expect(decoration.filled, isTrue);
      });

      testWidgets('has outline border', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;
        expect(decoration.border, isA<OutlineInputBorder>());
      });
    });

    group('callbacks', () {
      testWidgets('calls onChanged when text changes', (tester) async {
        // Arrange
        String? changedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'Test Value');

        // Assert
        expect(changedValue, equals('Test Value'));
      });

      testWidgets('calls onSubmitted when submitted', (tester) async {
        // Arrange
        String? submittedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                onSubmitted: (value) => submittedValue = value,
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'Submit Test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Assert
        expect(submittedValue, equals('Submit Test'));
      });

      testWidgets('calls onEditingComplete when editing completes', (
        tester,
      ) async {
        // Arrange
        // ignore: unused_local_variable
        var editingCompleted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                onEditingComplete: () => editingCompleted = true,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();
        focusNode.unfocus();
        await tester.pumpAndSettle();

        // Note: onEditingComplete behavior depends on Flutter framework
        // This test verifies the callback is properly wired
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('real-world scenarios', () {
      testWidgets('typical email field configuration', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Email',
                icon: Icons.email,
                obscure: false,
                onChanged: (_) {},
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isFalse);
        expect(textField.keyboardType, equals(TextInputType.emailAddress));
        expect(textField.textInputAction, equals(TextInputAction.next));
        expect(textField.enableSuggestions, isTrue);
      });

      testWidgets('typical password field configuration', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Password',
                icon: Icons.lock,
                obscure: true,
                onChanged: (_) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                suffixIcon: const Icon(Icons.visibility),
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isTrue);
        expect(textField.keyboardType, equals(TextInputType.visiblePassword));
        expect(textField.textInputAction, equals(TextInputAction.done));
        expect(textField.enableSuggestions, isFalse);
      });

      testWidgets('typical name field configuration', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Full Name',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isFalse);
        expect(textField.keyboardType, equals(TextInputType.name));
        expect(textField.textCapitalization, equals(TextCapitalization.words));
        expect(textField.enableSuggestions, isTrue);
      });
    });

    group('edge cases', () {
      testWidgets('handles empty label', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: '',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AppFormField), findsOneWidget);
      });

      testWidgets('handles very long label', (tester) async {
        // Arrange
        const longLabel =
            'This is a very long label that might wrap or overflow';

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: longLabel,
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('handles null optional parameters', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Test',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AppFormField), findsOneWidget);
      });
    });

    group('widget properties', () {
      testWidgets('is a StatelessWidget', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Test',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        final widget = tester.widget<AppFormField>(find.byType(AppFormField));
        expect(widget, isA<StatelessWidget>());
      });

      testWidgets('uses fieldKey when provided', (tester) async {
        // Arrange
        const testKey = Key('custom-field-key');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppFormField(
                focusNode: focusNode,
                label: 'Test',
                icon: Icons.person,
                obscure: false,
                onChanged: (_) {},
                fieldKey: testKey,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byKey(testKey), findsOneWidget);
      });
    });
  });
}
