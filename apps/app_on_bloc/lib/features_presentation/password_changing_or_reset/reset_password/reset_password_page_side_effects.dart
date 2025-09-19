part of 'reset_password__page.dart';

/// 🛡️ [_ErrorsListenersForResetPasswordPage] — encapsulates side-effects for Reset Password
/// - ❌ Failure → show localized error + clear failure
/// - ✅ Success → snackbar + redirect to SignIn
//
final class _ErrorsListenersForResetPasswordPage extends StatelessWidget {
  ///-----------------------------------------------------------------
  const _ErrorsListenersForResetPasswordPage({required this.child});
  //
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    return BlocListener<ResetPasswordCubit, ButtonSubmissionState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        switch (state) {
          /// ✅ Success
          case ButtonSubmissionSuccess():
            context
              ..showSnackbar(message: LocaleKeys.reset_password_success)
              // 🧭 Navigation after success
              ..goTo(RoutesNames.signIn);

          /// ❌ Error
          case ButtonSubmissionError(:final failure):
            final consumedFailure = failure?.consume();
            if (consumedFailure == null) return;
            context.showError(consumedFailure.toUIEntity());

          ///
          default:
            break;
          //
        }
      },

      ///
      child: child,
      //
    );
  }
}
