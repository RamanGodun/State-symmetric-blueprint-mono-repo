import 'package:bloc_adapter/bloc_adapter.dart'
    show AppThemeCubit, DIModule, SafeRegistration, di;

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
