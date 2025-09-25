import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_widgets.dart'
    show SignOutIconButton;
import 'package:app_on_riverpod/features_presentation/profile/providers/profile_page_provider.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] - Entry point for profile feature
/// ✅ State-agnostic UI via [_ProfileScreen] + [AsyncStateView]
/// ✅ `AsyncValue<T>` adapted to `AsyncStateView<T>`
/// ✅  Top-level error listeners (SignOut + Profile) are centralized
//
final class ProfilePage extends ConsumerWidget {
  ///----------------------------------
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 👀🖼️ Declarative UI bound to [profileProvider(uid)]
    final asyncUser = ref.watch<AsyncValue<UserEntity>>(profileProvider);

    /// 🔌 Adapter: `AsyncValue<UserEntity>` → `AsyncStateView<UserEntity>` (for state-agnostic UI)
    final profileViewState = asyncUser.asRiverpodAsyncStateView();

    /// ⛑️ Centralized (SignOut + Profile) one-shot error handling via overlays
    ///    - OverlayDispatcher resolves conflicts/priority internally
    return ErrorsListenerForAppOnRiverpod(
      providers: [
        signOutProvider, // ⛑️ catch signOut errors
        profileProvider, // ⛑️ catch profile fetch errors
      ],
      //
      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: _ProfileScreen(state: profileViewState),
    );
  }
}

////
////

/// 📄 [_ProfileScreen] — State-agnostic rendering via [AsyncStateView]
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ProfileScreen extends StatelessWidget {
  ///--------------------------------------------
  const _ProfileScreen({required this.state});
  //
  final AsyncStateView<UserEntity> state;

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: const _ProfileAppBar(),
      //
      body: state.when(
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
