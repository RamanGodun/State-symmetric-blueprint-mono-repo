import 'dart:convert' show jsonEncode;

import 'package:shared_layers/public_api/data_layer_shared.dart' show UserDTO;
import 'package:shared_layers/public_api/domain_layer_shared.dart'
    show UserEntity;
import 'package:shared_utils/public_api/general_utils.dart' show DataMap;

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
