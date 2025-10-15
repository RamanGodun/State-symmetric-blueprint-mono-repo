import 'package:app_on_bloc/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:app_on_bloc/features/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show DIModule, SafeRegistration, di;
import 'package:features/features_barrels/profile/profile.dart';
import 'package:features/features_barrels/profile/profile_infra.dart';

///
final class ProfileModule implements DIModule {
  ///---------------------------------------
  //
  @override
  String get name => 'ProfileModule';

  ///
  @override
  List<Type> get dependencies => [FirebaseModule, AuthModule];
  //

  ///
  @override
  Future<void> register() async {
    //
    di
      // Repositories
      ..registerLazySingletonIfAbsent<IProfileRepo>(() => ProfileRepoImpl(di()))
      // Use Cases
      ..registerLazySingletonIfAbsent(() => FetchProfileUseCase(di()))
      // Global Profile cubit
      ..registerLazySingletonIfAbsent<ProfileCubit>(
        () => ProfileCubit(di<FetchProfileUseCase>()),
      );

    //
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
