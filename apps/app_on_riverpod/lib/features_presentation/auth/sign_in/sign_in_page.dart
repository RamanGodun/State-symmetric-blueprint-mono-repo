import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/providers/sign_in__provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/providers/sign_in_form_fields_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_sign_in_page.dart';

/// 🔐 [SignInPage] — screen that allows user to sign in.
//
final class SignInPage extends ConsumerWidget {
  ///-------------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🧠🔁 Intelligent failure listener (declarative side-effect for error displaying) with optional "Retry" logic.
    ref.listenRetryAwareFailure(
      signInProvider,
      context,
      ref: ref,
      onRetry: () => ref.submitSignIn(),
    );

    return const _SignInPageView();
  }
}

////
////

/// 🔐 [_SignInPageView] — Main UI layout for the sign-in form
/// ✅ Uses HookWidget for managing focus nodes & rebuild optimization
//
final class _SignInPageView extends HookWidget {
  ///----------------------------------------------
  const _SignInPageView();

  @override
  Widget build(BuildContext context) {
    //
    ///  📌 Initialize and memoize focus nodes for fields
    final focus = useSignInFocusNodes();

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          // 🔕 Dismiss keyboard on outside tap
          onTap: context.unfocusKeyboard,
          // used "LayoutBuilder+ConstrainedBox" pattern
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: FocusTraversalGroup(
                  child: AutofillGroup(
                    ///
                    child: ListView(
                      children: [
                        /// 🖼️ Logo with Hero animation for smooth transitions
                        const _SignInHeader(),

                        /// 📧 Email input field
                        _SignInEmailInputField(focus),

                        /// 🔒 Password input field
                        _SignInPasswordInputField(focus),

                        /// 🚀 Primary submit button
                        const _SignInSubmitButton(),

                        /// 🔁 Links to redirect to sign-up or reset-password screen
                        const _SignInFooter(),
                        //
                      ],
                    ).centered().withPaddingHorizontal(AppSpacing.xxxm),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

////
////

/// 📩 Handles form validation and submission to [signInProvider].
//
extension SignInRefX on WidgetRef {
  ///-------------------------------
  //
  /// 📩 Triggers sign-in logic based on current form state
  void submitSignIn() {
    final form = read(signInFormProvider);
    context.unfocusKeyboard();
    read(
      signInProvider.notifier,
    ).signin(email: form.email.value, password: form.password.value);
  }
}
