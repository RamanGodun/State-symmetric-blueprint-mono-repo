import 'package:blueprint_on_qubit/core/base_moduls/di_container/core/di_module_interface.dart';
import 'package:blueprint_on_qubit/core/base_moduls/di_container/di_container_init.dart'
    show di;
import 'package:blueprint_on_qubit/core/base_moduls/di_container/modules/auth_module.dart';
import 'package:blueprint_on_qubit/core/base_moduls/di_container/modules/firebase_module.dart';
import 'package:blueprint_on_qubit/core/base_moduls/di_container/x_on_get_it.dart';
import 'package:blueprint_on_qubit/features/email_verification/data/email_verification_repo_impl.dart';
import 'package:blueprint_on_qubit/features/email_verification/data/remote_database_contract.dart';
import 'package:blueprint_on_qubit/features/email_verification/data/remote_database_impl.dart';
import 'package:blueprint_on_qubit/features/email_verification/domain/email_verification_use_case.dart';
import 'package:blueprint_on_qubit/features/email_verification/domain/repo_contract.dart';
import 'package:blueprint_on_qubit/features/email_verification/presentation/email_verification_cubit/email_verification_cubit.dart';
import 'package:blueprint_on_qubit/user_auth_cubit/auth_cubit.dart';

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
        IUserValidationRemoteDataSourceImpl.new,
      )
      /// Repositories
      ..registerFactoryIfAbsent<IUserValidationRepo>(
        () => IUserValidationRepoImpl(di()),
      )
      /// Usecases
      ..registerFactoryIfAbsent(() => EmailVerificationUseCase(di()))
      /// Email Verification Cubit
      ..registerFactoryIfAbsent<EmailVerificationCubit>(
        () => EmailVerificationCubit(
          di<EmailVerificationUseCase>(),
          di<AuthCubit>(),
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
