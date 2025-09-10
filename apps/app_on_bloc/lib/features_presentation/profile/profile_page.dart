import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_widget.dart';
import 'package:app_on_bloc/features_presentation/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'; // CoreAsync + AsyncLike + extensions
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] — Declarative profile screen with reactive auth-driven loading
/// ✅ Ultra-thin orchestration + AsyncStateView-based UI
/// ✅ Errors surfaced centrally via overlays (no inline error UI)
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

    /// 🛡️ Guard — mirror Riverpod: if not authenticated, show nothing
    if (uid == null) return const SizedBox.shrink();

    /// 🧩♻️ Inject sign-out actions; profile auto-loads inside ProfileCubit
    return BlocProvider<SignOutCubit>(
      create: (_) => di<SignOutCubit>(),

      /// 📣 One-shot error feedback via overlays (centralized)
      child: BlocListener<ProfileCubit, AsyncState<UserEntity>>(
        listenWhen: (prev, curr) =>
            prev is! AsyncStateError<UserEntity> &&
            curr is AsyncStateError<UserEntity>,
        listener: (context, state) {
          final failure = (state as AsyncStateError<UserEntity>).failure;
          context.showError(failure.toUIEntity());
        },

        /// 🔁 Stateless UI — consume AsyncStateView and render
        child: BlocBuilder<ProfileCubit, AsyncState<UserEntity>>(
          builder: (context, state) => ProfileView(
            // 🔌 Adapt AsyncState → AsyncStateView and render shared UI
            state: state.asAsyncStateView(),
          ),
        ),
      ),
    );
  }
}

////

////

/// 📄 [ProfileView] — State-agnostic rendering via [AsyncStateView]
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class ProfileView extends StatelessWidget {
  ///------------------------------------------
  const ProfileView({required this.state, super.key});

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
