import 'package:firebase_core/firebase_core.dart';

/// 🧩 [FirebaseOptionsResolver] — Strategy/contract to provide platform-specific [FirebaseOptions]
///
/// Why: keeps the bootstrap package UI-agnostic. Each app can provide its own resolver
/// (from .env, build-flavors, remote config, etc).
abstract interface class FirebaseOptionsResolver {
  /// Returns [FirebaseOptions] for the current platform.
  FirebaseOptions forCurrentPlatform();
}
