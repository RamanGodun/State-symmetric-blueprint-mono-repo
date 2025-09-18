import 'package:core/base_modules/errors_management.dart';
import 'package:core/base_modules/overlays.dart';
import 'package:flutter/material.dart';

/// 🧩 [Consumable] — Wraps a value for one-time consumption.
/// ✅ Prevents repeated UI side-effects (like dialogs/snackbars)
//
final class Consumable<T> {
  ///-------------------
  /// Creates a new [Consumable] wrapper
  Consumable(T value) : _value = value;
  //
  final T? _value;
  bool _hasBeenConsumed = false;

  /// Returns value only once (marks as consumed)
  T? consume() {
    if (_hasBeenConsumed) return null;
    _hasBeenConsumed = true;
    return _value;
  }

  /// Returns value without consuming it
  T? peek() => _value;
  //
  /// 🔄 Resets consumption state (useful for tests or reuse)
  void reset() => _hasBeenConsumed = false;
  //
  /// ✅ Whether the value has already been consumed /// ✅ Whether the value has already been consumed
  bool get isConsumed => _hasBeenConsumed;
  //
  @override
  String toString() =>
      'Consumable(value: $_value, consumed: $_hasBeenConsumed)';
  //
}

////
////

/// 📦 Extension to wrap any object in a [Consumable]
//
extension ConsumableX<T> on T {
  ///--------------------------
  Consumable<T> asConsumable() => Consumable(this);
}

////
////

/// 📦 Extension to one-time error show
//
extension FailureUIContextX on BuildContext {
  ///---------------------------------------
  //
  void consumeAndShowDialog(FailureUIEntity? uiFailure) {
    if (uiFailure != null) showError(uiFailure);
  }
}
