import 'dart:async';

import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/loggers/failure_logger_x.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/base_modules/errors_handling/core_of_module/failure_type.dart'
    show EmailVerificationTimeoutFailureType;
import 'package:core/utils_shared/timing_control/timing_config.dart'
    show AppDurations;
import 'package:features/email_verification/domain/email_verification_use_case.dart';
import 'package:firebase_adapter/constants/firebase_constants.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/features_providers/email_verification/domain_layer_providers/use_case_provider.dart';
import 'package:specific_for_riverpod/utils/safe_async_state.dart';

part 'email_verification_provider.g.dart';

/// 🧩 [emailVerificationNotifierProvider] — async notifier that handles email verification polling
/// 🧼 Sends verification email and checks if email is verified via Firebase
//
@riverpod
final class EmailVerificationNotifier extends _$EmailVerificationNotifier
    with SafeAsyncState<void> {
  ///-------------------------------------------------------------

  Timer? _timer;
  static const Duration _maxPollingDuration = AppDurations.min1;
  final Stopwatch _stopwatch = Stopwatch();
  late final EmailVerificationUseCase _emailVerificationUseCase;

  /// 🧱 Initializes verification logic
  @override
  FutureOr<void> build() {
    _emailVerificationUseCase = ref.read(emailVerificationUseCaseProvider);
    initSafe();
    debugPrint('VerificationNotifier: build() called...');

    unawaited(_emailVerificationUseCase.sendVerificationEmail());
    _startPolling();

    ref.onDispose(() => _timer?.cancel());
  }

  /// 🔁 Periodic email check every 5 seconds
  void _startPolling() {
    //
    _stopwatch.start();
    _timer = Timer.periodic(AppDurations.sec3, (_) {
      if (_stopwatch.elapsed > _maxPollingDuration) {
        _timer?.cancel();
        debugPrint('Polling timed out after 1 minute');

        final timeoutFailure = const Failure(
          type: EmailVerificationTimeoutFailureType(),
          message: 'Polling timed out after 1 minute',
        )..log(StackTrace.current);

        state = AsyncError(timeoutFailure, StackTrace.current);

        return;
      }
      _checkEmailVerified();
    });
    //
  }

  /// ✅ Checks if email is verified and cancels timer
  Future<void> _checkEmailVerified() async {
    debugPrint(
      'EmailVerificationNotifier: checking email verification status...',
    );
    final result = await _emailVerificationUseCase.checkIfEmailVerified();
    await result.fold((_) => null, (isVerified) async {
      if (isVerified) {
        _timer?.cancel();

        await _emailVerificationUseCase.reloadUser();

        final refreshed = FirebaseConstants.fbAuthInstance.currentUser;
        debugPrint(
          '🔁 After reload: emailVerified=${refreshed?.emailVerified}',
        );

        state = const AsyncData(null);
      }
    });
  }

  //
}
