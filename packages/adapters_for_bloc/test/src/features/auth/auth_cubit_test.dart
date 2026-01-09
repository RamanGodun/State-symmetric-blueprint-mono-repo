/// Tests for [AuthCubit]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - AuthCubit initialization
/// - Stream subscription to AuthGateway
/// - State transitions (Loading → Ready/Error)
/// - Subscription cleanup on dispose
library;

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthFailure, AuthGateway, AuthLoading, AuthReady, AuthSession;

class MockAuthGateway extends Mock implements AuthGateway {}

void main() {
  group('AuthCubit', () {
    late MockAuthGateway mockGateway;

    setUp(() {
      mockGateway = MockAuthGateway();
    });

    group('initialization', () {
      test('starts with AuthViewLoading state', () {
        // Arrange
        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => const Stream.empty(),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert
        expect(cubit.state, isA<AuthViewLoading>());
      });

      test('subscribes to gateway snapshots on creation', () {
        // Arrange
        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => const Stream.empty(),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert
        verify(() => mockGateway.snapshots$).called(1);
      });
    });

    group('state transitions', () {
      test('emits AuthViewLoading when gateway emits AuthLoading', () async {
        // Arrange
        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.value(const AuthLoading()),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert
        await expectLater(
          cubit.stream,
          emits(isA<AuthViewLoading>()),
        );
      });

      test('emits AuthViewReady when gateway emits AuthReady', () async {
        // Arrange
        const testSession = AuthSession(
          uid: 'test-uid',
          email: 'test@example.com',
          emailVerified: true,
          isAnonymous: false,
        );
        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.value(const AuthReady(testSession)),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert
        await expectLater(
          cubit.stream,
          emits(
            isA<AuthViewReady>()
                .having((s) => s.session, 'session', testSession)
                .having((s) => s.session.uid, 'uid', 'test-uid')
                .having(
                  (s) => s.session.email,
                  'email',
                  'test@example.com',
                )
                .having(
                  (s) => s.session.emailVerified,
                  'emailVerified',
                  true,
                ),
          ),
        );
      });

      test('emits AuthViewError when gateway emits AuthFailure', () async {
        // Arrange
        final testError = Exception('Auth failed');
        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.value(AuthFailure(testError)),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert
        await expectLater(
          cubit.stream,
          emits(
            isA<AuthViewError>().having((s) => s.error, 'error', testError),
          ),
        );
      });

      test('handles multiple state transitions', () async {
        // Arrange
        const session = AuthSession(
          uid: 'uid',
          email: 'test@test.com',
          emailVerified: false,
          isAnonymous: false,
        );
        final error = Exception('Error');

        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.fromIterable([
            const AuthLoading(),
            const AuthReady(session),
            AuthFailure(error),
            const AuthLoading(),
          ]),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert
        await expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AuthViewLoading>(),
            isA<AuthViewReady>(),
            isA<AuthViewError>(),
            isA<AuthViewLoading>(),
          ]),
        );
      });
    });

    group('AuthViewState equality', () {
      test('AuthViewLoading instances are equal', () {
        // Arrange & Act
        const state1 = AuthViewLoading();
        const state2 = AuthViewLoading();

        // Assert
        expect(state1, equals(state2));
        expect(state1.props, equals(state2.props));
      });

      test('AuthViewReady instances with same session are equal', () {
        // Arrange & Act
        const session1 = AuthSession(
          uid: 'uid',
          email: 'test@test.com',
          emailVerified: true,
          isAnonymous: false,
        );
        const session2 = AuthSession(
          uid: 'uid',
          email: 'test@test.com',
          emailVerified: true,
          isAnonymous: false,
        );

        const state1 = AuthViewReady(session1);
        const state2 = AuthViewReady(session2);

        // Assert
        expect(state1, equals(state2));
      });

      test('AuthViewReady instances with different sessions are not equal', () {
        // Arrange & Act
        const session1 = AuthSession(
          uid: 'uid1',
          email: 'test1@test.com',
          emailVerified: true,
          isAnonymous: false,
        );
        const session2 = AuthSession(
          uid: 'uid2',
          email: 'test2@test.com',
          emailVerified: false,
          isAnonymous: true,
        );

        const state1 = AuthViewReady(session1);
        const state2 = AuthViewReady(session2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('AuthViewError instances with same error are equal', () {
        // Arrange & Act
        final error = Exception('Test error');
        final state1 = AuthViewError(error);
        final state2 = AuthViewError(error);

        // Assert
        expect(state1, equals(state2));
      });
    });

    group('cleanup', () {
      test('cancels subscription when closed', () async {
        // Arrange
        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => const Stream.empty(),
        );

        final cubit = AuthCubit(gateway: mockGateway);

        // Act
        await cubit.close();

        // Assert - Should not throw and complete successfully
        expect(cubit.isClosed, isTrue);
      });

      test('handles close when stream is still active', () async {
        // Arrange
        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.periodic(
            const Duration(milliseconds: 100),
            (_) => const AuthLoading(),
          ),
        );

        final cubit = AuthCubit(gateway: mockGateway);

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });

    group('real-world scenarios', () {
      test('user signs in successfully', () async {
        // Arrange
        const authenticatedSession = AuthSession(
          uid: 'user-123',
          email: 'user@example.com',
          emailVerified: true,
          isAnonymous: false,
        );

        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.fromIterable([
            const AuthLoading(),
            const AuthReady(authenticatedSession),
          ]),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert - User flow: loading → authenticated
        await expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AuthViewLoading>(),
            isA<AuthViewReady>()
                .having((s) => s.session.uid, 'uid', 'user-123')
                .having(
                  (s) => s.session.emailVerified,
                  'emailVerified',
                  true,
                ),
          ]),
        );
      });

      test('user sign-in fails', () async {
        // Arrange
        final authError = Exception('Invalid credentials');

        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.fromIterable([
            const AuthLoading(),
            AuthFailure(authError),
          ]),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert - User flow: loading → error
        await expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AuthViewLoading>(),
            isA<AuthViewError>().having((s) => s.error, 'error', authError),
          ]),
        );
      });

      test('user signs out', () async {
        // Arrange
        const authenticatedSession = AuthSession(
          uid: 'user-123',
          email: 'user@example.com',
          emailVerified: true,
          isAnonymous: false,
        );

        const unauthenticatedSession = AuthSession(
          emailVerified: false,
          isAnonymous: false,
        );

        when(() => mockGateway.snapshots$).thenAnswer(
          (_) => Stream.fromIterable([
            const AuthReady(authenticatedSession),
            const AuthReady(unauthenticatedSession),
          ]),
        );

        // Act
        final cubit = AuthCubit(gateway: mockGateway);
        addTearDown(cubit.close);

        // Assert - User flow: authenticated → unauthenticated
        await expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AuthViewReady>().having(
              (s) => s.session.uid,
              'uid',
              'user-123',
            ),
            isA<AuthViewReady>().having((s) => s.session.uid, 'uid', null),
          ]),
        );
      });
    });
  });
}
