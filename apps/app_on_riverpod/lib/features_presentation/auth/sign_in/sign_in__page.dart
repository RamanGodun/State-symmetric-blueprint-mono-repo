import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/providers/input_form_fields_provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_in/providers/sign_in__provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_sign_in_page.dart';

/// 🔐 [SignInPage] — Entry point for the sign-in feature
//
final class SignInPage extends ConsumerWidget {
  ///---------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🦻 Riverpod-side effects listener (symmetry with BLoC 'SubmissionSideEffects')
    /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
    ref.listenSubmissionSideEffects(
      signInProvider,
      context,
      // ✅ Success → snackbar + go home
      onSuccess: (ctx, _) =>
          ctx.showSnackbar(message: LocaleKeys.sign_in_success),
      // 🔁 Retry with current form state
      onRetry: (ref) => ref.submitSignIn(),
    );

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _SignInScreen();
  }
}

////
////

/// 🔐 [_SignInScreen] — Main UI layout for the sign-in form
/// ✅ Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _SignInScreen extends HookWidget {
  ///--------------------------------------
  const _SignInScreen();

  @override
  Widget build(BuildContext context) {
    //
    ///  📌 Initialize and memoize focus nodes for fields
    final focusNodes = useSignInFocusNodes();

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
                        /// 🖼️ Logo with Hero animation
                        const _SignInHeader(),

                        /// 📧 Email input field
                        _EmailFormField(focusNodes),

                        /// 🔒 Password input field
                        _PasswordFormField(focusNodes),

                        /// 🚀 Primary submit button
                        const _SignInSubmitButton(),

                        /// 🔁 Links to redirect to sign-up or reset-password screen
                        const _SignInPageFooterGuard(),
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

/// 🧩 [SignInRefX] — Triggers sign-in using current form state (reads form provider).
/// 🧼 UX: unfocus keyboard before submit to avoid field glitches on navigation
//
extension SignInRefX on WidgetRef {
  ///---------------------------
  //
  /// 📩 Triggers sign-in logic based on current form state
  void submitSignIn() {
    context.unfocusKeyboard();
    final form = read(signInFormProvider);
    read(
      signInProvider.notifier,
    ).signin(
      email: form.email.value,
      password: form.password.value,
    );
  }
}
