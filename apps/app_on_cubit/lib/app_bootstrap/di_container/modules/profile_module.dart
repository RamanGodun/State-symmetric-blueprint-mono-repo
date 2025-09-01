import 'package:app_on_cubit/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:app_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:app_on_cubit/features_presentation/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/di/core/di_module_interface.dart';
import 'package:bloc_adapter/di/x_on_get_it.dart';
import 'package:features/profile/data/implementation_of_profile_fetch_repo.dart';
import 'package:features/profile/domain/fetch_profile_use_case.dart';
import 'package:features/profile/domain/repo_contract.dart';

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
