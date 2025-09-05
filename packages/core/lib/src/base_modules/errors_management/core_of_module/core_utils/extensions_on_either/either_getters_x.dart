import 'package:core/src/base_modules/errors_management/core_of_module/either.dart';

/// ✅ [EitherGetters] — lightweight accessors for Either results
/// ✅ Enables safe reads, branching, and composable logic
//
extension EitherGetters<L, R> on Either<L, R> {
  ///---------------------------------------

  /// ❌ Returns Left value if exists, else null
  L? get leftOrNull => switch (this) {
    Left(:final value) => value,
    Right() => null,
  };

  /// ✅ Returns Right value if exists, else null
  R? get rightOrNull => switch (this) {
    Right(:final value) => value as R?,
    Left() => null,
  };

  /// 🧭 True if this is Left (failure)
  bool get isLeft => this is Left<L, R>;

  /// 🧭 True if this is Right (success)
  bool get isRight => this is Right<L, R>;

  /// 🎯 Alias for [rightOrNull] (used for success value in UI logic)
  R? get valueOrNull => rightOrNull;

  /// 🔁 Fold with optional callbacks (returns null if no handler is matched)
  T? foldOrNull<T>({T Function(L l)? onLeft, T Function(R r)? onRight}) =>
      switch (this) {
        Left(:final value) => onLeft?.call(value),
        Right(:final value) => onRight?.call(value),
      };

  //
}
