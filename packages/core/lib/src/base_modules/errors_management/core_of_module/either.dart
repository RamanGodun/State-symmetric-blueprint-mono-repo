import 'package:meta/meta.dart' show immutable;

/// 🎯 [Either] — Functional construct for wrapping a result:
/// ✅ [Left] for failure, [Right] for success
/// ✅ Immutable, composable, and testable
//
@immutable
sealed class Either<L, R> {
  ///--------------------
  const Either();
  //

  /// 🔍 True if value is [Left] (failure)
  bool get isLeft => this is Left<L, R>;

  /// 🔍 True if value is [Right] (success)
  bool get isRight => this is Right<L, R>;

  /// 🔁 Pattern match — executes [leftOp] if Left, [rightOp] if Right
  T fold<T>(T Function(L l) leftOp, T Function(R r) rightOp) => switch (this) {
    Left(:final value) => leftOp(value),
    Right(:final value) => rightOp(value),
  };

  /// 🔁 Maps both sides into new values
  Either<L2, R2> map<L2, R2>(L2 Function(L l) mapL, R2 Function(R r) mapR) =>
      switch (this) {
        Left(:final value) => Left(mapL(value)),
        Right(:final value) => Right(mapR(value)),
      };

  /// 🔁 Maps both sides using named parameters
  Either<L2, R2> mapBoth<L2, R2>({
    required L2 Function(L l) leftMapper,
    required R2 Function(R r) rightMapper,
  }) => fold((l) => Left(leftMapper(l)), (r) => Right(rightMapper(r)));

  /// 🔁 Maps only the Right value
  Either<L, R2> mapRight<R2>(R2 Function(R r) mapR) => switch (this) {
    Left(:final value) => Left(value),
    Right(:final value) => Right(mapR(value)),
  };

  /// 🔁 Maps only the Left value
  Either<L2, R> mapLeft<L2>(L2 Function(L l) mapL) => switch (this) {
    Left(:final value) => Left(mapL(value)),
    Right(:final value) => Right(value),
  };

  /// 🔁 FlatMap (Right-biased) — chain another [Either] result
  Either<L, R2> thenMap<R2>(Either<L, R2> Function(R r) mapR) => switch (this) {
    Left(:final value) => Left(value),
    Right(:final value) => mapR(value),
  };

  //
}

////

////

/// 📦 [Left] — Represents failure value of [Either]
//
@immutable
final class Left<L, R> extends Either<L, R> {
  ///--------------------------------------
  const Left(this.value);

  ///
  final L value;
}

////
////

/// 📦 [Right] — Represents success value of [Either]
//
@immutable
final class Right<L, R> extends Either<L, R> {
  ///--------------------------------------
  const Right(this.value);

  ///
  final R value;
}
