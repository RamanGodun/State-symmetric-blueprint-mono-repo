import 'package:core/utils_shared/auth/auth_snapshot.dart';

/// 🛡️ [AuthGateway] — abstraction for authentication layer
/// - Exposes real-time [AuthSnapshot] stream as single source of truth
/// - Keeps UI/business logic decoupled from concrete auth provider (Firebase/Auth0/etc)
/// - Extend in infrastructure layer (e.g. FirebaseAuthGateway)
///
abstract interface class AuthGateway {
  ///------------------------------
  /// 🌐 Continuous stream of authentication state changes
  /// - Emits [AuthLoading], [AuthFailure], or [AuthReady]
  /// - Consumed by presentation/state layers to react to auth flow
  Stream<AuthSnapshot> get snapshots$;
  //
  /// 🚪 Sign out current user (optional, depends on app needs)
  // Future<void> signOut();
  //
  /// 🔄 Refresh authentication session/tokens (optional)
  Future<void> refresh();
  //
}
