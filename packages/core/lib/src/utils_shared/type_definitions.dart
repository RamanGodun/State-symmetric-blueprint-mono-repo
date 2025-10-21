import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';

// /// 🧩 [ResultFuture] — Represents async result with [Either<Failure, T>]
// typedef ResultFuture<T> = Future<Either<Failure, T>>;

// /// 🧩 [FailureOr<T>] — Sync `Either<Failure, T>`
// typedef FailureOr<T> = Either<Failure, T>;

// /// 🧩 [VoidResult] — `ResultFuture<void>`, for void  action
// typedef VoidResult = ResultFuture<void>;

// /// 🔁 [VoidEither] — Sync `Either<Failure, void>`
// typedef VoidEither = Either<Failure, void>;

/// 📦 [DataMap] — For JSON-style dynamic map (used for DTO, serialization, Firestore docs...)
typedef DataMap = Map<String, dynamic>;

//------------- Form fields module ----------------

// /// 🧾 [FormFieldUiState] — Compact record for field visibility & error display
// typedef FormFieldUiState = ({String? errorText, bool isObscure});

// /// 🧾 [SubmitSlice] — Compact record for field validity & error forms submission status
// typedef SubmitSlice = ({bool isValid, FormzSubmissionStatus status});

// /// 🔁 Often used DTO for submissions
// typedef EmailAndPassword = ({String email, String password});

// /// 🔁 Often used DTO for submissions
// typedef NameEmailPassword = ({String name, String email, String password});

// /// 📤 [SubmitCallback] — Button or form submission callback
// typedef SubmitCallback = void Function(BuildContext context);

//------------- Errors management module ----------------

/// 📡 [ListenFailureCallback] — Optional handler when failure is caught
typedef ListenFailureCallback = void Function(Failure failure);

/// 🔧 [RefAction] — Executes an action without returning value, using Riverpod context
typedef RefAction = void Function();

/// Cancel function signature for overlay subscriptions.
typedef Cancel = void Function();

/// Syntactic sugar for a getter that returns a `bool`.
typedef BoolGetter = bool Function();
