part of 'sign_up__page.dart';

/// 🧾 [_SignUpHeader] — [SignUpPage] logo and welcome message
/// 📦 Contains branding, main header, and sub-header
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignUpHeader extends StatelessWidget {
  ///-----------------------------------------
  const _SignUpHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🖼️ App logo
        Hero(
          tag: 'Logo',
          child: const FlutterLogo(
            size: AppSpacing.massive,
          ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.l),
        ),
        //
        /// 🏷️ Header text
        const TextWidget(LocaleKeys.pages_sign_up, TextType.headlineSmall),
        //
        /// 📝 Sub-header text
        const TextWidget(
          LocaleKeys.sign_up_sub_header,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.xl),
      ],
    );
  }
}

////
////

/// 🚀 [_SignUpSubmitButton] — Button for triggering sign-up logic
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [FormSubmitButtonForBlocApps]
//
final class _SignUpSubmitButton extends StatelessWidget {
  ///-------------------------------------------
  const _SignUpSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );
    final isLoading = context.select<SignUpCubit, bool>(
      (cubit) => cubit.state.isLoading,
    );

    return BlocSelector<SignUpFormCubit, SignUpFormState, bool>(
      selector: (state) => state.isValid,
      builder: (context, isValid) {
        final isEnabled = isValid && !isLoading && !isOverlayActive;

        return CustomFilledButton(
          label: isLoading
              ? LocaleKeys.buttons_submitting
              : LocaleKeys.buttons_sign_up,
          isLoading: isLoading,
          isEnabled: isEnabled,
          onPressed: isEnabled
              ? () {
                  context.unfocusKeyboard();
                  final form = context.read<SignUpFormCubit>().state;
                  context.read<SignUpCubit>().submit(
                    name: form.name.value,
                    email: form.email.value,
                    password: form.password.value,
                  );
                }
              : null,
        ).withPaddingBottom(AppSpacing.l);
      },
    );
  }
}

////
////

/// 🛡️ [_SignUpFooterGuard] — Make footer disable during form submission or active overlay
//
final class _SignUpFooterGuard extends StatelessWidget {
  ///------------------------------------------------------
  const _SignUpFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    return FooterGuard<SignUpCubit, SignUpState>(
      isLoadingSelector: (state) => state.isLoading,
      childBuilder: (_, isEnabled) =>
          /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
          _SignUpPageFooter(isEnabled: isEnabled),
    );
  }
}

////
////

/// 🔁 [_SignUpPageFooter] — sign in redirect link
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignUpPageFooter extends StatelessWidget {
  ///-----------------------------------------------
  const _SignUpPageFooter({required this.isEnabled});
  //
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🧭 Redirect to [SignUpPage]
        const TextWidget(
          LocaleKeys.buttons_redirect_to_sign_in,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.s),
        AppTextButton(
          label: LocaleKeys.pages_sign_in,
          isEnabled: isEnabled,
          onPressed: () => context.popView(),
        ).withPaddingBottom(AppSpacing.xxxm),
      ],
    );
  }
}
