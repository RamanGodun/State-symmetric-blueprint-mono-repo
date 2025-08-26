/// 👤 Profile Feature — shared domain & data (with caching-ready repo).
/// Provides profile fetch/create flows and repo contract.
// ignore_for_file: combinators_ordering, directives_ordering
library;

// ── Domain ────────────────────────────────────────────────────────────────────
export 'domain/repo_contract.dart';
export 'domain/fetch_profile_use_case.dart';

// ── Data (contracts + implementations) ────────────────────────────────────────
export 'data/remote_database_contract.dart';
export 'data/implementation_of_profile_fetch_repo.dart';
