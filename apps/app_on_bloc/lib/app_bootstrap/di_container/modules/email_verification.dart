import 'package:app_on_bloc/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:app_on_bloc/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show DIModule, SafeDispose, SafeRegistration, di;
import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:features/email_verification/data/email_verification_repo_impl.dart';
import 'package:features/email_verification/data/remote_database_contract.dart';
import 'package:features/email_verification/data/remote_database_impl.dart';
import 'package:features/email_verification/domain/email_verification_use_case.dart';
import 'package:features/email_verification/domain/repo_contract.dart';
import 'package:firebase_adapter/firebase_typedefs.dart' show FirebaseAuth;

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
