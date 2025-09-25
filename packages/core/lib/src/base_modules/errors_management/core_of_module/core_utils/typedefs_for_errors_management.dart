import 'package:core/base_modules/errors_management.dart';

/// 🧩 [ResultFuture] — Represents async result with [Either<Failure, T>]
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// 🧩 [FailureOr<T>] — Sync `Either<Failure, T>`
typedef FailureOr<T> = Either<Failure, T>;

/// 🧩 [VoidResult] — `ResultFuture<void>`, for void  action
typedef VoidResult = ResultFuture<void>;

/// 🔁 [VoidEither] — Sync `Either<Failure, void>`
typedef VoidEither = Either<Failure, void>;
