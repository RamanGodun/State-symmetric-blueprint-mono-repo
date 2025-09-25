// ignore_for_file: public_member_api_docs

import 'dart:async' show scheduleMicrotask;

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features_barrels/email_verification/email_verification.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/foundation.dart' show debugPrint;

final class EmailVerificationCubit extends CubitWithAsyncValue<void> {
  EmailVerificationCubit(this._useCase, this.gateway)
    : _poller = VerificationPoller(
        interval: AppDurations.sec3,
        timeout: AppDurations.min1,
      ),
      super() {
    scheduleMicrotask(_bootstrap);
  }

  final EmailVerificationUseCase _useCase;
  final VerificationPoller _poller;
  final AuthGateway gateway;

  bool _started = false;

  Future<void> _bootstrap() async {
    if (_started) return;
    _started = true;

    emit(const AsyncValueForBLoC.loading());

    final sent = await _useCase.sendVerificationEmail();
    sent.fold(
      (failure) => emit(AsyncValueForBLoC<void>.error(failure)),
      (_) => _startPolling(),
    );
  }

  void _startPolling() {
    _poller.start(
      onLoadingTick: () => emit(const AsyncValueForBLoC.loading()),
      onTimeout: () => emit(
        const AsyncValueForBLoC<void>.error(
          Failure(type: EmailVerificationTimeoutFailureType()),
        ),
      ),
      check: () async {
        final result = await _useCase.checkIfEmailVerified();
        return result.fold((_) => false, (v) => v);
      },
      onVerified: () async {
        await _useCase.reloadUser();

        // 🔔 ensure router refresh (симетрично Riverpod-реалізації)
        await gateway.refresh();
        debugPrint(
          '🔁 After reload + refresh: emailVerified=${FirebaseRefs.auth.currentUser?.emailVerified}',
        );

        emit(const AsyncValueForBLoC<void>.data(null));
      },
    );
  }

  @override
  Future<void> close() {
    _poller.cancel();
    return super.close();
  }
}
