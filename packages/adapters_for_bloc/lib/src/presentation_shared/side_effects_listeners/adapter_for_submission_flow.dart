import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocListener, StateStreamable;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        SubmissionFlowStateModel,
        SubmissionSideEffectsConfig,
        handleSubmissionTransition;

/// 🧯 [BlocAdapterForSubmissionFlowSideEffects] — BLoC adapter over the core
/// ✅ Default: reacts on `runtimeType` change (symmetry with Riverpod)
/// ✅ No local postFrame/mounted guards — dispatcher owns lifecycle
//
final class BlocAdapterForSubmissionFlowSideEffects<
  C extends StateStreamable<SubmissionFlowStateModel>
>
    extends StatelessWidget {
  ///--------------------------------------------------------------------------------------------------------
  const BlocAdapterForSubmissionFlowSideEffects({
    required this.child,
    this.listenWhen, // optional filter
    this.config = const SubmissionSideEffectsConfig(),
    super.key,
  });

  /// 🖼️ Child subtree to wrap
  final Widget child;

  /// 🧪 Custom predicate (default: react on runtimeType change)
  final bool Function(
    SubmissionFlowStateModel prev,
    SubmissionFlowStateModel curr,
  )?
  listenWhen;

  /// ⚙️ Branch config (success / error / reauth / retry / reset)
  final SubmissionSideEffectsConfig config;

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, SubmissionFlowStateModel>(
      // 🔎 Default enter-only by runtimeType (keeps parity with Riverpod)
      listenWhen: listenWhen ?? (p, c) => p.runtimeType != c.runtimeType,
      listener: (ctx, state) => handleSubmissionTransition(
        context: ctx,
        curr: state,
        cfg: config,
      ),
      child: child,
    );
  }

  //
}
