import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:app_on_bloc/features/auth/sign_out/sign_out_widgets.dart'
    show SignOutIconButton;
import 'package:app_on_bloc/features/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:core/public_api/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] - Entry point for profile feature
/// 🧩 Provide screen-scoped cubits (disposed on pop)
//
final class ProfilePage extends StatelessWidget {
  ///-----------------------------------------
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider<SignOutCubit>(
      create: (_) => di<SignOutCubit>(),

      child: const _ProfileView(),
    );
  }
}

////
////

/// 🔌 [_ProfileView] - Provides reactive auth-driven state for state-agnostic UI
/// ✅ State-symmetric UI via [_ProfileScreen] + [AsyncValueForBLoC]
/// ✅ `AsyncState<T>` adapted to `AsyncStateView<T>`
/// ✅  Top-level error listeners (SignOut + Profile) are centralized
//
final class _ProfileView extends StatelessWidget {
  ///------------------------------------------
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    //
    // 👀🖼️ Declarative UI bound directly via context.select
    final asyncState = context.select((ProfileCubit cubit) => cubit.state);

    /// ⛑️ Centralized (SignOut + Profile) one-shot error handling via overlays
    ///    - OverlayDispatcher resolves conflicts/priority internally
    return BlocAdapterForErrorsMultiListeners(
      resolveBlocs: (ctx) => [
        ctx.read<SignOutCubit>(), // ⛑️ catch SignOut errors
        ctx.read<ProfileCubit>(), // ⛑️ catch EmailVerification errors
      ],

      /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
      child: _ProfileScreen(state: asyncState),
    );
    //;
  }
}

////
////

/// 📄 [_ProfileScreen] — State-symmetric rendering via [AsyncValueForBLoC]
/// ✅ Symmetric widget used in Riverpod app for parity
//
final class _ProfileScreen extends StatelessWidget {
  ///--------------------------------------------
  const _ProfileScreen({required this.state});
  //
  final AsyncValueForBLoC<UserEntity> state;

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: const _ProfileAppBar(),
      //
      body: state.whenUI(
        //
        /// ⏳ Loading
        loading: () => const AppLoader(),

        /// ✅ Data
        data: (user) => _UserProfileCard(user: user),

        /// 🧨 Error — handled by overlay listener (silent here)
        error: (_) => const SizedBox.shrink(),
        //
      ),
    );
  }
}
