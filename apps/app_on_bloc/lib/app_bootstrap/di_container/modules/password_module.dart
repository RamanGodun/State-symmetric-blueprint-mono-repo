import 'package:app_on_bloc/app_bootstrap/di_container/modules/firebase_module.dart'
    show FirebaseModule, kFbAuthInstance;
import 'package:bloc_adapter/bloc_adapter.dart'
    show DIModule, SafeRegistration, di;
import 'package:features/password_changing_or_reset/data/password_actions_repo_impl.dart';
import 'package:features/password_changing_or_reset/data/remote_database_contract.dart';
import 'package:features/password_changing_or_reset/data/remote_database_impl.dart';
import 'package:features/password_changing_or_reset/domain/password_actions_use_case.dart';
import 'package:features/password_changing_or_reset/domain/repo_contract.dart';
import 'package:firebase_adapter/firebase_typedefs.dart' show FirebaseAuth;

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
