import 'package:app_on_cubit/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_cubit/core/base_modules/navigation/go_router_factory.dart'
    show buildGoRouter;
import 'package:app_on_cubit/features/auth/sign_in/sign_in__page.dart'
    show SignInPage;
import 'package:app_on_cubit/features/auth/sign_out/sign_out_cubit/sign_out_cubit.dart'
    show SignOutCubit;
import 'package:flutter/material.dart'
    show BuildContext, Icon, IconButton, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppIcons, AppSpacing, WidgetPaddingX;
import 'package:shared_widgets/public_api/buttons.dart' show AppTextButton;

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
      label: AppLocaleKeys.buttons_cancel,
      onPressed: () => context.read<SignOutCubit>().signOut(),
    ).withPaddingTop(AppSpacing.xm);
  }
}
