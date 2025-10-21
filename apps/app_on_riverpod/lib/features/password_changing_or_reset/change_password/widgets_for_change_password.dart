part of 'change_password_page.dart';

/// ℹ️ Info section for [ChangePasswordPage]
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ChangePasswordInfo extends StatelessWidget {
  ///-------------------------------------------------
  const _ChangePasswordInfo();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const SizedBox(height: AppSpacing.massive),
        const TextWidget(
          LocaleKeys.change_password_title,
          TextType.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xxxs),
        const TextWidget(
          LocaleKeys.change_password_warning,
          TextType.titleSmall,
        ),
        Text.rich(
          TextSpan(
            text: LocaleKeys.change_password_prefix.tr(),
            style: context.textTheme.titleSmall,
            children: [
              TextSpan(
                text: LocaleKeys.change_password_signed_out.tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).withPaddingOnly(top: AppSpacing.xxl, bottom: AppSpacing.xxxm);
  }
}

////
////

/// 🧾 [_PasswordFormField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _PasswordFormField extends ConsumerWidget {
  ///------------------------------------------------
  const _PasswordFormField(this.focusNodes);
  //
  final NodesForChangePasswordPage focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = ref.watch(
      changePasswordFormProvider.select(recordsForPasswordFormField()),
    );
    final form = ref.read(changePasswordFormProvider.notifier);
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('password_$epoch'),
      type: InputFieldType.password,
      focusNode: focusNodes.password,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.password],
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: form.togglePasswordVisibility,
      ),
      //
      onChanged: form.onPasswordChanged,
      onSubmitted: goNext(focusNodes.confirmPassword),
      //
    ).withPaddingBottom(AppSpacing.m);
  }
}

////
////

/// 🧾 [_ConfirmPasswordFormField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _ConfirmPasswordFormField extends ConsumerWidget {
  ///------------------------------------------------------
  const _ConfirmPasswordFormField(this.focusNodes);
  //
  final NodesForChangePasswordPage focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = ref.watch(
      changePasswordFormProvider.select(
        recordsForConfirmPasswordFormField(useFormValidity: true),
      ),
    );
    final form = ref.read(changePasswordFormProvider.notifier);
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('confirm_$epoch'),
      type: InputFieldType.confirmPassword,
      focusNode: focusNodes.confirmPassword,
      errorText: errorText,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: form.toggleConfirmPasswordVisibility,
      ),
      //
      onChanged: form.onConfirmPasswordChanged,
      onSubmitted: isValid ? () => ref.submitChangePassword() : null,
      //
    ).withPaddingBottom(AppSpacing.xxxl);
  }
}

////
////

/// 🔐 [_ChangePasswordSubmitButton] — dispatches the password change request
/// 📤 Submits new password when form is valid
//
final class _ChangePasswordSubmitButton extends ConsumerWidget {
  ///--------------------------------------------------------
  const _ChangePasswordSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return RiverpodAdapterForSubmitButton(
      label: LocaleKeys.change_password_title,
      isFormValid: changePasswordFormProvider.select(
        (state) => state.isValid,
      ),
      isLoadingSelector: changePasswordProvider.select<bool>(
        (SubmissionFlowStateModel state) => state.isLoading,
      ),
      onPressed: () => ref.submitChangePassword(),
    ).withPaddingBottom(AppSpacing.l);
  }
}
