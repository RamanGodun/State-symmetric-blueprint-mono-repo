part of 'sign_in_page.dart';

/// 🧩 [_SignInHeader] — displays logo and welcome messages for Sign In screen
/// 📦 Contains app logo, main header, and sub-header
//
final class _SignInHeader extends StatelessWidget {
  ///------------------------------------------
  const _SignInHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🖼️ App logo
        const FlutterLogo(
          size: AppSpacing.massive,
        ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.xxl),
        //
        /// 🏷️ Header text
        const TextWidget(LocaleKeys.sign_in_header, TextType.headlineSmall),
        //
        /// 📝 Sub-header text
        const TextWidget(
          LocaleKeys.sign_in_sub_header,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.xl),
      ],
    );
  }
}

////

////

/// 🧩 [_SignInEmailInputField] — email and password fields
//
final class _SignInEmailInputField extends ConsumerWidget {
  ///--------------------------------------------------
  const _SignInEmailInputField(this.focus);
  //
  final ({FocusNode email, FocusNode password}) focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(signInFormProvider);
    final formNotifier = ref.read(signInFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.email,
      focusNode: focus.email,
      errorText: form.email.uiErrorKey,
      onChanged: formNotifier.emailChanged,
      onSubmitted: focus.password.requestFocus,
    ).withPaddingBottom(AppSpacing.m);
  }
}

////

////

/// 🧩 [_SignInPasswordInputField] — password input field with visibility toggle
//
final class _SignInPasswordInputField extends ConsumerWidget {
  ///------------------------------------------------------
  const _SignInPasswordInputField(this.focus);
  //
  final ({FocusNode email, FocusNode password}) focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(signInFormProvider);
    final formNotifier = ref.read(signInFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.password,
      focusNode: focus.password,
      errorText: form.password.uiErrorKey,
      isObscure: form.isPasswordObscure,
      onChanged: formNotifier.passwordChanged,
      onSubmitted: form.isValid ? () => ref.submit() : null,
      suffixIcon: ObscureToggleIcon(
        isObscure: form.isPasswordObscure,
        onPressed: formNotifier.togglePasswordVisibility,
      ),
    ).withPaddingBottom(AppSpacing.xxxl);
  }
}

////

////

/// 🔘 [_SigninSubmitButton] — submit button for the sign-in form
//
final class _SigninSubmitButton extends ConsumerWidget {
  ///------------------------------------------------
  const _SigninSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(signInFormProvider);
    final signInState = ref.watch(signInProvider);
    final isOverlayActive = ref.isOverlayActive;

    return CustomFilledButton(
      label: signInState.isLoading
          ? LocaleKeys.buttons_submitting
          : LocaleKeys.buttons_sign_in,
      isEnabled: form.isValid && !isOverlayActive,
      isLoading: signInState.isLoading,
      onPressed: form.isValid && !signInState.isLoading
          ? () => ref.submit()
          : null,
    ).withPaddingBottom(AppSpacing.l);
  }
}

////

////

/// 🔁 [_SigninFooter] — sign up & reset password actions
//
final class _SigninFooter extends StatelessWidget {
  ///-------------------------------------------
  const _SigninFooter();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const TextWidget(
          LocaleKeys.buttons_redirect_to_sign_up,
          TextType.bodyMedium,
        ),
        const SizedBox(width: AppSpacing.s),

        AppTextButton(
          onPressed: () => context.goPushTo(RoutesNames.signUp),
          label: LocaleKeys.buttons_sign_up,
        ),
        const SizedBox(height: AppSpacing.xl),

        AppTextButton(
          onPressed: () => context.goTo(RoutesNames.resetPassword),
          label: LocaleKeys.sign_in_forgot_password,
          foregroundColor: AppColors.forErrors,
        ),
      ],
    );
  }
}
