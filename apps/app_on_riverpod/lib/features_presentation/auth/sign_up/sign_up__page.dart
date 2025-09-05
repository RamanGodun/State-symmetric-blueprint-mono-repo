import 'package:app_on_riverpod/features_presentation/auth/sign_up/providers/sign_up__provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_up/providers/sign_up_form_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'sign_up_input_fields.dart';
part 'widgets_for_sign_up_page.dart';

/// 🔐 [SignUpPage] — screen that allows user to register a new account.
//
final class SignUpPage extends HookConsumerWidget {
  ///-----------------------------------
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🧠🔁 Intelligent failure listener (declarative side-effect for error displaying) with optional "Retry" logic.
    ref.listenRetryAwareFailure(
      signupProvider,
      context,
      ref: ref,
      onRetry: () => ref.submit(),
    );

    final focus = useSignUpFocusNodes();

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: context.unfocusKeyboard,

          /// used "LayoutBuilder + ConstrainedBox" pattern
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: FocusTraversalGroup(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      /// 📋 Logo and welcome text
                      const _SignupHeader(),

                      /// 🔢 Name input field
                      _NameInputField(focus),

                      /// 🔢 Email input field
                      _EmailInputField(focus),

                      /// 🔢 Password input field
                      _PasswordInputField(focus),

                      /// 🔢 Confirm password field
                      _ConfirmPasswordInputField(focus),

                      /// 🔺 Submit button
                      const _SignupSubmitButton(),

                      /// 🔄 Redirect to sign in
                      const _SignupFooter(),
                    ],
                  ).withPaddingHorizontal(AppSpacing.xxxm),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //
}

////
////

/// 📩 Handles form validation and submission to [signupProvider].
//
extension SignUpRefX on WidgetRef {
  ///-------------------------------
  //
  /// 📩 Triggers sign-up logic based on current form state
  void submit() {
    final form = read(signUpFormProvider);
    read(signupProvider.notifier).signup(
      name: form.name.value,
      email: form.email.value,
      password: form.password.value,
    );
  }

  //
}
