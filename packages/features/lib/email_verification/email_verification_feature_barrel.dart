/// ✉️ Email Verification Feature — shared domain & data layer.
/// Covers sending verification email and checking verification status.
// ignore_for_file: combinators_ordering, directives_ordering
library;

// ── Domain ────────────────────────────────────────────────────────────────────
export 'domain/repo_contract.dart';
export 'domain/email_verification_use_case.dart';

// ── Data (contracts + implementations) ────────────────────────────────────────
export 'data/remote_database_contract.dart';
export 'data/remote_database_impl.dart';
export 'data/email_verification_repo_impl.dart';
