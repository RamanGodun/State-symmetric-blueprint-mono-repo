// core/lib/utils_shared/id_generator.dart

/// Signature for a pluggable ID generator function.
//
typedef NextId = String Function();

/// Centralized ID generator utility.
///   - Provides a single access point for generating unique IDs.
///   - Implementation can be swapped in one place (e.g. uuid → nanoid → ulid).
///   - Useful for tests (can inject deterministic IDs).
//
final class Id {
  ///-----------------
  Id._();

  /// Generate a new ID using the current generator.
  static String next() => generator();

  /// The current ID generator (can be reassigned in tests or app bootstrap).
  static NextId generator = _defaultNext;

  /// Reset back to the default implementation.
  static void reset() => generator = _defaultNext;
}

////
////

/// Contract for injectable ID generators
//
abstract interface class IdGenerator {
  ///------------------------------
  String next();
}

////

/// Lightweight namespace wrapper around a NextId function.
/// Lets you have per-feature generators (overlayId, userId, etc.).
//
final class IdNamespace implements IdGenerator {
  ///----------------------------------------
  IdNamespace({
    required NextId generator,
    String? prefix,
  }) : _gen = generator,
       _prefix = prefix;

  /// Factory: namespace backed by the current global Id.generator.
  factory IdNamespace.fromGlobal({String? prefix}) =>
      IdNamespace(generator: Id.next, prefix: prefix);

  final NextId _gen;
  final String? _prefix;

  @override
  String next() {
    final raw = _gen();
    // Promote nullable field to a local variable for safe interpolation.
    final p = _prefix;
    return (p == null || p.isEmpty) ? raw : '$p-$raw';
  }
}

////
////

/// ? Replace the body below to change global behavior
//
String _defaultNext() {
  // ? Example options:
  // return nanoid();          // short, URL-safe IDs
  // return const Uuid().v4(); // standard UUID v4

  _c++;
  return 'loc-$_c'; // temporary fallback (no deps)
}

int _c = 0;

/*
? Usage examples:

  ? 1) Global (simple):
final id = Id.next();                   // get a new ID
Id.generator = () => 'test-1';         // inject deterministic IDs in tests
Id.reset();                            // restore default implementation


 ? 2) Per-feature namespaces:
final overlayIds = IdNamespace.fromGlobal(prefix: 'ov');
final userIds    = IdNamespace.fromGlobal(prefix: 'usr');

OverlayUIEntry({String? id, IdGenerator? idGen})
  : id = id ?? (idGen ?? overlayIds).next();


? Elsewhere (e.g. user creation):
final newUserId = userIds.next();


*/
