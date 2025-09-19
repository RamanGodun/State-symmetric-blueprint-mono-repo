part of 'sign_in__page.dart';

/// 🛡️ [_ErrorsListenersForSignInPage] — encapsulates side-effects for SignIn
/// - ✅ Success → snackbar + redirect to Home
/// - ❌ Error → show localized error
//
final class _ErrorsListenersForSignInPage extends StatelessWidget {
  ///-----------------------------------------------------------
  const _ErrorsListenersForSignInPage({required this.child});
  //
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, ButtonSubmissionState>(
      listenWhen: (prev, current) => prev.runtimeType != current.runtimeType,
      listener: (context, state) {
        //
        switch (state) {
          //
          /// ✅ Success
          case ButtonSubmissionSuccess():
            context.showSnackbar(message: LocaleKeys.sign_in_forgot_password);

          ////

          /// ❌ Error
          case ButtonSubmissionError(:final failure):
            final consumedFailure = failure?.consume();
            if (consumedFailure == null) return;
            context.showError(consumedFailure.toUIEntity());
          //
          default:
            break;
        }
      },

      ///
      child: child,
      // /
    );
  }
}
