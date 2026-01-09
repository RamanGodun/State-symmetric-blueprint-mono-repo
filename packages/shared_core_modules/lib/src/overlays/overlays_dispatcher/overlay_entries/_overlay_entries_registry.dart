// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart' show Widget;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show
        OverlayCategory,
        OverlayDismissPolicy,
        OverlayDispatcher,
        OverlayPriority,
        OverlayReplacePolicy;
import 'package:shared_core_modules/shared_core_modules.dart'
    show AnimationEngine, OverlayDispatcher;
import 'package:shared_utils/public_api/general_utils.dart'
    show IdGenerator, IdNamespace;

// import 'package:uuid/uuid.dart' show Uuid;

part 'banner_overlay_entry.dart';
part 'dialog_overlay_entry.dart';
part 'snackbar_overlay_entry.dart';

/// 🧩 [OverlayUIEntry] — Abstract descriptor for a UI overlay entry
///   - Used in queue management and conflict resolution
///   - Holds config such as dismiss policy, priority, and platform-aware widget
///   - Each entry is uniquely identified by [id] (used to avoid duplicate insertion)
//
sealed class OverlayUIEntry {
  ///---------------------
  /// 🆔 Unique entry identifier (auto-generated if not provided)
  OverlayUIEntry({String? id, IdGenerator? idGen})
    : id = id ?? (idGen ?? overlayIds).next();
  //
  final String id;

  /// 🎛️ Conflict resolution strategy: priority, replacement policy, category
  OverlayConflictStrategy get strategy;

  /// 🔓 Whether user can dismiss overlay via tap on background
  OverlayDismissPolicy? get dismissPolicy;

  /// ☁️ Whether overlay allows taps to pass through background
  bool get tapPassthroughEnabled => false;

  /// 🧱 Builds the overlay widget (platform-specific with animation engine inside)
  Widget buildWidget();

  /// 🧼 Called when overlay is auto-dismissed (e.g. timeout)
  void onAutoDismissed() {}

  //
}

////

////

/// 🧠 [OverlayConflictStrategy] — Strategy object for each overlay that
/// defines its replacement logic and category identification.
/// used to determine behavior when multiple overlays are triggered.
//
final class OverlayConflictStrategy {
  const OverlayConflictStrategy({
    required this.priority,
    required this.policy,
    required this.category,
  });

  ///-----------------------
  //
  final OverlayPriority priority;
  final OverlayReplacePolicy policy;
  final OverlayCategory category;

  //
}

////
////

// Binds to the *current* global generator (honors future overrides in bootstrap)
final overlayIds = IdNamespace.fromGlobal(prefix: 'overlays');
