import 'dart:async' show Future, FutureOr;

import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show Either, EitherGetters, Failure;

/// 🚦 [ResultNavigationExt] — Provides `.redirectIfSuccess()` for sync and async results
/// ✅ Helps trigger side effects like navigation in success flow
//
extension ResultNavigationExt<T> on Either<Failure, T> {
  ///---------------------------------------------------
  //
  // 🔁 Runs callback if result is success (e.g. for redirect/navigation)
  Either<Failure, T> redirectIfSuccess(void Function(T value) navigator) {
    final value = rightOrNull;
    if (value != null) navigator(value);
    return this;
  }
}

////
////

extension ResultFutureNavigationExt<T> on Future<Either<Failure, T>> {
  ///-------------------------------------------------------------
  //
  // 🔁 Awaits result and runs [navigator] if success
  Future<Either<Failure, T>> redirectIfSuccess(
    FutureOr<void> Function(T value) navigator,
  ) async {
    final result = await this;
    final value = result.rightOrNull;
    if (value != null) await navigator(value);
    return result;
  }
}
