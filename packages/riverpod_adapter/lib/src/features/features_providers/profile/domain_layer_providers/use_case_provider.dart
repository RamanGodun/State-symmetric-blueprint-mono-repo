import 'package:features/features.dart' show FetchProfileUseCase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/features/features_providers/profile/data_layers_providers/data_layer_providers.dart';
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
