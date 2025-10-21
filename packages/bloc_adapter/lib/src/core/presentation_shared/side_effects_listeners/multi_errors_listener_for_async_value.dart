import 'package:bloc_adapter/src/core/presentation_shared/async_state/async_value_for_bloc.dart';
import 'package:core/public_api/base_modules/errors_management.dart'
    show Failure, FailureToUIEntityX;
import 'package:core/public_api/base_modules/overlays.dart'
    show ContextXForOverlays;
import 'package:core/public_api/core.dart' show postFrame;
import 'package:core/public_api/shared_layers/presentation.dart'
    show handleEnterOnlyErrorTransition;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ⛑️ [ErrorsListenerForAppOnCubit] — listen multiple BLoC/Cubit sources at once
/// ✅ Enter-only: reacts only on transition into [AsyncErrorForBLoC]
//
final class ErrorsListenerForAppOnCubit extends StatelessWidget {
  ///---------------------------------------------------------
  const ErrorsListenerForAppOnCubit({
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
      handleEnterOnlyErrorTransition(
        prevFailure: null, // filtered by listenWhen
        nextFailure: failure,
        emit: (f) => postFrame(() {
          if (onError != null) {
            onError(ctx, f);
          } else {
            ctx.showError(f.toUIEntity());
          }
        }),
      );
    },
  );
}

/*

NOTE:
   If need to avoid listenWhen and put filtration om ocre, then:

AsyncValueForBLoC<T>? _prev;
return BlocListener<BlocBase<AsyncValueForBLoC<T>>, AsyncValueForBLoC<T>>(
  bloc: bloc,
  listenWhen: (prev, curr) { _prev = prev; return true; }, // або прибрати зовсім
  listener: (ctx, state) {
    final prevFailure = _prev is AsyncErrorForBLoC<T>
        ? (_prev as AsyncErrorForBLoC<T>).failure
        : null;
    final nextFailure = state is AsyncErrorForBLoC<T>
        ? (state as AsyncErrorForBLoC<T>).failure
        : null;

    handleEnterOnlyErrorTransition(
      prevFailure: prevFailure,
      nextFailure: nextFailure,
      emit: (f) => postFrame(() {
        if (onError != null) onError(ctx, f);
        else ctx.showError(f.toUIEntity());
      }),
    );
  },
);

listenWhen always true (or at all without it)

 */
