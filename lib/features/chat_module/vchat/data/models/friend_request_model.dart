import 'community_model.dart';

class FriendRequestModel {
  final String id;
  final String name;
  final String? profileImage;

  const FriendRequestModel({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }

  CommunityModel toCommunityModel() {
    return CommunityModel(
      id: id,
      name: name,
      image: profileImage,
      memberCount: 0,
      profileImages: const [],
      isJoined: false,
      isCreated: false,
    );
  }
}
