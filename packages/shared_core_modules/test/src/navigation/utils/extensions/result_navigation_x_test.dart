import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ApiFailureType, EitherGetters, Failure, Left, Right;
import 'package:shared_core_modules/public_api/base_modules/navigation.dart';

void main() {
  group('ResultNavigationExt', () {
    group('redirectIfSuccess', () {
      test('calls navigator callback when result is success', () {
        // Arrange
        const result = Right<Failure, String>('success value');
        var navigatorCalled = false;
        String? receivedValue;

        // Act
        result.redirectIfSuccess((value) {
          navigatorCalled = true;
          receivedValue = value;
        });

        // Assert
        expect(navigatorCalled, isTrue);
        expect(receivedValue, equals('success value'));
      });

      test('does not call navigator when result is failure', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Error occurred',
        );
        const result = Left<Failure, String>(failure);
        var navigatorCalled = false;

        // Act
        result.redirectIfSuccess((_) {
          navigatorCalled = true;
        });

        // Assert
        expect(navigatorCalled, isFalse);
      });

      test('returns the same Either instance', () {
        // Arrange
        const result = Right<Failure, int>(42);

        // Act
        final returnedResult = result.redirectIfSuccess((_) {});

        // Assert
        expect(returnedResult, same(result));
        expect(identical(returnedResult, result), isTrue);
      });

      test('navigator receives correct value type', () {
        // Arrange
        const intResult = Right<Failure, int>(123);
        const stringResult = Right<Failure, String>('test');
        const boolResult = Right<Failure, bool>(true);
        int? receivedInt;
        String? receivedString;
        bool? receivedBool;

        // Act
        intResult.redirectIfSuccess((value) => receivedInt = value);
        stringResult.redirectIfSuccess((value) => receivedString = value);
        boolResult.redirectIfSuccess((value) => receivedBool = value);

        // Assert
        expect(receivedInt, equals(123));
        expect(receivedString, equals('test'));
        expect(receivedBool, isTrue);
      });

      test('can be chained with other operations', () {
        // Arrange
        const result = Right<Failure, int>(10);
        var navigated = false;
        int? finalValue;

        // Act
        finalValue = result
            .redirectIfSuccess((_) => navigated = true)
            .fold((_) => 0, (value) => value * 2);

        // Assert
        expect(navigated, isTrue);
        expect(finalValue, equals(20));
      });

      test('navigator can perform side effects', () {
        // Arrange
        const result = Right<Failure, String>('data');
        final sideEffects = <String>[];

        // Act
        result.redirectIfSuccess((value) {
          sideEffects
            ..add('Navigated to page')
            ..add('Logged: $value')
            ..add('Updated state');
        });

        // Assert
        expect(sideEffects, hasLength(3));
        expect(sideEffects[0], equals('Navigated to page'));
        expect(sideEffects[1], equals('Logged: data'));
        expect(sideEffects[2], equals('Updated state'));
      });

      test('handles complex object types', () {
        // Arrange
        final complexObject = {'name': 'John', 'age': 30};
        final result = Right<Failure, Map<String, dynamic>>(complexObject);
        Map<String, dynamic>? receivedObject;

        // Act
        result.redirectIfSuccess((value) => receivedObject = value);

        // Assert
        expect(receivedObject, equals(complexObject));
        expect(receivedObject?['name'], equals('John'));
        expect(receivedObject?['age'], equals(30));
      });

      test('multiple redirectIfSuccess calls work independently', () {
        // Arrange
        const result = Right<Failure, int>(5);
        var callCount = 0;

        // Act
        result
          ..redirectIfSuccess((_) => callCount++)
          ..redirectIfSuccess((_) => callCount++)
          ..redirectIfSuccess((_) => callCount++);

        // Assert
        expect(callCount, equals(3));
      });

      test('does not modify original Either value', () {
        // Arrange
        const originalValue = 'original';
        final result = const Right<Failure, String>(originalValue)
          // Act
          ..redirectIfSuccess((value) {
            // Try to modify (won't affect original since String is immutable)
          });

        // Assert
        final extractedValue = result.fold((_) => '', (value) => value);
        expect(extractedValue, equals(originalValue));
      });

      test('navigator can be a void function', () {
        // Arrange
        const result = Right<Failure, int>(99);

        // Act & Assert - should not throw
        expect(
          () => result.redirectIfSuccess((_) {}),
          returnsNormally,
        );
      });

      test('handles nullable success values', () {
        // Arrange
        const result = Right<Failure, String?>(null);
        var navigatorCalled = false;

        // Act
        result.redirectIfSuccess((value) => navigatorCalled = true);

        // Assert
        // Navigator should NOT be called because rightOrNull returns null
        // and the implementation checks if (value != null)
        expect(navigatorCalled, isFalse);
      });

      test('navigator throwing exception propagates', () {
        // Arrange
        const result = Right<Failure, int>(42);

        void throwingNavigator(int value) {
          throw Exception('Navigation error');
        }

        // Act & Assert
        expect(
          () => result.redirectIfSuccess(throwingNavigator),
          throwsException,
        );
      });
    });
  });

  group('ResultFutureNavigationExt', () {
    group('redirectIfSuccess', () {
      test('calls navigator callback when future result is success', () async {
        // Arrange
        final futureResult = Future.value(
          const Right<Failure, String>('async success'),
        );
        var navigatorCalled = false;
        String? receivedValue;

        // Act
        await futureResult.redirectIfSuccess((value) {
          navigatorCalled = true;
          receivedValue = value;
        });

        // Assert
        expect(navigatorCalled, isTrue);
        expect(receivedValue, equals('async success'));
      });

      test('does not call navigator when future result is failure', () async {
        // Arrange
        const failure = Failure(type: ApiFailureType(), message: 'Async error');
        final futureResult = Future.value(const Left<Failure, String>(failure));
        var navigatorCalled = false;

        // Act
        await futureResult.redirectIfSuccess((_) {
          navigatorCalled = true;
        });

        // Assert
        expect(navigatorCalled, isFalse);
      });

      test('returns the same Either result after await', () async {
        // Arrange
        const originalResult = Right<Failure, int>(42);
        final futureResult = Future.value(originalResult);

        // Act
        final returnedResult = await futureResult.redirectIfSuccess((_) {});

        // Assert
        expect(returnedResult.isRight, isTrue);
        expect(returnedResult.rightOrNull, equals(42));
      });

      test('navigator can be async function', () async {
        // Arrange
        final futureResult = Future.value(const Right<Failure, String>('data'));
        var asyncOperationCompleted = false;

        // Act
        await futureResult.redirectIfSuccess((value) async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          asyncOperationCompleted = true;
        });

        // Assert
        expect(asyncOperationCompleted, isTrue);
      });

      test('navigator receives correct value type from future', () async {
        // Arrange
        final intFuture = Future.value(const Right<Failure, int>(456));
        final stringFuture = Future.value(
          const Right<Failure, String>('async test'),
        );
        int? receivedInt;
        String? receivedString;

        // Act
        await intFuture.redirectIfSuccess((value) => receivedInt = value);
        await stringFuture.redirectIfSuccess(
          (value) => receivedString = value,
        );

        // Assert
        expect(receivedInt, equals(456));
        expect(receivedString, equals('async test'));
      });

      test('can be chained with other async operations', () async {
        // Arrange
        final futureResult = Future.value(const Right<Failure, int>(20));
        var navigated = false;

        // Act
        final result = await futureResult.redirectIfSuccess(
          (_) => navigated = true,
        );
        final finalValue = result.fold((_) => 0, (value) => value * 3);

        // Assert
        expect(navigated, isTrue);
        expect(finalValue, equals(60));
      });

      test('navigator can perform async side effects', () async {
        // Arrange
        final futureResult = Future.value(
          const Right<Failure, String>('async data'),
        );
        final sideEffects = <String>[];

        // Act
        await futureResult.redirectIfSuccess((value) async {
          sideEffects.add('Started navigation');
          await Future<void>.delayed(const Duration(milliseconds: 5));
          sideEffects.add('Completed navigation to $value');
        });

        // Assert
        expect(sideEffects, hasLength(2));
        expect(sideEffects[0], equals('Started navigation'));
        expect(sideEffects[1], equals('Completed navigation to async data'));
      });

      test('handles delayed future resolution', () async {
        // Arrange
        final futureResult = Future.delayed(
          const Duration(milliseconds: 50),
          () => const Right<Failure, String>('delayed'),
        );
        var navigatorCalled = false;

        // Act
        await futureResult.redirectIfSuccess((_) {
          navigatorCalled = true;
        });

        // Assert
        expect(navigatorCalled, isTrue);
      });

      test('handles complex async object types', () async {
        // Arrange
        final complexObject = {'id': 1, 'name': 'Test', 'active': true};
        final futureResult = Future.value(
          Right<Failure, Map<String, dynamic>>(complexObject),
        );
        Map<String, dynamic>? receivedObject;

        // Act
        await futureResult.redirectIfSuccess(
          (value) async => receivedObject = value,
        );

        // Assert
        expect(receivedObject, equals(complexObject));
        expect(receivedObject?['id'], equals(1));
        expect(receivedObject?['name'], equals('Test'));
        expect(receivedObject?['active'], isTrue);
      });

      test('multiple async redirects work sequentially', () async {
        // Arrange
        final futureResult = Future.value(const Right<Failure, int>(10));
        final callOrder = <String>[];

        // Act
        await futureResult.redirectIfSuccess((value) async {
          callOrder.add('first');
          await Future<void>.delayed(const Duration(milliseconds: 10));
        });

        await futureResult.redirectIfSuccess((value) async {
          callOrder.add('second');
          await Future<void>.delayed(const Duration(milliseconds: 10));
        });

        // Assert
        expect(callOrder, equals(['first', 'second']));
      });

      test('does not modify original Future<Either> value', () async {
        // Arrange
        const originalValue = 'original async';
        final futureResult = Future.value(
          const Right<Failure, String>(originalValue),
        );

        // Act
        final result = await futureResult.redirectIfSuccess((_) async {});

        // Assert
        final extractedValue = result.fold((_) => '', (value) => value);
        expect(extractedValue, equals(originalValue));
      });

      test('navigator can be sync or async', () async {
        // Arrange
        final futureResult1 = Future.value(const Right<Failure, int>(1));
        final futureResult2 = Future.value(const Right<Failure, int>(2));
        var syncCalled = false;
        var asyncCalled = false;

        // Act
        await futureResult1.redirectIfSuccess((_) => syncCalled = true);
        await futureResult2.redirectIfSuccess((_) async => asyncCalled = true);

        // Assert
        expect(syncCalled, isTrue);
        expect(asyncCalled, isTrue);
      });

      test('handles nullable async success values', () async {
        // Arrange
        final futureResult = Future.value(const Right<Failure, String?>(null));
        var navigatorCalled = false;

        // Act
        await futureResult.redirectIfSuccess((value) => navigatorCalled = true);

        // Assert
        // Navigator should NOT be called because rightOrNull returns null
        // and the implementation checks if (value != null)
        expect(navigatorCalled, isFalse);
      });

      test('async navigator throwing exception propagates', () async {
        // Arrange
        final futureResult = Future.value(const Right<Failure, int>(99));

        Future<void> throwingNavigator(int value) async {
          await Future<void>.delayed(const Duration(milliseconds: 5));
          throw Exception('Async navigation error');
        }

        // Act & Assert
        expect(
          () => futureResult.redirectIfSuccess(throwingNavigator),
          throwsException,
        );
      });

      test('handles future that completes with failure', () async {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Future failed',
          statusCode: 500,
        );
        final futureResult = Future.value(const Left<Failure, String>(failure));
        var navigatorCalled = false;

        // Act
        final result = await futureResult.redirectIfSuccess((_) async {
          navigatorCalled = true;
        });

        // Assert
        expect(navigatorCalled, isFalse);
        expect(result.isLeft, isTrue);
        final leftValue = result.fold((f) => f, (_) => null);
        expect(leftValue?.message, equals('Future failed'));
      });

      test('preserves result type through async chain', () async {
        // Arrange
        final futureResult = Future.value(
          const Right<Failure, List<int>>([1, 2, 3]),
        );

        // Act
        final result = await futureResult.redirectIfSuccess((_) async {});

        // Assert
        expect(result.isRight, isTrue);
        expect(result.rightOrNull, equals([1, 2, 3]));
        expect(result.rightOrNull, isA<List<int>>());
      });
    });
  });
}
