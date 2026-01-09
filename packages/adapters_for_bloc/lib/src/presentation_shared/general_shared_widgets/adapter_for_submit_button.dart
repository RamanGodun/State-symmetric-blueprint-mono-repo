import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show OverlayStatusCubit;
import 'package:adapters_for_bloc/src/base_app_modules/overlays_module/locker_while_active_overlay.dart'
    show BlocOverlayWatcher;
import 'package:adapters_for_bloc/src/utils/bloc_select_x_on_context.dart'
    show BlocWatchSelectX;
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, VoidCallback, Widget;
import 'package:flutter_bloc/flutter_bloc.dart' show StateStreamable;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show ButtonSubmissionStateX, SubmissionFlowStateModel;
import 'package:shared_widgets/public_api/buttons.dart' show SubmitButton;

/// Default: uses `.isLoading` extension on SubmissionFlowState.
bool _defaultLoading(SubmissionFlowStateModel state) => state.isLoading;

////
////

/// 🚀 [BlocAdapterForSubmitButton] — BLoC adapter for core submit button.
/// Wires form validity, loading state and overlay activity into [SubmitButton].
//
final class BlocAdapterForSubmitButton<
  FormsCubit extends StateStreamable<FormsState>,
  FormsState,
  SubmitCubit extends StateStreamable<SubmissionFlowStateModel>
>
    extends StatelessWidget {
  ///---------------------------------
  const BlocAdapterForSubmitButton({
    required this.label,
    required this.isFormValid,
    required this.onPressed,
    this.loadingLabel,
    this.isLoadingSelector = _defaultLoading,
    super.key,
  });

  /// Default button label.
  final String label;
  //
  /// Predicate to check if form state is valid.
  final bool Function(FormsState) isFormValid;
  //
  /// Selector to check if submit state is loading.
  final bool Function(SubmissionFlowStateModel submitState) isLoadingSelector;
  //
  /// Press callback (enabled only when form is valid and not locked).
  final VoidCallback onPressed;
  //
  /// Optional label during loading (raw text or localization key).
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    //
    final watcher = BlocOverlayWatcher(context);
    //
    // Symmetric, concise, and rebuild-safe:
    final isValid = context.watchAndSelect<FormsCubit, FormsState, bool>(
      isFormValid,
    );
    final submitState = context
        .watchAndSelect<
          SubmitCubit,
          SubmissionFlowStateModel,
          SubmissionFlowStateModel
        >(
          (s) => s,
        );
    final isLoading = isLoadingSelector(submitState);
    final isOverlayActive = context
        .watchAndSelect<OverlayStatusCubit, bool, bool>((s) => s);
    //
    return SubmitButton(
      label: label,
      loadingLabel: loadingLabel,
      isValid: () => isValid,
      isLoading: () => isLoading,
      isOverlayActive: () => isOverlayActive,
      onPressed: onPressed,
      overlayWatcher: watcher,
    );
  }

  //
}
