import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show signInRepoProvider, signOutRepoProvider, signUpRepoProvider;
import 'package:features_dd_layers/public_api/auth/auth.dart'
    show SignInUseCase, SignOutUseCase, SignUpUseCase;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_cases_providers.g.dart';

/// 🧩 [signInUseCaseProvider] — provides instance of [SignInUseCase]
/// 🧼 Depends on [signInRepoProvider] to inject repository
//
@Riverpod()
SignInUseCase signInUseCase(Ref ref) {
  final repo = ref.watch(signInRepoProvider);
  return SignInUseCase(repo);
}

////

////
/// 🧩 Provides [SignOutUseCase] via injected repo
//
@Riverpod()
SignOutUseCase signOutUseCase(Ref ref) {
  final repo = ref.watch(signOutRepoProvider);
  return SignOutUseCase(repo);
}

////

////

/// 🧩 Provides [SignUpUseCase] via injected repo
//
@riverpod
SignUpUseCase signUpUseCase(Ref ref) {
  final repo = ref.watch(signUpRepoProvider);
  return SignUpUseCase(repo);
}
