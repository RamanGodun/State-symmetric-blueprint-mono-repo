import 'package:bloc_adapter/src/core/base_modules/overlays_module/locker_while_active_overlay.dart'
    show BlocOverlayWatcher;
import 'package:bloc_adapter/src/core/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:core/public_api/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🚀 [BlocAdapterForSubmitButton] — BLoC adapter for core submit button.
/// Wires form validity, loading state and overlay activity into [SubmitButton].
//
final class BlocAdapterForSubmitButton<
  FormsCubit extends StateStreamable<FormsState>,
  FormsState,
  SubmitCubit extends StateStreamable<SubmissionFlowState>
>
    extends StatelessWidget {
  ///---------------------------------
  const BlocAdapterForSubmitButton({
    required this.label,
    required this.isFormValid,
    required this.onPressed,
    this.isLoadingSelector,
    this.loadingLabel,
    super.key,
  });

  /// Default button label.
  final String label;
  //
  /// Predicate to check if form state is valid.
  final bool Function(FormsState) isFormValid;
  //
  /// Selector to check if submit state is loading.
  final bool Function(dynamic submitState)? isLoadingSelector;
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
    return BlocBuilder<SubmitCubit, SubmissionFlowState>(
      buildWhen: (p, c) => p.runtimeType != c.runtimeType,
      builder: (context, submitState) {
        return BlocSelector<FormsCubit, FormsState, bool>(
          selector: isFormValid,
          builder: (context, isValid) {
            return SubmitButton(
              label: label,
              loadingLabel: loadingLabel,
              isValid: () => isValid,
              isLoading: () =>
                  isLoadingSelector?.call(submitState) ??
                  submitState is ButtonSubmissionLoadingState,
              isOverlayActive: () =>
                  context.select<OverlayStatusCubit, bool>((c) => c.state),
              onPressed: onPressed,
              overlayWatcher: watcher,
            );
          },
        );
      },
    );
  }

  //
}
