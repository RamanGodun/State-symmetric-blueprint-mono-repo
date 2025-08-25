import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:blueprint_on_cubit/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_in_repo_impl.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_out_repo_impl.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_up_repo_impl.dart';
import 'package:features/auth/data/remote_database_contract.dart';
import 'package:features/auth/data/remote_database_impl.dart';
import 'package:features/auth/domain/repo_contracts.dart';
import 'package:features/auth/domain/use_cases/sign_in.dart';
import 'package:features/auth/domain/use_cases/sign_out.dart';
import 'package:features/auth/domain/use_cases/sign_up.dart';
import 'package:firebase_bootstrap_config/firebase_auth_gateway.dart';
import 'package:firebase_bootstrap_config/firebase_types.dart'
    show FirebaseAuth;
import 'package:specific_for_bloc/di_container_on_get_it/core/di.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di_module_interface.dart';
import 'package:specific_for_bloc/di_container_on_get_it/x_on_get_it.dart';
import 'package:specific_for_bloc/user_auth_cubit/auth_stream_cubit.dart';

///
final class AuthModule implements DIModule {
  ///------------------------------------
  //
  @override
  String get name => 'AuthModule';

  ///
  @override
  List<Type> get dependencies => [FirebaseModule];

  ///
  @override
  Future<void> register() async {
    //
    // Data Sources
    di
      ..registerLazySingletonIfAbsent<IAuthRemoteDatabase>(
        AuthRemoteDatabaseImpl.new,
      )
      //
      /// Repositories
      //
      ..registerFactoryIfAbsent<ISignInRepo>(() => SignInRepoImpl(di()))
      ..registerFactoryIfAbsent<ISignOutRepo>(() => SignOutRepoImpl(di()))
      ..registerLazySingletonIfAbsent<ISignUpRepo>(() => SignUpRepoImpl(di()))
      //
      /// Use Cases
      //
      ..registerFactoryIfAbsent(() => SignInUseCase(di()))
      ..registerFactoryIfAbsent(() => SignUpUseCase(di()))
      ..registerLazySingletonIfAbsent(() => SignOutUseCase(di()))
      //
      /// AuthStreamcubit
      //
      ..registerLazySingleton<AuthGateway>(
        () => FirebaseAuthGateway(
          di<FirebaseAuth>(instanceName: kFbAuthInstance),
        ),
      )
      ..registerLazySingleton<AuthCubit>(() => AuthCubit(gateway: di()))
      //
      // Sign out cubit
      //
      ..registerFactoryIfAbsent(() => SignOutCubit(di<SignOutUseCase>()));

    //
  }

  ////

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
