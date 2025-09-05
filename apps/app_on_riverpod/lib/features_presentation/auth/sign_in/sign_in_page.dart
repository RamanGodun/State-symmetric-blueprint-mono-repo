import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/providers/sign_in__provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/providers/sign_in_form_fields_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show HookConsumerWidget;
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_sign_in_page.dart';

/// 🔐 [SignInPage] — screen that allows user to sign in.
//
final class SignInPage extends HookConsumerWidget {
  ///-------------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final focus = useSignInFocusNodes();

    /// 🧠🔁 Intelligent failure listener (declarative side-effect for error displaying) with optional "Retry" logic.
    ref.listenRetryAwareFailure(
      signInProvider,
      context,
      ref: ref,
      onRetry: () => ref.submit(),
    );

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: context.unfocusKeyboard,

          /// used "LayoutBuilder+ConstrainedBox" pattern
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: FocusTraversalGroup(
                  ///
                  child: ListView(
                    children: [
                      //
                      const _SignInHeader(),
                      _SignInEmailInputField(focus),
                      _SignInPasswordInputField(focus),
                      const _SigninSubmitButton(),
                      const _SigninFooter(),
                      //
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

/// 📩 Handles form validation and submission to [signInProvider].
//
extension SignInRefX on WidgetRef {
  ///-------------------------------
  //
  /// 📩 Triggers sign-in logic based on current form state
  void submit() {
    final form = read(signInFormProvider);
    read(
      signInProvider.notifier,
    ).signin(email: form.email.value, password: form.password.value);
  }
}
