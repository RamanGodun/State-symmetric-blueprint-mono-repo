import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:blueprint_on_cubit/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:features/email_verification/data/email_verification_repo_impl.dart';
import 'package:features/email_verification/data/remote_database_contract.dart';
import 'package:features/email_verification/data/remote_database_impl.dart';
import 'package:features/email_verification/domain/email_verification_use_case.dart';
import 'package:features/email_verification/domain/repo_contract.dart';
import 'package:firebase_bootstrap_config/firebase_types.dart'
    show FirebaseAuth;
import 'package:specific_for_bloc/di_container_on_get_it/core/di.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di_module_interface.dart';
import 'package:specific_for_bloc/di_container_on_get_it/x_on_get_it.dart';

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
      ..registerLazySingletonIfAbsent<IUserValidationRemoteDataSource>(
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
