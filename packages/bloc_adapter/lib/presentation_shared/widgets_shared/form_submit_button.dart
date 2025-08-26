//
// ignore_for_file: public_member_api_docs

import 'package:bloc_adapter/base_modules/overlays_module/overlay_status_cubit.dart';
import 'package:core/base_modules/form_fields/input_validation/x_on_forms_submission_status.dart';
import 'package:core/shared_presentation_layer/widgets_shared/buttons/filled_button.dart';
import 'package:core/utils_shared/type_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

/// 🚀 [FormSubmitButton] — Bloc-aware smart submit button for forms.
///
/// 🧠 This widget acts as a **behavioral adapter** around [CustomFilledButton].
/// It listens to the given Bloc/cubit and automatically:
///   - shows a loader during form submission
///   - disables itself if form is invalid or submission in progress
///   - respects overlay state (to avoid multiple submissions)
///
/// ✅ Common use case:
///   - Place at bottom of forms (SignIn, SignUp, ResetPassword, etc)
///   - Controlled declaratively using status and validation selectors
//
final class FormSubmitButton<Tcubit extends StateStreamable<TState>, TState>
    extends StatelessWidget {
  ///--------------------------------------------------
  const FormSubmitButton({
    required this.label,
    required this.onPressed,
    required this.statusSelector,
    required this.isValidatedSelector,
    super.key,
  });
  //
  final String label;
  final SubmitCallback onPressed;
  final FormzSubmissionStatus Function(TState) statusSelector;
  final bool Function(TState) isValidatedSelector;

  @override
  Widget build(BuildContext context) {
    //
    /// Whether an overlay/dialog is active (blocks submission)
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );

    return BlocBuilder<Tcubit, TState>(
      buildWhen: (prev, curr) =>
          statusSelector(prev) != statusSelector(curr) ||
          isValidatedSelector(prev) != isValidatedSelector(curr),
      builder: (context, state) {
        final status = statusSelector(state);
        final isValidated = isValidatedSelector(state);
        final isLoading = status.isInProgress;
        final isEnabled = status.canSubmit && isValidated && !isOverlayActive;

        return CustomFilledButton(
          label: label,
          onPressed: isEnabled ? () => onPressed(context) : null,
          isLoading: isLoading,
          isEnabled: isEnabled,
          isValidated: isValidated,
        );
      },
    );
  }
}
