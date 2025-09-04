part of 'sign_up__page.dart';

/// 🧾 [_SignupHeader] — logo and welcome message
//
final class _SignupHeader extends StatelessWidget {
  ///------------------------------------------
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    //
    return const Column(
      children: [
        SizedBox(height: AppSpacing.xxl),
        FlutterLogo(size: AppSpacing.massive),
        SizedBox(height: AppSpacing.xxxm),
        TextWidget(LocaleKeys.pages_sign_up, TextType.headlineSmall),
        TextWidget(LocaleKeys.sign_up_sub_header, TextType.bodyMedium),
        SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

////

////

final class _SignupSubmitButton extends ConsumerWidget {
  ///------------------------------------------------
  const _SignupSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // /
    final form = ref.watch(signUpFormProvider);
    final signupState = ref.watch(signupProvider);
    final isOverlayActive = ref.isOverlayActive;

    return CustomFilledButton(
      label: signupState.isLoading
          ? LocaleKeys.buttons_submitting
          : LocaleKeys.buttons_sign_up,
      isEnabled: form.isValid && !isOverlayActive,
      isLoading: signupState.isLoading,
      onPressed: form.isValid && !signupState.isLoading
          ? () => ref.submit()
          : null,
    ).withPaddingBottom(AppSpacing.xl);
  }
}

////

////

/// 🔁 [_SignupFooter] — sign in redirect
//
final class _SignupFooter extends StatelessWidget {
  ///-------------------------------------------
  const _SignupFooter();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const TextWidget(
          LocaleKeys.buttons_redirect_to_sign_in,
          TextType.titleSmall,
        ),
        const SizedBox(height: AppSpacing.s),

        AppTextButton(
          onPressed: () => context.popView(),
          label: LocaleKeys.buttons_sign_in,
        ),
      ],
    );
  }
}
