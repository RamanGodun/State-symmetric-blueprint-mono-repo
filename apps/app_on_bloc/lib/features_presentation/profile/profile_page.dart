import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart'
    show SignOutCubit;
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_widget.dart'
    show SignOutIconButton;
import 'package:app_on_bloc/features_presentation/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show AuthCubit, AuthViewReady, ThemePicker, ThemeTogglerIcon, di;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:core/base_modules/errors_management.dart';
import 'package:core/base_modules/localization.dart'
    show LanguageToggleButton, LocaleKeys, TextType, TextWidget;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/overlays.dart';
import 'package:core/base_modules/ui_design.dart'
    show AppSpacing, BlurContainer;
import 'package:core/shared_layers/domain.dart' show UserEntity;
import 'package:core/shared_layers/presentation.dart'
    show AppLoader, CustomAppBar, CustomFilledButton, KeyValueTextWidget;
import 'package:core/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] — Shows user profile details and allows sign-out
/// ✅ Uses [AuthCubit] to obtain UID and loads profile via [ProfileCubit]
/// ✅ Injects [SignOutCubit] to trigger logout
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
    // 🛑 Guard: If user is not available, return empty widget
    if (uid == null) return const SizedBox.shrink();

    // to avoid loadProfile triggering on each rebuild:
    final profileCubit = context.read<ProfileCubit>();
    if (profileCubit.state is! ProfileLoaded) {
      profileCubit.loadProfile(uid);
    }

    /// 🧩♻️ Injects [ProfileCubit] and [SignOutCubit] with DI and loads profile on init
    return BlocProvider<SignOutCubit>(
      create: (_) => di<SignOutCubit>(),

      /// Bloc listener for one-shot error feedback.
      /// Uses `Consumable<FailureUIModel>` for single-use error overlays.
      child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) =>
            prev is! ProfileError && curr is ProfileError,

        /// 📣 Show error once and reset failure
        listener: (context, state) {
          if (state is ProfileError) {
            final failure = state.failure.consume();
            if (failure != null) {
              final failureUIEntity = failure.toUIEntity();
              context.showError(failureUIEntity);
              context.read<ProfileCubit>().clearFailure();
            }
          }
        },

        ///
        child: const ProfileView(),
      ),
    );
  }
}

////

////

/// 📄 [ProfileView] — Handles state for loading, error, and loaded profile states
/// ✅ Reacts to [ProfileCubit] and shows appropriate UI
//
final class ProfileView extends StatelessWidget {
  ///------------------------------------------
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: const _ProfileAppBar(),

      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileInitial() => const SizedBox.shrink(),
          ProfileLoaded(:final user) => _UserProfileCard(user: user),

          ProfileLoading() =>
            const AppLoader(), // Show loader while data is loading

          ProfileError() =>
            const SizedBox.shrink(), // Show nothing, as overlay handles errors
        },
      ),
    );
  }
}
