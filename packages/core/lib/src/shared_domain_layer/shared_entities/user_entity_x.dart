import 'package:core/src/shared_data_layer/user_data_transfer_objects/_user_dto.dart';
import 'package:core/src/shared_domain_layer/shared_entities/_user_entity.dart';

/// 🔁 [UserEntityX] — Extension on [UserEntity] with transformation and utility methods
//
extension UserEntityX on UserEntity {
  ///------------------------------

  /// 🧱 Converts [UserEntity] → [UserDTO] (for persistence or transfer)
  UserDTO toDTO() => UserDTO(
    id: id,
    name: name,
    email: email,
    profileImage: profileImage,
    point: point,
    rank: rank,
  );

  /// 🧱 Allows `.copyWith()` on [UserEntity] entity (immutability support)
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    int? point,
    String? rank,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      point: point ?? this.point,
      rank: rank ?? this.rank,
    );
  }

  /// ❓ Checks if user is considered empty
  bool get isEmpty => id.isEmpty;

  /// ✅ Opposite of [isEmpty]
  bool get isNotEmpty => id.isNotEmpty;

  //
}
