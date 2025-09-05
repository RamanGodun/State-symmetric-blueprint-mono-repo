/// 🧾 Form Fields Module — barrel exports
// ignore_for_file: combinators_ordering, directives_ordering
library;

//
// ─── WIDGETS & FACTORY ────────────────────────────────────────────────────────
//
export '../src/base_modules/forms/form_field_factory.dart'
    show InputFieldFactory;
export '../src/base_modules/forms/widgets/app_text_field.dart'
    show AppTextField;
export '../src/base_modules/forms/widgets/password_visibility_icon.dart'
    show ObscureToggleIcon;

//
// ─── VALIDATION (Formz inputs & enums) ────────────────────────────────────────
//
export '../src/base_modules/forms/input_validation/validation_enums.dart';
export '../src/base_modules/forms/input_validation/x_on_forms_submission_status.dart';

//
// ─── UTILS (focus, helpers, services) ─────────────────────────────────────────
//
export '../src/base_modules/forms/utils/use_auth_focus_nodes.dart'
    show
        useSignInFocusNodes,
        useSignUpFocusNodes,
        useChangePasswordFocusNodes,
        useResetPasswordFocusNodes;
export '../src/base_modules/forms/utils/focus_nodes_generator.dart'
    show generateFocusNodes;
export '../src/base_modules/forms/utils/form_validation_service.dart'
    show FormValidationService;
