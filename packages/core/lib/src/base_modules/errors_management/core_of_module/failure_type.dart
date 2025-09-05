import 'package:core/src/base_modules/errors_management/extensible_part/failure_types/failure_codes.dart';
import 'package:core/src/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:flutter/material.dart';

part '../extensible_part/failure_types/firebase.dart';
part '../extensible_part/failure_types/misc.dart';
part '../extensible_part/failure_types/network.dart';

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
