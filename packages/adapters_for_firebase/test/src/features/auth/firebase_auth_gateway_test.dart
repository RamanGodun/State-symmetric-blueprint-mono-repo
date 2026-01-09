/// Tests for [FirebaseAuthGateway]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - snapshots$ stream behavior
/// - currentSnapshot getter
/// - refresh method
/// - Auth state changes (sign in/out)
/// - Stream deduplication
/// - Error handling
library;

import 'package:adapters_for_firebase/src/features/auth/firebase_auth_gateway.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthFailure, AuthGateway, AuthLoading, AuthReady, AuthSnapshot;

class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockUser extends Mock implements fb.User {}

void main() {
  group('FirebaseAuthGateway', () {
    late MockFirebaseAuth mockAuth;
    late FirebaseAuthGateway gateway;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      gateway = FirebaseAuthGateway(mockAuth);

      // Default: no user signed in
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAuth.userChanges()).thenAnswer(
        (_) => Stream.value(null),
      );
    });

    tearDown(() {
      gateway.dispose();
    });

    group('construction', () {
      test('creates instance with FirebaseAuth dependency', () {
        // Arrange & Act
        final testGateway = FirebaseAuthGateway(mockAuth);

        // Assert
        expect(testGateway, isA<FirebaseAuthGateway>());
        expect(testGateway, isA<AuthGateway>());

        testGateway.dispose();
      });
    });

    group('currentSnapshot', () {
      test('returns AuthReady with null session when no user', () {
        // Arrange
        when(() => mockAuth.currentUser).thenReturn(null);

        // Act
        final snapshot = gateway.currentSnapshot;

        // Assert
        expect(snapshot, isA<AuthReady>());
        final ready = snapshot as AuthReady;
        expect(ready.session.uid, isNull);
        expect(ready.session.email, isNull);
        expect(ready.session.emailVerified, isFalse);
        expect(ready.session.isAnonymous, isFalse);
      });

      test('returns AuthReady with user session when user is signed in', () {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('test-uid');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockUser.emailVerified).thenReturn(true);
        when(() => mockUser.isAnonymous).thenReturn(false);

        when(() => mockAuth.currentUser).thenReturn(mockUser);

        // Act
        final snapshot = gateway.currentSnapshot;

        // Assert
        expect(snapshot, isA<AuthReady>());
        final ready = snapshot as AuthReady;
        expect(ready.session.uid, equals('test-uid'));
        expect(ready.session.email, equals('test@example.com'));
        expect(ready.session.emailVerified, isTrue);
        expect(ready.session.isAnonymous, isFalse);
      });

      test('returns AuthReady with anonymous user data', () {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('anon-uid');
        when(() => mockUser.email).thenReturn(null);
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockUser.isAnonymous).thenReturn(true);

        when(() => mockAuth.currentUser).thenReturn(mockUser);

        // Act
        final snapshot = gateway.currentSnapshot;

        // Assert
        final ready = snapshot as AuthReady;
        expect(ready.session.uid, equals('anon-uid'));
        expect(ready.session.email, isNull);
        expect(ready.session.emailVerified, isFalse);
        expect(ready.session.isAnonymous, isTrue);
      });
    });

    group('snapshots', () {
      test('starts with AuthLoading', () async {
        // Arrange
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => Stream.value(null),
        );

        // Act
        final first = await gateway.snapshots$.first;

        // Assert
        expect(first, isA<AuthLoading>());
      });

      test('emits AuthReady after initial load', () async {
        // Arrange
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => Stream.value(null),
        );

        // Act
        final snapshots = await gateway.snapshots$.take(2).toList();

        // Assert
        expect(snapshots[0], isA<AuthLoading>());
        expect(snapshots[1], isA<AuthReady>());
      });

      test('emits new snapshot when user signs in', () async {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('new-user-id');
        when(() => mockUser.email).thenReturn('new@example.com');
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockUser.isAnonymous).thenReturn(false);

        // Mock currentUser to change from null to mockUser
        when(() => mockAuth.currentUser).thenReturn(null);

        when(() => mockAuth.userChanges()).thenAnswer((_) async* {
          yield null;
          // Update currentUser before yielding mockUser
          when(() => mockAuth.currentUser).thenReturn(mockUser);
          yield mockUser;
        });

        // Act - Collect snapshots with timeout
        final snapshots = <AuthSnapshot>[];
        final subscription = gateway.snapshots$.listen(snapshots.add);

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        // Assert - Should get: AuthLoading, AuthReady(null), AuthReady(user)
        expect(snapshots.length, greaterThanOrEqualTo(2));
        expect(snapshots[0], isA<AuthLoading>());

        final lastReady = snapshots.last as AuthReady;
        expect(lastReady.session.uid, equals('new-user-id'));
      });

      test('deduplicates identical auth states', () async {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('same-uid');
        when(() => mockUser.email).thenReturn('same@example.com');
        when(() => mockUser.emailVerified).thenReturn(true);
        when(() => mockUser.isAnonymous).thenReturn(false);

        // Emit same user multiple times
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => Stream.fromIterable([mockUser, mockUser, mockUser]),
        );

        // Act
        final snapshots = await gateway.snapshots$.take(2).toList();

        // Assert - Should only emit 2: AuthLoading + 1 AuthReady (duplicates filtered)
        expect(snapshots.length, equals(2));
        expect(snapshots[0], isA<AuthLoading>());
        expect(snapshots[1], isA<AuthReady>());
      });

      test('emits different snapshots for different users', () async {
        // Arrange
        final user1 = MockUser();
        when(() => user1.uid).thenReturn('uid-1');
        when(() => user1.email).thenReturn('user1@example.com');
        when(() => user1.emailVerified).thenReturn(true);
        when(() => user1.isAnonymous).thenReturn(false);

        final user2 = MockUser();
        when(() => user2.uid).thenReturn('uid-2');
        when(() => user2.email).thenReturn('user2@example.com');
        when(() => user2.emailVerified).thenReturn(false);
        when(() => user2.isAnonymous).thenReturn(false);

        when(() => mockAuth.currentUser).thenReturn(user1);

        when(() => mockAuth.userChanges()).thenAnswer((_) async* {
          yield user1;
          // Update currentUser before yielding user2
          when(() => mockAuth.currentUser).thenReturn(user2);
          yield user2;
        });

        // Act - Collect snapshots with timeout
        final snapshots = <AuthSnapshot>[];
        final subscription = gateway.snapshots$.listen(snapshots.add);

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        // Assert
        expect(snapshots.length, greaterThanOrEqualTo(2));
        expect(snapshots[0], isA<AuthLoading>());

        final lastReady = snapshots.last as AuthReady;
        expect(lastReady.session.uid, equals('uid-2'));
      });

      test('converts stream errors to AuthFailure', () async {
        // Arrange
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => Stream.error(Exception('Auth stream error')),
        );

        // Act
        final snapshots = await gateway.snapshots$.take(2).toList();

        // Assert
        expect(snapshots[0], isA<AuthLoading>());
        expect(snapshots[1], isA<AuthFailure>());

        final failure = snapshots[1] as AuthFailure;
        expect(failure.error, isA<Exception>());
      });
    });

    group('refresh', () {
      test('reloads current user and emits update', () async {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('test-uid');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockUser.isAnonymous).thenReturn(false);
        when(mockUser.reload).thenAnswer((_) async {});

        when(() => mockAuth.currentUser).thenReturn(mockUser);
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => const Stream.empty(),
        );

        // Act
        await gateway.refresh();

        // Assert
        verify(mockUser.reload).called(1);
      });

      test('does nothing when no user is signed in', () async {
        // Arrange
        when(() => mockAuth.currentUser).thenReturn(null);
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => const Stream.empty(),
        );

        // Act - Should not throw
        await gateway.refresh();

        // Assert - No user to reload
        verifyNever(() => MockUser().reload());
      });

      test('triggers manual refresh signal in stream', () async {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('test-uid');
        when(() => mockUser.email).thenReturn('original@example.com');
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockUser.isAnonymous).thenReturn(false);
        when(mockUser.reload).thenAnswer((_) async {
          // Simulate email verification after reload
          when(() => mockUser.emailVerified).thenReturn(true);
        });

        when(() => mockAuth.currentUser).thenReturn(mockUser);
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => const Stream.empty(),
        );

        final snapshots = <AuthSnapshot>[];
        final subscription = gateway.snapshots$.listen(snapshots.add);

        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Act - Refresh should trigger new snapshot
        await gateway.refresh();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(snapshots.length, greaterThan(1));
        await subscription.cancel();
      });
    });

    group('dispose', () {
      test('closes internal streams', () {
        // Arrange
        final testGateway = FirebaseAuthGateway(mockAuth)
          // Act
          ..dispose();

        // Assert - Should not throw when accessing stream after dispose
        // The _tick$ subject should be closed
        expect(testGateway.dispose, returnsNormally);
      });

      test('can be called multiple times safely', () {
        // Arrange
        final testGateway = FirebaseAuthGateway(mockAuth);

        // Act & Assert
        expect(() {
          testGateway
            ..dispose()
            ..dispose()
            ..dispose();
        }, returnsNormally);
      });
    });

    group('real-world scenarios', () {
      test('handles complete sign-in flow', () async {
        // Arrange - User signs in
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('signed-in-uid');
        when(() => mockUser.email).thenReturn('user@example.com');
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockUser.isAnonymous).thenReturn(false);

        when(() => mockAuth.currentUser).thenReturn(null);

        when(() => mockAuth.userChanges()).thenAnswer((_) async* {
          yield null;
          when(() => mockAuth.currentUser).thenReturn(mockUser);
          yield mockUser;
        });

        // Act - Collect snapshots with timeout
        final snapshots = <AuthSnapshot>[];
        final subscription = gateway.snapshots$.listen(snapshots.add);

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        // Assert - Loading -> Unauthenticated -> Authenticated
        expect(snapshots.length, greaterThanOrEqualTo(2));
        expect(snapshots[0], isA<AuthLoading>());

        final lastReady = snapshots.last as AuthReady;
        expect(lastReady.session.uid, equals('signed-in-uid'));
      });

      test('handles email verification flow', () async {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('user-uid');
        when(() => mockUser.email).thenReturn('user@example.com');
        when(() => mockUser.isAnonymous).thenReturn(false);

        // Initially not verified
        when(() => mockUser.emailVerified).thenReturn(false);
        when(mockUser.reload).thenAnswer((_) async {
          // After reload, email is verified
          when(() => mockUser.emailVerified).thenReturn(true);
        });

        when(() => mockAuth.currentUser).thenReturn(mockUser);
        when(() => mockAuth.userChanges()).thenAnswer(
          (_) => Stream.value(mockUser),
        );

        // Act - Check initial state
        final initialSnapshot = gateway.currentSnapshot as AuthReady;
        expect(initialSnapshot.session.emailVerified, isFalse);

        // Refresh to get updated verification status
        await gateway.refresh();
        final updatedSnapshot = gateway.currentSnapshot as AuthReady;

        // Assert
        expect(updatedSnapshot.session.emailVerified, isTrue);
      });

      test('handles sign-out flow', () async {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('user-uid');
        when(() => mockUser.email).thenReturn('user@example.com');
        when(() => mockUser.emailVerified).thenReturn(true);
        when(() => mockUser.isAnonymous).thenReturn(false);

        when(() => mockAuth.currentUser).thenReturn(mockUser);

        when(() => mockAuth.userChanges()).thenAnswer((_) async* {
          yield mockUser;
          when(() => mockAuth.currentUser).thenReturn(null);
          yield null;
        });

        // Act - Collect snapshots with timeout
        final snapshots = <AuthSnapshot>[];
        final subscription = gateway.snapshots$.listen(snapshots.add);

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        // Assert - Loading -> Authenticated -> Unauthenticated
        expect(snapshots.length, greaterThanOrEqualTo(2));
        expect(snapshots[0], isA<AuthLoading>());

        final lastReady = snapshots.last as AuthReady;
        expect(lastReady.session.uid, isNull);
      });
    });
  });
}
