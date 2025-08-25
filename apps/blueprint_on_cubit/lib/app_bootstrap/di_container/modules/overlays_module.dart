import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/theme_module.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:specific_for_bloc/base_modules/overlays/overlay_status_cubit.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di_module_interface.dart';
import 'package:specific_for_bloc/di_container_on_get_it/x_on_get_it.dart';

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
      ..registerLazySingletonIfAbsent(OverlayStatusCubit.new)
      ..registerLazySingletonIfAbsent(
        () => OverlayDispatcher(
          onOverlayStateChanged: di<OverlayStatusCubit>().updateStatus,
        ),
      );
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
