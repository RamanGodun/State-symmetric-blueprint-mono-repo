import 'package:app_on_cubit/features/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show AppThemeCubit, AuthCubit, OverlayStatusCubit, di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart' show GoRouter;

/// 📦 [GlobalProviders] — top-level widget that wires global Blocs/Repositories
/// ✅ Ensures app-wide singletons are available via context
/// ✅ Keeps global dependencies consistent with DI container
//
final class GlobalProviders extends StatelessWidget {
  ///---------------------------------------------
  const GlobalProviders({required this.child, super.key});

  /// Wrapped subtree (usually the app shell)
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// 🎨 Global theme state
        BlocProvider.value(value: di<AppThemeCubit>()),

        /// 📤 Overlay activity state
        BlocProvider.value(value: di<OverlayStatusCubit>()),

        /// 🔐 Authentication state
        BlocProvider.value(value: di<AuthCubit>()),

        /// 👤 Profile state
        BlocProvider.value(value: di<ProfileCubit>()),

        /// 🧭 Navigation — inject GoRouter into context
        /// Allows `context.read<GoRouter>()` across the tree
        RepositoryProvider<GoRouter>.value(value: di<GoRouter>()),

        // ➕ Additional providers can be added here...
      ],

      ///
      child: child,
    );
  }
}
