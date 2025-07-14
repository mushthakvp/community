import '../../domain/entities/community_info_entity.dart';

class CommunityInfoModel extends CommunityInfoEntity {
  const CommunityInfoModel({
    required super.id,
    required super.name,
    super.image,
    required super.communityId,
    required super.isCreator,
    required super.isUserInGroup,
    required super.memberCount,
  });

  factory CommunityInfoModel.fromJson(Map<String, dynamic> json) {
    return CommunityInfoModel(
      id: json['_id'] ?? '',
      name: json['groupName'] ?? json['name'] ?? '',
      image: json['groupProfileImage'] ?? json['image'],
      communityId: json['communityId'] ?? json['_id'] ?? '',
      isCreator: json['isCreator'] ?? false,
      isUserInGroup: json['isUserInGroup'] ?? false,
      memberCount: json['memberCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'groupName': name,
      'groupProfileImage': image,
      'communityId': communityId,
      'isCreator': isCreator,
      'isUserInGroup': isUserInGroup,
      'memberCount': memberCount,
    };
  }
}
