import 'package:adapters_for_riverpod/src/features/profile/data_layers_providers/data_layer_providers.dart'
    show profileRepoProvider;
import 'package:features_dd_layers/public_api/profile/profile.dart'
    show FetchProfileUseCase;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

/// 🧩 [fetchProfileUseCaseProvider] — provides [FetchProfileUseCase]
/// 🧼 Injects repository dependency from data layer
//
// ignore: avoid_redundant_argument_values
@Riverpod(keepAlive: false)
FetchProfileUseCase fetchProfileUseCase(Ref ref) {
  ///-----------------------------------------
  //
  final repo = ref.watch(profileRepoProvider);
  return FetchProfileUseCase(repo);
  //
}
