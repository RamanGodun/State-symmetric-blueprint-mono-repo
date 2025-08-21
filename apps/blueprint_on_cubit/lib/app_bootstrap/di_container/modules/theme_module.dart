import 'package:core/base_modules/theme/theme_providers_or_cubits/theme_cubit.dart'
    show AppThemeCubit;
import 'package:core/di_container_cubit/core/di.dart' show di;
import 'package:core/di_container_cubit/core/di_module_interface.dart';
import 'package:core/di_container_cubit/x_on_get_it.dart';

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
