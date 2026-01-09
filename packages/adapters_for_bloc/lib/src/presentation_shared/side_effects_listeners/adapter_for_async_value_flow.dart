import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show AsyncErrorForBLoC, AsyncValueForBLoC;
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBase, BlocListener, MultiBlocListener;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show Failure, FailureToUIEntityX;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayAfterFrameX;

/// ⛑️ [BlocAdapterForErrorsMultiListeners] — listen multiple BLoC/Cubit sources at once
/// ✅ Enter-only: reacts only on transition into [AsyncErrorForBLoC]
//
final class BlocAdapterForErrorsMultiListeners extends StatelessWidget {
  ///---------------------------------------------------------
  const BlocAdapterForErrorsMultiListeners({
    required this.resolveBlocs, // lazy resolver with a valid BuildContext
    required this.child,
    super.key,
    this.onError,
  });

  /// Lazy resolver returning heterogeneous cubits via a common supertype.
  final List<BlocBase<AsyncValueForBLoC<Object?>>> Function(BuildContext)
  resolveBlocs;

  /// Child subtree.
  final Widget child;

  /// Optional custom error hook (e.g. logging/metrics).
  final void Function(BuildContext context, Failure failure)? onError;

  @override
  Widget build(BuildContext context) {
    // Resolve with a valid context (blocs are already mounted); dedupe defensively
    final blocs = {...resolveBlocs(context)};

    return MultiBlocListener(
      listeners: blocs
          .map(
            (b) =>
                buildEnterOnlyErrorListener<Object?>(bloc: b, onError: onError),
          )
          .toList(),
      child: child,
    );
  }
}

/// Build a BlocListener that fires on enter-only AsyncErrorForBLoC.
BlocListener<BlocBase<AsyncValueForBLoC<T>>, AsyncValueForBLoC<T>>
buildEnterOnlyErrorListener<T>({
  required BlocBase<AsyncValueForBLoC<T>> bloc,
  void Function(BuildContext, Failure)? onError,
}) {
  return BlocListener<BlocBase<AsyncValueForBLoC<T>>, AsyncValueForBLoC<T>>(
    bloc: bloc,
    listenWhen: (prev, curr) =>
        prev is! AsyncErrorForBLoC<T> && curr is AsyncErrorForBLoC<T>,
    listener: (ctx, state) {
      final failure = (state as AsyncErrorForBLoC<T>).failure;
      if (onError != null) {
        onError(ctx, failure);
      } else {
        // ✅  OverlayDispatcher handles lifecycle (No local postFrame/mounted guards here)
        ctx.showErrorAfterFrame(failure.toUIEntity());
      }
    },
  );
}
