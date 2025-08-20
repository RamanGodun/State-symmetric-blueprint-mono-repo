part of 'reset_password_page.dart';

/// ℹ️ [_ResetPasswordHeader] — header section with logo & instructions
//
final class _ResetPasswordHeader extends StatelessWidget {
  ///--------------------------------------------------
  const _ResetPasswordHeader();

  @override
  Widget build(BuildContext context) {
    //
    return const Column(
      children: [
        SizedBox(height: AppSpacing.huge),
        SizedBox(height: AppSpacing.huge),
        FlutterLogo(size: AppSpacing.huge),
        SizedBox(height: AppSpacing.xxxm),
        TextWidget(LocaleKeys.reset_password_header, TextType.headlineSmall),
        TextWidget(LocaleKeys.reset_password_sub_header, TextType.bodyMedium),
        SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

////

////

/// 🧾 [_ResetPasswordEmailInputField] — email input field for password reset
//
final class _ResetPasswordEmailInputField extends HookConsumerWidget {
  ///--------------------------------------------------------------
  const _ResetPasswordEmailInputField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(resetPasswordFormProvider);
    final notifier = ref.read(resetPasswordFormProvider.notifier);
    final focusNode = useFocusNode();

    return InputFieldFactory.create(
      type: InputFieldType.email,
      focusNode: focusNode,
      errorText: form.email.uiErrorKey,
      onChanged: notifier.emailChanged,
      onSubmitted: form.isValid ? () => ref.submitResetPassword() : null,
    );
  }
}

////

////

/// 🔘 [_ResetPasswordSubmitButton] — confirms reset action
//
final class _ResetPasswordSubmitButton extends ConsumerWidget {
  ///-------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final form = ref.watch(resetPasswordFormProvider);
    final resetState = ref.watch(resetPasswordProvider);
    final isOverlayActive = ref.isOverlayActive;

    return CustomFilledButton(
      onPressed: form.isValid && !resetState.isLoading
          ? () => ref.submitResetPassword()
          : null,
      label: resetState.isLoading
          ? LocaleKeys.buttons_submitting
          : LocaleKeys.buttons_reset_password,
      isLoading: resetState.isLoading,
      isEnabled: form.isValid && !isOverlayActive,
    );
  }
}

////

////

/// 🔁 [_ResetPasswordFooter] — footer with redirect to Sign In
//
final class _ResetPasswordFooter extends StatelessWidget {
  ///--------------------------------------------------
  const _ResetPasswordFooter();

  @override
  Widget build(BuildContext context) {
    //
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextWidget(
            LocaleKeys.reset_password_remember,
            TextType.titleSmall,
          ),
          AppTextButton(
            onPressed: () => context.goTo(RoutesNames.signIn),
            label: LocaleKeys.buttons_sign_in,
          ),
        ],
      ),
    );
  }
}
