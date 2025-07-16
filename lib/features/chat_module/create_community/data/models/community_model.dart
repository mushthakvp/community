import '../../domain/entities/community_entity.dart';
import 'member_model.dart';

class CommunityModel extends CommunityEntity {
  const CommunityModel({
    required super.id,
    required super.name,
    super.description,
    super.profileImage,
    super.shareLink,
    super.members,
    super.isCreator,
    super.isUserInGroup,
    super.isUserRequested,
    super.isUserAccepted,
    super.isBot,
    super.role,
    super.userWallpaper,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['groupName'] ?? json['name'] ?? '',
      description: json['description'],
      profileImage: json['groupProfileImage'] ?? json['profileImage'],
      shareLink: json['shareLink'],
      members: json['members'] != null
          ? (json['members'] as List)
                .map((member) => MemberModel.fromJson(member))
                .toList()
          : [],
      isCreator: json['isCreator'] ?? false,
      isUserInGroup: json['isUserInGroup'] ?? false,
      isUserRequested: json['isUserRequested'] ?? false,
      isUserAccepted: json['isUserAccepted'] ?? false,
      isBot: json['isBot'] ?? false,
      role: json['role'],
      userWallpaper: json['userWallpaper'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'groupName': name,
      'description': description,
      'groupProfileImage': profileImage,
      'shareLink': shareLink,
      'members': members
          .map((member) => (member as MemberModel).toJson())
          .toList(),
      'isCreator': isCreator,
      'isUserInGroup': isUserInGroup,
      'isUserRequested': isUserRequested,
      'isUserAccepted': isUserAccepted,
      'isBot': isBot,
      'role': role,
      'userWallpaper': userWallpaper,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? profileImage,
    String? shareLink,
    List<MemberEntity>? members,
    bool? isCreator,
    bool? isUserInGroup,
    bool? isUserRequested,
    bool? isUserAccepted,
    bool? isBot,
    String? role,
    String? userWallpaper,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      shareLink: shareLink ?? this.shareLink,
      members: members ?? this.members,
      isCreator: isCreator ?? this.isCreator,
      isUserInGroup: isUserInGroup ?? this.isUserInGroup,
      isUserRequested: isUserRequested ?? this.isUserRequested,
      isUserAccepted: isUserAccepted ?? this.isUserAccepted,
      isBot: isBot ?? this.isBot,
      role: role ?? this.role,
      userWallpaper: userWallpaper ?? this.userWallpaper,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
