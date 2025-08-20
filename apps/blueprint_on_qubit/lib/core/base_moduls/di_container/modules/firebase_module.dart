import 'package:blueprint_on_qubit/core/base_moduls/di_container/core/di_module_interface.dart';
import 'package:blueprint_on_qubit/core/base_moduls/di_container/di_container_init.dart'
    show di;
import 'package:blueprint_on_qubit/core/base_moduls/di_container/x_on_get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

///
final class FirebaseModule implements DIModule {
  ///----------------------------------------
  //
  @override
  String get name => 'FirebaseModule';

  ///
  @override
  List<Type> get dependencies => const [];

  ///
  @override
  Future<void> register() async {
    di
      ..registerLazySingletonIfAbsent<FirebaseAuth>(() => FirebaseAuth.instance)
      ..registerLazySingletonIfAbsent<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
      )
      ..registerLazySingletonIfAbsent<
        CollectionReference<Map<String, dynamic>>
      >(
        () => FirebaseFirestore.instance.collection('users'),
      );
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
