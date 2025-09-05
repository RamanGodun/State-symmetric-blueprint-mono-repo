import 'package:core/src/base_modules/forms/input_validation/validation_enums.dart';
import 'package:flutter/material.dart';

/// For custom focus nodes generating
Map<InputFieldType, FocusNode> generateFocusNodes(Set<InputFieldType> fields) {
  return {for (final f in fields) f: FocusNode()};
}

// Usage:
// final nodes = generateFocusNodes({InputFieldType.email, InputFieldType.password});
// nodes[InputFieldType.email]!.requestFocus();
