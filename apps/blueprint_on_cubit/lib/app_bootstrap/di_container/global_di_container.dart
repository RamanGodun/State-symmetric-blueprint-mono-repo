import 'package:bloc_adapter/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:bloc_adapter/base_modules/theme_module/theme_cubit.dart';
import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/utils/user_auth_cubit/auth_stream_cubit.dart';
import 'package:blueprint_on_cubit/features_presentation/profile/cubit/profile_page_cubit.dart';
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

        // others...
      ],
      child: child,
    );
  }
}
