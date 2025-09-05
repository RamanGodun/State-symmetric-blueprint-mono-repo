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
import 'package:riverpod_adapter/features_providers/email_verification/domain_layer_providers/use_case_provider.dart';
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart'
    show authGatewayProvider;
import 'package:riverpod_adapter/utils/safe_async_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_provider.g.dart';

/// 🧩 [EmailVerificationNotifier] — керує відправкою + polling верифікації пошти
/// ✅ Після підтвердження виконує reload + gateway.refresh() → миттєвий редірект
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

    // ✉️ Одразу шлемо лист та стартуємо polling
    unawaited(_emailVerificationUseCase.sendVerificationEmail());
    _startPolling();

    ref.onDispose(() => _timer?.cancel());
  }

  /// 🔁 Перевірка кожні 3 секунди (до 1 хв)
  void _startPolling() {
    _stopwatch.start();
    _timer = Timer.periodic(AppDurations.sec3, (_) {
      if (_stopwatch.elapsed > _maxPollingDuration) {
        _timer?.cancel();
        final timeoutFailure = const Failure(
          type: EmailVerificationTimeoutFailureType(),
          message: 'Polling timed out after 1 minute',
        )..log(StackTrace.current);
        state = AsyncError(timeoutFailure, StackTrace.current);
        return;
      }
      _checkEmailVerified();
    });
  }

  /// ✅ Коли e-mail підтверджено — робимо reload + gateway.refresh()
  Future<void> _checkEmailVerified() async {
    debugPrint('EmailVerificationNotifier: checking email verification…');
    final result = await _emailVerificationUseCase.checkIfEmailVerified();

    await result.fold((_) => null, (isVerified) async {
      if (!isVerified) return;

      _timer?.cancel();

      // 1) Перечитати юзера з Firebase
      await _emailVerificationUseCase.reloadUser();

      // 2) Синхронно “стукнути” у gateway, щоб GoRouter негайно оновився
      final gateway = ref.read(authGatewayProvider);
      await gateway.refresh();

      final refreshed = FirebaseConstants.fbAuthInstance.currentUser;
      debugPrint(
        '🔁 After reload + refresh: emailVerified=${refreshed?.emailVerified}',
      );

      // 3) Завершити нотифайер “успіхом”
      state = const AsyncData(null);
    });
  }

  //
}
