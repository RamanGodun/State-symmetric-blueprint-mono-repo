import 'package:equatable/equatable.dart' show Equatable;
import 'package:meta/meta.dart' show sealed;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show FailureType;

/// 🧩 [Failure] — Domain-layer error representation.
/// ✅ Encapsulates structured error data
/// ✅ Used throughout layers (repo → use case → UI)
/// ✅ Supports localized display and diagnostics fallback
///
@sealed
final class Failure extends Equatable {
  /// 🔒 Private constructor to ensure factory usage only
  const Failure({
    required this.type,
    @pragma('vm:entry-point') this.message,
    this.statusCode,
  });

  /// 🧩 Structured metadata (i18n key, code)
  final FailureType type;

  /// 💬 Optional raw error message (e.g. Dio/Firebase message) for fallback when there is no localization in app
  final String? message;

  /// 🔢 Optional HTTP or platform status code
  final int? statusCode;

  @override
  List<Object?> get props => [type, message, statusCode];

  /// 🪪 For diagnostics — fallback code representation
  String get safeCode => statusCode?.toString() ?? type.code;
}
