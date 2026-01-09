import 'package:flutter/material.dart' show immutable;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show FailureCodes;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show CoreLocaleKeys;

part '../extensible_part/failure_types/firebase_failure_types.dart';
part '../extensible_part/failure_types/misc_failure_types.dart';
part '../extensible_part/failure_types/network_failure_types.dart';

/// 💡 [FailureType] — Centralized descriptor for domain failures
/// ✅ Contains i18n translation key, unique code, and extensibility
//
@immutable
sealed class FailureType {
  ///------------------
  const FailureType({required this.code, required this.translationKey});

  ///
  final String code;

  ///
  final String translationKey;

  //
}
