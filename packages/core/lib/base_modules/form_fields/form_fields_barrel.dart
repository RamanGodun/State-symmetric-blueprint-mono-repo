/// 🧾 Form Fields Module — barrel exports
// ignore_for_file: combinators_ordering, directives_ordering
library;

//
// ─── WIDGETS & FACTORY ────────────────────────────────────────────────────────
//
export '_form_field_factory.dart' show InputFieldFactory;
export 'widgets/app_text_field.dart' show AppTextField;
export 'widgets/password_visibility_icon.dart' show ObscureToggleIcon;

//
// ─── VALIDATION (Formz inputs & enums) ────────────────────────────────────────
//
export 'input_validation/validation_enums.dart';
export 'input_validation/x_on_forms_submission_status.dart';

//
// ─── UTILS (focus, helpers, services) ─────────────────────────────────────────
//
export 'utils/use_auth_focus_nodes.dart'
    show
        useSignInFocusNodes,
        useSignUpFocusNodes,
        useChangePasswordFocusNodes,
        useResetPasswordFocusNodes;
export 'utils/focus_nodes_generator.dart' show generateFocusNodes;
export 'utils/form_validation_service.dart' show FormValidationService;
