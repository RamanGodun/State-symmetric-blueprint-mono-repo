import 'package:specific_for_bloc/base_modules/theme/theme_cubit.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di_module_interface.dart';
import 'package:specific_for_bloc/di_container_on_get_it/x_on_get_it.dart';

/// 🎨 Registers theme cubit for loader (and later, the main app).
//
final class ThemeModule implements DIModule {
  ///-------------------------------------
  //
  @override
  String get name => 'ThemeModule';

  ///
  @override
  List<Type> get dependencies => const [];

  ///
  @override
  Future<void> register() async {
    di.registerLazySingletonIfAbsent(AppThemeCubit.new);
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
