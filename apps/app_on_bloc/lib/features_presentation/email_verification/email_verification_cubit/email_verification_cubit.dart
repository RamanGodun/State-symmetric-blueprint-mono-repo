import 'dart:async';

import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable.dart'
    show Consumable;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable_extensions.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/base_modules/errors_handling/core_of_module/failure_type.dart'
    show EmailVerificationTimeoutFailureType;
import 'package:core/utils_shared/timing_control/timing_config.dart'
    show AppDurations;
import 'package:equatable/equatable.dart';
import 'package:features/features.dart' show EmailVerificationUseCase;
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseUser;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'email_verification_state.dart';

/// Handles the email verification flow, including sending the email,
/// polling for verification, and timing out if necessary.
//
final class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  ///------------------------------------------------------------------
  EmailVerificationCubit(this._useCase)
    : super(const EmailVerificationState()) {
    // _startPolling();
  }
  //
  final EmailVerificationUseCase _useCase;
  //

  Timer? _pollingTimer;
  final Stopwatch _stopwatch = Stopwatch();
  static const Duration _maxPollingDuration = AppDurations.min1;
  bool _started = false;
  //

  /// Initializes the verification flow once (send email + start polling).
  Future<void> initVerificationFlow() async {
    if (_started) return;
    _started = true;
    await sendVerificationEmail();
    _startPolling();
  }

  /// Starts polling every 3 seconds to check if email is verified.
  /// Stops polling if verification succeeds or timeout is reached.
  void _startPolling() {
    _pollingTimer?.cancel();
    _stopwatch
      ..reset()
      ..start();
    //
    _pollingTimer = Timer.periodic(AppDurations.sec3, (_) async {
      if (_stopwatch.elapsed >= _maxPollingDuration) {
        _stopPolling();
        emit(
          state.copyWith(
            status: EmailVerificationStatus.failure,
            failure: const Failure(
              type: EmailVerificationTimeoutFailureType(),
              message: 'Timeout exceeded',
            ).asConsumable(),
          ),
        );
        return;
      }
      //
      await checkVerified();
    });
  }

  /// Stops polling and resets the stopwatch.
  void _stopPolling() {
    _pollingTimer?.cancel();
    _stopwatch.stop();
  }

  /// Checks if the user has verified their email.
  /// If verified, reloads user and stops polling.
  Future<void> checkVerified() async {
    emit(state.copyWith(status: EmailVerificationStatus.loading));
    //
    final result = await _useCase.checkIfEmailVerified();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EmailVerificationStatus.failure,
          failure: failure.asConsumable(),
        ),
      ),
      //
      (isVerified) async {
        if (isVerified) {
          await _useCase.reloadUser();
          _stopPolling();
          emit(state.copyWith(status: EmailVerificationStatus.verified));
        } else {
          emit(state.copyWith(status: EmailVerificationStatus.unverified));
        }
      },
    );
  }

  /// Sends the verification email to the user.
  Future<void> sendVerificationEmail() async {
    emit(state.copyWith(status: EmailVerificationStatus.loading));
    //
    final result = await _useCase.sendVerificationEmail();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EmailVerificationStatus.failure,
          failure: failure.asConsumable(),
        ),
      ),
      (_) => emit(state.copyWith(status: EmailVerificationStatus.resent)),
    );
  }

  /// Stops polling and disposes of the cubit.
  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }

  //
}
