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

    return BlocSelector<ResetPasswordCubit, ResetPasswordState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: errorText,
          onChanged: context.read<ResetPasswordCubit>().onEmailChanged,
          onSubmitted: () => context.read<ResetPasswordCubit>().submit(),
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
    return BlocSelector<
      ResetPasswordCubit,
      ResetPasswordState,
      ({FormzSubmissionStatus status, bool isValid})
    >(
      selector: (state) => (status: state.status, isValid: state.isValid),
      builder: (context, state) {
        return FormSubmitButtonForBlocApps<
              ResetPasswordCubit,
              ResetPasswordState
            >(
              label: LocaleKeys.buttons_reset_password,
              onPressed: (_) {
                context.unfocusKeyboard();
                context.read<ResetPasswordCubit>().submit();
              },
              statusSelector: (state) => state.status,
              isValidatedSelector: (state) => state.isValid,
            )
            .withPaddingBottom(AppSpacing.xl);
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
      isLoadingSelector: (state) => state.status.isSubmissionInProgress,
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
