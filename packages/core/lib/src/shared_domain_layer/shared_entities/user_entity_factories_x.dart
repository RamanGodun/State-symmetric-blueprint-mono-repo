import 'package:core/src/shared_data_layer/user_data_transfer_objects/_user_dto.dart';
import 'package:core/src/shared_domain_layer/shared_entities/_user_entity.dart';

/// 🧩 [UserEntityFactories] — Static-like utilities related to [UserEntity] creation
//
extension UserEntityFactories on UserEntity {
  ///-------------------------------------

  /// 🔰 Returns a predefined empty [UserEntity] placeholder
  static UserEntity empty() => const UserEntity(
    id: '',
    name: '',
    email: '',
    profileImage: '',
    point: 0,
    rank: '',
  );

  /// 🔄 Converts [UserDTO] to [UserEntity] entity (factory-style)
  static UserEntity fromDTO(UserDTO dto) => UserEntity(
    id: dto.id,
    name: dto.name,
    email: dto.email,
    profileImage: dto.profileImage,
    point: dto.point,
    rank: dto.rank,
  );

  /// 🔁 Mass conversion from DTO list to entity list
  static List<UserEntity> fromDTOList(List<UserDTO> list) =>
      list.map(fromDTO).toList();

  //
}
