import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show DIModule, SafeRegistration, di;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/auth_module.dart'
    show AuthModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart'
    show FirebaseModule;
import 'package:app_on_cubit/features/profile/cubit/profile_page_cubit.dart'
    show ProfileCubit;
import 'package:features_dd_layers/public_api/profile/profile.dart'
    show FetchProfileUseCase, IProfileRepo;
import 'package:features_dd_layers/public_api/profile/profile_infra.dart'
    show ProfileRepoImpl;

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
