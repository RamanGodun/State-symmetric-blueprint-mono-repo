part of 'reset_password_page.dart';

/// ℹ️ Info section for [_ResetPasswordHeader]
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordHeader extends StatelessWidget {
  ///--------------------------------------------------
  const _ResetPasswordHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const FlutterLogo(
          size: AppSpacing.great,
        ).withPaddingOnly(top: AppSpacing.great, bottom: AppSpacing.l),
        const TextWidget(
          LocaleKeys.reset_password_header,
          TextType.headlineSmall,
        ),
        const TextWidget(
          LocaleKeys.reset_password_sub_header,
          TextType.bodyMedium,
        ).withPaddingBottom(AppSpacing.xxl),
      ],
    );
  }
}

////
////

/// 🧩 [_ResetPasswordEmailInputField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _ResetPasswordEmailInputField extends ConsumerWidget {
  ///--------------------------------------------------------------
  const _ResetPasswordEmailInputField(this.focusNodes);
  //
  final ({FocusNode email}) focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //

    final emailError = ref.watch(
      resetPasswordFormProvider.select((f) => f.email.uiErrorKey),
    );
    final isValid = ref.watch(
      resetPasswordFormProvider.select((f) => f.isValid),
    );
    final notifier = ref.read(resetPasswordFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.email,
      focusNode: focusNodes.email,
      errorText: emailError,
      onChanged: notifier.onEmailChanged,
      onSubmitted: isValid ? () => ref.submitResetPassword() : null,
    ).withPaddingBottom(AppSpacing.huge);
  }
}

////
////

/// 🔘 [_ResetPasswordSubmitButton] — Confirms reset action button
//
final class _ResetPasswordSubmitButton extends ConsumerWidget {
  ///-------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return FormSubmitButtonForRiverpodApps(
      label: LocaleKeys.buttons_reset_password,
      isValidProvider: resetPasswordFormIsValidProvider,
      isLoadingProvider: resetPasswordIsLoadingProvider,
      onPressed: () => ref.submitResetPassword(),
    ).withPaddingBottom(AppSpacing.xl);
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
      resetPasswordProvider.select((state) => state.isLoading),
    );
    //
    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isOverlayActive = ref.isOverlayActive;
    final isEnabled = !isLoading && !isOverlayActive;

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return _ResetPasswordFooter(isEnabled: isEnabled);
  }
}

////
////

/// 🔁 [_ResetPasswordFooter] — sign in redirect link
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordFooter extends StatelessWidget {
  ///--------------------------------------------------
  const _ResetPasswordFooter({required this.isEnabled});
  //
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🧭 Redirect to [SignInPage]
        const TextWidget(
          LocaleKeys.reset_password_remember,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.xs),
        //
        AppTextButton(
          label: LocaleKeys.buttons_sign_in,
          isEnabled: isEnabled,
          onPressed: () => context.goTo(RoutesNames.signIn),
        ).withPaddingBottom(AppSpacing.xxxm),
      ],
    );
  }
}
