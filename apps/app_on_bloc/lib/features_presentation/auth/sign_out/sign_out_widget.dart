import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:core/base_modules/ui_design.dart' show AppIcons, AppSpacing;
import 'package:core/utils.dart';
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
