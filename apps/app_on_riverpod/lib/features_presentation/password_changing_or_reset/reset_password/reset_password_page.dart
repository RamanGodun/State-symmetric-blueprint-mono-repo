import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/input_fields_provider.dart';
import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/reset_password__provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_reset_password_page.dart';

/// 🔐 [ResetPasswordPage] — Entry point for the reset-password feature,
//
final class ResetPasswordPage extends ConsumerWidget {
  ///----------------------------------------------
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🦻 Riverpod-side effects listener (symmetry with BLoC 'SubmissionSideEffects')
    /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
    ref.listenSubmissionSideEffects(
      resetPasswordProvider,
      context,
      // ✅ Success → snackbar + go [SignInPage]
      onSuccess: (ctx, _) => ctx
        ..showSnackbar(message: LocaleKeys.reset_password_success)
        ..goTo(RoutesNames.signIn),
      // 🔁 Retry with current form state
      onRetry: (ref) => ref.submitResetPassword(),
    );

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _ResetPasswordScreen();
  }
}

////
////

/// 🔐 [_ResetPasswordScreen] — Screen that allows the user to reset password.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordScreen extends HookWidget {
  ///---------------------------------------------
  const _ResetPasswordScreen();

  @override
  Widget build(BuildContext context) {
    //
    /// 📌 Shared focus nodes for form fields
    final focusNodes = useResetPasswordFocusNodes();

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
                  ///
                  child: ListView(
                    children: [
                      /// ℹ️ Info section for [ResetPasswordPage]
                      const _ResetPasswordHeader(),

                      /// 📧 Email input field
                      _EmailFormField(focusNodes),

                      /// 🚀 Primary submit button
                      const _ResetPasswordSubmitButton(),

                      /// 🔁 Links to redirect to sign-in screen
                      const _ResetPasswordFooterGuard(),
                    ],
                  ).withPaddingHorizontal(AppSpacing.l),
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

/// 🧩 [ResetPasswordRefX] — Triggers reset-password using current form state (reads form provider).
/// 🧼 UX: unfocus keyboard before submit to avoid field glitches on navigation
//
extension ResetPasswordRefX on WidgetRef {
  ///----------------------------------
  /// 📤 Submits the password reset request using the current form state.
  void submitResetPassword() {
    final form = read(resetPasswordFormProvider);
    context.unfocusKeyboard();
    read(resetPasswordProvider.notifier).resetPassword(email: form.email.value);
  }
}
