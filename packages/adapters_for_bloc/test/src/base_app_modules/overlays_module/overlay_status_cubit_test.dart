/// Tests for [OverlayStatusCubit]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Cubit initialization
/// - isActive setter
/// - isActive getter
/// - updateStatus method
/// - State transitions
library;

import 'dart:async';

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverlayStatusCubit', () {
    late OverlayStatusCubit cubit;

    setUp(() {
      cubit = OverlayStatusCubit();
    });

    tearDown(() {
      unawaited(cubit.close());
    });

    group('initialization', () {
      test('starts with false (inactive) state', () {
        expect(cubit.state, isFalse);
        expect(cubit.isActive, isFalse);
      });
    });

    group('isActive setter', () {
      test('sets state to true', () {
        // Act
        cubit.isActive = true;

        // Assert
        expect(cubit.state, isTrue);
        expect(cubit.isActive, isTrue);
      });

      test('sets state to false', () {
        // Arrange
        cubit
          ..isActive = true
          // Act
          ..isActive = false;

        // Assert
        expect(cubit.state, isFalse);
        expect(cubit.isActive, isFalse);
      });

      test('emits state change when value changes', () async {
        // Arrange
        final states = <bool>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act
        cubit
          ..isActive = true
          ..isActive = false
          ..isActive = true;

        // Wait for emissions
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states, equals([true, false, true]));
      });
    });

    group('isActive getter', () {
      test('returns current state', () {
        // Arrange
        cubit.isActive = true;

        // Act & Assert
        expect(cubit.isActive, equals(cubit.state));
        expect(cubit.isActive, isTrue);
      });

      test('reflects state changes', () {
        // Act & Assert
        expect(cubit.isActive, isFalse);

        cubit.isActive = true;
        expect(cubit.isActive, isTrue);

        cubit.isActive = false;
        expect(cubit.isActive, isFalse);
      });
    });

    group('updateStatus', () {
      test('updates state to active', () {
        // Act
        cubit.updateStatus(isActive: true);

        // Assert
        expect(cubit.state, isTrue);
        expect(cubit.isActive, isTrue);
      });

      test('updates state to inactive', () {
        // Arrange
        cubit
          ..updateStatus(isActive: true)
          // Act
          ..updateStatus(isActive: false);

        // Assert
        expect(cubit.state, isFalse);
        expect(cubit.isActive, isFalse);
      });

      test('emits state changes', () async {
        // Arrange
        final states = <bool>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act
        cubit
          ..updateStatus(isActive: true)
          ..updateStatus(isActive: false);

        // Wait for emissions
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states, equals([true, false]));
      });

      test('is functionally equivalent to isActive setter', () {
        // Act
        cubit.updateStatus(isActive: true);
        final state1 = cubit.state;

        cubit.isActive = false;
        final state2 = cubit.state;

        // Assert
        expect(state1, isTrue);
        expect(state2, isFalse);
      });
    });

    group('state transitions', () {
      test('handles rapid state changes', () async {
        // Arrange
        final states = <bool>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act - Rapid toggles
        cubit
          ..isActive = true
          ..isActive = false
          ..isActive = true
          ..isActive = false
          ..isActive = true;

        // Wait for all emissions
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states, equals([true, false, true, false, true]));
      });

      test('emits only when value actually changes', () async {
        // Arrange
        final states = <bool>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act - Set same value multiple times
        cubit
          ..isActive = true
          ..isActive = true
          ..isActive = true;

        // Wait for emissions
        await Future<void>.delayed(Duration.zero);

        // Assert - Cubit only emits distinct values
        expect(states, equals([true]));
      });
    });

    group('real-world scenarios', () {
      test('overlay shows and hides', () async {
        // Arrange
        final states = <bool>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act - Show overlay
        cubit.isActive = true;
        expect(cubit.isActive, isTrue);

        // Wait a bit
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Hide overlay
        cubit.isActive = false;
        expect(cubit.isActive, isFalse);

        // Wait for emissions
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states, equals([true, false]));
      });

      test('multiple overlays opening and closing', () async {
        // Arrange
        final states = <bool>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act - Simulate multiple overlay interactions
        cubit
          ..updateStatus(isActive: true) // Overlay 1 opens
          ..updateStatus(isActive: false) // Overlay 1 closes
          ..updateStatus(isActive: true) // Overlay 2 opens
          ..updateStatus(
            isActive: true,
          ) // Overlay 3 opens (still true - BLoC filters duplicate)
          ..updateStatus(isActive: false); // All closed

        // Wait for emissions
        await Future<void>.delayed(Duration.zero);

        // Assert - BLoC filters duplicate emissions, so expect 4 not 5
        expect(states, hasLength(4));
        expect(states, equals([true, false, true, false]));
        expect(states.last, isFalse);
      });

      test('integration with overlay dispatcher', () async {
        // Simulate overlay dispatcher updating status
        final states = <bool>[];
        final subscription = cubit.stream.listen(states.add);
        addTearDown(subscription.cancel);

        // Act - Overlay dispatcher would call these
        cubit.isActive = true; // Before showing overlay
        await Future<void>.delayed(const Duration(milliseconds: 5));

        cubit.isActive = false; // After hiding overlay
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states, equals([true, false]));
      });
    });

    group('lifecycle', () {
      test('can be closed while inactive', () async {
        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });

      test('can be closed while active', () async {
        // Arrange
        cubit.isActive = true;

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
