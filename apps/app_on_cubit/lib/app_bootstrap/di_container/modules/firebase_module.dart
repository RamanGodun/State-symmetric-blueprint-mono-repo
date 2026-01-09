import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show DIModule, SafeRegistration, di;
import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth, FirebaseRefs, UsersCollection;
import 'package:features_dd_layers/public_api/profile/profile_infra.dart'
    show IProfileRemoteDatabase, ProfileRemoteDatabaseImpl;

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
        () => FirebaseRefs.auth,
        instanceName: kFbAuthInstance,
      )
      ..registerLazySingletonIfAbsent<UsersCollection>(
        () => FirebaseRefs.usersCollectionRef,
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
