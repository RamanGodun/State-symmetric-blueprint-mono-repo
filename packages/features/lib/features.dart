/// 🧩 Features — top-level public API for feature domains/contracts.
// ignore_for_file: directives_ordering

library;

// Domain-only public APIs
export 'features_barrels/auth/auth.dart';
// ── Infra-level public APIs (DI wiring, repos, DB impls) ─────────────────
export 'features_barrels/auth/auth_infra.dart';
export 'features_barrels/email_verification/email_verification.dart';
export 'features_barrels/email_verification/email_verification_infra.dart';
export 'features_barrels/password_changing_or_reset/password_changing_or_reset.dart';
export 'features_barrels/password_changing_or_reset/password_changing_or_reset_infra.dart';
export 'features_barrels/profile/profile.dart';
export 'features_barrels/profile/profile_infra.dart';
