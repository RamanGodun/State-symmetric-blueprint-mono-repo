import 'package:bloc_adapter/bloc_adapter.dart'
    show DIModule, SafeRegistration, di;
import 'package:features/features_barrels/profile/profile_infra.dart';
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
