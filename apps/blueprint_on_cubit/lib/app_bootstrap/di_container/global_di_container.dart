import 'package:blueprint_on_cubit/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:blueprint_on_cubit/features_presentation/profile/cubit/profile_page_cubit.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_status_cubit.dart'
    show OverlayStatusCubit;
import 'package:core/base_modules/theme/theme_providers_or_cubits/theme_cubit.dart'
    show AppThemecubit;
import 'package:core/di_container_cubit/core/di.dart';
import 'package:core/utils_shared/bloc_specific/user_auth_cubit/auth_stream_adapter.dart';
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
        BlocProvider.value(value: di<AppThemecubit>()),
        BlocProvider.value(value: di<OverlayStatusCubit>()),

        BlocProvider.value(value: di<AuthCubit>()),
        BlocProvider.value(value: di<Profilecubit>()),

        BlocProvider.value(value: di<EmailVerificationcubit>()),

        // others...
      ],
      child: child,
    );
  }
}
