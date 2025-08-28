import 'package:bloc_adapter/base_modules/overlays_module/overlay_activity_port_bloc.dart';
import 'package:bloc_adapter/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/di/core/di_module_interface.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/theme_module.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show setGlobalOverlayDispatcherResolver, setOverlayDispatcherResolver;

///
final class OverlaysModule implements DIModule {
  ///------------------------------------
  //
  @override
  String get name => 'OverlaysModule';

  ///
  @override
  List<Type> get dependencies => const [ThemeModule];

  ///
  @override
  Future<void> register() async {
    di
      ..registerLazySingleton(OverlayStatusCubit.new)
      ..registerLazySingleton(
        () => OverlayDispatcher(
          activityPort: BlocOverlayActivityPort(di<OverlayStatusCubit>()),
        ),
      );

    // 🔌 Wire CORE resolvers (і контекстний, і глобальний можуть повертати один і той же інстанс)
    setOverlayDispatcherResolver((_) => di<OverlayDispatcher>());
    setGlobalOverlayDispatcherResolver(di.call);
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
