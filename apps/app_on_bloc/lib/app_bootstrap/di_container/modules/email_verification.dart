import 'package:app_on_bloc/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:app_on_bloc/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/public_api/core.dart';
import 'package:features/features.dart';
import 'package:firebase_adapter/firebase_adapter.dart';

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
