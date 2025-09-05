import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_provider.dart';
import 'package:app_on_riverpod/features_presentation/email_verification/provider/email_verification_provider.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_email_verification_page.dart';

/// 🧼 [VerifyEmailPage] — screen that handles email verification polling
/// Automatically redirects when email gets verified
//
final class VerifyEmailPage extends ConsumerWidget {
  ///--------------------------------------------
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⛑️ Error listener
    ref
      ..listenRetryAwareFailure(
        emailVerificationNotifierProvider,
        context,
        ref: ref,
        onRetry: () => ref.invalidate(emailVerificationNotifierProvider),
      )
      // 🎯 Trigger the polling logic
      ..read(emailVerificationNotifierProvider);

    final asyncValue = ref.watch(emailVerificationNotifierProvider);

    return Scaffold(
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(context.isDarkMode ? 0.05 : 0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: asyncValue.when(
            //
            loading: () => const AppLoader(),
            error: (_, _) => const VerifyEmailCancelButton(),

            data: (_) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [_VerifyEmailInfo(), VerifyEmailCancelButton()],
            ).withPaddingSymmetric(h: AppSpacing.xl, v: AppSpacing.xxl),
          ),
        ),
      ),
    );
  }
}
