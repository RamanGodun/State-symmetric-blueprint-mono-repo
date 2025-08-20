import 'package:blueprint_on_qubit/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:blueprint_on_qubit/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:core/di_container_cubit/core/di.dart' show di;
import 'package:core/di_container_cubit/core/di_module_interface.dart';
import 'package:core/di_container_cubit/x_on_get_it.dart';
import 'package:core/utils_shared/bloc_specific/user_auth_cubit/auth_cubit.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_in_repo_impl.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_out_repo_impl.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_up_repo_impl.dart';
import 'package:features/auth/data/remote_database_contract.dart';
import 'package:features/auth/data/remote_database_impl.dart';
import 'package:features/auth/domain/repo_contracts.dart';
import 'package:features/auth/domain/use_cases/sign_in.dart';
import 'package:features/auth/domain/use_cases/sign_out.dart';
import 'package:features/auth/domain/use_cases/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

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
      /// AuthStreamCubit
      //
      ..registerLazySingletonIfAbsent<AuthCubit>(
        () => AuthCubit(userStream: di<FirebaseAuth>().authStateChanges()),
      )
      //
      // Sign out Cubit
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
