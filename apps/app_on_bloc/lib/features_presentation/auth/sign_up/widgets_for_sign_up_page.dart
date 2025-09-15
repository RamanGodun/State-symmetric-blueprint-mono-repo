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
      children: [
        /// 🖼️ App logo
        Hero(
          tag: 'Logo',
          child: const FlutterLogo(
            size: AppSpacing.massive,
          ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.xl),
        ),
        //
        /// 🏷️ Header text
        const TextWidget(LocaleKeys.pages_sign_up, TextType.headlineSmall),
        //
        /// 📝 Sub-header text
        const TextWidget(
          LocaleKeys.sign_in_sub_header,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.l),
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
    return FormSubmitButtonForBlocApps<SignUpCubit, SignUpPageState>(
      label: LocaleKeys.buttons_sign_up,
      onPressed: (context) {
        context.unfocusKeyboard();
        context.read<SignUpCubit>().submit();
      },
      statusSelector: (state) => state.status,
      isValidatedSelector: (state) => state.isValid,
    ).withPaddingBottom(AppSpacing.l);
  }
}

////
////

/// 🔁 [_WrapperForFooter] — sign up & reset password links
/// ✅ Disabled during form submission or overlay

//
final class _WrapperForFooter extends StatelessWidget {
  ///------------------------------------------------------
  const _WrapperForFooter();

  @override
  Widget build(BuildContext context) {
    //
    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );

    return BlocSelector<SignUpCubit, SignUpPageState, bool>(
      selector: (state) => state.status.isSubmissionInProgress,
      builder: (context, isLoading) {
        final isEnabled = !isLoading && !isOverlayActive;

        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        return _SignUpPageFooter(isEnabled: isEnabled);
      },
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
