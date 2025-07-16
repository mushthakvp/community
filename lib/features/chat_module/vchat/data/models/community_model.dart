import '../../domain/entities/community_entity.dart';

class CommunityModel extends CommunityEntity {
  const CommunityModel({
    required super.id,
    required super.name,
    super.image,
    required super.memberCount,
    super.profileImages,
    super.isJoined,
    super.isCreated,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['_id'] ?? '',
      name: json['groupName'] ?? '',
      image: json['groupProfileImage'],
      memberCount: json['memberCount'] ?? 0,
      profileImages:
          (json['profileImages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isJoined: json['isJoined'] ?? false,
      isCreated: json['isCreated'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'groupName': name,
      'groupProfileImage': image,
      'memberCount': memberCount,
      'profileImages': profileImages,
      'isJoined': isJoined,
      'isCreated': isCreated,
    };
  }

  CommunityModel copyWith({
    String? id,
    String? name,
    String? image,
    int? memberCount,
    List<String>? profileImages,
    bool? isJoined,
    bool? isCreated,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      memberCount: memberCount ?? this.memberCount,
      profileImages: profileImages ?? this.profileImages,
      isJoined: isJoined ?? this.isJoined,
      isCreated: isCreated ?? this.isCreated,
    );
  }
}
