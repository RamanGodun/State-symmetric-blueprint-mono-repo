/// 🔑 Password Changing / Reset Feature — shared domain & data.
/// Encapsulates password change and reset-link flows.
// ignore_for_file: combinators_ordering, directives_ordering
library;

// ── Domain ────────────────────────────────────────────────────────────────────
export 'domain/repo_contract.dart';
export 'domain/password_actions_use_case.dart';

// ── Data (contracts + implementations) ────────────────────────────────────────
export 'data/remote_database_contract.dart';
export 'data/remote_database_impl.dart';
export 'data/password_actions_repo_impl.dart';
