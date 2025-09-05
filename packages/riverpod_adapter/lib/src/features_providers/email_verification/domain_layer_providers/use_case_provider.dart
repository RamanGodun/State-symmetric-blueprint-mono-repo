import 'package:features/features.dart' show EmailVerificationUseCase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/features_providers/email_verification/data_layer_providers/data_layer_providers.dart'
    show emailVerificationRepoProvider;
import 'package:riverpod_adapter/src/utils/auth/auth_stream_adapter.dart'
    show authGatewayProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

//packages/specific_for_riverpod/lib/riverpod_specific/auth_stream_adapter.dart

part 'use_case_provider.g.dart';

/// 🧩 [emailVerificationUseCaseProvider] — provides [EmailVerificationUseCase]
//
@riverpod
EmailVerificationUseCase emailVerificationUseCase(Ref ref) {
  ///---------------------------------------------------
  //
  final repo = ref.watch(emailVerificationRepoProvider);
  final gateway = ref.watch(authGatewayProvider);
  return EmailVerificationUseCase(repo, gateway);
  //
}
