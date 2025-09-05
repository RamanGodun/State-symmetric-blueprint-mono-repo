import 'dart:convert';

import 'package:core/src/shared_data_layer/user_data_transfer_objects/_user_dto.dart';
import 'package:core/src/shared_domain_layer/shared_entities/_user_entity.dart';
import 'package:core/src/utils_shared/type_definitions.dart';

/// 🔄 [UserDTOX] — Instance-level helpers for [UserDTO]
/// ✅ Converts to entity or JSON (for logic or API usage)
//
extension UserDTOX on UserDTO {
  ///------------------------

  /// 🔄 Converts [UserDTO] → Domain [UserEntity] entity
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    profileImage: profileImage,
    point: point,
    rank: rank,
  );

  /// 📦 Converts current [UserDTO] → raw [Map]
  DataMap toJsonMap() => {
    'name': name,
    'email': email,
    'profileImage': profileImage,
    'point': point,
    'rank': rank,
  };

  /// 📦 Converts current [UserDTO] → JSON string
  String toJson() => jsonEncode(toJsonMap());

  /// ❓ Returns true if DTO is empty (based on ID)
  bool get isEmpty => id.isEmpty;

  /// ✅ Negated [isEmpty]
  bool get isNotEmpty => !isEmpty;

  //
}
