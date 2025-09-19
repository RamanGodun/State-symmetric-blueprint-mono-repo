//
// ignore_for_file: public_member_api_docs

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧯 [SubmissionSideEffects] — BLoC listener for Success/Error (+ optionally RequiresReauth) states.
//
final class SubmissionSideEffects<
  C extends StateStreamable<ButtonSubmissionState>
>
    extends StatelessWidget {
  ///-----------------------------------------------------------------------------------------------------
  const SubmissionSideEffects({
    required this.child,
    this.listenWhen,
    this.onSuccess,
    this.onError,
    this.onRequiresReauth,
    super.key,
  });
  //
  ///
  final Widget child;

  /// Custom predicate (by default - on runtimeType changes)
  final bool Function(ButtonSubmissionState prev, ButtonSubmissionState curr)?
  listenWhen;

  /// ✅ Success type function
  final void Function(BuildContext context, ButtonSubmissionSuccess state)?
  onSuccess;

  /// ❌ Error type function
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionError state,
  )?
  onError;

  /// 🔄 Requires Reauth type function (optional)
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionRequiresReauth state,
  )?
  onRequiresReauth;

  @override
  Widget build(BuildContext context) {
    //
    return BlocListener<C, ButtonSubmissionState>(
      listenWhen: listenWhen ?? (p, c) => p.runtimeType != c.runtimeType,
      listener: (context, state) {
        //
        switch (state) {
          //
          /// ✅ Success
          case ButtonSubmissionSuccess():
            onSuccess?.call(context, state);

          /// ❌ Error
          case ButtonSubmissionError(:final failure):
            final consumedFailure = failure?.consume();
            if (consumedFailure == null) return;
            final failureForUI = consumedFailure.toUIEntity();
            (onError != null)
                ? onError!(context, failureForUI, state)
                : context.showError(failureForUI);

          /// 🔄 Requires Reauth → show dialog, than signOut for reAuth
          case ButtonSubmissionRequiresReauth(:final failure):
            final consumedFailure = failure?.consume();
            if (consumedFailure == null) return;
            final failureForUI = consumedFailure.toUIEntity();
            (onRequiresReauth != null)
                ? onRequiresReauth!(context, failureForUI, state)
                : context.showError(failureForUI);

          ///
          default:
            break;
          //
        }
      },

      ///
      child: child,
      //
    );
  }
}
