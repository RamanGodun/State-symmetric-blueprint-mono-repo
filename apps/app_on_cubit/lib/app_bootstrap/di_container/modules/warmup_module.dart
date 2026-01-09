import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show AuthCubit, DIModule, di;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/auth_module.dart'
    show AuthModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/profile_module.dart'
    show ProfileModule;
import 'package:app_on_cubit/app_bootstrap/warmup_controller.dart'
    show WarmupController;
import 'package:app_on_cubit/features/profile/cubit/profile_page_cubit.dart'
    show ProfileCubit;

/// 🔥 [WarmupModule] — DI module that wires the global [WarmupController].
/// ✅ Ensures profile is pre-fetched as soon as user signs in.
/// 🎯 Symmetric to Riverpod warmup provider, but for BLoC flavor.
//
final class WarmupModule implements DIModule {
  ///--------------------------------------
  @override
  String get name => 'WarmupModule';

  /// 📦 Depends on Auth & Profile modules, since it orchestrates both.
  @override
  List<Type> get dependencies => [AuthModule, ProfileModule];
  //
  WarmupController? _warmup;

  /// 🚀 Create and store warmup controller (auto-subscribes to AuthCubit).
  @override
  Future<void> register() async {
    _warmup = WarmupController(
      authCubit: di<AuthCubit>(),
      profileCubit: di<ProfileCubit>(),
    );
    di.registerSingleton<WarmupController>(_warmup!);
  }

  @override
  Future<void> dispose() async {
    // ♻️ Clean up warmup controller to avoid leaks.
    await _warmup?.dispose();
    _warmup = null;
  }

  //
}
