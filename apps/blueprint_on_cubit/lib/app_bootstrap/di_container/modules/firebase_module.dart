import 'package:features/profile/data/remote_database_contract.dart';
import 'package:features/profile/data/remote_database_impl.dart';
import 'package:firebase_bootstrap_config/firebase_config/firebase_constants.dart';
import 'package:firebase_bootstrap_config/firebase_types.dart'
    show FirebaseAuth, UsersCollection;
import 'package:specific_for_bloc/di_container_on_get_it/core/di.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di_module_interface.dart';
import 'package:specific_for_bloc/di_container_on_get_it/x_on_get_it.dart';

///
final class FirebaseModule implements DIModule {
  ///----------------------------------------
  //
  @override
  String get name => 'FirebaseModule';

  ///
  @override
  List<Type> get dependencies => const [];

  ///
  @override
  Future<void> register() async {
    di
      // Base instances
      ..registerLazySingletonIfAbsent<FirebaseAuth>(
        () => FirebaseConstants.fbAuthInstance,
        instanceName: kFbAuthInstance,
      )
      ..registerLazySingletonIfAbsent<UsersCollection>(
        () => FirebaseConstants.usersCollection,
        instanceName: kUsersCollection,
      )
      ///
      //
      /// 🔁 BACKEND SWITCH POINT for profile feature
      ..registerLazySingletonIfAbsent<IProfileRemoteDatabase>(
        () => ProfileRemoteDatabaseImpl(
          di<UsersCollection>(instanceName: kUsersCollection),
          di<FirebaseAuth>(instanceName: kFbAuthInstance),
        ),
      );
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}

////

/// 🔑 DI key for FirebaseAuth instance
const kFbAuthInstance = 'fbAuth';

////

/// 🔑 DI key for Firestore users collection
const kUsersCollection = 'usersCollection';
