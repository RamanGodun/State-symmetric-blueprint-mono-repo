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
    return BlocListener<SignInCubit, SignInPageState>(
      listenWhen: (prev, current) => prev.runtimeType != current.runtimeType,
      listener: (context, state) {
        //
        switch (state) {
          case SignInSuccess():
            context.showSnackbar(message: LocaleKeys.sign_in_forgot_password);

          case SignInError(:final failure):
            context.showError(failure.toUIEntity());

          default:
            break;
        }
      },
      child: child,
    );
  }
}
