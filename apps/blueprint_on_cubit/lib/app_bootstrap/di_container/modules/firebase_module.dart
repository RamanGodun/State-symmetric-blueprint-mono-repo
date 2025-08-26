import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/di/core/di_module_interface.dart';
import 'package:bloc_adapter/di/x_on_get_it.dart';
import 'package:features/profile/data/remote_database_contract.dart';
import 'package:features/profile/data/remote_database_impl.dart';
import 'package:firebase_adapter/constants/firebase_constants.dart';
import 'package:firebase_adapter/firebase_typedefs.dart'
    show FirebaseAuth, UsersCollection;

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
