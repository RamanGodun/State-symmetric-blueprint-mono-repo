import 'package:app_on_bloc/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart'
    show SignOutCubit, SignOutState, SignOutStatus;
import 'package:app_on_bloc/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart' show di;
import 'package:core/base_modules/errors_management.dart';
import 'package:core/base_modules/localization.dart'
    show LocaleKeys, TextType, TextWidget;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/overlays.dart';
import 'package:core/base_modules/ui_design.dart';
import 'package:core/shared_layers/presentation.dart'
    show AppLoader, AppTextButton;
import 'package:core/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_email_verification_page.dart';

/// [VerifyEmailPage] — Entry point widget for email verification flow.
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

      /// Listen for any failures and show error overlay if needed.
      child: BlocListener<EmailVerificationCubit, EmailVerificationState>(
        listenWhen: (prev, curr) => curr.failure?.consume() != null,
        listener: (context, state) {
          final error = state.failure?.consume();
          if (error != null) {
            context.showError(error.toUIEntity());
          }
        },

        child: const _VerifyEmailPageView(),
      ),
      // ),
    );
  }
}

/// [_VerifyEmailPageView] — Main UI for the email verification process.
/// Handles starting the verification polling and UI updates based on state.
//
final class _VerifyEmailPageView extends StatelessWidget {
  ///--------------------------------------------------
  const _VerifyEmailPageView();

  @override
  Widget build(BuildContext context) {
    //
    /// Get reference to the cubit.
    final emailVerificationcubit = context.read<EmailVerificationCubit>();

    /// Ensure the verification flow is initialized only once after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailVerificationcubit.initVerificationFlow();
    });

    // Listen for cubit state changes and rebuild UI accordingly.
    return BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
      builder: (context, state) {
        final status = state.status;
        return Scaffold(
          body: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(
                  context.isDarkMode ? 0.05 : 0.9,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main information/instructions for the user.
                  const _VerifyEmailInfo(),
                  // Show loader while loading, else show cancel button
                  if (status == EmailVerificationStatus.loading)
                    const AppLoader()
                  else
                    const VerifyEmailCancelButton(),
                ],
              ).withPaddingAll(AppSpacing.l),
            ),
          ).withPaddingHorizontal(AppSpacing.l),
        );
      },
    );
  }
}
