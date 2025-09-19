part of 'sign_up__page.dart';

/// 🛡️ [_ErrorsListenersForSignUpPage] — encapsulates side-effects for SignUp
/// - ✅ Success → snackbar + redirect to VerifyEmail (or Home — as you prefer)
/// - ❌ Error → show localized error
//
final class _ErrorsListenersForSignUpPage extends StatelessWidget {
  ///-----------------------------------------------------------
  const _ErrorsListenersForSignUpPage({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, ButtonSubmissionState>(
      listenWhen: (prev, current) => prev.runtimeType != current.runtimeType,
      listener: (context, state) {
        //
        switch (state) {
          //
          /// ✅ Success
          case ButtonSubmissionSuccess():
            context.showSnackbar(
              message: LocaleKeys.sign_up_already_have_account,
            );

          ////

          /// ❌ Error
          case ButtonSubmissionError(:final failure):
            final consumedFailure = failure?.consume();
            if (consumedFailure == null) return;
            context.showError(consumedFailure.toUIEntity());

          ///
          default:
            break;
        }
      },

      ///
      child: child,
      //
    );
  }
}
