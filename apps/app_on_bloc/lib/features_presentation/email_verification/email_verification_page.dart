import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_widgets.dart'
    show VerifyEmailCancelButton;
import 'package:app_on_bloc/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_email_verification_page.dart';

/// 🧼 [VerifyEmailPage] — Entry point of email-verification feature
/// 🧩 Provide screen-scoped cubits (disposed on pop)
//
final class VerifyEmailPage extends StatelessWidget {
  ///---------------------------------------------
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmailVerificationCubit>(
          create: (_) => di<EmailVerificationCubit>(),
        ),
        BlocProvider<SignOutCubit>(create: (_) => di<SignOutCubit>()),
      ],

      child: const _VerifyEmailView(),
    );
  }
}

////
////

/// 🧼 [_VerifyEmailView] - Provides reactive auth-driven state for state-agnostic UI
/// ✅ State-agnostic UI via [_VerifyEmailScreen] + [AsyncStateView]
/// ✅ `AsyncState<T>` adapted to `AsyncStateView<T>`
/// ✅  Top-level error listeners (SignOut + EmailVerification) are centralized
/// ✅ Automatically redirects when email gets verified
//
final class _VerifyEmailView extends StatelessWidget {
  ///----------------------------------------------
  const _VerifyEmailView();

  @override
  Widget build(BuildContext context) {
    //
    // 👀🖼️ Declarative UI bound directly via context.select
    final asyncState = context.select(
      (EmailVerificationCubit cubit) => cubit.state,
    );
    //
    /// 🔌 Adapter: `AsyncState<void>` → `AsyncStateView<void>` (for state-agnostic UI)
    final emailVerificationState = asyncState.asCubitAsyncStateView();

    /// ⛑️ Centralized (SignOut + EmailVerification) one-shot errors handling via overlays
    ///    - OverlayDispatcher resolves conflicts/priority internally
    return ErrorsListenerForAppOnCubit(
      resolveBlocs: (ctx) => [
        ctx.read<SignOutCubit>(), // ⛑️ catch SignOut errors
        ctx.read<EmailVerificationCubit>(), // ⛑️ catch EmailVerification errors
      ],

      /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
      child: _VerifyEmailScreen(state: emailVerificationState),
    );
  }
}

////
////

/// 📄 [_VerifyEmailScreen] — renders state-agnostic verification UI
/// ✅ Shows instructions, inline loader, and cancel button
/// ✅ Works with both BLoC & Riverpod via [AsyncStateView]
//
final class _VerifyEmailScreen extends StatelessWidget {
  ///---------------------------------------------
  const _VerifyEmailScreen({required this.state});
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
      ),
    );
  }
}
