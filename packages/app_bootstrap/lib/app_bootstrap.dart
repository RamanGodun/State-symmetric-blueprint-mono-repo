//
// ignore_for_file: directives_ordering, dangling_library_doc_comments

/// 🚀 App Bootstrap — Public API
/// ✅ Exports only clean, curated interfaces (no src leaks!)
/// ✅ Organized by logical sections for clarity & scalability
///

/// ---------------- CONFIG ----------------
export 'src/configs/env.dart';
export 'src/configs/flavor.dart';
export 'src/configs/platform_requirements.dart';

/// ------------- BOOTSTRAP CONTRACTS -------------
export 'src/bootstrap_contracts/bootstrap.dart';
export 'src/bootstrap_contracts/local_storage.dart';
export 'src/bootstrap_contracts/remote_database.dart';

/// ----------------- APP LAUNCHER -----------------
export 'src/utils/app_launcher.dart';

/// -------------- PLATFORM CHECKS -----------------
export 'src/utils/platform_validation.dart';
