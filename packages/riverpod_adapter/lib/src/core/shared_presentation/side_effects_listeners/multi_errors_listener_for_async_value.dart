import 'package:core/public_api/base_modules/errors_management.dart'
    show Failure, FailureToUIEntityX;
import 'package:core/public_api/base_modules/overlays.dart'
    show ContextXForOverlays;
import 'package:core/public_api/core.dart' show postFrame;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/base_modules/errors_handling_module/async_value_failure_x.dart';

/// ⛑️ Listen multiple Failure?-selectors (projected from AsyncValue) and show overlay on enter-only error.
//
final class ErrorsListenerForAppOnRiverpod extends ConsumerWidget {
  ///-----------------------------------------------------------
  ErrorsListenerForAppOnRiverpod({
    required this.failureSources,
    required this.child,
    super.key,
    this.onError, // optional global hook
  }) : assert(failureSources.isNotEmpty, 'failureSources must not be empty');

  /// 🔌 Sources that expose Failure? (usually via provider.select((av) => av.failureOrNull)).
  final List<ProviderListenable<Failure?>> failureSources;

  /// 🖼️ Child subtree
  final Widget child;

  /// 🎯 Optional global error hook (e.g. metrics)
  final void Function(BuildContext context, Failure failure)? onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    attachEnterOnlyErrorListenersRP(
      ref: ref,
      context: context,
      sources: failureSources,
      onError: onError,
    );
    //
    return child;
  }
}

////
////

/// Listen multiple AsyncValue providers and trigger enter-only error overlays.
void attachEnterOnlyErrorListenersRP({
  required WidgetRef ref,
  required BuildContext context,
  required List<ProviderListenable<Failure?>> sources,
  void Function(BuildContext, Failure)? onError,
}) {
  // 🧼 Defensive dedupe
  final unique = {...sources};
  //
  for (final s in unique) {
    ref.listen<Failure?>(s, (prev, next) {
      if (prev == null && next != null) {
        postFrame(() {
          // 🚨 Enter-only: prev !error → next error
          if (onError != null)
            onError(context, next);
          else
            context.showError(next.toUIEntity());
        });
      }
    });
  }
}

/// Helper: project [AsyncValue<T>] → Failure?
extension FailureSelectorX<T> on ProviderListenable<AsyncValue<T>> {
  ///
  ProviderListenable<Failure?> get failureSource =>
      select((av) => av.failureOrNull);
}
