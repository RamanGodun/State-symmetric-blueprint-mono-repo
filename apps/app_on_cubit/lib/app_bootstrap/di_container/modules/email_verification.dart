import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show DIModule, SafeDispose, SafeRegistration, di;
import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/auth_module.dart'
    show AuthModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart'
    show FirebaseModule, kFbAuthInstance;
import 'package:app_on_cubit/features/email_verification/email_verification_cubit/email_verification_cubit.dart'
    show EmailVerificationCubit;
import 'package:features_dd_layers/public_api/email_verification/email_verification.dart'
    show EmailVerificationUseCase, IUserValidationRepo;
import 'package:features_dd_layers/public_api/email_verification/email_verification_infra.dart'
    show
        IUserValidationRemoteDataSource,
        IUserValidationRemoteDataSourceImpl,
        IUserValidationRepoImpl;
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthGateway;

///
final class EmailVerificationModule implements DIModule {
  ///-------------------------------------------------
  //
  @override
  String get name => 'EmailVerificationModule';

  ///
  @override
  List<Type> get dependencies => [FirebaseModule, AuthModule];

  ///
  @override
  Future<void> register() async {
    //
    /// Data sources
    di
      ..registerFactoryIfAbsent<IUserValidationRemoteDataSource>(
        () => IUserValidationRemoteDataSourceImpl(
          di<FirebaseAuth>(instanceName: kFbAuthInstance),
        ),
      )
      /// Repositories
      ..registerFactoryIfAbsent<IUserValidationRepo>(
        () => IUserValidationRepoImpl(di()),
      )
      /// Usecases
      ..registerFactoryIfAbsent(
        () => EmailVerificationUseCase(
          di<IUserValidationRepo>(),
          di<AuthGateway>(),
        ),
      )
      /// Email Verification cubit
      ..registerFactoryIfAbsent<EmailVerificationCubit>(
        () => EmailVerificationCubit(
          di<EmailVerificationUseCase>(),
          di<AuthGateway>(),
        ),
      );

    //
  }

  ///
  @override
  Future<void> dispose() async {
    await di.safeDispose<EmailVerificationCubit>();
  }

  //
}
