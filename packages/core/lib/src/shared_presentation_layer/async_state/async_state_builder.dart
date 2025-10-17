import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';

/// 🎨 [AsyncStateBuilder] — declarative UI builder for [AsyncStateView].
/// ✅ Unified rendering of loading/data/error branches
/// ✅ Eliminates boilerplate `.when(...)` duplication in widgets
//
class AsyncStateBuilder<T> extends StatelessWidget {
  ///---------------------------------------------------------------
  const AsyncStateBuilder({
    required this.state,
    required this.data,
    this.loading,
    this.error,
    super.key,
  });

  /// 🌊 Async state source (BLoC or Riverpod via adapter)
  final AsyncStateView<T> state;

  /// 🧩 Builder for `data` branch
  final Widget Function(T) data;

  /// ⏳ Builder for `loading` branch (optional, defaults to [AppLoader])
  final Widget Function()? loading;

  /// 🧨 Builder for `error` branch (optional, defaults to empty box)
  final Widget Function(Failure)? error;

  @override
  Widget build(BuildContext context) {
    // 🔁 Declarative pattern-match rendering
    return state.when(
      loading: loading ?? () => const AppLoader(),
      data: data,
      error: error ?? (_) => const SizedBox.shrink(),
    );
  }

  /// Typical usage:
  // ```dart
  /// return AsyncStateBuilder<UserEntity>(
  ///   state: view,
  ///   data: (user) => _UserProfileCard(user: user),
  ///   loading: () => const Center(child: CircularProgressIndicator()),
  ///   error: (f) => ErrorMessage(f),
  /// );
  // ```
}
