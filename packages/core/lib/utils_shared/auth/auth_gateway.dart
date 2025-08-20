import 'package:core/utils_shared/auth/auth_snapshot.dart';

///
abstract interface class AuthGateway {
  /// Єдине джерело істини по автентифікації
  Stream<AuthSnapshot> get snapshots$;

  // Додатково за потреби:
  // Future<void> signOut();
  ///
  // Future<void> refresh();

  //
}
