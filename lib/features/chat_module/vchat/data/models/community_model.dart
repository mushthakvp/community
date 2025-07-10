import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/community_entity.dart';

CommunityResponseModel communityResponseModelFromJson(String str) =>
    CommunityResponseModel.fromJson(json.decode(str));

String communityResponseModelToJson(CommunityResponseModel data) =>
    json.encode(data.toJson());

class CommunityResponseModel extends Equatable {
  final bool? success;
  final CommunityDataModel? data;
  final String? message;

  const CommunityResponseModel({this.success, this.data, this.message});

  factory CommunityResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return CommunityResponseModel(
        success: json["success"] as bool?,
        data: json["data"] != null
            ? CommunityDataModel.fromJson(json["data"])
            : null,
        message: json["message"] as String?,
      );
    } catch (e) {
      return const CommunityResponseModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };

  @override
  List<Object?> get props => [success, data, message];
}

class CommunityDataModel extends Equatable {
  final List<CommunityModel>? data;

  const CommunityDataModel({this.data});

  factory CommunityDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return CommunityDataModel(
        data: json["data"] != null
            ? List<CommunityModel>.from(
                (json["data"] as List).map((x) => CommunityModel.fromJson(x)),
              )
            : null,
      );
    } catch (e) {
      return const CommunityDataModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [data];
}

class CommunityModel extends Equatable {
  final String? id;
  final String? groupName;
  final String? groupProfileImage;
  final String? description;
  final int? memberCount;
  final List<String>? profileImages;
  final bool? isJoined;
  final bool? isAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommunityModel({
    this.id,
    this.groupName,
    this.groupProfileImage,
    this.description,
    this.memberCount,
    this.profileImages,
    this.isJoined,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    try {
      return CommunityModel(
        id: json["_id"] as String? ?? json["id"] as String?,
        groupName: json["groupName"] as String?,
        groupProfileImage: json["groupProfileImage"] as String?,
        description: json["description"] as String?,
        memberCount: json["memberCount"] as int?,
        profileImages: json["profileImages"] != null
            ? List<String>.from(json["profileImages"])
            : null,
        isJoined: json["isJoined"] as bool?,
        isAdmin: json["isAdmin"] as bool?,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
      );
    } catch (e) {
      return const CommunityModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "groupName": groupName,
    "groupProfileImage": groupProfileImage,
    "description": description,
    "memberCount": memberCount,
    "profileImages": profileImages,
    "isJoined": isJoined,
    "isAdmin": isAdmin,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  // Convert to Entity
  CommunityEntity toEntity() {
    return CommunityEntity(
      id: id ?? '',
      name: groupName ?? '',
      profileImage: groupProfileImage,
      description: description,
      memberCount: memberCount ?? 0,
      profileImages: profileImages ?? [],
      isJoined: isJoined ?? false,
      isAdmin: isAdmin ?? false,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt,
    );
  }

  // Create from Entity
  factory CommunityModel.fromEntity(CommunityEntity entity) {
    return CommunityModel(
      id: entity.id,
      groupName: entity.name,
      groupProfileImage: entity.profileImage,
      description: entity.description,
      memberCount: entity.memberCount,
      profileImages: entity.profileImages,
      isJoined: entity.isJoined,
      isAdmin: entity.isAdmin,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    groupName,
    groupProfileImage,
    description,
    memberCount,
    profileImages,
    isJoined,
    isAdmin,
    createdAt,
    updatedAt,
  ];
}
