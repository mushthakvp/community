import '../../domain/entities/profile_data.dart';
import 'user_profile_model.dart';

class ProfileDataModel extends ProfileData {
  const ProfileDataModel({
    required super.success,
    required super.message,
    required super.user,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: UserProfileModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': (user as UserProfileModel).toJson(),
    };
  }
}
