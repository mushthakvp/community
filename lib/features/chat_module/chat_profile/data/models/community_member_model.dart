import '../../domain/entities/community_member_entity.dart';

class CommunityMemberModel extends CommunityMemberEntity {
  const CommunityMemberModel({
    required super.id,
    required super.name,
    super.profileImage,
    required super.isAdmin,
    required super.isFriend,
    required super.isRequested,
    required super.isCurrentUser,
  });

  factory CommunityMemberModel.fromJson(Map<String, dynamic> json) {
    return CommunityMemberModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      isAdmin: json['isAdmin'] ?? false,
      isFriend: json['isFriend'] ?? false,
      isRequested: json['isRequested'] ?? false,
      isCurrentUser: json['isCurrentUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImage': profileImage,
      'isAdmin': isAdmin,
      'isFriend': isFriend,
      'isRequested': isRequested,
      'isCurrentUser': isCurrentUser,
    };
  }

  factory CommunityMemberModel.fromEntity(CommunityMemberEntity entity) {
    return CommunityMemberModel(
      id: entity.id,
      name: entity.name,
      profileImage: entity.profileImage,
      isAdmin: entity.isAdmin,
      isFriend: entity.isFriend,
      isRequested: entity.isRequested,
      isCurrentUser: entity.isCurrentUser,
    );
  }

  @override
  CommunityMemberModel copyWith({
    String? id,
    String? name,
    String? profileImage,
    bool? isAdmin,
    bool? isFriend,
    bool? isRequested,
    bool? isCurrentUser,
  }) {
    return CommunityMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isAdmin: isAdmin ?? this.isAdmin,
      isFriend: isFriend ?? this.isFriend,
      isRequested: isRequested ?? this.isRequested,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}

class CommunityMembersResponseModel {
  final bool success;
  final String message;
  final List<CommunityMemberModel> members;

  CommunityMembersResponseModel({
    required this.success,
    required this.message,
    required this.members,
  });

  factory CommunityMembersResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityMembersResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      members: json['members'] == null
          ? []
          : List<CommunityMemberModel>.from(
              json['members'].map((x) => CommunityMemberModel.fromJson(x)),
            ),
    );
  }
}
