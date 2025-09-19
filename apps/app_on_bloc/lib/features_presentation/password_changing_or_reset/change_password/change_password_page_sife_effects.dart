part of 'change_password__page.dart';

/// 🛡️ [_ErrorsListenerForChangePasswordPage] — incapsulates side-effects for [_ChangePasswordView]
///     - ✅ Success → snackbar + redirect to home page
///     - ❌ Error → show error (via overlay) + reset state
///     - 🔄 RequiresReauth → dialog with confirm → signOut
//
final class _ErrorsListenerForChangePasswordPage extends StatelessWidget {
  ///-------------------------------------------------------
  const _ErrorsListenerForChangePasswordPage({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    return BlocListener<ChangePasswordCubit, ButtonSubmissionState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) async {
        //
        switch (state) {
          //
          /// ✅ Success
          case ButtonSubmissionSuccess():
            context
              ..showSnackbar(
                message: LocaleKeys.reauth_password_updated.tr(),
              )
              // 🧭 Navigation after success
              ..goIfMounted(RoutesNames.home);

          ////

          /// ❌ Error
          case ButtonSubmissionError(:final failure):
            final consumedFailure = failure?.consume();
            if (consumedFailure == null) return;
            context.showError(consumedFailure.toUIEntity());
            context.read<ChangePasswordCubit>().resetState();

          ////

          /// 🔄 Requires Reauth → show dialog, than signOut for reAuth
          case ButtonSubmissionRequiresReauth(:final failure):
            final consumedFailure = failure?.consume();
            if (consumedFailure == null) return;
            context.showError(
              consumedFailure.toUIEntity(),
              onConfirm: context.read<ChangePasswordCubit>().confirmReauth,
            );

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
