import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_widgets.dart'
    show SignOutIconButton;
import 'package:app_on_bloc/features_presentation/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'; // CoreAsync + AsyncLike + extensions
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] — profile screen with reactive auth-driven state
///     ✅ Top-level error listeners (SignOut + Profile)
///     ✅ State-agnostic UI ([_ProfileView]) via AsyncStateView
//
final class ProfilePage extends StatelessWidget {
  ///------------------------------------
  const ProfilePage({super.key});
  //

  @override
  Widget build(BuildContext context) {
    //
    final auth = context.watch<AuthCubit>().state;
    final uid = switch (auth) {
      AuthViewReady(:final session) => session.uid,
      _ => null,
    };

    /// 🛡️ Guard — render nothing if unauthenticated
    if (uid == null) return const SizedBox.shrink();

    /// 🧩♻️ Inject sign-out actions; profile auto-loads inside ProfileCubit
    return BlocProvider<SignOutCubit>(
      // ✅ screen-scoped instance, will be closed automatically
      create: (_) => di<SignOutCubit>(),

      /// ⛑️ Centralized (SignOut + Profile) one-shot error handling via overlays
      ///    - OverlayDispatcher resolves conflicts/priority internally
      child: AsyncMultiErrorListener(
        resolveBlocs: (ctx) => [
          ctx.read<SignOutCubit>(), // ⛑️ catch SignOut errors
          ctx.read<ProfileCubit>(), // ⛑️ catch EmailVerification errors
        ],

        ///
        child: BlocBuilder<ProfileCubit, AsyncState<UserEntity>>(
          builder: (context, state) {
            /// 🔌 Adapt AsyncState → AsyncStateView and render shared UI
            final profileViewState = state.asCubitAsyncStateView();

            return _ProfileView(state: profileViewState);
          },
        ),
      ),
    );
  }
}

////
////

/// 📄 [_ProfileView] — State-agnostic rendering via [AsyncStateView]
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ProfileView extends StatelessWidget {
  ///------------------------------------------
  const _ProfileView({required this.state});

  ///
  final AsyncStateView<UserEntity> state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _ProfileAppBar(),

      ///
      body: state.when(
        /// ⏳ Loading
        loading: () => const AppLoader(),

        /// ✅ Data
        data: (user) => _UserProfileCard(user: user),

        /// 🧨 Error — handled by overlay listener (silent here)
        error: (_) => const SizedBox.shrink(),
      ),
    );
  }
}
