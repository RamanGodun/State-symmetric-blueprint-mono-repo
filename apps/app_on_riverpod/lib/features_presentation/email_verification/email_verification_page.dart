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
/// ✅ Automatically redirects when email gets verified
/// ✅ Unified rendering via [VerifyEmailView] + AsyncStateView
//
final class VerifyEmailPage extends ConsumerWidget {
  ///--------------------------------------------
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⛑️ Centralized retry-aware error handling
    ref
      ..listenRetryAwareFailure(
        emailVerificationNotifierProvider,
        context,
        ref: ref,
        onRetry: () => ref.invalidate(emailVerificationNotifierProvider),
      )
      /// ▶️ Trigger polling (notifier starts flow in build)
      ..read(emailVerificationNotifierProvider);

    /// 🔌 Bridge AsyncValue → AsyncStateView
    final view = ref.watch(emailVerificationNotifierProvider).asAsyncLike();

    /// ♻️ State-agnostic UI (identical to BLoC)
    return VerifyEmailView(state: view);
  }
}

////

////

/// 📄 [VerifyEmailView] — State-agnostic UI with inline loader
/// ✅ Works with both Riverpod & BLoC via [AsyncStateView]
//
final class VerifyEmailView extends StatelessWidget {
  ///---------------------------------------------
  const VerifyEmailView({required this.state, super.key});
  //
  /// 🔌 Unified async facade
  final AsyncStateView<void> state;

  @override
  Widget build(BuildContext context) {
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

          /// ℹ️ Instructions + inline loader OR cancel
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main information/instructions for the user.
              const _VerifyEmailInfo(),
              // Show loader while polling
              if (state.isLoading) const AppLoader(),
              //  Show cancel button
              const _VerifyEmailCancelButton().withPaddingTop(AppSpacing.l),
            ],
          ).withPaddingSymmetric(h: AppSpacing.xl, v: AppSpacing.xxl),
        ),
      ),
    );
  }

  //
}
