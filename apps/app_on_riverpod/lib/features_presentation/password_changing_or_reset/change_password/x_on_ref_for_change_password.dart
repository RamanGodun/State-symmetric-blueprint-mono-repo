part of 'change_password_page.dart';

/// 🛡️ [PasswordChangeRefX] — handles side-effects for Change Password flow.
//
extension PasswordChangeRefX on WidgetRef {
  ///---------------------------------------------
  //
  /// Encapsulates success, error, and retry handling.
  ///   - ✅ On success: shows success snackbar and navigates home.
  ///   - ❌ On failure: shows localized error.
  ///   - 🔄 On "requires-recent-login" error: triggers reauthentication flow and retries on success.
  void listenToPasswordChange(BuildContext context) {
    listen<ChangePasswordState>(changePasswordProvider, (prev, next) async {
      switch (next) {
        ///
        // ✅ On success
        case ChangePasswordSuccess(:final message):
          context.showUserSnackbar(message: message);
          // 🧭 Navigation after success
          context.goIfMounted(RoutesNames.home);

        /// 🔄 On reauth
        case ChangePasswordRequiresReauth():
          final result = await context.pushTo<String>(const SignInPage());
          if (result == 'success') {
            await read(changePasswordProvider.notifier).retryAfterReauth();
          }

        /// ❌ On error
        case ChangePasswordError(:final failure):
          context.showError(failure.toUIEntity());
        default:
          break;
      }
    });
  }

  //
}
