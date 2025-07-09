import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.success,
    required super.message,
    required super.totalApplied,
    required super.totalPosted,
    required super.user,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      totalApplied: json['totalApplied'] ?? 0,
      totalPosted: json['totalPosted'] ?? 0,
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'totalApplied': totalApplied,
      'totalPosted': totalPosted,
      'user': (user as UserModel).toJson(),
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
