import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.profileImage,
    super.joinedDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profileImage': profileImage,
      'joinedDate': joinedDate?.toIso8601String(),
    };
  }
}
