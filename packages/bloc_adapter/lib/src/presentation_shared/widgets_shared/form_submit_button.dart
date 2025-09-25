import 'package:bloc_adapter/src/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:core/base_modules/localization.dart' show LocaleKeys;
import 'package:core/shared_layers/presentation.dart'
    show
        ButtonSubmissionErrorState,
        ButtonSubmissionLoadingState,
        ButtonSubmissionState,
        ButtonSubmissionSuccessState,
        CustomFilledButton;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🖱️ [SubmitCallback] — common signature for submit button handlers
/// ✅ Does not pass [BuildContext] explicitly (outer context is used instead)
typedef SubmitCallback = void Function();

////
////

/// 🚀 [FormSubmitButtonForBLoCApps] — universal submit button aware of two cubits (FormCubit + SubmitCubit)
/// ✅ Automatically:
///   - shows loader while submitting
///   - disables itself when form is invalid / overlay is active / submitting
///   - prevents “button flicker” after Success/Error by using a short transient-lock
//
final class FormSubmitButtonForBLoCApps<
  FormsCubit extends StateStreamable<FormsState>,
  FormsState,
  SubmitCubit extends StateStreamable<ButtonSubmissionState>
>
    extends StatefulWidget {
  ///-------------------------------
  const FormSubmitButtonForBLoCApps({
    required this.label,
    required this.isFormValid,
    required this.onPressed,
    this.loadingLabel = LocaleKeys.buttons_submitting,
    this.padding,
    super.key,
  });

  /// 🏷️ Default label text
  final String label;

  /// 🔄 Label text shown while submitting
  final String loadingLabel;

  /// ✅ Selector that checks if form is valid
  final bool Function(FormsState) isFormValid;

  /// 🖱️ Tap handler (only called when enabled)
  final SubmitCallback onPressed;

  /// 📐 Optional padding around the button
  final EdgeInsets? padding;

  @override
  State<FormSubmitButtonForBLoCApps<FormsCubit, FormsState, SubmitCubit>>
  createState() =>
      _FormSubmitButtonForBLoCAppsState<FormsCubit, FormsState, SubmitCubit>();
}

////

/// 🏗️ Internal state — holds transient-lock to smooth UX
//
final class _FormSubmitButtonForBLoCAppsState<
  FormsCubit extends StateStreamable<FormsState>,
  FormsState,
  SubmitCubit extends StateStreamable<ButtonSubmissionState>
>
    extends
        State<
          FormSubmitButtonForBLoCApps<FormsCubit, FormsState, SubmitCubit>
        > {
  ///---------------------------------------------------------------------
  //
  bool _transientLock = false;

  /// ⏳ Arms a short lock after Success/Error
  /// - released on the next frame, giving overlays time to activate
  void _armTransientLock() {
    if (mounted) {
      setState(() => _transientLock = true);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _transientLock = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    // 🛡️ Disable button if overlay is active
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (c) => c.state,
    );

    return BlocListener<SubmitCubit, ButtonSubmissionState>(
      listenWhen: (p, c) => p.runtimeType != c.runtimeType,
      listener: (context, state) {
        // When submission ends (Success/Error) → short lock to avoid flicker
        switch (state) {
          case ButtonSubmissionErrorState():
          case ButtonSubmissionSuccessState():
            _armTransientLock();
          default:
            break;
        }
      },
      child: BlocBuilder<SubmitCubit, ButtonSubmissionState>(
        buildWhen: (p, c) => p.runtimeType != c.runtimeType,
        builder: (context, submitState) {
          final isLoading = submitState is ButtonSubmissionLoadingState;

          return BlocSelector<FormsCubit, FormsState, bool>(
            selector: widget.isFormValid,
            builder: (context, isValid) {
              final isEnabled =
                  isValid && !isLoading && !isOverlayActive && !_transientLock;

              final currentLabel = isLoading
                  ? widget.loadingLabel
                  : widget.label;

              final btn = CustomFilledButton(
                label: currentLabel,
                onPressed: isEnabled ? widget.onPressed : null,
                isLoading: isLoading,
                isEnabled: isEnabled,
                isValidated: isValid,
              );

              if (widget.padding != null)
                return Padding(padding: widget.padding!, child: btn);
              return btn;
            },
          );
        },
      ),
    );
  }
}
