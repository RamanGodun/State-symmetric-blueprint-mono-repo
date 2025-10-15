import 'package:app_on_riverpod/core/base_modules/navigation/go_router_factory.dart';
import 'package:app_on_riverpod/features/auth/sign_in/sign_in__page.dart'
    show SignInPage;
import 'package:app_on_riverpod/features/auth/sign_out/sign_out_provider.dart';
import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      label: LocaleKeys.buttons_cancel,
      onPressed: () => ref.read(signOutProvider.notifier).signOut(),
    ).withPaddingTop(AppSpacing.xm);
  }
}
