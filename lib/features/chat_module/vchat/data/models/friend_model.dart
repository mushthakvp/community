import 'package:equatable/equatable.dart';

import '../../domain/entities/friend_entity.dart';

class FriendResponseModel extends Equatable {
  final bool? success;
  final FriendDataModel? data;
  final String? message;

  const FriendResponseModel({this.success, this.data, this.message});

  factory FriendResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return FriendResponseModel(
        success: json["success"] as bool?,
        data: json["data"] != null
            ? FriendDataModel.fromJson(json["data"])
            : null,
        message: json["message"] as String?,
      );
    } catch (e) {
      return const FriendResponseModel();
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

class FriendDataModel extends Equatable {
  final List<FriendModel>? data;

  const FriendDataModel({this.data});

  factory FriendDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return FriendDataModel(
        data: json["data"] != null
            ? List<FriendModel>.from(
                (json["data"] as List).map((x) => FriendModel.fromJson(x)),
              )
            : null,
      );
    } catch (e) {
      return const FriendDataModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [data];
}

class FriendModel extends Equatable {
  final String? id;
  final String? name;
  final String? profileImage;
  final bool? isOnline;
  final DateTime? lastSeen;
  final String? status;
  final DateTime? createdAt;

  const FriendModel({
    this.id,
    this.name,
    this.profileImage,
    this.isOnline,
    this.lastSeen,
    this.status,
    this.createdAt,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    try {
      return FriendModel(
        id: json["_id"] as String? ?? json["id"] as String?,
        name: json["name"] as String?,
        profileImage: json["profileImage"] as String?,
        isOnline: json["isOnline"] as bool?,
        lastSeen: json["lastSeen"] != null
            ? DateTime.tryParse(json["lastSeen"])
            : null,
        status: json["status"] as String?,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
      );
    } catch (e) {
      return const FriendModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profileImage": profileImage,
    "isOnline": isOnline,
    "lastSeen": lastSeen?.toIso8601String(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
  };

  // Convert to Entity
  FriendEntity toEntity() {
    return FriendEntity(
      id: id ?? '',
      name: name ?? '',
      profileImage: profileImage,
      isOnline: isOnline ?? false,
      lastSeen: lastSeen,
      status: _mapStringToFriendStatus(status),
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  // Create from Entity
  factory FriendModel.fromEntity(FriendEntity entity) {
    return FriendModel(
      id: entity.id,
      name: entity.name,
      profileImage: entity.profileImage,
      isOnline: entity.isOnline,
      lastSeen: entity.lastSeen,
      status: entity.status.name,
      createdAt: entity.createdAt,
    );
  }

  FriendStatus _mapStringToFriendStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return FriendStatus.pending;
      case 'accepted':
        return FriendStatus.accepted;
      case 'blocked':
        return FriendStatus.blocked;
      case 'removed':
        return FriendStatus.removed;
      default:
        return FriendStatus.accepted;
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    profileImage,
    isOnline,
    lastSeen,
    status,
    createdAt,
  ];
}
