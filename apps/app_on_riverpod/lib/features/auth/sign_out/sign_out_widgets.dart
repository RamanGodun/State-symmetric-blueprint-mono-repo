import 'package:app_on_riverpod/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_riverpod/core/base_modules/navigation/go_router_factory.dart'
    show buildGoRouter;
import 'package:app_on_riverpod/features/auth/sign_in/sign_in__page.dart'
    show SignInPage;
import 'package:app_on_riverpod/features/auth/sign_out/sign_out_provider.dart'
    show signOutProvider;
import 'package:flutter/material.dart'
    show BuildContext, Icon, IconButton, Icons, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppSpacing, WidgetPaddingX;
import 'package:shared_widgets/public_api/buttons.dart' show AppTextButton;

/// ❌ [SignOutIconButton] — triggers logout
///     🔁 No manual navigation: success is handled by GoRouter ([buildGoRouter])
///        and perform redirection to [SignInPage]
//
final class SignOutIconButton extends ConsumerWidget {
  ///----------------------------------------------
  const SignOutIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () => ref.read(signOutProvider.notifier).signOut(),
    ).withPaddingRight(AppSpacing.xm);
  }
}

////
////

/// ❌ [VerifyEmailCancelButton] — triggers logout
///     🔁 No manual navigation: success is handled by GoRouter ([buildGoRouter])
///        and perform redirection to [SignInPage]
//
final class VerifyEmailCancelButton extends ConsumerWidget {
  ///-----------------------------------------------------
  const VerifyEmailCancelButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// Button always is clickable (user can cancel polling in ane moment)
    return AppTextButton(
      label: AppLocaleKeys.buttons_cancel,
      onPressed: () => ref.read(signOutProvider.notifier).signOut(),
    ).withPaddingTop(AppSpacing.xm);
  }
}
