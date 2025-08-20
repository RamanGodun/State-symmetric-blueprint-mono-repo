import 'package:blueprint_on_qubit/features/auth/presentation/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppIcons, AppSpacing;
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
final class SignOutIconButton extends StatelessWidget {
  ///--------------------------------------
  const SignOutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return IconButton(
      icon: const Icon(AppIcons.logout),
      onPressed: () => context.read<SignOutCubit>().signOut(),
    ).withPaddingOnly(right: AppSpacing.m);
  }
}
