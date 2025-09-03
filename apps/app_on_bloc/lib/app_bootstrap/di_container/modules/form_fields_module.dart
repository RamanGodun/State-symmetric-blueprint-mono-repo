import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/di/core/di_module_interface.dart';
import 'package:bloc_adapter/di/x_on_get_it.dart';
import 'package:core/base_modules/form_fields/utils/form_validation_service.dart'
    show FormValidationService;

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
    di.registerFactoryIfAbsent(() => const FormValidationService());
  }

  ///
  @override
  Future<void> dispose() async {
    // No resources to dispose for this DI module yet.
  }

  //
}
