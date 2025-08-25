import 'package:core/shared_data_layer/user_data_transfer_objects/_user_dto.dart';
import 'package:core/utils_shared/type_definitions.dart';

/// 🧰 [UserDTOFactories] — Static utilities for creating [UserDTO]
/// ✅ Use case: Firestore mapping, default user creation
//
extension UserDTOFactories on UserDTO {
  ///--------------------------------

  /*
  /// 🔄 Creates [UserDTO] from Firestore document snapshot
  /// ❗️ Throws [FormatException] if document is missing
  static UserDTO fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const FormatException('No user data found in document');
    }

    return UserDTO(
      id: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      profileImage: data['profileImage'] as String? ?? '',
      point: (data['point'] as num?)?.toInt() ?? 0,
      rank: data['rank'] as String? ?? '',
    );
  }
 */

  /// 🔄 Creates [UserDTO] from raw Firestore [Map]
  static UserDTO fromMap(DataMap map, {required String id}) => UserDTO(
    id: id,
    name: map['name'] as String? ?? '',
    email: map['email'] as String? ?? '',
    profileImage: map['profileImage'] as String? ?? '',
    point: (map['point'] as num?)?.toInt() ?? 0,
    rank: map['rank'] as String? ?? '',
  );

  /// 🆕 Creates a new default [UserDTO] for registration
  static UserDTO newUser({
    required String id,
    required String name,
    required String email,
  }) => UserDTO(
    id: id,
    name: name,
    email: email,
    profileImage: 'https://picsum.photos/300',
    point: 0,
    rank: 'bronze',
  );

  //
}
