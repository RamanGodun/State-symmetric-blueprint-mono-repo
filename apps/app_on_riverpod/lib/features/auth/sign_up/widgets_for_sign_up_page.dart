part of 'sign_up__page.dart';

/// 🧾 [_SignUpHeader] — [SignUpPage] logo and welcome message
/// 📦 Contains branding, main header, and sub-header
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _SignUpHeader extends StatelessWidget {
  ///-------------------------------------------
  const _SignUpHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: 'Logo',
          child: Image.asset(
            FlavorX.appIcon,
            width: AppSpacing.massive,
            height: AppSpacing.massive,
          ).withPaddingOnly(top: AppSpacing.xl, bottom: AppSpacing.l),
        ),
        //
        /// 🏷️ Main header text
        const TextWidget(LocaleKeys.pages_sign_up, TextType.headlineSmall),
        //
        /// 📝 Sub-header text
        const TextWidget(
          LocaleKeys.sign_up_sub_header,
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
/// ✅ Delegates behavior to [RiverpodAdapterForSubmitButton]
//
final class _SignUpSubmitButton extends ConsumerWidget {
  ///------------------------------------------------
  const _SignUpSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return RiverpodAdapterForSubmitButton(
      label: LocaleKeys.buttons_sign_up,
      isValidProvider: signUpFormProvider.select((state) => state.isValid),
      isLoadingProvider: signUpProvider.select((state) => state.isLoading),
      onPressed: () => ref.submitSignUp(),
    ).withPaddingBottom(AppSpacing.l);
  }
}

////
////

/// 🔁 [_SignUpPageFooterGuard] — sign in redirect link
/// ✅ Disabled during form submission or overlay
//
final class _SignUpPageFooterGuard extends StatelessWidget {
  ///----------------------------------------------------
  const _SignUpPageFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    /// 🧠 Computes `isEnabled` [_SignUpPageFooter]
    return RiverpodAdapterForFooterGuard(
      isLoadingProvider: signUpProvider.select((state) => state.isLoading),

      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: const _SignUpPageFooter(),
    );
  }
}

/*

 */

////
////

/// 🧭 [_SignUpPageFooter] —  Redirect link to [SignInPage]
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _SignUpPageFooter extends StatelessWidget {
  ///-----------------------------------------------
  const _SignUpPageFooter();

  @override
  Widget build(BuildContext context) {
    //
    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isEnabled = context.isFooterEnabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TextWidget(
          LocaleKeys.buttons_redirect_to_sign_in,
          TextType.bodyMedium,
        ),
        //
        AppTextButton(
          label: LocaleKeys.pages_sign_in,
          isEnabled: isEnabled,
          onPressed: () => context.popView(),
        ).withPaddingBottom(AppSpacing.xxxm),
      ],
    );
  }
}
