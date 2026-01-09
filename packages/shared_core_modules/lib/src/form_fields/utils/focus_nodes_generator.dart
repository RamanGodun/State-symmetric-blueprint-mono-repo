import 'package:flutter/material.dart' show FocusNode;
import 'package:shared_core_modules/src/form_fields/input_validation/validation_enums.dart'
    show InputFieldType;

/// For custom focus nodes generating
Map<InputFieldType, FocusNode> generateFocusNodes(Set<InputFieldType> fields) {
  return {for (final f in fields) f: FocusNode()};
}

// Usage:
// final nodes = generateFocusNodes({InputFieldType.email, InputFieldType.password});
// nodes[InputFieldType.email]!.requestFocus();
