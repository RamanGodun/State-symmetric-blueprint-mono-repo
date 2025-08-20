import 'package:blueprint_on_qubit/core/base_moduls/di_container/core/di_module_interface.dart';
import 'package:blueprint_on_qubit/core/base_moduls/di_container/di_container_init.dart'
    show di;
import 'package:blueprint_on_qubit/core/base_moduls/di_container/modules/theme_module.dart';
import 'package:blueprint_on_qubit/core/base_moduls/di_container/x_on_get_it.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_status_cubit.dart'
    show OverlayStatusCubit;

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
