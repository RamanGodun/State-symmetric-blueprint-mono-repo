import 'package:core/utils_shared/auth/auth_snapshot.dart'
    show AuthFailure, AuthLoading, AuthReady, AuthSnapshot;
import 'package:firebase_adapter/firebase_adapter.dart'
    show FirebaseAuthGateway;

/// 🛡️ [AuthGateway] — authentication abstraction
/// - Provides a single [AuthSnapshot] stream as the source of truth
/// - Decouples UI/business logic from specific providers (Firebase, Auth0, …)
/// - Concrete implementations live in the infrastructure layer (e.g. [FirebaseAuthGateway])
//
abstract interface class AuthGateway {
  ///------------------------------
  //
  /// 🌐 Continuous stream of authentication states:
  ///   [AuthLoading] | [AuthFailure] | [AuthReady]
  /// Consumed by the presentation layer to react to auth changes.
  Stream<AuthSnapshot> get snapshots$;

  /// 📊 Current synchronous snapshot
  /// Used inside `GoRouter.redirect` for deterministic decisions.
  AuthSnapshot get currentSnapshot;

  /// 🔄 Manual refresh (e.g., reload tokens or user session)
  Future<void> refresh();

  //
}
