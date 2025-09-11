import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_widgets.dart'
    show SignOutIconButton;
import 'package:app_on_riverpod/features_presentation/profile/providers/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] — profile with reactive auth-driven state
///     ✅ Top-level error listeners (SignOut + Profile)
///     ✅ State-agnostic UI ([_ProfileView]) via AsyncStateView
//
final class ProfilePage extends ConsumerWidget {
  ///----------------------------------
  const ProfilePage({super.key});
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// Get current user UID (null if not signed in)
    final uid = FirebaseRefs.auth.currentUser?.uid;

    /// 🛡️ Guard — render nothing if unauthenticated
    if (uid == null) return const SizedBox();

    final asyncUser = ref.watch<AsyncValue<UserEntity>>(profileProvider(uid));

    /// 🔌 Adapt AsyncState → AsyncStateView
    final profileViewState = asyncUser.asRiverpodAsyncStateView();

    /// ⛑️ Centralized (SignOut + Profile) one-shot error handling via overlays
    ///    - OverlayDispatcher resolves conflicts/priority internally
    return AsyncMultiErrorListenerRp(
      providers: [
        signOutProvider, // ⛑️ catch signOut errors
        profileProvider(uid), // ⛑️ catch profile fetch errors
      ],
      //
      /// 🔌 Adapt AsyncValue → AsyncLike and render shared UI (identical to same widget on app with Cubit/BLoC)
      child: _ProfileView(state: profileViewState),
    );
  }
}

////
////

/// 📄 [_ProfileView] — State-agnostic rendering via [AsyncStateView]
/// ✅ Same widget used in Cubit/BLoC app for perfect parity
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
