import 'package:shared_layers/public_api/data_layer_shared.dart' show UserDTO;
import 'package:shared_layers/public_api/domain_layer_shared.dart'
    show UserEntity;
import 'package:shared_layers/src/shared_data_layer/user_data_transfer_objects/user_dto_x.dart'
    show UserDTOX;

/// 🔁 [UserDTOListX] — List-level helper for [UserDTO] → [UserEntity]
/// ✅ Useful for bulk transformations
//
extension UserDTOListX on List<UserDTO> {
  ///----------------------------------
  //
  List<UserEntity> toEntities() => map((dto) => dto.toEntity()).toList();
  //
}
