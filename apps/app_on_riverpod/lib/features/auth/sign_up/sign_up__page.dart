import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show
        RiverpodAdapterForFooterGuard,
        RiverpodAdapterForSubmissionFlowSideEffects,
        RiverpodAdapterForSubmitButton;
import 'package:app_on_riverpod/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_riverpod/core/shared_presentation/utils/flavor_x.dart'
    show FlavorX;
import 'package:app_on_riverpod/features/auth/sign_in/sign_in__page.dart'
    show SignInPage;
import 'package:app_on_riverpod/features/auth/sign_up/providers/input_form_fields_provider.dart'
    show signUpFormProvider;
import 'package:app_on_riverpod/features/auth/sign_up/providers/sign_up__provider.dart'
    show signUpProvider;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:shared_core_modules/public_api/base_modules/forms.dart';
import 'package:shared_core_modules/public_api/base_modules/navigation.dart'
    show NavigationX;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayBaseMethods;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppSpacing, OtherContextX, WidgetAlignX, WidgetPaddingX;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        ButtonSubmissionStateX,
        SubmissionFlowStateModel,
        SubmissionSideEffectsConfig;
import 'package:shared_widgets/public_api/buttons.dart' show AppTextButton;
import 'package:shared_widgets/public_api/footers.dart'
    show FooterEnabledContextX;
import 'package:shared_widgets/public_api/text_widgets.dart';

part 'sign_up_input_fields.dart';
part 'widgets_for_sign_up_page.dart';

/// 🧾🔐 [SignUpPage] — Entry point for the sign-up feature
//
final class SignUpPage extends ConsumerWidget {
  ///-----------------------------------
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🦻 Riverpod-side effects listener (symmetry with BLoC 'SubmissionSideEffects')
    /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
    ref.listenSubmissionSideEffects(
      signUpProvider,
      context,
      config: SubmissionSideEffectsConfig(
        // ✅ Success → snackbar + go [VerifyEmailPage]
        onSuccess: (ctx, _) =>
            ctx.showSnackbar(message: AppLocaleKeys.sign_up_success),
        // 🔁 Retry with current form state
        onRetry: (ctx) => ref.submitSignUp(),
        // 🧹 (optional) forms' reset after error
        // onResetForm: (ctx) => ref.read(signUpFormProvider.notifier).reset(),
      ),
    );
    //
    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _SignUpScreen();
  }
}

////
////

/// 🔐 [_SignUpScreen] — Main UI layout for the sign-up form
/// ✅ Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _SignUpScreen extends HookWidget {
  ///--------------------------------------
  const _SignUpScreen();

  @override
  Widget build(BuildContext context) {
    //
    /// 📌 Shared focus nodes for form fields
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
                        _UserNameFormField(focusNodes),

                        /// 📧 Email input
                        _EmailFormField(focusNodes),

                        /// 🔒 Password input field
                        _PasswordFormField(focusNodes),

                        /// 🔐 Confirm password input
                        _ConfirmPasswordFormField(focusNodes),

                        /// 🚀 Primary submit button
                        const _SignUpSubmitButton(),

                        /// 🔁 Links to redirect to sign-in screen
                        const _SignUpPageFooterGuard(),
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
  ///---------------------------
  //
  /// 📩 Triggers sign-up logic based on current form state
  void submitSignUp() {
    context.unfocusKeyboard();
    final form = read(signUpFormProvider);
    read(signUpProvider.notifier).signUp(
      name: form.name.value,
      email: form.email.value,
      password: form.password.value,
    );
  }
}
