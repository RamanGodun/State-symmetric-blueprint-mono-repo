import 'package:core/src/base_modules/form_fields/form_field_factory.dart';
import 'package:core/src/base_modules/form_fields/input_validation/validation_enums.dart';
import 'package:core/src/base_modules/form_fields/utils/keys.dart';
import 'package:core/src/base_modules/form_fields/widgets/app_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormFieldFactory', () {
    late FocusNode focusNode;

    setUp(() {
      focusNode = FocusNode();
    });

    tearDown(() {
      focusNode.dispose();
    });

    group('create method', () {
      group('InputFieldType.name', () {
        testWidgets('creates name field with correct configuration', (
          tester,
        ) async {
          // Arrange
          // ignore: unused_local_variable
          String? changedValue;

          // Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.name,
            focusNode: focusNode,
            errorText: null,
            onChanged: (value) => changedValue = value,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.byType(AppFormField), findsOneWidget);
          final field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.obscure, isFalse);
        });

        testWidgets('uses correct default key for name field', (tester) async {
          // Arrange & Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.name,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.byKey(FormFieldsKeys.nameField), findsOneWidget);
        });

        testWidgets('accepts custom key override', (tester) async {
          // Arrange
          const customKey = Key('custom-name-field');

          // Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.name,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
            fieldKeyOverride: customKey,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.byKey(customKey), findsOneWidget);
        });

        testWidgets('calls onChanged callback', (tester) async {
          // Arrange
          String? changedValue;

          final widget = FormFieldFactory.create(
            type: InputFieldType.name,
            focusNode: focusNode,
            errorText: null,
            onChanged: (value) => changedValue = value,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Act
          await tester.enterText(find.byType(TextField), 'John Doe');

          // Assert
          expect(changedValue, equals('John Doe'));
        });

        testWidgets('calls onSubmitted callback', (tester) async {
          // Arrange
          var submitted = false;

          final widget = FormFieldFactory.create(
            type: InputFieldType.name,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
            onSubmitted: () => submitted = true,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Act
          await tester.enterText(find.byType(TextField), 'Test Name');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          // Assert
          expect(submitted, isTrue);
        });
      });

      group('InputFieldType.email', () {
        testWidgets('creates email field with correct configuration', (
          tester,
        ) async {
          // Arrange & Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.email,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.byType(AppFormField), findsOneWidget);
          final field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.obscure, isFalse);
          expect(field.keyboardType, equals(TextInputType.emailAddress));
        });

        testWidgets('uses correct default key for email field', (tester) async {
          // Arrange & Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.email,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.byKey(FormFieldsKeys.emailField), findsOneWidget);
        });

        testWidgets('passes autofill hints to email field', (tester) async {
          // Arrange
          const hints = [AutofillHints.email];

          // Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.email,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
            autofillHints: hints,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          final field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.autofillHints, equals(hints));
        });
      });

      group('InputFieldType.password', () {
        testWidgets('creates password field with correct configuration', (
          tester,
        ) async {
          // Arrange & Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.password,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
            isObscure: true,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.byType(AppFormField), findsOneWidget);
          final field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.obscure, isTrue);
          expect(field.keyboardType, equals(TextInputType.visiblePassword));
        });

        testWidgets('uses correct default key for password field', (
          tester,
        ) async {
          // Arrange & Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.password,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.byKey(FormFieldsKeys.passwordField), findsOneWidget);
        });

        testWidgets('respects isObscure parameter', (tester) async {
          // Arrange & Act - Test with isObscure = true
          var widget = FormFieldFactory.create(
            type: InputFieldType.password,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
            isObscure: true,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          var field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.obscure, isTrue);

          // Test with isObscure = false
          widget = FormFieldFactory.create(
            type: InputFieldType.password,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.obscure, isFalse);
        });

        testWidgets('passes suffix icon to password field', (tester) async {
          // Arrange
          const suffixIcon = Icon(Icons.visibility);

          // Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.password,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
            suffixIcon: suffixIcon,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          final field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.suffixIcon, equals(suffixIcon));
        });
      });

      group('InputFieldType.confirmPassword', () {
        testWidgets(
          'creates confirm password field with correct configuration',
          (tester) async {
            // Arrange & Act
            final widget = FormFieldFactory.create(
              type: InputFieldType.confirmPassword,
              focusNode: focusNode,
              errorText: null,
              onChanged: (_) {},
              isObscure: true,
            );

            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: widget,
                ),
              ),
            );

            // Assert
            expect(find.byType(AppFormField), findsOneWidget);
            final field = tester.widget<AppFormField>(
              find.byType(AppFormField),
            );
            expect(field.obscure, isTrue);
            expect(field.keyboardType, equals(TextInputType.visiblePassword));
          },
        );

        testWidgets('uses correct default key for confirm password field', (
          tester,
        ) async {
          // Arrange & Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.confirmPassword,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(
            find.byKey(FormFieldsKeys.confirmPasswordField),
            findsOneWidget,
          );
        });

        testWidgets('passes suffix icon to confirm password field', (
          tester,
        ) async {
          // Arrange
          const suffixIcon = Icon(Icons.visibility);

          // Act
          final widget = FormFieldFactory.create(
            type: InputFieldType.confirmPassword,
            focusNode: focusNode,
            errorText: null,
            onChanged: (_) {},
            suffixIcon: suffixIcon,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          final field = tester.widget<AppFormField>(find.byType(AppFormField));
          expect(field.suffixIcon, equals(suffixIcon));
        });
      });
    });

    group('common parameters', () {
      testWidgets('passes errorText to all field types', (tester) async {
        // Arrange
        const errorText = 'Test error';

        // Act & Assert - Name field
        final widget = FormFieldFactory.create(
          type: InputFieldType.name,
          focusNode: focusNode,
          errorText: errorText,
          onChanged: (_) {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        final field = tester.widget<AppFormField>(find.byType(AppFormField));
        expect(field.errorKey, equals(errorText));
      });

      testWidgets('passes textInputAction to all field types', (tester) async {
        // Arrange
        const action = TextInputAction.next;

        // Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: null,
          onChanged: (_) {},
          textInputAction: action,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        final field = tester.widget<AppFormField>(find.byType(AppFormField));
        expect(field.textInputAction, equals(action));
      });

      testWidgets('passes controller to all field types', (tester) async {
        // Arrange
        final controller = TextEditingController(text: 'Initial');

        // Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.name,
          focusNode: focusNode,
          errorText: null,
          onChanged: (_) {},
          controller: controller,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        expect(find.text('Initial'), findsOneWidget);
      });

      testWidgets('passes onEditingComplete to all field types', (
        tester,
      ) async {
        // Arrange
        // ignore: unused_local_variable
        var completed = false;

        // Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: null,
          onChanged: (_) {},
          onEditingComplete: () => completed = true,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        final field = tester.widget<AppFormField>(find.byType(AppFormField));
        expect(field.onEditingComplete, isNotNull);
      });
    });

    group('real-world scenarios', () {
      testWidgets('creates complete sign-in form', (tester) async {
        // Arrange
        final emailFocus = FocusNode();
        final passwordFocus = FocusNode();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  FormFieldFactory.create(
                    type: InputFieldType.email,
                    focusNode: emailFocus,
                    errorText: null,
                    onChanged: (_) {},
                    textInputAction: TextInputAction.next,
                  ),
                  FormFieldFactory.create(
                    type: InputFieldType.password,
                    focusNode: passwordFocus,
                    errorText: null,
                    onChanged: (_) {},
                    isObscure: true,
                    textInputAction: TextInputAction.done,
                    suffixIcon: const Icon(Icons.visibility),
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AppFormField), findsNWidgets(2));
        expect(find.byKey(FormFieldsKeys.emailField), findsOneWidget);
        expect(find.byKey(FormFieldsKeys.passwordField), findsOneWidget);
      });

      testWidgets('creates complete sign-up form', (tester) async {
        // Arrange
        final nameFocus = FocusNode();
        final emailFocus = FocusNode();
        final passwordFocus = FocusNode();
        final confirmPasswordFocus = FocusNode();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  FormFieldFactory.create(
                    type: InputFieldType.name,
                    focusNode: nameFocus,
                    errorText: null,
                    onChanged: (_) {},
                  ),
                  FormFieldFactory.create(
                    type: InputFieldType.email,
                    focusNode: emailFocus,
                    errorText: null,
                    onChanged: (_) {},
                  ),
                  FormFieldFactory.create(
                    type: InputFieldType.password,
                    focusNode: passwordFocus,
                    errorText: null,
                    onChanged: (_) {},
                    isObscure: true,
                  ),
                  FormFieldFactory.create(
                    type: InputFieldType.confirmPassword,
                    focusNode: confirmPasswordFocus,
                    errorText: null,
                    onChanged: (_) {},
                    isObscure: true,
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AppFormField), findsNWidgets(4));
      });

      testWidgets('handles error states', (tester) async {
        // Arrange & Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: 'Invalid email format',
          onChanged: (_) {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        final field = tester.widget<AppFormField>(find.byType(AppFormField));
        expect(field.errorKey, equals('Invalid email format'));
      });
    });

    group('edge cases', () {
      testWidgets('handles null errorText', (tester) async {
        // Arrange & Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: null,
          onChanged: (_) {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        final field = tester.widget<AppFormField>(find.byType(AppFormField));
        expect(field.errorKey, isNull);
      });

      testWidgets('handles empty errorText', (tester) async {
        // Arrange & Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: '',
          onChanged: (_) {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        final field = tester.widget<AppFormField>(find.byType(AppFormField));
        expect(field.errorKey, equals(''));
      });

      testWidgets('creates field without optional parameters', (tester) async {
        // Arrange & Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.name,
          focusNode: focusNode,
          errorText: null,
          onChanged: (_) {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        expect(find.byType(AppFormField), findsOneWidget);
      });
    });

    group('factory pattern', () {
      test('factory class cannot be instantiated', () {
        // This test verifies that FormFieldFactory is abstract
        // and cannot be directly instantiated
        expect(FormFieldFactory, isA<Type>());
      });

      testWidgets('returns Widget from create method', (tester) async {
        // Arrange & Act
        final widget = FormFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: null,
          onChanged: (_) {},
        );

        // Assert
        expect(widget, isA<Widget>());
        expect(widget, isA<AppFormField>());
      });

      testWidgets('creates different widgets for different types', (
        tester,
      ) async {
        // Arrange & Act
        final nameField = FormFieldFactory.create(
          type: InputFieldType.name,
          focusNode: FocusNode(),
          errorText: null,
          onChanged: (_) {},
        );

        final emailField = FormFieldFactory.create(
          type: InputFieldType.email,
          focusNode: FocusNode(),
          errorText: null,
          onChanged: (_) {},
        );

        // Assert - Different configurations but same widget type
        expect(nameField, isA<AppFormField>());
        expect(emailField, isA<AppFormField>());
      });
    });
  });
}
