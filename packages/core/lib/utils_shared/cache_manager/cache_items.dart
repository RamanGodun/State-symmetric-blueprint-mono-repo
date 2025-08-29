part of 'cache_manager.dart';

/// 📦 [_CacheEntry] — Cache value + timestamp wrapper (internal use only)
//
final class _CacheEntry<T> {
  ///--------------------
  /// Stores [value] with [timestamp] when it was cached
  const _CacheEntry(this.value, this.timestamp);

  /// Cached value (generic type [T])
  final T value;

  /// 🕐 Time when value was cached
  final DateTime timestamp;
  //

  //
}

////
////

/// 📊 [CacheStats] — Cache state for monitoring/debugging
//
final class CacheStats {
  ///----------------
  /// Creates immutable snapshot of cache state
  const CacheStats({
    required this.totalItems,
    required this.inFlightRequests,
    required this.ttl,
  });

  /// 📦 Total number of cached items
  final int totalItems;

  /// 🔄 Number of active in-flight async requests
  final int inFlightRequests;

  /// ⏱️ Cache Time-to-Live duration
  final Duration ttl;

  /// 📝 Developer-friendly string representation for logs/debugging
  @override
  String toString() =>
      'CacheStats(items: $totalItems, inFlight: $inFlightRequests, ttl: $ttl)';

  //
}
