/// Tests for Firebase typedefs
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Type verification for typedef aliases
///
/// Coverage:
/// - UsersCollection typedef
/// - FirebaseUser typedef
/// - FBException typedef
library;

import 'package:adapters_for_firebase/src/utils/typedefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Firebase Typedefs', () {
    group('UsersCollection', () {
      test('is typedef for CollectionReference<Map<String, dynamic>>', () {
        // Assert - Type checking
        expect(
          UsersCollection,
          equals(CollectionReference<Map<String, dynamic>>),
        );
      });
    });

    group('FirebaseUser', () {
      test('is typedef for firebase_auth User', () {
        // Assert - Type checking
        expect(
          FirebaseUser,
          equals(fb_auth.User),
        );
      });
    });

    group('FBException', () {
      test('is typedef for FirebaseException', () {
        // Assert - Type checking
        expect(
          FBException,
          equals(FirebaseException),
        );
      });
    });

    group('real-world usage', () {
      test('typedefs provide consistent API surface', () {
        // This test documents the purpose of typedefs:
        // 1. Hide Firebase SDK imports from feature layers
        // 2. Provide consistent naming
        // 3. Allow easy refactoring if Firebase is replaced

        // Arrange & Act & Assert
        expect(UsersCollection, isNotNull);
        expect(FirebaseUser, isNotNull);
        expect(FBException, isNotNull);
      });
    });
  });
}
