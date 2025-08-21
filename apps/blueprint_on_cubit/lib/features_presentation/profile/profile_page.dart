import 'package:blueprint_on_cubit/core/base_moduls/navigation/routes/app_routes.dart';
import 'package:blueprint_on_cubit/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:blueprint_on_cubit/features_presentation/auth/sign_out/sign_out_widget.dart';
import 'package:blueprint_on_cubit/features_presentation/profile/cubit/profile_page_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:core/base_modules/errors_handling/core_of_module/failure_ui_mapper.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart';
import 'package:core/base_modules/localization/module_widgets/language_toggle_button/toggle_button.dart';
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart';
import 'package:core/base_modules/theme/widgets_and_utils/blur_wrapper.dart';
import 'package:core/base_modules/theme/widgets_and_utils/theme_toggle_widgets/theme_picker.dart';
import 'package:core/base_modules/theme/widgets_and_utils/theme_toggle_widgets/theme_toggler.dart';
import 'package:core/di_container_cubit/core/di.dart' show di;
import 'package:core/shared_domain_layer/shared_entities/_user_entity.dart';
import 'package:core/shared_presentation_layer/shared_widgets/app_bar.dart';
import 'package:core/shared_presentation_layer/shared_widgets/buttons/filled_button.dart';
import 'package:core/shared_presentation_layer/shared_widgets/key_value_text_widget.dart';
import 'package:core/shared_presentation_layer/shared_widgets/loader.dart';
import 'package:core/utils_shared/bloc_specific/user_auth_cubit/auth_stream_adapter.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:core/utils_shared/spider/app_images_paths.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] — Shows user profile details and allows sign-out
/// ✅ Uses [AuthCubit] to obtain UID and loads profile via [Profilecubit]
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

    // щоб не тригерити loadProfile на кожен rebuild:
    final profilecubit = context.read<Profilecubit>();
    if (profilecubit.state is! ProfileLoaded) {
      profilecubit.loadProfile(uid);
    }

    /// 🧩♻️ Injects [Profilecubit] and [SignOutcubit] with DI and loads profile on init
    return BlocProvider<SignOutCubit>(
      create: (_) => di<SignOutCubit>(),

      /// Bloc listener for one-shot error feedback.
      /// Uses `Consumable<FailureUIModel>` for single-use error overlays.
      child: BlocListener<Profilecubit, ProfileState>(
        listenWhen: (prev, curr) =>
            prev is! ProfileError && curr is ProfileError,

        /// 📣 Show error once and reset failure
        listener: (context, state) {
          if (state is ProfileError) {
            final failure = state.failure.consume();
            if (failure != null) {
              final failureUIEntity = failure.toUIEntity();
              context.showError(failureUIEntity);
              context.read<Profilecubit>().clearFailure();
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
/// ✅ Reacts to [Profilecubit] and shows appropriate UI
//
final class ProfileView extends StatelessWidget {
  ///------------------------------------------
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: const _ProfileAppBar(),

      body: BlocBuilder<Profilecubit, ProfileState>(
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
