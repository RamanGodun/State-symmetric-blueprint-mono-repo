import 'package:blueprint_on_riverpod/features_presentation/auth/sign_out/sign_out_provider.dart';
import 'package:blueprint_on_riverpod/features_presentation/email_verification/provider/email_verification_provider.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/base_modules/theme/ui_constants/app_colors.dart'
    show AppColors;
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/shared_presentation_layer/widgets_shared/buttons/text_button.dart';
import 'package:core/shared_presentation_layer/widgets_shared/loader.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/constants/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/base_modules/errors_handling_module/show_dialog_when_error_x.dart';

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
