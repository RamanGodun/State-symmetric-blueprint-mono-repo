part of 'sign_up__page.dart';

/// 🧾 [_SignUpHeader] — [SignUpPage] logo and welcome message
/// 📦 Contains branding, main header, and sub-header
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _SignUpHeader extends StatelessWidget {
  ///------------------------------------------
  const _SignUpHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: 'Logo',
          child: const FlutterLogo(
            size: AppSpacing.massive,
          ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.l),
        ),
        //
        /// 🏷️ Main header text
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
/// ✅ Delegates behavior to [FormSubmitButtonForRiverpodApps]
//
final class _SignUpSubmitButton extends ConsumerWidget {
  ///------------------------------------------------
  const _SignUpSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return FormSubmitButtonForRiverpodApps(
      label: LocaleKeys.buttons_sign_up,
      isValidProvider: signUpFormProvider.select((state) => state.isValid),
      isLoadingProvider: signUpProvider.select((state) => state.isLoading),
      onPressed: () => ref.submitSignUp(),
    ).withPaddingBottom(AppSpacing.l);
  }
}

////
////

/// 🔁 [_WrapperForFooter] — sign in redirect link
/// ✅ Disabled during form submission or overlay
//
final class _WrapperForFooter extends ConsumerWidget {
  ///-------------------------------------------
  const _WrapperForFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⏳ Submission loading (primitive bool)
    final isLoading = ref.watch(
      signUpProvider.select((state) => state.isLoading),
    );

    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isOverlayActive = ref.isOverlayActive;
    final isEnabled = !isLoading && !isOverlayActive;

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return _SignUpPageFooter(isEnabled: isEnabled);
  }
}

////
////

/// 🔁 [_SignUpPageFooter] — sign in redirect link
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _SignUpPageFooter extends StatelessWidget {
  ///-------------------------------------------
  const _SignUpPageFooter({required this.isEnabled});
  //
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🧭 Redirect to [SignUpPage]
        const TextWidget(
          LocaleKeys.buttons_redirect_to_sign_in,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.xs),
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
