import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show AsyncValueFailureX;
import 'package:flutter/material.dart' show BuildContext, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValue, ConsumerWidget, ProviderListenable, WidgetRef;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show Failure, FailureToUIEntityX;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayAfterFrameX;

/// ⛑️ Listen multiple Failure?-selectors (projected from AsyncValue) and show overlay on enter-only error.
//
final class RiverpodAdapterForErrorsMultiListeners extends ConsumerWidget {
  ///-----------------------------------------------------------
  RiverpodAdapterForErrorsMultiListeners({
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
      // enter-only: prev null → next non-null
      if (prev == null && next != null) {
        if (onError != null) {
          onError(context, next);
        } else {
          // ✅  OverlayDispatcher handles lifecycle (No local postFrame/mounted guards here)
          context.showErrorAfterFrame(next.toUIEntity());
        }
      }
    });
  }
}

/// Sugar: project [AsyncValue<T>] → Failure?
extension FailureSelectorX<T> on ProviderListenable<AsyncValue<T>> {
  ///
  ProviderListenable<Failure?> get failureSource =>
      select((av) => av.failureOrNull);
}
