import 'package:core/base_modules/errors_management.dart'
    show Failure, FailureToUIEntityX;
import 'package:core/base_modules/overlays.dart' show ContextXForOverlays;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart' show AsyncValueFailureX;

/// ⛑️ [AsyncMultiErrorListenerRp] — listen multiple AsyncValue providers at once
/// ✅ Enter-only: reacts only on transition into AsyncError
/// ✅ Reusable: accepts heterogeneous providers (payload type-agnostic)
final class AsyncMultiErrorListenerRp extends ConsumerWidget {
  ///--------------------------------------------------------------
  const AsyncMultiErrorListenerRp({
    required this.providers,
    required this.child,
    super.key,
    this.onError, // optional global hook
  }) : assert(providers.length > 0, 'providers must not be empty');

  /// 🔌 Sources emitting AsyncValue (heterogeneous T via `dynamic`)
  final List<ProviderListenable<AsyncValue<dynamic>>> providers;

  /// 🖼️ Child subtree
  final Widget child;

  /// 🎯 Optional global error hook (e.g. metrics)
  final void Function(BuildContext context, Failure failure)? onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🧼 Deduplicate providers (defensive)
    final unique = {...providers};
    for (final p in unique) {
      ref.listen<AsyncValue<dynamic>>(p, (prev, next) {
        final prevFailure = prev?.asFailure;
        final nextFailure = next.asFailure;

        // 🚨 Enter-only: prev !error → next error
        if (prevFailure == null && nextFailure != null) {
          if (onError != null) {
            onError!(context, nextFailure);
          } else {
            context.showError(nextFailure.toUIEntity());
          }
        }
      });
    }
    return child;
  }
}
