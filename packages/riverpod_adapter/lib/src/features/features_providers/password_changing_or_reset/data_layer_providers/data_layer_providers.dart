import 'package:features/features_barrels/password_changing_or_reset/password_changing_or_reset.dart';
import 'package:features/features_barrels/password_changing_or_reset/password_changing_or_reset_infra.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/utils/auth/firebase_providers.dart'
    show firebaseAuthProvider;
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
