import 'package:core/base_modules/errors_management.dart'
    show Failure, FailureToUIEntityX;
import 'package:core/base_modules/overlays.dart' show ContextXForOverlays;
import 'package:core/core.dart' show AsyncState, AsyncStateError;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ⛑️ [AsyncMultiErrorListener] — listen multiple BLoC/Cubit sources at once
/// ✅ Enter-only: reacts only on transition into [AsyncStateError]
/// ✅ Reusable: accepts heterogeneous cubits (payload type-agnostic via `dynamic`)
//
final class AsyncMultiErrorListener extends StatelessWidget {
  ///-----------------------------------------------------
  const AsyncMultiErrorListener({
    required this.resolveBlocs, // 🧠 lazy resolver
    required this.child,
    super.key,
    this.onError,
  });

  /// 🧠 Lazy resolver: called inside build with a *valid* context
  final List<BlocBase<AsyncState<dynamic>>> Function(BuildContext) resolveBlocs;

  /// 🖼️ Child subtree
  final Widget child;

  /// 🎯 Optional custom error hook (e.g. logging/metrics)
  final void Function(BuildContext context, Failure failure)? onError;

  @override
  Widget build(BuildContext context) {
    // resolve with a valid context (providers are already mounted)
    final blocs = {...resolveBlocs(context)}; // dedupe defensively

    return MultiBlocListener(
      listeners: blocs
          .map(
            (bloc) =>
                BlocListener<
                  BlocBase<AsyncState<dynamic>>,
                  AsyncState<dynamic>
                >(
                  bloc: bloc,
                  listenWhen: (prev, curr) =>
                      prev is! AsyncStateError && curr is AsyncStateError,
                  listener: (ctx, state) {
                    final failure = (state as AsyncStateError).failure;
                    if (onError != null) {
                      onError!(ctx, failure);
                    } else {
                      ctx.showError(failure.toUIEntity());
                    }
                  },
                ),
          )
          .toList(),
      child: child,
    );
  }
}
