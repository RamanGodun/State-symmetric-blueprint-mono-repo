part of 'sign_in_page.dart';

/// 🖼️ [_SignInHeader] — app logo + welcome texts
/// 📦 Contains branding, main header, and sub-header
//
final class _SignInHeader extends StatelessWidget {
  ///------------------------------------------
  const _SignInHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        /// 🖼️ App logo with Hero animation for smooth transitions
        Hero(
          tag: 'Logo',
          child: const FlutterLogo(
            size: AppSpacing.massive,
          ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.xxl),
        ),
        //
        /// 🏷️ Main header text
        const TextWidget(LocaleKeys.sign_in_header, TextType.headlineSmall),
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

/// 📧 [_SignInEmailInputField] — Email input field with validation & focus handling
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _SignInEmailInputField extends ConsumerWidget {
  ///--------------------------------------------------
  const _SignInEmailInputField(this.focusNode);
  //
  final ({FocusNode email, FocusNode password}) focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final emailError = ref.watch(
      signInFormProvider.select((f) => f.email.uiErrorKey),
    );
    final formNotifier = ref.read(signInFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.email,
      focusNode: focusNode.email,
      errorText: emailError,
      onChanged: formNotifier.emailChanged,
      onSubmitted: goNext(focusNode.password),
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🧩 [_SignInPasswordInputField] — password input field with visibility toggle
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _SignInPasswordInputField extends ConsumerWidget {
  ///------------------------------------------------------
  const _SignInPasswordInputField(this.focusNode);
  //
  final ({FocusNode email, FocusNode password}) focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final passwordError = ref.watch(
      signInFormProvider.select((f) => f.password.uiErrorKey),
    );
    final isObscure = ref.watch(
      signInFormProvider.select((f) => f.isPasswordObscure),
    );
    final isValid = ref.watch(
      signInFormProvider.select((f) => f.isValid),
    );
    final formNotifier = ref.read(signInFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.password,
      focusNode: focusNode.password,
      errorText: passwordError,
      isObscure: isObscure,
      onChanged: formNotifier.passwordChanged,
      onSubmitted: isValid ? () => ref.submitSignIn() : null,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: formNotifier.togglePasswordVisibility,
      ),
    ).withPaddingBottom(AppSpacing.xl);
  }
}

////
////

/// 🚀 [_SignInSubmitButton] — Button for triggering sign-in logic
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [FormSubmitButtonForRiverpodApps]
//
final class _SignInSubmitButton extends ConsumerWidget {
  ///------------------------------------------------
  const _SignInSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return FormSubmitButtonForRiverpodApps(
      label: LocaleKeys.buttons_sign_in,
      isValidProvider: signInFormIsValidProvider,
      isLoadingProvider: signInSubmitIsLoadingProvider,
      onPressed: () => ref.submitSignIn(),
    ).withPaddingBottom(AppSpacing.l);
  }
}

////
////

/// 🔁 [_SignInFooter] — sign up & reset password links
/// ✅ Disabled during form submission or overlay
//
final class _SignInFooter extends ConsumerWidget {
  ///-------------------------------------------
  const _SignInFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⏳ Submission loading (primitive bool)
    final isLoading = ref.watch(
      signInProvider.select((a) => a.isLoading),
    );

    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isOverlayActive = ref.isOverlayActive;
    final isEnabled = !isLoading && !isOverlayActive;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Redirect to [SignUpPage]
        const TextWidget(
          LocaleKeys.buttons_redirect_to_sign_up,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.s),
        AppTextButton(
          label: LocaleKeys.buttons_sign_up,
          isEnabled: isEnabled,
          onPressed: () => context.goPushTo(RoutesNames.signUp),
        ).withPaddingBottom(AppSpacing.xxxm),

        /// Redirect to [ResetPasswordPage]
        const TextWidget(
          LocaleKeys.sign_in_forgot_password,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.s),
        AppTextButton(
          label: LocaleKeys.buttons_reset_password,
          foregroundColor: AppColors.forErrors,
          isEnabled: isEnabled,
          onPressed: () => context.goTo(RoutesNames.resetPassword),
        ),
      ],
    );
  }
}
