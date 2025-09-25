import 'dart:async';

import 'package:core/core.dart';
import 'package:features/features.dart' show EmailVerificationUseCase;
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_provider.g.dart';

@riverpod
final class EmailVerificationNotifier extends _$EmailVerificationNotifier
    with SafeAsyncState<void> {
  late final EmailVerificationUseCase _useCase;
  late final VerificationPoller _poller;

  bool _started = false;

  @override
  FutureOr<void> build() {
    _useCase = ref.read(emailVerificationUseCaseProvider);
    _poller = VerificationPoller(
      interval: AppDurations.sec3,
      timeout: AppDurations.min1,
    );

    initSafe();
    ref.onDispose(_poller.cancel);

    if (!_started) {
      _started = true;

      state = const AsyncLoading();

      // fire-and-forget
      unawaited(_useCase.sendVerificationEmail());

      _poller.start(
        onLoadingTick: () {
          if (isAlive) state = const AsyncLoading();
        },
        onTimeout: () {
          if (!isAlive) return;
          final timeoutFailure = const Failure(
            type: EmailVerificationTimeoutFailureType(),
          )..log(StackTrace.current);
          state = AsyncError(timeoutFailure, StackTrace.current);
        },
        check: () async {
          final result = await _useCase.checkIfEmailVerified();
          return result.fold((_) => false, (v) => v);
        },
        onVerified: () async {
          if (!isAlive) return;
          await _useCase.reloadUser();

          final gateway = ref.read(authGatewayProvider);
          await gateway.refresh();

          debugPrint(
            '🔁 After reload + refresh: emailVerified=${FirebaseRefs.auth.currentUser?.emailVerified}',
          );

          if (isAlive) state = const AsyncData(null);
        },
      );
    }
  }
}
