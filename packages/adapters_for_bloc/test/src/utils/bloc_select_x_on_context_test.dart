/// Tests for [BlocWatchSelectX] extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - watchAndSelect method
/// - readBloc method
/// - Widget rebuilds on selected state changes
/// - Widget does not rebuild on non-selected state changes
library;

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Test cubit for testing
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(count: 0, name: 'Test'));

  void increment() => emit(state.copyWith(count: state.count + 1));

  void setName(String name) => emit(state.copyWith(name: name));
}

@immutable
class CounterState {
  const CounterState({required this.count, required this.name});

  final int count;
  final String name;

  CounterState copyWith({int? count, String? name}) {
    return CounterState(
      count: count ?? this.count,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState &&
          runtimeType == other.runtimeType &&
          count == other.count &&
          name == other.name;

  @override
  int get hashCode => count.hashCode ^ name.hashCode;
}

void main() {
  group('BlocWatchSelectX', () {
    group('watchAndSelect', () {
      testWidgets('selects and watches specific state slice', (tester) async {
        // Arrange
        final cubit = CounterCubit();
        int? displayedCount;

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  displayedCount = context
                      .watchAndSelect<CounterCubit, CounterState, int>(
                        (state) => state.count,
                      );
                  return Text('$displayedCount');
                },
              ),
            ),
          ),
        );

        // Assert - Initial value
        expect(displayedCount, equals(0));
        expect(find.text('0'), findsOneWidget);
      });

      testWidgets('rebuilds widget when selected state changes', (
        tester,
      ) async {
        // Arrange
        final cubit = CounterCubit();
        var buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  buildCount++;
                  final count = context
                      .watchAndSelect<CounterCubit, CounterState, int>(
                        (state) => state.count,
                      );
                  return Text('$count');
                },
              ),
            ),
          ),
        );

        final initialBuildCount = buildCount;

        // Act - Change selected state
        cubit.increment();
        await tester.pump();

        // Assert - Widget rebuilt
        expect(buildCount, equals(initialBuildCount + 1));
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('does not rebuild when non-selected state changes', (
        tester,
      ) async {
        // Arrange
        final cubit = CounterCubit();
        var buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  buildCount++;
                  final count = context
                      .watchAndSelect<CounterCubit, CounterState, int>(
                        (state) => state.count,
                      );
                  return Text('$count');
                },
              ),
            ),
          ),
        );

        final initialBuildCount = buildCount;

        // Act - Change non-selected state
        cubit.setName('New Name');
        await tester.pump();

        // Assert - Widget NOT rebuilt (count didn't change)
        expect(buildCount, equals(initialBuildCount));
        expect(find.text('0'), findsOneWidget);
      });

      testWidgets('can select different state slices', (tester) async {
        // Arrange
        final cubit = CounterCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  final count = context
                      .watchAndSelect<CounterCubit, CounterState, int>(
                        (state) => state.count,
                      );
                  final name = context
                      .watchAndSelect<CounterCubit, CounterState, String>(
                        (state) => state.name,
                      );
                  return Column(
                    children: [
                      Text('Count: $count'),
                      Text('Name: $name'),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Assert - Both slices displayed
        expect(find.text('Count: 0'), findsOneWidget);
        expect(find.text('Name: Test'), findsOneWidget);

        // Act - Update count
        cubit.increment();
        await tester.pump();

        // Assert
        expect(find.text('Count: 1'), findsOneWidget);
        expect(find.text('Name: Test'), findsOneWidget);

        // Act - Update name
        cubit.setName('Updated');
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Count: 1'), findsOneWidget);
        expect(find.text('Name: Updated'), findsOneWidget);
      });

      testWidgets('works with complex state transformations', (tester) async {
        // Arrange
        final cubit = CounterCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  // Select computed/derived value
                  final isEven = context
                      .watchAndSelect<CounterCubit, CounterState, bool>(
                        (state) => state.count.isEven,
                      );
                  return Text(isEven ? 'Even' : 'Odd');
                },
              ),
            ),
          ),
        );

        // Assert - Initial (0 is even)
        expect(find.text('Even'), findsOneWidget);

        // Act - Increment to 1 (odd)
        cubit.increment();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Odd'), findsOneWidget);

        // Act - Increment to 2 (even)
        cubit.increment();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Even'), findsOneWidget);
      });
    });

    group('readBloc', () {
      testWidgets('reads bloc without listening', (tester) async {
        // Arrange
        final cubit = CounterCubit();
        CounterCubit? readCubit;

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  readCubit = context.readBloc<CounterCubit>();
                  return const Text('Test');
                },
              ),
            ),
          ),
        );

        // Assert
        expect(readCubit, equals(cubit));
      });

      testWidgets('does not cause rebuilds when state changes', (tester) async {
        // Arrange
        final cubit = CounterCubit();
        var buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  buildCount++;
                  final bloc = context.readBloc<CounterCubit>();
                  return Text('${bloc.state.count}');
                },
              ),
            ),
          ),
        );

        final initialBuildCount = buildCount;

        // Act - Change state
        cubit.increment();
        await tester.pump();

        // Assert - Widget NOT rebuilt (using read, not watch)
        expect(buildCount, equals(initialBuildCount));
      });

      testWidgets('can call methods on read bloc', (tester) async {
        // Arrange
        final cubit = CounterCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      context.readBloc<CounterCubit>().increment();
                    },
                    child: const Text('Increment'),
                  );
                },
              ),
            ),
          ),
        );

        // Act - Tap button
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        expect(cubit.state.count, equals(1));
      });

      testWidgets('is equivalent to context.read()', (tester) async {
        // Arrange
        final cubit = CounterCubit();
        CounterCubit? bloc1;
        CounterCubit? bloc2;

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  bloc1 = context.readBloc<CounterCubit>();
                  bloc2 = context.read<CounterCubit>();
                  return const Text('Test');
                },
              ),
            ),
          ),
        );

        // Assert - Both return same instance
        expect(bloc1, equals(bloc2));
        expect(bloc1, equals(cubit));
      });
    });

    group('real-world scenarios', () {
      testWidgets('efficient list item rendering with watchAndSelect', (
        tester,
      ) async {
        // Arrange
        final cubit = CounterCubit();
        var itemBuildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: ListView(
                children: [
                  Builder(
                    builder: (context) {
                      itemBuildCount++;
                      final count = context
                          .watchAndSelect<CounterCubit, CounterState, int>(
                            (state) => state.count,
                          );
                      return Text('Count: $count');
                    },
                  ),
                  Builder(
                    builder: (context) {
                      final name = context
                          .watchAndSelect<CounterCubit, CounterState, String>(
                            (state) => state.name,
                          );
                      return Text('Name: $name');
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        final initialBuildCount = itemBuildCount;

        // Act - Change name (first item doesn't depend on name)
        cubit.setName('New');
        await tester.pump();

        // Assert - First item (count) not rebuilt
        expect(itemBuildCount, equals(initialBuildCount));
      });

      testWidgets('button callbacks with readBloc', (tester) async {
        // Arrange
        final cubit = CounterCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: cubit,
                child: Builder(
                  builder: (context) {
                    final count = context
                        .watchAndSelect<CounterCubit, CounterState, int>(
                          (state) => state.count,
                        );
                    return Column(
                      children: [
                        Text('Count: $count'),
                        ElevatedButton(
                          onPressed: () {
                            context.readBloc<CounterCubit>().increment();
                          },
                          child: const Text('Increment'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Assert - Initial
        expect(find.text('Count: 0'), findsOneWidget);

        // Act
        await tester.tap(find.text('Increment'));
        await tester.pump();

        // Assert
        expect(find.text('Count: 1'), findsOneWidget);
      });

      testWidgets('mimics Riverpod ref.watch(select) behavior', (tester) async {
        // This test demonstrates Riverpod-like API parity
        final cubit = CounterCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  // BLoC: context.watchAndSelect<Cubit, State, Result>(select)
                  // Riverpod: ref.watch(provider.select(select))
                  final count = context
                      .watchAndSelect<CounterCubit, CounterState, int>(
                        (state) => state.count,
                      );
                  return Text('$count');
                },
              ),
            ),
          ),
        );

        expect(find.text('0'), findsOneWidget);
      });
    });
  });
}
