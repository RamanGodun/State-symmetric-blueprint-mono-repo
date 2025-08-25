import 'package:features/email_verification/data/providers/data_layer_providers.dart';
import 'package:features/email_verification/domain/email_verification_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/riverpod_specific/auth_stream_adapter.dart';

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
