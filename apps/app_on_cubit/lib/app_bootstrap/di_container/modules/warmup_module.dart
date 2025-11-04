import 'package:app_on_cubit/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:app_on_cubit/app_bootstrap/di_container/modules/profile_module.dart';
import 'package:app_on_cubit/core/shared_presentation/utils/warmup_controller.dart';
import 'package:app_on_cubit/features/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart' show AuthCubit, DIModule, di;

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
