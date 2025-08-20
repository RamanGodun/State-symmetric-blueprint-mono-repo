import 'package:blueprint_on_riverpod/features/email_verification/data/email_verification_repo_impl.dart';
import 'package:blueprint_on_riverpod/features/email_verification/data/remote_database_contract.dart';
import 'package:blueprint_on_riverpod/features/email_verification/data/remote_database_impl.dart';
import 'package:blueprint_on_riverpod/features/email_verification/domain/repo_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_layer_providers.g.dart';

/// 📦 [emailVerificationRepoProvider] — provides validated domain repo
/// 🔁 Combines error mapping with remote data source delegation
//
@riverpod
IUserValidationRepo emailVerificationRepo(Ref ref) {
  final remote = ref.watch(userValidationRemoteDataSourceProvider);
  return IUserValidationRepoImpl(remote);
}

/// 🛰️ [userValidationRemoteDataSourceProvider] — provides Firebase-based remote source
//
@riverpod
IUserValidationRemoteDataSource userValidationRemoteDataSource(Ref ref) =>
    IUserValidationRemoteDataSourceImpl();
