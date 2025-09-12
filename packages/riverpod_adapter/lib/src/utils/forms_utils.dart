import 'package:core/utils.dart' show FieldUiState;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🌀 [AsyncStatusX] — utility extension for [AsyncValue<Object?>]
/// ✅ Quickly checks if state is "idle or has data"
/// ✅ Handy in forms/listeners for simple condition handling
extension AsyncStatusX on AsyncValue<Object?> {
  ///
  bool get isIdleOrData => !isLoading && !hasError;
}

////
////

/// 🧱 [fieldUi] — factory for building [FieldUiState]
/// ✅ Unified approach for selectors (BlocSelector / ref.select)
/// ✅ Reduces duplication of inline tuples `(errorText, isObscure)`
FieldUiState fieldUi({
  required bool isObscure,
  String? error,
}) => (errorText: error, isObscure: isObscure);

////
////

/// 🎯 [goNext] — convenience callback to move focus to the next [FocusNode]
/// ✅ Used inside `onSubmitted` for input fields
/// ✅ Keeps widget code clean and declarative
VoidCallback goNext(FocusNode next) =>
    () => next.requestFocus();

////
////

/// 📩 [readNotifier] — shorthand alias for `ref.read(provider)`
/// ✅ Used for controller (notifier) access inside forms
/// ✅ Simplifies code in submit or action methods
T readNotifier<T>(
  WidgetRef ref,
  AlwaysAliveProviderListenable<T> p,
) => ref.read(p);
