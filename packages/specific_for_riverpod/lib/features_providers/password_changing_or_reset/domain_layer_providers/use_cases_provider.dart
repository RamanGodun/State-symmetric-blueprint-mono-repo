import 'package:features/password_changing_or_reset/domain/password_actions_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/features_providers/password_changing_or_reset/data_layer_providers/data_layer_providers.dart';

part 'use_cases_provider.g.dart';

/// 🧩 [passwordUseCasesProvider] — provides instance of [PasswordRelatedUseCases]
/// 🧼 Depends on [passwordRepoProvider] for implementation
//
@riverpod
PasswordRelatedUseCases passwordUseCases(Ref ref) {
  ///─────------------------------------------------
  //
  final repo = ref.watch(passwordRepoProvider);
  return PasswordRelatedUseCases(repo);
  //
}
