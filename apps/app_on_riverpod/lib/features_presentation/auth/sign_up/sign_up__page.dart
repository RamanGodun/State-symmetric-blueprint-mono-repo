import 'package:app_on_riverpod/features_presentation/auth/sign_up/providers/sign_up__provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_up/providers/sign_up_form_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'sign_up_input_fields.dart';
part 'widgets_for_sign_up_page.dart';

/// 🧾🔐 [SignUpPage] — Entry point for the sign-up feature
/// ✅ Provides scoped cubit with injected services
//
final class SignUpPage extends ConsumerWidget {
  ///-----------------------------------
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🔄 [ ref.listenRetryAwareFailure] — Ref listener for one-shot
    ///    error handling (with optional "retry" logic) via overlays
    /// 🧠 OverlayDispatcher resolves conflicts/priority internally
    ref.listenRetryAwareFailure(
      signUpProvider,
      context,
      ref: ref,
      onRetry: () => ref.submitSignUp(),
    );

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _SignUpView();
  }
}

////
////

/// 🔐 [_SignUpView] — Main UI layout for the sign-up form
///    Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _SignUpView extends HookWidget {
  ///------------------------------------
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    //
    // 📌 Shared focus nodes for form fields
    final focusNodes = useSignUpFocusNodes();

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
                        /// 🔰 Logo with Hero animation
                        const _SignUpHeader(),

                        /// 👤 Name input field
                        _SignUpUserNameInputField(focusNodes),

                        /// 📧 Email input
                        _SignUpEmailInputField(focusNodes),

                        /// 🔒 Password input field
                        _SignUpPasswordInputField(focusNodes),

                        /// 🔐 Confirm password input
                        _SignUpConfirmPasswordInputField(focusNodes),

                        /// 🚀 Primary submit button
                        const _SignUpSubmitButton(),

                        /// 🔁 Links to redirect to sign-up or reset-password screen
                        const _WrapperForFooter(),
                      ],
                    ).centered().withPaddingHorizontal(AppSpacing.xxxm),
                    //
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

/// 📩 Handles form validation and submission to [signUpProvider].
//
extension SignUpRefX on WidgetRef {
  ///-------------------------------
  //
  /// 📩 Triggers sign-up logic based on current form state
  void submitSignUp() {
    final form = read(signUpFormProvider);
    read(signUpProvider.notifier).signup(
      name: form.name.value,
      email: form.email.value,
      password: form.password.value,
    );
  }
}
