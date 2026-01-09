/*

import 'package:core/public_api/base_modules/errors_management.dart' show Failure, FailureToUIEntityX;
import 'package:core/public_api/base_modules/overlays.dart' show ContextXForOverlays;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/base_modules/errors_handling_module/async_value_failure_x.dart'; // for .asFailure

/// ⛑️ [AsyncErrorListenerRp] — reusable top-level error listener for any [AsyncValue]
/// ✅ Triggers overlay only when we ENTER an error state (prev !error → next error)
/// ✅ Keeps navigation out (GoRouter does redirects declaratively)
final class AsyncErrorListenerRp<T> extends ConsumerWidget {
  ///--------------------------------------------------------------
  const AsyncErrorListenerRp({
    required this.provider,
    required this.child,
    super.key,
    this.onError, // optional custom handling hook
  });

  /// 🔌 Target provider emitting [AsyncValue]
  final ProviderListenable<AsyncValue<T>> provider;

  /// 🖼️ Child subtree
  final Widget child;

  /// 🎯 Optional custom error hook
  final void Function(BuildContext context, Failure failure)? onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<T>>(provider, (prev, next) {
      final prevFailure = prev?.asFailure;
      final nextFailure = next.asFailure;

      // 🚨 enter-only: react only when transitioning into error
      if (prevFailure == null && nextFailure != null) {
        if (onError != null) {
          onError!(context, nextFailure);
        } else {
          context.showError(nextFailure.toUIEntity());
        }
      }
    });

    return child;
  }
}



 */
