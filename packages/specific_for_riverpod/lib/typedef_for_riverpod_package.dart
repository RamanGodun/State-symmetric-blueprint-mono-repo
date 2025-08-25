import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;

/// 🔧 [RefCallback] — Provides [WidgetRef] for scoped logic or widget actions
typedef RefCallback = void Function(WidgetRef ref);
