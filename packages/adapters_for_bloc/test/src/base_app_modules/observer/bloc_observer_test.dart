/// Tests for [AppBlocObserver]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - onCreate lifecycle event
/// - onEvent logging (BLoC only)
/// - onChange state transitions
/// - onTransition (BLoC only)
/// - onError handling
/// - onClose lifecycle event
library;

import 'dart:async';

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Test cubit for observer testing
class TestCubit extends Cubit<int> {
  TestCubit() : super(0);

  void increment() => emit(state + 1);

  void throwError() {
    addError(Exception('Test error'), StackTrace.current);
  }
}

// Test bloc for observer testing
class TestBloc extends Bloc<TestEvent, int> {
  TestBloc() : super(0) {
    on<IncrementEvent>((event, emit) => emit(state + 1));
    on<ErrorEvent>((event, emit) => throw Exception('Test error'));
  }
}

abstract class TestEvent {}

class IncrementEvent extends TestEvent {}

class ErrorEvent extends TestEvent {}

void main() {
  group('AppBlocObserver', () {
    late AppBlocObserver observer;
    late List<String> logs;

    setUp(() {
      observer = const AppBlocObserver();
      logs = [];

      // Capture debug prints
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };
    });

    tearDown(() {
      debugPrint = debugPrintSynchronously;
    });

    group('onCreate', () {
      test('logs when cubit is created', () {
        // Arrange
        final cubit = TestCubit();
        addTearDown(cubit.close);

        // Act
        observer.onCreate(cubit);

        // Assert
        expect(
          logs,
          contains(contains('🟢')),
        );
        expect(
          logs.any(
            (log) => log.contains('Created') && log.contains('TestCubit'),
          ),
          isTrue,
        );
      });

      test('logs when bloc is created', () {
        // Arrange
        final bloc = TestBloc();
        addTearDown(bloc.close);

        // Act
        observer.onCreate(bloc);

        // Assert
        expect(
          logs,
          contains(contains('🟢')),
        );
        expect(
          logs.any(
            (log) => log.contains('Created') && log.contains('TestBloc'),
          ),
          isTrue,
        );
      });

      test('includes timestamp in log', () {
        // Arrange
        final cubit = TestCubit();
        addTearDown(cubit.close);

        // Act
        observer.onCreate(cubit);

        // Assert
        expect(
          logs.any((log) => RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(log)),
          isTrue,
        );
      });
    });

    group('onEvent', () {
      test('logs when event is added to bloc', () {
        // Arrange
        final bloc = TestBloc();
        addTearDown(bloc.close);
        final event = IncrementEvent();

        // Act
        observer.onEvent(bloc, event);

        // Assert
        expect(
          logs,
          contains(contains('📨')),
        );
        expect(
          logs.any(
            (log) =>
                log.contains('Event') &&
                log.contains('TestBloc') &&
                log.contains('IncrementEvent'),
          ),
          isTrue,
        );
      });

      test('includes event details in log', () {
        // Arrange
        final bloc = TestBloc();
        addTearDown(bloc.close);
        final event = ErrorEvent();

        // Act
        observer.onEvent(bloc, event);

        // Assert
        expect(
          logs.any((log) => log.contains('ErrorEvent')),
          isTrue,
        );
      });
    });

    group('onChange', () {
      test('logs when cubit state changes', () {
        // Arrange
        final cubit = TestCubit();
        addTearDown(cubit.close);
        const change = Change<int>(currentState: 0, nextState: 1);

        // Act
        observer.onChange(cubit, change);

        // Assert
        expect(
          logs,
          contains(contains('🔄')),
        );
        expect(
          logs.any(
            (log) => log.contains('State') && log.contains('TestCubit'),
          ),
          isTrue,
        );
      });

      test('logs when bloc state changes', () {
        // Arrange
        final bloc = TestBloc();
        addTearDown(bloc.close);
        const change = Change<int>(currentState: 0, nextState: 1);

        // Act
        observer.onChange(bloc, change);

        // Assert
        expect(
          logs.any(
            (log) => log.contains('State') && log.contains('TestBloc'),
          ),
          isTrue,
        );
      });
    });

    group('onTransition', () {
      test('logs bloc transitions', () {
        // Arrange
        final bloc = TestBloc();
        addTearDown(bloc.close);
        final event = IncrementEvent();
        final transition = Transition<TestEvent, int>(
          currentState: 0,
          event: event,
          nextState: 1,
        );

        // Act
        observer.onTransition(bloc, transition);

        // Assert
        expect(
          logs,
          contains(contains('➡️')),
        );
        expect(
          logs.any(
            (log) => log.contains('Transition') && log.contains('TestBloc'),
          ),
          isTrue,
        );
      });

      test('includes transition details in log', () {
        // Arrange
        final bloc = TestBloc();
        addTearDown(bloc.close);
        final event = IncrementEvent();
        final transition = Transition<TestEvent, int>(
          currentState: 0,
          event: event,
          nextState: 1,
        );

        // Act
        observer.onTransition(bloc, transition);

        // Assert
        expect(
          logs.any((log) => log.contains('Transition')),
          isTrue,
        );
      });
    });

    group('onError', () {
      test('logs error from cubit', () {
        // Arrange
        final cubit = TestCubit();
        addTearDown(cubit.close);
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act
        observer.onError(cubit, error, stackTrace);

        // Assert
        expect(
          logs,
          contains(contains('❌')),
        );
        expect(
          logs.any(
            (log) =>
                log.contains('[BLoC]') &&
                log.contains('TestCubit') &&
                log.contains('Test error'),
          ),
          isTrue,
        );
      });

      test('logs error from bloc', () {
        // Arrange
        final bloc = TestBloc();
        addTearDown(bloc.close);
        final error = Exception('Bloc error');
        final stackTrace = StackTrace.current;

        // Act
        observer.onError(bloc, error, stackTrace);

        // Assert
        expect(
          logs.any(
            (log) => log.contains('TestBloc') && log.contains('Bloc error'),
          ),
          isTrue,
        );
      });

      test('logs error type in message', () {
        // Arrange
        final cubit = TestCubit();
        addTearDown(cubit.close);
        final error = Exception('Error');
        final stackTrace = StackTrace.current;

        // Act
        observer.onError(cubit, error, stackTrace);

        // Assert
        expect(
          logs.any((log) => log.contains('_Exception')),
          isTrue,
        );
      });

      test('logs stack trace in debug mode', () {
        // Arrange
        final cubit = TestCubit();
        addTearDown(cubit.close);
        final error = Exception('Error');
        final stackTrace = StackTrace.current;

        // Act
        observer.onError(cubit, error, stackTrace);

        // Assert - Stack trace should be logged
        expect(logs.length, greaterThan(1)); // Error + stack trace
      });
    });

    group('onClose', () {
      test('logs when cubit is closed', () {
        // Arrange
        final cubit = TestCubit();

        // Act
        observer.onClose(cubit);
        unawaited(cubit.close());

        // Assert
        expect(
          logs,
          contains(contains('🔴')),
        );
        expect(
          logs.any(
            (log) => log.contains('Closed') && log.contains('TestCubit'),
          ),
          isTrue,
        );
      });

      test('logs when bloc is closed', () {
        // Arrange
        final bloc = TestBloc();

        // Act
        observer.onClose(bloc);
        unawaited(bloc.close());

        // Assert
        expect(
          logs.any(
            (log) => log.contains('Closed') && log.contains('TestBloc'),
          ),
          isTrue,
        );
      });
    });

    group('integration', () {
      test('observes full cubit lifecycle', () {
        // Arrange
        Bloc.observer = observer;
        final cubit = TestCubit()
          // Act
          ..increment()
          ..increment();

        // Assert - Should log onCreate, onChange (x2)
        expect(
          logs.any(
            (log) => log.contains('Created') && log.contains('TestCubit'),
          ),
          isTrue,
        );
        expect(
          logs.where((log) => log.contains('State')).length,
          equals(2),
        );

        // Cleanup
        unawaited(cubit.close());
      });

      test('observes full bloc lifecycle', () async {
        // Arrange
        Bloc.observer = observer;
        final bloc = TestBloc()
          // Act
          ..add(IncrementEvent())
          ..add(IncrementEvent());

        // Wait for events to process
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert - Should log onCreate, onEvent (x2)
        expect(
          logs.any(
            (log) => log.contains('Created') && log.contains('TestBloc'),
          ),
          isTrue,
        );

        // Cleanup
        unawaited(bloc.close());
      });

      test('observes error in cubit', () {
        // Arrange
        Bloc.observer = observer;
        final cubit = TestCubit()
          // Act
          ..throwError();

        // Assert
        expect(
          logs.any((log) => log.contains('❌') && log.contains('TestCubit')),
          isTrue,
        );

        // Cleanup
        unawaited(cubit.close());
      });
    });

    group('timestamp formatting', () {
      test('timestamp is in ISO8601 format', () {
        // Arrange
        final cubit = TestCubit();
        addTearDown(cubit.close);

        // Act
        observer.onCreate(cubit);

        // Assert - Should contain ISO8601 timestamp
        expect(
          logs.any(
            (log) => RegExp(
              r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}',
            ).hasMatch(log),
          ),
          isTrue,
        );
      });
    });
  });
}
