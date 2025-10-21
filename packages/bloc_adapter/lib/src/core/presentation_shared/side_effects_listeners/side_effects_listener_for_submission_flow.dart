import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧯 [SubmissionStateSideEffects] — universal BLoC listener for button-driven flows
/// ✅ Handles three common branches:
///    - Success → `onSuccess`
///    - Error → `onError` (auto-consumes `Consumable<Failure>`)
///    - RequiresReauth → `onRequiresReauth` (optional)
//
/// 💡 Defaults:
///    - If `onError` is not provided → shows `context.showError(...)`
///    - If `onRequiresReauth` is not provided → also shows `context.showError(...)`
//
final class SubmissionStateSideEffects<
  C extends StateStreamable<SubmissionFlowState>
>
    extends StatelessWidget {
  ///----------------------------
  const SubmissionStateSideEffects({
    required this.child,
    this.listenWhen,
    this.onSuccess,
    this.onError,
    this.onRequiresReauth,
    this.onResetForm,
    this.onRetry,
    this.retryLabel,
    this.onErrorWithRetry,
    super.key,
  });

  /// Subtree to wrap
  final Widget child;

  /// Custom predicate (default: fires on runtimeType changes)
  final bool Function(SubmissionFlowState prev, SubmissionFlowState curr)?
  listenWhen;

  /// ✅ Success handler
  final void Function(BuildContext context, ButtonSubmissionSuccessState state)?
  onSuccess;

  /// ❌ Error handler
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionErrorState state,
  )?
  onError;

  /// 🔄 Requires-reauth handler (optional)
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionRequiresReauthState state,
  )?
  onRequiresReauth;

  /// 🧼 Optional hook to reset form state (e.g. SignInFormCubit.resetState()) on error
  /// Pass: `onResetForm: (ctx) => ctx.read<SignInFormCubit>().resetState()`
  final void Function(BuildContext context)? onResetForm;

  /// 📞 Callback for retry action (submit, resend, etc)
  final void Function(BuildContext context)? onRetry;

  /// 🔄 Confirm button text in Retry dialog (if need to change default)
  final String? retryLabel;

  /// 📲 Error render with Retry-button
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionErrorState state,
    VoidCallback retry,
  )?
  onErrorWithRetry;

  ////

  @override
  Widget build(BuildContext context) {
    //
    return BlocListener<C, SubmissionFlowState>(
      listenWhen: listenWhen ?? (p, c) => p.runtimeType != c.runtimeType,
      listener: (context, state) {
        //
        switch (state) {
          //
          /// ✅ Success
          case ButtonSubmissionSuccessState():
            onSuccess?.call(context, state);

          ////

          /// ❌ Error
          case ButtonSubmissionErrorState(:final failure):
            final consumed = failure?.consume();
            if (consumed == null) return;
            final failureForUI = consumed.toUIEntity();
            final retryable = consumed.isRetryable;
            //
            if (retryable && onRetry != null) {
              void retry() => onRetry!.call(context);
              if (onErrorWithRetry != null) {
                onErrorWithRetry!(context, failureForUI, state, retry);
              } else {
                // Default (button with retry button)
                context.showError(
                  failureForUI,
                  showAs: ShowAs.dialog,
                  onConfirm: retry,
                  confirmText:
                      retryLabel ??
                      AppLocalizer.translateSafely(LocaleKeys.buttons_retry),
                );
              }
              onResetForm?.call(context);
              return;
            }
            //
            /// Usual branch without retry logic
            (onError != null)
                ? onError!(context, failureForUI, state)
                : context.showError(failureForUI);
            // Additionally reset the form if provided
            onResetForm?.call(context);

          ////

          /// 🔄 Requires reauth
          case ButtonSubmissionRequiresReauthState(:final failure):
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
