import 'package:app_on_riverpod/features/auth/sign_out/sign_out_provider.dart';
import 'package:app_on_riverpod/features/auth/sign_out/sign_out_widgets.dart';
import 'package:app_on_riverpod/features/email_verification/provider/email_verification_provider.dart';
import 'package:core/public_api/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_email_verification_page.dart';

/// 🧼 [VerifyEmailPage] — Entry point of email-verification feature
/// ✅ Provides reactive auth-driven state for state-agnostic UI (via [_VerifyEmailScreen] + [AsyncValue])
/// ✅ `AsyncValue<T>` adapted to `AsyncStateView<T>`
/// ✅  Top-level error listeners (SignOut + EmailVerification) are centralized
/// ✅ Automatically redirects when email gets verified
//
final class VerifyEmailPage extends ConsumerWidget {
  ///--------------------------------------------
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ▶️ Trigger polling (notifier starts flow in build)
    ref.read(emailVerificationNotifierProvider);

    /// 🖼️ Declarative UI bound to [emailVerificationNotifierProvider]
    final emailVerificationState = ref.watch(emailVerificationNotifierProvider);

    /// ⛑️ Centralized (SignOut + EmailVerification) one-shot errors handling via overlays
    ///    - OverlayDispatcher resolves conflicts/priority internally
    return ErrorsListenerForAppOnRiverpod(
      providers: [
        signOutProvider, // ⛑️ catch signOut errors
        emailVerificationNotifierProvider, // ⛑️ catch verification errors
      ],
      //
      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: _VerifyEmailScreen(state: emailVerificationState),
    );
  }
}

////
////

/// 📄 [_VerifyEmailScreen] — renders state-symmetric verification UI
/// ✅ Shows instructions, inline loader, and cancel button
/// ✅ Symmetric between BLoC&Riverpod via [AsyncValue]
//
final class _VerifyEmailScreen extends StatelessWidget {
  ///---------------------------------------------
  const _VerifyEmailScreen({required this.state});
  //
  /// 🔌 Unified async facade
  final AsyncValue<void> state;

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

          /// ℹ️ Info + loader + cancel
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _VerifyEmailInfo(), // ℹ️ instructions
              if (state.isLoading) const AppLoader(), // ⏳ loader
              const VerifyEmailCancelButton(), // ❌ cancel
            ],
          ).withPaddingSymmetric(h: AppSpacing.xl, v: AppSpacing.xxl),
        ),
      ).withPaddingSymmetric(h: AppSpacing.xm),
    );
  }
}
