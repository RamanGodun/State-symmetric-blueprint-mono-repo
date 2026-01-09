part of 'result_logger_x.dart';

/// [FutureResultLoggerExt] — Extension for logging [Either] async results.
/// 🪵 Logs failures, 📈 logs successes, 📊 tracks events declaratively.
//
extension FutureResultLoggerExt<T> on Future<Either<Failure, T>> {
  ///---------------------------------------------------------

  /// 🪵 Logs failure if result is Left
  Future<Either<Failure, T>> log([StackTrace? stack]) async {
    final result = await this;
    if (result.isLeft) ErrorsLogger.failure(result.leftOrNull!, stack);
    return result;
  }

  /// 📈 Logs success value to console if result is Right
  Future<Either<Failure, T>> logSuccess([String? tag]) async {
    final result = await this;
    if (result.isRight) {
      final resolved = tag ?? 'Success';
      debugPrint('[SUCCESS][$resolved] ${result.rightOrNull}');
    }
    return result;
  }

  /// 📊 Tracks event if result is successful
  Future<Either<Failure, T>> track(String eventName) async {
    final result = await this;
    if (result.isRight) debugPrint('[TRACK] $eventName');
    return result;
  }

  //
}
