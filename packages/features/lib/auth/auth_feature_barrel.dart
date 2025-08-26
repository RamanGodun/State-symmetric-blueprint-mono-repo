/// 🔐 Auth Feature — shared domain & data layer (state-manager agnostic).
/// Exposes contracts, use cases, and repo implementations.
// ignore_for_file: combinators_ordering, directives_ordering
library;

// ── Domain ────────────────────────────────────────────────────────────────────
export 'domain/repo_contracts.dart';
export 'domain/use_cases/sign_in.dart';
export 'domain/use_cases/sign_out.dart';
export 'domain/use_cases/sign_up.dart';

// ── Data (contracts + implementations) ────────────────────────────────────────
export 'data/remote_database_contract.dart';
export 'data/remote_database_impl.dart';
export 'data/auth_repo_implementations/sign_in_repo_impl.dart';
export 'data/auth_repo_implementations/sign_out_repo_impl.dart';
export 'data/auth_repo_implementations/sign_up_repo_impl.dart';
