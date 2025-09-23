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
          TextType.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.xxxs),
        const TextWidget(
          LocaleKeys.change_password_warning,
          TextType.bodyMedium,
        ),
        Text.rich(
          TextSpan(
            text: LocaleKeys.change_password_prefix.tr(),
            style: const TextStyle(fontSize: 16),
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

/// 🧾 [_PasswordInputField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _PasswordInputField extends ConsumerWidget {
  ///-------------------------------------------
  const _PasswordInputField(this.focusNodes);
  //
  final ({FocusNode password, FocusNode confirmPassword}) focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final passwordError = ref.watch(
      changePasswordFormProvider.select((f) => f.password.uiErrorKey),
    );
    final isObscure = ref.watch(
      changePasswordFormProvider.select((f) => f.isPasswordObscure),
    );
    final notifier = ref.read(changePasswordFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.password,
      focusNode: focusNodes.password,
      errorText: passwordError,
      isObscure: isObscure,
      onChanged: notifier.onPasswordChanged,
      onSubmitted: goNext(focusNodes.confirmPassword),
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: notifier.togglePasswordVisibility,
      ),
    ).withPaddingBottom(AppSpacing.m);
  }
}

////
////

/// 🧾 [_ConfirmPasswordInputField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _ConfirmPasswordInputField extends ConsumerWidget {
  ///--------------------------------------------------
  const _ConfirmPasswordInputField(this.focusNodes);
  //
  final ({FocusNode password, FocusNode confirmPassword}) focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final confirmPasswordError = ref.watch(
      changePasswordFormProvider.select((f) => f.confirmPassword.uiErrorKey),
    );
    final isObscure = ref.watch(
      changePasswordFormProvider.select((f) => f.isConfirmPasswordObscure),
    );
    final isValid = ref.watch(
      changePasswordFormProvider.select((f) => f.isValid),
    );
    final notifier = ref.read(changePasswordFormProvider.notifier);

    return InputFieldFactory.create(
      type: InputFieldType.confirmPassword,
      focusNode: focusNodes.confirmPassword,
      errorText: confirmPasswordError,
      isObscure: isObscure,
      onChanged: notifier.onConfirmPasswordChanged,
      onSubmitted: isValid ? () => ref.submitChangePassword() : null,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: notifier.toggleConfirmPasswordVisibility,
      ),
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
    return FormSubmitButtonForRiverpodApps(
      label: LocaleKeys.change_password_title,
      isValidProvider: changePasswordFormIsValidProvider,
      isLoadingProvider: changePasswordSubmitIsLoadingProvider,
      onPressed: () => ref.submitChangePassword(),
    ).withPaddingBottom(AppSpacing.l);
  }
}

////
////

/// 🛡️s📤 Submits the password change request (when the form is valid)
//
extension PasswordActionsRefX on WidgetRef {
  ///------------------------------------
  Future<void> submitChangePassword() async {
    final form = watch(changePasswordFormProvider);
    if (!form.isValid) return;
    //
    final notifier = read(changePasswordProvider.notifier);
    await notifier.changePassword(form.password.value);
    //
  }
}
