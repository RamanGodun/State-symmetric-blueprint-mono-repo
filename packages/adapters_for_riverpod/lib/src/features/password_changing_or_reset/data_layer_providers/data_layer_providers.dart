import 'package:adapters_for_riverpod/src/features/auth/for_firebase/firebase_providers.dart'
    show firebaseAuthProvider;
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset.dart'
    show IPasswordRepo;
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset_infra.dart'
    show IPasswordRemoteDatabase, PasswordRemoteDatabaseImpl, PasswordRepoImpl;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_layer_providers.g.dart';

/// 🔌 [passwordRemoteDatabaseProvider] — low-level remote access (FirebaseAuth injected)
/// ⛓️ Keeps `features` backend-agnostic.
//
@riverpod
IPasswordRemoteDatabase passwordRemoteDatabase(Ref ref) =>
    PasswordRemoteDatabaseImpl(ref.watch(firebaseAuthProvider));

/// 🧩 [passwordRepoProvider] — adds failure mapping and domain boundary
//
@riverpod
IPasswordRepo passwordRepo(Ref ref) =>
    PasswordRepoImpl(ref.watch(passwordRemoteDatabaseProvider));
