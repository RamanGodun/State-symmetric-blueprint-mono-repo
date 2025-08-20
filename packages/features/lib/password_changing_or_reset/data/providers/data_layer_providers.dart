import 'package:features/password_changing_or_reset/data/password_actions_repo_impl.dart';
import 'package:features/password_changing_or_reset/data/remote_database_contract.dart';
import 'package:features/password_changing_or_reset/data/remote_database_impl.dart';
import 'package:features/password_changing_or_reset/domain/repo_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_layer_providers.g.dart';

/// 🧩 [passwordRemoteDatabaseProvider] — provides implementation of [IPasswordRemoteDatabase]
/// ✅ Low-level data access for password-related Firebase actions
//
@riverpod
IPasswordRemoteDatabase passwordRemoteDatabase(Ref ref) =>
    PasswordRemoteDatabaseImpl();

/// 🧩 [passwordRepoProvider] — provides implementation of [IPasswordRepo]
/// 🧼 Adds failure mapping on top of remote data source
/// ✅ Used by domain layer use cases
//
@riverpod
IPasswordRepo passwordRepo(Ref ref) =>
    PasswordRepoImpl(ref.watch(passwordRemoteDatabaseProvider));
