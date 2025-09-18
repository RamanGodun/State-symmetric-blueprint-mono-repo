part of 'reset_password__page.dart';

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
final class _ResetPasswordEmailInputField extends HookWidget {
  ///------------------------------------------------------
  const _ResetPasswordEmailInputField();

  @override
  Widget build(BuildContext context) {
    //
    final focusNode = useResetPasswordFocusNodes().email;

    return BlocSelector<
      ResetPasswordFormCubit,
      ResetPasswordFormState,
      String?
    >(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: errorText,
          onChanged: context.read<ResetPasswordFormCubit>().onEmailChanged,
          onSubmitted: () {
            final form = context.read<ResetPasswordFormCubit>().state;
            if (form.isValid) {
              context.read<ResetPasswordCubit>().submit(form.email.value);
            }
          },
        ).withPaddingBottom(AppSpacing.huge);
      },
    );
  }
}

////
////

/// 🔘 [_ResetPasswordSubmitButton] — Confirms reset action button
//
final class _ResetPasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );
    final isLoading = context.select<ResetPasswordCubit, bool>(
      (cubit) => cubit.state.isLoading,
    );

    return BlocSelector<ResetPasswordFormCubit, ResetPasswordFormState, bool>(
      selector: (s) => s.isValid,
      builder: (context, isValid) {
        final isEnabled = isValid && !isLoading && !isOverlayActive;

        return CustomFilledButton(
          label: isLoading
              ? LocaleKeys.buttons_submitting
              : LocaleKeys.buttons_reset_password,
          isLoading: isLoading,
          isEnabled: isEnabled,
          onPressed: isEnabled
              ? () {
                  context.unfocusKeyboard();
                  final email = context
                      .read<ResetPasswordFormCubit>()
                      .state
                      .email
                      .value;
                  context.read<ResetPasswordCubit>().submit(email);
                }
              : null,
        ).withPaddingBottom(AppSpacing.xl);
      },
    );
  }
}

////
////

/// 🛡️ [_ResetPasswordFooterGuard] — Make footer disable during form submission or active overlay
//
final class _ResetPasswordFooterGuard extends StatelessWidget {
  ///-------------------------------------------------------
  const _ResetPasswordFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    return FooterGuard<ResetPasswordCubit, ResetPasswordState>(
      isLoadingSelector: (state) => state.isLoading,
      childBuilder: (_, isEnabled) =>
          /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
          _ResetPasswordPageFooter(isEnabled: isEnabled),
    );
  }
}

////
////

/// 🔁 [_ResetPasswordPageFooter] — sign in redirect link
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ResetPasswordPageFooter extends StatelessWidget {
  ///------------------------------------------------------
  const _ResetPasswordPageFooter({required this.isEnabled});
  //
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    //
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextWidget(
          LocaleKeys.reset_password_remember,
          TextType.titleSmall,
        ),
        AppTextButton(
          label: LocaleKeys.buttons_sign_in,
          isEnabled: isEnabled,
          onPressed: () => context.popView(),
        ),
      ],
    ).withPaddingBottom(AppSpacing.xxxm);
  }
}
