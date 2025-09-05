/// 🔐 Auth — domain contracts & use cases (infra-free public API).
// ignore_for_file: combinators_ordering, directives_ordering
library;

// ── Domain ──────────
export '../../src/auth/domain/repo_contracts.dart';
export '../../src/auth/domain/use_cases/sign_in.dart';
export '../../src/auth/domain/use_cases/sign_out.dart';
export '../../src/auth/domain/use_cases/sign_up.dart';

// ❌ No data implementations exported here
// (keep infra behind DI or a separate internal barrel)
