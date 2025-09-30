import 'package:bloc_adapter/src/core/presentation_shared/async_state/async_value_for_bloc.dart';
import 'package:core/public_api/base_modules/errors_management.dart'
    show Failure, FailureToUIEntityX;
import 'package:core/public_api/base_modules/overlays.dart'
    show ContextXForOverlays;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ⛑️ [ErrorsListenerForAppOnCubit] — listen multiple BLoC/Cubit sources at once
/// ✅ Enter-only: reacts only on transition into [AsyncErrorForBLoC]
/// ✅ Reusable: accepts heterogeneous cubits (payload type-agnostic via `dynamic`)
//
final class ErrorsListenerForAppOnCubit extends StatelessWidget {
  ///-----------------------------------------------------
  const ErrorsListenerForAppOnCubit({
    required this.resolveBlocs, // 🧠 lazy resolver
    required this.child,
    super.key,
    this.onError,
  });

  /// 🧠 Lazy resolver: called inside build with a *valid* context
  final List<BlocBase<AsyncValueForBLoC<dynamic>>> Function(BuildContext)
  resolveBlocs;

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
                  BlocBase<AsyncValueForBLoC<dynamic>>,
                  AsyncValueForBLoC<dynamic>
                >(
                  bloc: bloc,
                  listenWhen: (prev, curr) =>
                      prev is! AsyncErrorForBLoC && curr is AsyncErrorForBLoC,
                  listener: (ctx, state) {
                    final failure = (state as AsyncErrorForBLoC).failure;
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
