import 'package:app_on_bloc/core/base_modules/navigation/module_core/go_router_factory.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_in/sign_in__page.dart'
    show SignInPage;
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:core/base_modules/localization.dart' show LocaleKeys;
import 'package:core/base_modules/ui_design.dart' show AppIcons, AppSpacing;
import 'package:core/shared_layers/presentation.dart' show AppTextButton;
import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ❌ [SignOutIconButton] — triggers logout
///     🔁 No manual navigation: success is handled by GoRouter ([buildGoRouter])
///        and perform redirection to [SignInPage]
//
final class SignOutIconButton extends StatelessWidget {
  ///--------------------------------------
  const SignOutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return IconButton(
      icon: const Icon(AppIcons.logout),
      onPressed: () => context.read<SignOutCubit>().signOut(),
    ).withPaddingRight(AppSpacing.xm);
  }
}

////
////

/// ❌ [VerifyEmailCancelButton] — triggers logout
///     🔁 No manual navigation: success is handled by GoRouter ([buildGoRouter])
///        and perform redirection to [SignInPage]
//
final class VerifyEmailCancelButton extends StatelessWidget {
  ///----------------------------------------------------
  const VerifyEmailCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return AppTextButton(
      label: LocaleKeys.buttons_cancel,
      onPressed: () => context.read<SignOutCubit>().signOut(),
    ).withPaddingTop(AppSpacing.xm);
  }
}
