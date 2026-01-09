/// Tests for SubmissionFlowStateModel and ButtonSubmissionStateX
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - State construction
/// - Equatable behavior (equality and hashCode)
/// - Extension methods (isLoading, isSuccess, isError, isRequiresReauth)
/// - Failure handling with Consumable
/// - Real-world scenarios (form submission flows)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/src/shared_presentation_layer/state_models/submission_state.dart';

// Helper to create test failures
Failure _testFailure() => const Failure(type: GenericFirebaseFailureType());

void main() {
  group('SubmissionFlowStateModel', () {
    group('SubmissionFlowInitialState', () {
      test('creates instance', () {
        // Arrange & Act
        const state = SubmissionFlowInitialState();

        // Assert
        expect(state, isA<SubmissionFlowStateModel>());
        expect(state, isA<SubmissionFlowInitialState>());
      });

      test('is const constructor', () {
        // Arrange & Act
        const state1 = SubmissionFlowInitialState();
        const state2 = SubmissionFlowInitialState();

        // Assert - Same instances due to const
        expect(identical(state1, state2), isTrue);
      });

      test('has empty props for Equatable', () {
        // Arrange & Act
        const state = SubmissionFlowInitialState();

        // Assert
        expect(state.props, isEmpty);
      });

      test('two instances are equal', () {
        // Arrange & Act
        const state1 = SubmissionFlowInitialState();
        const state2 = SubmissionFlowInitialState();

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('ButtonSubmissionLoadingState', () {
      test('creates instance', () {
        // Arrange & Act
        const state = ButtonSubmissionLoadingState();

        // Assert
        expect(state, isA<SubmissionFlowStateModel>());
        expect(state, isA<ButtonSubmissionLoadingState>());
      });

      test('is const constructor', () {
        // Arrange & Act
        const state1 = ButtonSubmissionLoadingState();
        const state2 = ButtonSubmissionLoadingState();

        // Assert
        expect(identical(state1, state2), isTrue);
      });

      test('has empty props for Equatable', () {
        // Arrange & Act
        const state = ButtonSubmissionLoadingState();

        // Assert
        expect(state.props, isEmpty);
      });

      test('two instances are equal', () {
        // Arrange & Act
        const state1 = ButtonSubmissionLoadingState();
        const state2 = ButtonSubmissionLoadingState();

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('is not equal to other state types', () {
        // Arrange & Act
        const loadingState = ButtonSubmissionLoadingState();
        const initialState = SubmissionFlowInitialState();

        // Assert
        expect(loadingState, isNot(equals(initialState)));
      });
    });

    group('ButtonSubmissionSuccessState', () {
      test('creates instance', () {
        // Arrange & Act
        const state = ButtonSubmissionSuccessState();

        // Assert
        expect(state, isA<SubmissionFlowStateModel>());
        expect(state, isA<ButtonSubmissionSuccessState>());
      });

      test('is const constructor', () {
        // Arrange & Act
        const state1 = ButtonSubmissionSuccessState();
        const state2 = ButtonSubmissionSuccessState();

        // Assert
        expect(identical(state1, state2), isTrue);
      });

      test('has empty props for Equatable', () {
        // Arrange & Act
        const state = ButtonSubmissionSuccessState();

        // Assert
        expect(state.props, isEmpty);
      });

      test('two instances are equal', () {
        // Arrange & Act
        const state1 = ButtonSubmissionSuccessState();
        const state2 = ButtonSubmissionSuccessState();

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('ButtonSubmissionErrorState', () {
      test('creates instance with failure', () {
        // Arrange
        final failure = Consumable(_testFailure());

        // Act
        final state = ButtonSubmissionErrorState(failure);

        // Assert
        expect(state, isA<SubmissionFlowStateModel>());
        expect(state, isA<ButtonSubmissionErrorState>());
        expect(state.failure, equals(failure));
      });

      test('creates instance with null failure', () {
        // Arrange & Act
        const state = ButtonSubmissionErrorState(null);

        // Assert
        expect(state.failure, isNull);
      });

      test('includes failure in props for Equatable', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state = ButtonSubmissionErrorState(failure);

        // Act & Assert
        expect(state.props, equals([failure]));
      });

      test('two instances with same failure are equal', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state1 = ButtonSubmissionErrorState(failure);
        final state2 = ButtonSubmissionErrorState(failure);

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('two instances with different failures are not equal', () {
        // Arrange
        final failure1 = Consumable(_testFailure());
        final failure2 = Consumable(_testFailure());
        final state1 = ButtonSubmissionErrorState(failure1);
        final state2 = ButtonSubmissionErrorState(failure2);

        // Assert - Different Consumable instances
        expect(state1, isNot(equals(state2)));
      });

      test('instance with failure not equal to instance with null', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final stateWithFailure = ButtonSubmissionErrorState(failure);
        const stateWithNull = ButtonSubmissionErrorState(null);

        // Assert
        expect(stateWithFailure, isNot(equals(stateWithNull)));
      });

      test('two instances with null failure are equal', () {
        // Arrange & Act
        const state1 = ButtonSubmissionErrorState(null);
        const state2 = ButtonSubmissionErrorState(null);

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('ButtonSubmissionRequiresReauthState', () {
      test('creates instance with failure', () {
        // Arrange
        final failure = Consumable(_testFailure());

        // Act
        final state = ButtonSubmissionRequiresReauthState(failure);

        // Assert
        expect(state, isA<SubmissionFlowStateModel>());
        expect(state, isA<ButtonSubmissionRequiresReauthState>());
        expect(state.failure, equals(failure));
      });

      test('creates instance with null failure', () {
        // Arrange & Act
        const state = ButtonSubmissionRequiresReauthState(null);

        // Assert
        expect(state.failure, isNull);
      });

      test('includes failure in props for Equatable', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state = ButtonSubmissionRequiresReauthState(failure);

        // Act & Assert
        expect(state.props, equals([failure]));
      });

      test('two instances with same failure are equal', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state1 = ButtonSubmissionRequiresReauthState(failure);
        final state2 = ButtonSubmissionRequiresReauthState(failure);

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('two instances with different failures are not equal', () {
        // Arrange
        final failure1 = Consumable(_testFailure());
        final failure2 = Consumable(_testFailure());
        final state1 = ButtonSubmissionRequiresReauthState(failure1);
        final state2 = ButtonSubmissionRequiresReauthState(failure2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two instances with null failure are equal', () {
        // Arrange & Act
        const state1 = ButtonSubmissionRequiresReauthState(null);
        const state2 = ButtonSubmissionRequiresReauthState(null);

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('sealed class behavior', () {
      test('all state types extend SubmissionFlowStateModel', () {
        // Arrange & Act
        const initial = SubmissionFlowInitialState();
        const loading = ButtonSubmissionLoadingState();
        const success = ButtonSubmissionSuccessState();
        const error = ButtonSubmissionErrorState(null);
        const reauth = ButtonSubmissionRequiresReauthState(null);

        // Assert
        expect(initial, isA<SubmissionFlowStateModel>());
        expect(loading, isA<SubmissionFlowStateModel>());
        expect(success, isA<SubmissionFlowStateModel>());
        expect(error, isA<SubmissionFlowStateModel>());
        expect(reauth, isA<SubmissionFlowStateModel>());
      });

      test('state types are distinct', () {
        // Arrange & Act
        const initial = SubmissionFlowInitialState();
        const loading = ButtonSubmissionLoadingState();
        const success = ButtonSubmissionSuccessState();
        const error = ButtonSubmissionErrorState(null);
        const reauth = ButtonSubmissionRequiresReauthState(null);

        // Assert - All different types
        expect(initial, isNot(equals(loading)));
        expect(loading, isNot(equals(success)));
        expect(success, isNot(equals(error)));
        expect(error, isNot(equals(reauth)));
        expect(reauth, isNot(equals(initial)));
      });
    });
  });

  group('ButtonSubmissionStateX', () {
    group('isLoading', () {
      test('returns true for ButtonSubmissionLoadingState', () {
        // Arrange
        const state = ButtonSubmissionLoadingState();

        // Act & Assert
        expect(state.isLoading, isTrue);
      });

      test('returns false for SubmissionFlowInitialState', () {
        // Arrange
        const state = SubmissionFlowInitialState();

        // Act & Assert
        expect(state.isLoading, isFalse);
      });

      test('returns false for ButtonSubmissionSuccessState', () {
        // Arrange
        const state = ButtonSubmissionSuccessState();

        // Act & Assert
        expect(state.isLoading, isFalse);
      });

      test('returns false for ButtonSubmissionErrorState', () {
        // Arrange
        const state = ButtonSubmissionErrorState(null);

        // Act & Assert
        expect(state.isLoading, isFalse);
      });

      test('returns false for ButtonSubmissionRequiresReauthState', () {
        // Arrange
        const state = ButtonSubmissionRequiresReauthState(null);

        // Act & Assert
        expect(state.isLoading, isFalse);
      });
    });

    group('isSuccess', () {
      test('returns true for ButtonSubmissionSuccessState', () {
        // Arrange
        const state = ButtonSubmissionSuccessState();

        // Act & Assert
        expect(state.isSuccess, isTrue);
      });

      test('returns false for other states', () {
        // Arrange
        const initial = SubmissionFlowInitialState();
        const loading = ButtonSubmissionLoadingState();
        const error = ButtonSubmissionErrorState(null);
        const reauth = ButtonSubmissionRequiresReauthState(null);

        // Act & Assert
        expect(initial.isSuccess, isFalse);
        expect(loading.isSuccess, isFalse);
        expect(error.isSuccess, isFalse);
        expect(reauth.isSuccess, isFalse);
      });
    });

    group('isError', () {
      test('returns true for ButtonSubmissionErrorState', () {
        // Arrange
        const state = ButtonSubmissionErrorState(null);

        // Act & Assert
        expect(state.isError, isTrue);
      });

      test('returns true regardless of failure value', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final stateWithFailure = ButtonSubmissionErrorState(failure);
        const stateWithNull = ButtonSubmissionErrorState(null);

        // Act & Assert
        expect(stateWithFailure.isError, isTrue);
        expect(stateWithNull.isError, isTrue);
      });

      test('returns false for other states', () {
        // Arrange
        const initial = SubmissionFlowInitialState();
        const loading = ButtonSubmissionLoadingState();
        const success = ButtonSubmissionSuccessState();
        const reauth = ButtonSubmissionRequiresReauthState(null);

        // Act & Assert
        expect(initial.isError, isFalse);
        expect(loading.isError, isFalse);
        expect(success.isError, isFalse);
        expect(reauth.isError, isFalse);
      });
    });

    group('isRequiresReauth', () {
      test('returns true for ButtonSubmissionRequiresReauthState', () {
        // Arrange
        const state = ButtonSubmissionRequiresReauthState(null);

        // Act & Assert
        expect(state.isRequiresReauth, isTrue);
      });

      test('returns true regardless of failure value', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final stateWithFailure = ButtonSubmissionRequiresReauthState(failure);
        const stateWithNull = ButtonSubmissionRequiresReauthState(null);

        // Act & Assert
        expect(stateWithFailure.isRequiresReauth, isTrue);
        expect(stateWithNull.isRequiresReauth, isTrue);
      });

      test('returns false for other states', () {
        // Arrange
        const initial = SubmissionFlowInitialState();
        const loading = ButtonSubmissionLoadingState();
        const success = ButtonSubmissionSuccessState();
        const error = ButtonSubmissionErrorState(null);

        // Act & Assert
        expect(initial.isRequiresReauth, isFalse);
        expect(loading.isRequiresReauth, isFalse);
        expect(success.isRequiresReauth, isFalse);
        expect(error.isRequiresReauth, isFalse);
      });
    });

    group('combined extension usage', () {
      test('only one flag is true per state', () {
        // Arrange
        const initial = SubmissionFlowInitialState();
        const loading = ButtonSubmissionLoadingState();
        const success = ButtonSubmissionSuccessState();
        const error = ButtonSubmissionErrorState(null);
        const reauth = ButtonSubmissionRequiresReauthState(null);

        // Assert - Initial state has all flags false
        expect(initial.isLoading, isFalse);
        expect(initial.isSuccess, isFalse);
        expect(initial.isError, isFalse);
        expect(initial.isRequiresReauth, isFalse);

        // Assert - Loading state
        expect(loading.isLoading, isTrue);
        expect(loading.isSuccess, isFalse);
        expect(loading.isError, isFalse);
        expect(loading.isRequiresReauth, isFalse);

        // Assert - Success state
        expect(success.isLoading, isFalse);
        expect(success.isSuccess, isTrue);
        expect(success.isError, isFalse);
        expect(success.isRequiresReauth, isFalse);

        // Assert - Error state
        expect(error.isLoading, isFalse);
        expect(error.isSuccess, isFalse);
        expect(error.isError, isTrue);
        expect(error.isRequiresReauth, isFalse);

        // Assert - Reauth state
        expect(reauth.isLoading, isFalse);
        expect(reauth.isSuccess, isFalse);
        expect(reauth.isError, isFalse);
        expect(reauth.isRequiresReauth, isTrue);
      });
    });
  });

  group('real-world scenarios', () {
    group('login form submission flow', () {
      test('transitions through states during successful login', () {
        // Arrange - Simulating login flow
        final states = <SubmissionFlowStateModel>[
          const SubmissionFlowInitialState(),
        ]
        // Act - User submits login form
        ;
        expect(states.last.isLoading, isFalse);

        // Form starts submitting
        states.add(const ButtonSubmissionLoadingState());
        expect(states.last.isLoading, isTrue);

        // Login succeeds
        states.add(const ButtonSubmissionSuccessState());
        expect(states.last.isSuccess, isTrue);

        // Assert - Correct state transitions
        expect(states.length, equals(3));
        expect(states[0], isA<SubmissionFlowInitialState>());
        expect(states[1], isA<ButtonSubmissionLoadingState>());
        expect(states[2], isA<ButtonSubmissionSuccessState>());
      });

      test('handles login failure', () {
        // Arrange - Simulating failed login
        final states = <SubmissionFlowStateModel>[];
        final failure = Consumable(_testFailure());

        // Act
        states
          ..add(const SubmissionFlowInitialState())
          ..add(const ButtonSubmissionLoadingState())
          ..add(ButtonSubmissionErrorState(failure));

        // Assert
        expect(states.last.isError, isTrue);
        expect(
          (states.last as ButtonSubmissionErrorState).failure,
          equals(failure),
        );
      });
    });

    group('change password flow', () {
      test('requires reauthentication', () {
        // Arrange - User tries to change password
        final states = <SubmissionFlowStateModel>[];
        final reauthFailure = Consumable(_testFailure());

        // Act
        states
          ..add(const SubmissionFlowInitialState())
          ..add(const ButtonSubmissionLoadingState())
          // Backend requires reauth
          ..add(ButtonSubmissionRequiresReauthState(reauthFailure));

        // Assert
        expect(states.last.isRequiresReauth, isTrue);
        final reauthState = states.last as ButtonSubmissionRequiresReauthState;
        expect(reauthState.failure, equals(reauthFailure));
      });

      test('succeeds after reauthentication', () {
        // Arrange
        final states = <SubmissionFlowStateModel>[
          const SubmissionFlowInitialState(),
          const ButtonSubmissionLoadingState(),
          const ButtonSubmissionRequiresReauthState(null),
          const ButtonSubmissionLoadingState(),
          const ButtonSubmissionSuccessState(),
        ]
        // Act - First attempt requires reauth
        // User reauthenticates and tries again
        ;

        // Assert
        expect(states.length, equals(5));
        expect(states[2].isRequiresReauth, isTrue);
        expect(states[4].isSuccess, isTrue);
      });
    });

    group('registration form', () {
      test('handles network error during registration', () {
        // Arrange
        final failure = Consumable(_testFailure());

        // Act
        const initialState = SubmissionFlowInitialState();
        const loadingState = ButtonSubmissionLoadingState();
        final errorState = ButtonSubmissionErrorState(failure);

        // Assert - Can retry from error state
        expect(initialState.isLoading, isFalse);
        expect(loadingState.isLoading, isTrue);
        expect(errorState.isError, isTrue);
        expect(errorState.failure, isNotNull);
      });

      test('successful registration flow', () {
        // Arrange
        final states = <SubmissionFlowStateModel>[
          const SubmissionFlowInitialState(),
          const ButtonSubmissionLoadingState(),
          const ButtonSubmissionSuccessState(),
        ]
        // Act - User fills form and submits
        ;

        // Assert - Navigate to next screen on success
        expect(states.last.isSuccess, isTrue);
      });
    });

    group('UI conditional rendering', () {
      test('shows loading indicator when isLoading is true', () {
        // Arrange
        const state = ButtonSubmissionLoadingState();

        // Act
        final shouldShowLoader = state.isLoading;
        final shouldDisableButton = state.isLoading;

        // Assert
        expect(shouldShowLoader, isTrue);
        expect(shouldDisableButton, isTrue);
      });

      test('shows success message when isSuccess is true', () {
        // Arrange
        const state = ButtonSubmissionSuccessState();

        // Act
        final shouldShowSuccessMessage = state.isSuccess;
        final shouldNavigateAway = state.isSuccess;

        // Assert
        expect(shouldShowSuccessMessage, isTrue);
        expect(shouldNavigateAway, isTrue);
      });

      test('shows error message when isError is true', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state = ButtonSubmissionErrorState(failure);

        // Act
        final shouldShowError = state.isError;
        final errorToDisplay = state.failure;

        // Assert
        expect(shouldShowError, isTrue);
        expect(errorToDisplay, isNotNull);
      });

      test('shows reauth dialog when isRequiresReauth is true', () {
        // Arrange
        const state = ButtonSubmissionRequiresReauthState(null);

        // Act
        final shouldShowReauthDialog = state.isRequiresReauth;

        // Assert
        expect(shouldShowReauthDialog, isTrue);
      });

      test('enables button only when not loading', () {
        // Arrange
        const initial = SubmissionFlowInitialState();
        const loading = ButtonSubmissionLoadingState();
        const success = ButtonSubmissionSuccessState();
        const error = ButtonSubmissionErrorState(null);

        // Act & Assert
        expect(initial.isLoading, isFalse); // Button enabled
        expect(loading.isLoading, isTrue); // Button disabled
        expect(success.isLoading, isFalse); // Button enabled
        expect(error.isLoading, isFalse); // Button enabled
      });
    });

    group('state machine transitions', () {
      test('typical happy path state flow', () {
        // Arrange
        SubmissionFlowStateModel currentState =
            const SubmissionFlowInitialState();

        // Act & Assert - Initial
        expect(currentState, isA<SubmissionFlowInitialState>());

        // User taps submit
        currentState = const ButtonSubmissionLoadingState();
        expect(currentState.isLoading, isTrue);

        // Request succeeds
        currentState = const ButtonSubmissionSuccessState();
        expect(currentState.isSuccess, isTrue);
      });

      test('error recovery flow', () {
        // Arrange
        SubmissionFlowStateModel currentState =
            const SubmissionFlowInitialState();
        final failure = Consumable(_testFailure());

        // Act - First attempt fails
        currentState = const ButtonSubmissionLoadingState();
        currentState = ButtonSubmissionErrorState(failure);
        expect(currentState.isError, isTrue);

        // User retries
        currentState = const ButtonSubmissionLoadingState();
        expect(currentState.isLoading, isTrue);

        // Second attempt succeeds
        currentState = const ButtonSubmissionSuccessState();
        expect(currentState.isSuccess, isTrue);
      });

      test('reauth required flow', () {
        // Arrange
        SubmissionFlowStateModel currentState =
            const SubmissionFlowInitialState();

        // Act - Submission requires reauth
        currentState = const ButtonSubmissionLoadingState();
        currentState = const ButtonSubmissionRequiresReauthState(null);
        expect(currentState.isRequiresReauth, isTrue);

        // User cancels reauth
        currentState = const SubmissionFlowInitialState();
        expect(currentState.isLoading, isFalse);
        expect(currentState.isRequiresReauth, isFalse);
      });
    });

    group('failure consumption pattern', () {
      test('can consume failure after displaying', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state = ButtonSubmissionErrorState(failure);

        // Act - Display error message
        expect(state.isError, isTrue);
        final displayedFailure = state.failure?.consume();

        // Assert - Failure consumed
        expect(displayedFailure, isA<Failure>());
        expect(state.failure?.isConsumed, isTrue);
      });

      test('handles already consumed failure', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state = ButtonSubmissionErrorState(failure);

        // Act - Consume once
        state.failure?.consume();
        final secondConsume = state.failure?.consume();

        // Assert - Returns null on second consume
        expect(secondConsume, isNull);
        expect(state.failure?.isConsumed, isTrue);
      });

      test('reauth state also supports failure consumption', () {
        // Arrange
        final failure = Consumable(_testFailure());
        final state = ButtonSubmissionRequiresReauthState(failure);

        // Act
        final consumedFailure = state.failure?.consume();

        // Assert
        expect(consumedFailure, isA<Failure>());
        expect(state.failure?.isConsumed, isTrue);
      });
    });
  });
}
