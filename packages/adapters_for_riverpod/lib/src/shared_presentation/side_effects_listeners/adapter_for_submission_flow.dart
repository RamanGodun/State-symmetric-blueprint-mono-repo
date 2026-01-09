import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenable, WidgetRef;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        SubmissionFlowStateModel,
        SubmissionSideEffectsConfig,
        handleSubmissionTransition;

/// 🧯 [RiverpodAdapterForSubmissionFlowSideEffects] — Riverpod adapter over the core
/// ✅ Default: reacts on `runtimeType` change (symmetry with BLoC)
/// ✅ No local postFrame/mounted guards — dispatcher owns lifecycle
//
extension RiverpodAdapterForSubmissionFlowSideEffects on WidgetRef {
  ///--------------------------------------
  ///
  /// 🎧 Subscribe to a submit-flow provider with a single config entry-point
  void listenSubmissionSideEffects(
    ProviderListenable<SubmissionFlowStateModel> provider,
    BuildContext context, {
    bool Function(SubmissionFlowStateModel prev, SubmissionFlowStateModel next)?
    listenWhen,
    SubmissionSideEffectsConfig config = const SubmissionSideEffectsConfig(),
  }) {
    SubmissionFlowStateModel? prevState;

    listen<SubmissionFlowStateModel>(
      provider,
      (previous, current) {
        // 🔎 Enter-only by runtimeType (symmetry with BLoC)
        if (listenWhen != null &&
            previous != null &&
            !listenWhen(previous, current)) {
          prevState = current;
          return;
        }
        if (listenWhen == null &&
            previous != null &&
            previous.runtimeType == current.runtimeType) {
          prevState = current;
          return;
        }
        //
        handleSubmissionTransition(
          context: context,
          curr: current,
          prev: prevState,
          cfg: config,
        );
        //
        prevState = current;
      },
      onError: (_, _) {}, // 🔕 keep logs quiet here
    );
  }

  //
}
