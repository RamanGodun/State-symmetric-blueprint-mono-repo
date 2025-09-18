part of 'change_password_page.dart';

/// 🛡️ [_ErrorsListenerForChangePasswordPage] — incapsulates side-effects for [_ChangePasswordView]
///     - ✅ Success → snackbar + redirect to home page
///     - ❌ Error → show error (via overlay) + reset state
///     - 🔄 RequiresReauth → dialog with confirm → signOut
//
final class _ErrorsListenerForChangePasswordPage extends StatelessWidget {
  ///-------------------------------------------------------
  const _ErrorsListenerForChangePasswordPage({required this.child});
  //
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) async {
        //
        switch (state) {
          //
          /// ✅ Success
          case ChangePasswordSuccess():
            context
              ..showSnackbar(
                message: LocaleKeys.reauth_password_updated.tr(),
              )
              // 🧭 Navigation after success
              ..goIfMounted(RoutesNames.home);

          /// ❌ Error
          case ChangePasswordError(:final failure):
            context.showError(failure.toUIEntity());
            context.read<ChangePasswordCubit>().resetState();

          /// 🔄 Requires Reauth → show dialog, than signOut for reAuth
          case ChangePasswordRequiresReauth(:final failure):
            context.showError(
              failure.toUIEntity(),
              onConfirm: () async {
                await context.read<ChangePasswordCubit>().confirmReauth();
              },
            );

          ///
          default:
            break;
        }
      },
      child: child,
    );
  }
}
