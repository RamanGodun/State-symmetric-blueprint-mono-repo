part of 'reset_password_page.dart';

/// 🛡️ [ResetPasswordRefX] — extension for WidgetRef to handle Reset Password side-effects.
/// Handles submission and listens for result feedback (success/error).
//
extension ResetPasswordRefX on WidgetRef {
  //
  /// Encapsulates success and error handling for the reset password process.
  ///   - ✅ On success: shows success snackbar and navigates to Sign In page.
  ///   - ❌ On failure: shows localized error.
  void listenToResetPassword(BuildContext context) {
    final showSnackbar = context.showUserSnackbar;

    listen<AsyncValue<void>>(resetPasswordProvider, (prev, next) {
      next.whenOrNull(
        // ✅ On success
        data: (_) {
          showSnackbar(message: LocaleKeys.reset_password_success.tr());
          context.goIfMounted(RoutesNames.signIn);
        },
        // ❌ On error
        error: (error, _) => context.showError((error as Failure).toUIEntity()),
      );
    });
  }

  ////

  /// 📤 Submits the password reset request using the current form state.
  void submitResetPassword() {
    final form = read(resetPasswordFormProvider);
    read(resetPasswordProvider.notifier).resetPassword(email: form.email.value);
  }

  //
}
