import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show DIModule, SafeRegistration, di;
import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart'
    show FirebaseModule, kFbAuthInstance;
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset.dart'
    show IPasswordRepo, PasswordRelatedUseCases;
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset_infra.dart'
    show IPasswordRemoteDatabase, PasswordRemoteDatabaseImpl, PasswordRepoImpl;

/// 🔐 [PasswordModule] — Registers dependencies for password-related features
/// ⛓️ Depends on [FirebaseModule] to get `FirebaseAuth` instance via DI.
/// ✅ Remote DB → Repo → UseCases
//
final class PasswordModule implements DIModule {
  ///----------------------------------------
  //
  @override
  String get name => 'PasswordModule';

  ///
  @override
  List<Type> get dependencies => const [];

  ///
  @override
  Future<void> register() async {
    //
    di
      // 📡 Remote Database (inject FirebaseAuth from DI)
      ..registerFactoryIfAbsent<IPasswordRemoteDatabase>(
        () => PasswordRemoteDatabaseImpl(
          di<FirebaseAuth>(instanceName: kFbAuthInstance),
        ),
      )
      // 📦 Repository
      ..registerFactoryIfAbsent<IPasswordRepo>(
        () => PasswordRepoImpl(di()),
      )
      // 🧠 Use Cases
      ..registerFactoryIfAbsent(
        () => PasswordRelatedUseCases(di()),
      );
  }

  /// 🧼 Clean-up (not used yet, placeholder)
  @override
  Future<void> dispose() async {
    // No disposable resources for PasswordModule yet
  }

  //
}
