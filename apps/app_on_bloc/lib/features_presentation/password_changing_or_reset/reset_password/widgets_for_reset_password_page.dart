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
    //
    return BlocSelector<
      ResetPasswordFormCubit,
      ResetPasswordFormState,
      (String?, int)
    >(
      selector: (state) => (state.email.uiErrorKey, state.epoch),
      builder: (context, tuple) {
        final (errorText, epoch) = tuple;

        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: errorText,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
          onChanged: context.read<ResetPasswordFormCubit>().onEmailChanged,
          onEditingComplete: () {
            final current = context.read<ResetPasswordFormCubit>().state;
            if (current.isValid) {
              context.read<ResetPasswordCubit>().submit(current.email.value);
            }
          },
          fieldKeyOverride: ValueKey('email_$epoch'),
        ).withPaddingBottom(AppSpacing.huge);
      },
    );
  }
}

////
////

/// 🔘 [_ResetPasswordSubmitButton] — Confirms reset action button
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [UniversalSubmitButton]
//
final class _ResetPasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return UniversalSubmitButton<
          ResetPasswordFormCubit,
          ResetPasswordFormState,
          ResetPasswordCubit
        >(
          label: LocaleKeys.buttons_reset_password,
          loadingLabel: LocaleKeys.buttons_submitting,
          isFormValid: (state) => state.isValid,
          //
          onPressed: () {
            final formState = context.read<ResetPasswordFormCubit>().state;
            context.unfocusKeyboard().read<ResetPasswordCubit>().submit(
              formState.email.value,
            );
          },
          //
        )
        .withPaddingBottom(AppSpacing.xl);
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
    return FooterGuard<ResetPasswordCubit, ButtonSubmissionState>(
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
