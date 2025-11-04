part of 'email_verification_page.dart';

/// ℹ️ [_VerifyEmailInfo] — shows instructions about checking inbox / spam
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _VerifyEmailInfo extends StatelessWidget {
  ///----------------------------------------------
  const _VerifyEmailInfo();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const TextWidget(
          LocaleKeys.pages_verify_email,
          TextType.titleMedium,
          fontWeight: FontWeight.w700,
          isTextOnFewStrings: true,
        ),
        const SizedBox(height: AppSpacing.xxxm),
        const TextWidget(LocaleKeys.verify_email_sent, TextType.bodyMedium),
        const SizedBox(height: AppSpacing.xxs),
        TextWidget(
          FirebaseRefs.auth.currentUser?.email ??
              LocaleKeys.verify_email_unknown,
          TextType.bodyMedium,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: AppSpacing.xxxm),
        const TextWidget(
          LocaleKeys.verify_email_not_found,
          TextType.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xxs),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: LocaleKeys.verify_email_check_prefix.tr(),
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: context.colorScheme.onSurface,
            ),
            children: [
              TextSpan(
                text: LocaleKeys.verify_email_spam.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: LocaleKeys.verify_email_check_suffix.tr()),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxxs),
        const TextWidget(
          LocaleKeys.verify_email_or,
          TextType.error,
          color: AppColors.forErrors,
        ),
        const SizedBox(height: AppSpacing.xxs),
        const TextWidget(
          LocaleKeys.verify_email_ensure_correct,
          TextType.bodyMedium,
          isTextOnFewStrings: true,
        ),
        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }
}
