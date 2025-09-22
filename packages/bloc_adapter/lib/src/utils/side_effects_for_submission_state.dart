import 'package:core/core.dart';
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧯 [SubmissionSideEffects] — universal BLoC listener for button-driven flows
/// ✅ Handles three common branches:
///    - Success → `onSuccess`
///    - Error → `onError` (auto-consumes `Consumable<Failure>`)
///    - RequiresReauth → `onRequiresReauth` (optional)
//
/// 💡 Defaults:
///    - If `onError` is not provided → shows `context.showError(...)`
///    - If `onRequiresReauth` is not provided → also shows `context.showError(...)`
//
/// Usage:
/// ```dart
/// SubmissionSideEffects<MyCubit>(
///   onSuccess: (ctx, _) => ctx.showSnackbar(message: 'Done!'),
///   child: MyView(),
/// )
/// ```
final class SubmissionSideEffects<
  C extends StateStreamable<ButtonSubmissionState>
>
    extends StatelessWidget {
  ///----------------------------
  const SubmissionSideEffects({
    required this.child,
    this.listenWhen,
    this.onSuccess,
    this.onError,
    this.onRequiresReauth,
    this.onResetForm,
    super.key,
  });

  /// Subtree to wrap
  final Widget child;

  /// Custom predicate (default: fires on runtimeType changes)
  final bool Function(ButtonSubmissionState prev, ButtonSubmissionState curr)?
  listenWhen;

  /// ✅ Success handler
  final void Function(BuildContext context, ButtonSubmissionSuccess state)?
  onSuccess;

  /// ❌ Error handler
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionError state,
  )?
  onError;

  /// 🔄 Requires-reauth handler (optional)
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionRequiresReauth state,
  )?
  onRequiresReauth;

  /// 🧼 Optional hook to reset form state (e.g. SignInFormCubit.resetState()) on error
  /// Pass: `onResetForm: (ctx) => ctx.read<SignInFormCubit>().resetState()`
  final void Function(BuildContext context)? onResetForm;

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
            final consumed = failure?.consume();
            if (consumed == null) return;
            final failureForUI = consumed.toUIEntity();
            (onError != null)
                ? onError!(context, failureForUI, state)
                : context.showError(failureForUI);
            // Additionally reset the form if provided
            onResetForm?.call(context);

          /// 🔄 Requires reauth
          case ButtonSubmissionRequiresReauth(:final failure):
            final consumed = failure?.consume();
            if (consumed == null) return;
            final failureForUI = consumed.toUIEntity();
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
