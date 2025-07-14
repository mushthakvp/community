import '../../domain/entities/friend_entity.dart';

class FriendModel extends FriendEntity {
  const FriendModel({
    required super.id,
    required super.name,
    super.profileImage,
    super.district,
    required super.isOnline,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      district: json['district'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImage': profileImage,
      'district': district,
      'isOnline': isOnline,
    };
  }
}

class FriendsResponseModel {
  final bool success;
  final String message;
  final List<FriendModel> data;

  FriendsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FriendsResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? []
          : List<FriendModel>.from(
              json['data'].map((x) => FriendModel.fromJson(x)),
            ),
    );
  }
}
