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
        case ChangePasswordSuccess():
          context.showUserSnackbar(
            message: LocaleKeys.reauth_password_updated.tr(),
          );
          // 🧭 Navigation after success
          context.goIfMounted(RoutesNames.home);

        /// ❌ On error
        case ChangePasswordError(:final failure):
          context.showError(failure.toUIEntity());
          read(changePasswordFormProvider.notifier).reset();

        /// 🔄 Requires Reauth → show dialog, than signOut for reAuth
        case ChangePasswordRequiresReauth(:final failure):
          context.showError(
            failure.toUIEntity(),
            onConfirm: () async {
              await read(changePasswordProvider.notifier).confirmReauth();
            },
          );

        ///
        default:
          break;
      }
    });
  }

  //
}
