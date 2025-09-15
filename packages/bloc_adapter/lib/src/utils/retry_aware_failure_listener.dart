import 'package:bloc_adapter/bloc_adapter.dart' show SubmissionState;
import 'package:bloc_adapter/src/utils/i_submission_state.dart'
    show SubmissionActor;
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 📣 One-shot failure feedback with optional Retry.
/// ✅ Requires: TCubit implements [SubmissionActor<TState>].
/// ✅ Calls `consume()` inside; default cleanup -> cubit.resetStatus/clearFailure().
//
final class FailureListenerForAppWithBloc<
  TState extends SubmissionState,
  TCubit extends SubmissionActor<TState>
>
    extends StatelessWidget {
  ///---------------------------------
  const FailureListenerForAppWithBloc({
    required this.child,
    this.listenWhen,
    this.onRetry,
    this.onAfterHandled,
    this.confirmText,
    this.showAs,
    super.key,
  });

  /// 🌳 Subtree to wrap
  final Widget child;

  /// 🔎 Optional custom predicate
  final bool Function(TState prev, TState curr)? listenWhen;

  /// 🔁 Optional retry handler
  final void Function(TCubit cubit)? onRetry;

  /// 🧼 Optional cleanup callback
  final void Function(BuildContext context, TState state)? onAfterHandled;

  /// 🏷️ Retry button text override
  final String? confirmText;

  /// 🎛️ Force overlay type (default = dialog)
  final ShowAs? showAs;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TCubit, TState>(
      listenWhen:
          listenWhen ??
          (prev, curr) =>
              prev.status != curr.status && curr.status.isSubmissionFailure,
      listener: (context, state) {
        final failure = state.failure?.consume();
        if (failure == null) return;

        final falureForUI = failure.toUIEntity();

        final cubit = context.read<TCubit>();

        // 🔧 Default ShowAs depends on retryability (as it worked before):
        // - retryable: dialog
        // - non-retryable: infoDialog
        final defaultShowAs = failure.isRetryable
            ? ShowAs.dialog
            : ShowAs.infoDialog;
        final resolvedShowAs = showAs ?? defaultShowAs;

        if (failure.isRetryable && onRetry != null) {
          context.showError(
            falureForUI,
            showAs: resolvedShowAs,
            onConfirm: () {
              context.dispatcher.dismissCurrent(force: true);
              onRetry!(cubit);
            },
            confirmText:
                confirmText ??
                AppLocalizer.translateSafely(LocaleKeys.buttons_retry),
          );
        } else {
          context.showError(falureForUI, showAs: resolvedShowAs);
        }

        // 🧽 Cleanup
        if (onAfterHandled != null) {
          onAfterHandled!(context, state);
        } else {
          // Calls default methods
          context.read<TCubit>()
            ..resetStatus()
            ..clearFailure();
        }
      },
      child: child,
    );
  }
}
