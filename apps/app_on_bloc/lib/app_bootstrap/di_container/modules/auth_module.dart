import 'package:app_on_bloc/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show AuthCubit, DIModule, SafeRegistration, di;
import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:features/features_barrels/auth/auth.dart';
import 'package:features/features_barrels/auth/auth_infra.dart';
import 'package:firebase_adapter/firebase_adapter.dart'
    show FirebaseAuth, FirebaseAuthGateway, UsersCollection;

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
        () => AuthRemoteDatabaseImpl(
          di<FirebaseAuth>(instanceName: kFbAuthInstance),
          di<UsersCollection>(instanceName: kUsersCollection),
        ),
      )
      //
      /// Repositories
      //
      ..registerFactoryIfAbsent<ISignInRepo>(() => SignInRepoImpl(di()))
      ..registerFactoryIfAbsent<ISignOutRepo>(() => SignOutRepoImpl(di()))
      ..registerFactoryIfAbsent<ISignUpRepo>(() => SignUpRepoImpl(di()))
      //
      /// Use Cases
      //
      ..registerFactoryIfAbsent(() => SignInUseCase(di()))
      ..registerFactoryIfAbsent(() => SignUpUseCase(di()))
      ..registerFactoryIfAbsent(() => SignOutUseCase(di()))
      //
      /// AuthStreamCubit
      //
      ..registerLazySingleton<AuthGateway>(
        () => FirebaseAuthGateway(
          di<FirebaseAuth>(instanceName: kFbAuthInstance),
        ),
      )
      ..registerLazySingletonIfAbsent<AuthCubit>(
        () => AuthCubit(gateway: di<AuthGateway>()),
      )
      //
      //
      /// Sign out cubit, injects AuthGateway (stream → states)
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
