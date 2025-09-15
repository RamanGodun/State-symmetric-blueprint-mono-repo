import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

/// 📦 Read-only contract for submission UI state.
//
abstract interface class FormSubmissionState {
  ///----------------------------------
  /// Current submission status (idle/inProgress/success/failure).
  FormzSubmissionStatus get status;
  //
  /// Last failure wrapped into one-shot wrapper.
  Consumable<Failure>? get failure;
}

////
////

/// 🧼 Mutating contract implemented by Cubit/Bloc.
//
abstract interface class SubmissionController {
  ///---------------------------------------
  /// Reset status back to initial.
  void resetStatus();
  //
  /// Clear stored failure (after it’s been consumed).
  void clearFailure();
}

////
////

/// Combined contract: streamable state + cleanup API.
//
abstract interface class SubmissionActor<TState extends FormSubmissionState>
    implements StateStreamable<TState>, SubmissionController {}
