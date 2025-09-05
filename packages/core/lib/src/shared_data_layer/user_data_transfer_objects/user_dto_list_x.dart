import 'package:core/src/shared_data_layer/user_data_transfer_objects/_user_dto.dart';
import 'package:core/src/shared_data_layer/user_data_transfer_objects/user_dto_x.dart';
import 'package:core/src/shared_domain_layer/shared_entities/_user_entity.dart';

/// 🔁 [UserDTOListX] — List-level helper for [UserDTO] → [UserEntity]
/// ✅ Useful for bulk transformations
//
extension UserDTOListX on List<UserDTO> {
  ///----------------------------------
  //
  List<UserEntity> toEntities() => map((dto) => dto.toEntity()).toList();
  //
}
