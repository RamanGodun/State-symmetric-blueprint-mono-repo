import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show AuthCubit, DIModule, SafeRegistration, di;
import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth, FirebaseAuthGateway, UsersCollection;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart'
    show FirebaseModule, kFbAuthInstance, kUsersCollection;
import 'package:app_on_cubit/features/auth/sign_out/sign_out_cubit/sign_out_cubit.dart'
    show SignOutCubit;
import 'package:features_dd_layers/public_api/auth/auth.dart'
    show
        ISignInRepo,
        ISignOutRepo,
        ISignUpRepo,
        SignInUseCase,
        SignOutUseCase,
        SignUpUseCase;
import 'package:features_dd_layers/public_api/auth/auth_infra.dart'
    show
        AuthRemoteDatabaseImpl,
        IAuthRemoteDatabase,
        SignInRepoImpl,
        SignOutRepoImpl,
        SignUpRepoImpl;
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthGateway;

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
