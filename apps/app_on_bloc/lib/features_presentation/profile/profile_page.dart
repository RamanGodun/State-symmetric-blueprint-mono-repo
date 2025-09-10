import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
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
/// ✅ Thin orchestration only: auth → load profile → render via AsyncLike
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

    /// 🛡️ Auth guard — keep UX consistent with Riverpod app
    if (uid == null) return const SizedBox.shrink();

    /// ♻️ Reactive load: whenever auth session (UID) resolves/changes — (re)load profile
    /// No manual “if (!isData)” checks, no spamming: load is called only on Ready
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthViewState>(
          listenWhen: (prev, curr) {
            // fire only when UID actually changes to a non-null value
            final prevUid = switch (prev) {
              AuthViewReady(:final session) => session.uid,
              _ => null,
            };
            final currUid = switch (curr) {
              AuthViewReady(:final session) => session.uid,
              _ => null,
            };
            return prevUid != currUid && currUid != null;
          },
          listener: (context, state) {
            if (state is AuthViewReady && state.session.uid != null) {
              context.read<ProfileCubit>().load(state.session.uid!);
            }
          },
        ),

        /// 📣 One-shot error feedback via overlays (centralized; no inline error widget)
        BlocListener<ProfileCubit, CoreAsync<UserEntity>>(
          listenWhen: (prev, curr) =>
              prev is! CoreAsyncError<UserEntity> &&
              curr is CoreAsyncError<UserEntity>,
          listener: (context, state) {
            final failure = (state as CoreAsyncError<UserEntity>).failure;
            context.showError(failure.toUIEntity());
          },
        ),
      ],

      /// 🔁 Stateless UI — consume AsyncLike and render in a single place
      child: BlocBuilder<ProfileCubit, CoreAsync<UserEntity>>(
        builder: (context, state) => ProfileView(
          // 🔌 Adapt CoreAsync → AsyncLike and render shared UI
          state: state.asAsyncLike(),
        ),
      ),
    );
  }
}

////

////

/// 📄 [ProfileView] — State-agnostic rendering via [AsyncLike]
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class ProfileView extends StatelessWidget {
  ///------------------------------------------
  const ProfileView({required this.state, super.key});

  ///
  final AsyncLike<UserEntity> state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _ProfileAppBar(),

      ///
      body: state.when(
        /// ⏳ Loading
        loading: () => const AppLoader(),

        /// ✅ Data
        data: (u) => _UserProfileCard(user: u),

        /// 🧨 Error — handled by overlay listener (silent here)
        error: (_) => const SizedBox.shrink(),
      ),
    );
  }
}
