import 'package:blueprint_on_qubit/core/base_moduls/di_container/di_container_init.dart'
    show di;
import 'package:blueprint_on_qubit/features/email_verification/presentation/email_verification_cubit/email_verification_cubit.dart';
import 'package:blueprint_on_qubit/features/profile/presentation/cubit/profile_page_cubit.dart';
import 'package:blueprint_on_qubit/user_auth_cubit/auth_cubit.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_status_cubit.dart'
    show OverlayStatusCubit;
import 'package:core/base_modules/theme/theme_providers_or_cubits/theme_cubit.dart'
    show AppThemeCubit;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 📦 [GlobalProviders] — Wraps all global Blocs with providers for the app
//
final class GlobalProviders extends StatelessWidget {
  ///---------------------------------------------
  const GlobalProviders({required this.child, super.key});

  ///
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: di<AppThemeCubit>()),
        BlocProvider.value(value: di<OverlayStatusCubit>()),

        BlocProvider.value(value: di<AuthCubit>()),
        BlocProvider.value(value: di<ProfileCubit>()),

        BlocProvider.value(value: di<EmailVerificationCubit>()),

        // others...
      ],
      child: child,
    );
  }
}
