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
final class _ResetPasswordEmailInputField extends HookWidget {
  ///------------------------------------------------------
  const _ResetPasswordEmailInputField();

  @override
  Widget build(BuildContext context) {
    //
    final focusNode = useResetPasswordFocusNodes().email;

    return BlocSelector<ResetPasswordcubit, ResetPasswordState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: errorText,
          onChanged: context.read<ResetPasswordcubit>().onEmailChanged,
          onSubmitted: () => context.read<ResetPasswordcubit>().submit(),
        );
      },
    );
  }
}

////

////

/// 🔘 [_ResetPasswordSubmitButton] — confirms reset action
//
final class _ResetPasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<
      ResetPasswordcubit,
      ResetPasswordState,
      ({FormzSubmissionStatus status, bool isValid})
    >(
      selector: (state) => (status: state.status, isValid: state.isValid),
      builder: (context, state) {
        return FormSubmitButton<ResetPasswordcubit, ResetPasswordState>(
          label: LocaleKeys.buttons_reset_password,
          onPressed: (_) {
            context.unfocusKeyboard();
            context.read<ResetPasswordcubit>().submit();
          },
          statusSelector: (s) => s.status,
          isValidatedSelector: (s) => s.isValid,
        );
      },
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
            onPressed: () => context.popView(),
            label: LocaleKeys.buttons_sign_in,
          ),
        ],
      ),
    );
  }
}
