import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:app_on_bloc/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_email_verification_page.dart';

/// 🧼 [VerifyEmailPage] — Entry point widget for email verification flow.
/// ✅ Unified rendering via [_VerifyEmailView] + AsyncStateView (no adapter)
/// Registers required cubits and handles error listening.
//
final class VerifyEmailPage extends StatelessWidget {
  ///---------------------------------------------
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// Register all the required cubits using MultiBlocProvider.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: di<EmailVerificationCubit>()),
        BlocProvider.value(value: di<SignOutCubit>()),
      ],

      /// ⛑️ One-shot error overlay when AsyncState switches to Error
      child: BlocListener<EmailVerificationCubit, AsyncState<void>>(
        listenWhen: (prev, curr) =>
            prev is! AsyncStateError && curr is AsyncStateError,
        listener: (context, state) {
          final failure = (state as AsyncStateError<void>).failure;
          context.showError(failure.toUIEntity());
        },

        child: BlocBuilder<EmailVerificationCubit, AsyncState<void>>(
          builder: (context, state) {
            // ▶️ Kick off flow once after first frame (mirrors notifier.init in RP)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<EmailVerificationCubit>().initVerificationFlow();
            });

            // 🔌 AsyncState → AsyncStateView for shared UI
            final view = state.asAsyncStateView();

            return _VerifyEmailView(state: view);
          },
        ),
      ),
    );
  }
}

////

////

/// 📄 [_VerifyEmailView] — State-agnostic UI with inline loader
/// ✅ Works with both Riverpod & BLoC via [AsyncStateView]
//
final class _VerifyEmailView extends StatelessWidget {
  ///---------------------------------------------
  const _VerifyEmailView({required this.state});
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
