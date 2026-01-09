import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show authGatewayProvider, emailVerificationRepoProvider;
import 'package:features_dd_layers/public_api/email_verification/email_verification.dart'
    show EmailVerificationUseCase;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
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
