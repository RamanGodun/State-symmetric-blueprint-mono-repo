// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

/// 👤 [UserEntity] — Domain Entity representing a user in the system
/// ✅ Immutable, comparable via [Equatable], used only in domain logic
//
@immutable
final class UserEntity extends Equatable {
  ///----------------------------------
  /// 🧱 Creates a new [UserEntity] instance
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.point,
    required this.rank,
  });
  //
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final int point;
  final String rank;

  ///
  @override
  List<Object?> get props => [id, name, email, profileImage, point, rank];

  ///
  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, point: $point, rank: $rank)';

  //
}
