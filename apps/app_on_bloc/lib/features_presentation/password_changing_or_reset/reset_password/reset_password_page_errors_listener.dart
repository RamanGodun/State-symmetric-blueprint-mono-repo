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
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        switch (state) {
          /// ✅ Success
          case ResetPasswordSuccess():
            context
              ..showSnackbar(message: LocaleKeys.reset_password_success)
              // 🧭 Navigation after success
              ..goTo(RoutesNames.signIn);

          /// ❌ Error
          case ResetPasswordError(:final failure):
            context.showError(failure.toUIEntity());

          default:
            break;
        }
      },
      child: child,
    );
  }
}

////
////

/*

 /// ❌ Error Listener
        BlocListener<ResetPasswordCubit, ResetPasswordState>(
          // 🎯 Fire only on submission failure transition
          listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
          listener: (context, state) {
            final error = state.failure?.consume();
            if (error != null) {
              context.showError(error.toUIEntity());
              context.read<ResetPasswordCubit>().clearFailure();
            }
          },
        ),

        /// ✅ Success Listener
        BlocListener<ResetPasswordCubit, ResetPasswordState>(
          // 🎯 Fire only on submission success transition
          listenWhen: (prev, curr) => prev.status != curr.status && curr.status.isSubmissionSuccess,
          listener: (context, state) {
            context
              ..showSnackbar(message: LocaleKeys.reset_password_success)
              // 🧭 Navigation after success
              ..goTo(RoutesNames.signIn);
          },
        ),

 */
