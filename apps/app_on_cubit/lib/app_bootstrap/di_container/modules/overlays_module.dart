import 'package:app_on_cubit/app_bootstrap/di_container/modules/theme_module.dart';
import 'package:bloc_adapter/base_modules/overlays_module/overlay_activity_port_bloc.dart';
import 'package:bloc_adapter/base_modules/overlays_module/overlay_resolver_wiring.dart';
import 'package:bloc_adapter/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/di/core/di_module_interface.dart';
import 'package:bloc_adapter/di/x_on_get_it.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher;

/// 📤 [OverlaysModule] — wires overlay system into DI
/// ✅ Registers overlay state + dispatcher
/// ✅ Provides global & context-aware resolvers for overlays
//
final class OverlaysModule implements DIModule {
  ///----------------------------------------
  @override
  String get name => 'OverlaysModule';

  @override
  List<Type> get dependencies => const [ThemeModule];

  @override
  Future<void> register() async {
    di
      // 🧠 Overlay activity state (Cubit)
      ..registerLazySingletonIfAbsent<OverlayStatusCubit>(
        OverlayStatusCubit.new,
      )
      // 📤 Dispatcher with Bloc-based activity port
      ..registerLazySingletonIfAbsent<OverlayDispatcher>(() {
        final status = di<OverlayStatusCubit>();
        return OverlayDispatcher(activityPort: BlocOverlayActivityPort(status));
      });

    // 🔌 Wire resolvers (currently both):
    //    - Context-aware resolver (BuildContext)
    //    - Global context-agnostic resolver (background tasks, infra)
    OverlayResolverWiringBloc.wire(
      container: di,
      // scope: OverlayWiringScope.both, // (optional) make it explicit
    );
    //
  }

  @override
  Future<void> dispose() async {
    // ♻️ Properly dispose status cubit on teardown
    await di.safeDispose<OverlayStatusCubit>();
  }

  //
}
