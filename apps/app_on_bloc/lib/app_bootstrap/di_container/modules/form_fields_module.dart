import 'package:bloc_adapter/bloc_adapter.dart' show DIModule;

///  🔐 Registers form validation service
//
final class FormFieldsModule implements DIModule {
  ///------------------------------------
  //
  @override
  String get name => 'FormFieldsModule';

  ///
  @override
  List<Type> get dependencies => const [];

  ///
  @override
  Future<void> register() async {
    // di.registerFactoryIfAbsent(() => const FormValidationService());
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
