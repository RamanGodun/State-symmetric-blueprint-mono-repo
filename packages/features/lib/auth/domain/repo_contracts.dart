import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;

/// 🔐 [ISignInRepo] — contract for signing in user with email/password
//
abstract interface class ISignInRepo {
  ///---------------------------------
  //
  // 🔐 Signs user in using provided credentials
  ResultFuture<void> signIn({required String email, required String password});
  //
}

////

////

/// 🔓 [ISignOutRepo] — contract for signing out the user
//
abstract interface class ISignOutRepo {
  ///----------------------------------
  //
  // 🔓 Signs out the currently authenticated user
  ResultFuture<void> signOut();
  //
}

////

////

/// 🆕 [ISignUpRepo] — contract for user registration logic
//
abstract interface class ISignUpRepo {
  ///--------------------------------
  //
  // 🆕 Creates a new user and stores additional info in Remote database
  ResultFuture<void> signup({
    required String name,
    required String email,
    required String password,
  });
  //
}
