import 'package:app_on_riverpod/features_presentation/profile/providers/profile_page_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'warmup_provider.g.dart';

/// 🚀 [warmupProvider] — universal warm-up provider for the application.
/// 📌 Purpose is to improves perceived performance and UX by running one-time or background
/// initialization logic as soon as the app starts or when critical dependencies become available.
//
@Riverpod(keepAlive: true)
///
/// ✅ Current behavior:
/// - Listens to [authUidProvider].
/// - 👤 When a `uid` appears → primes the [profileProvider] (fetch without clearing UI).
/// - 🚪 When `uid` disappears → resets the profile state.
void warmup(Ref ref) {
  ref.listen<String?>(
    authUidProvider.select((av) => av.valueOrNull),
    (prev, uid) {
      if (uid != null) {
        // 👤 User signed in → fetch profile without clearing UI
        ref.read(profileProvider.notifier).prime(uid);
      } else {
        // 🚪 User signed out → reset profile state
        ref.read(profileProvider.notifier).resetState();
      }
    },
    fireImmediately: true,
  );
  //
  /// 🔮 Future extensions:
  /// - Preload user preferences or settings.
  /// - Warm up feature flags, localization dictionaries, or cached configuration.
  /// - Trigger background sync tasks.
}
