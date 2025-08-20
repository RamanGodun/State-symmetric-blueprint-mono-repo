import 'package:blueprint_on_qubit/core/base_moduls/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:blueprint_on_qubit/features/auth/presentation/sign_out/sign_out_cubit/sign_out_cubit.dart'
    show SignOutCubit, SignOutState, SignOutStatus;
import 'package:blueprint_on_qubit/features/email_verification/presentation/email_verification_cubit/email_verification_cubit.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_ui_mapper.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart';
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/base_modules/theme/ui_constants/app_colors.dart'
    show AppColors;
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/di_container_cubit/core/di.dart' show di;
import 'package:core/shared_presentation_layer/shared_widgets/buttons/text_button.dart';
import 'package:core/shared_presentation_layer/shared_widgets/loader.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_bootstrap_config/firebase_config/firebase_constants.dart';
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
    final emailVerificationCubit = context.read<EmailVerificationCubit>();

    /// Ensure the verification flow is initialized only once after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailVerificationCubit.initVerificationFlow();
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
