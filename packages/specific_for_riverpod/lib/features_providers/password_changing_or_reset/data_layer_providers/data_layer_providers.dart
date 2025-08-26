import 'package:features/password_changing_or_reset/data/password_actions_repo_impl.dart';
import 'package:features/password_changing_or_reset/data/remote_database_contract.dart';
import 'package:features/password_changing_or_reset/data/remote_database_impl.dart';
import 'package:features/password_changing_or_reset/domain/repo_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/auth/firebase_providers.dart'
    show firebaseAuthProvider;

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
