import 'package:equatable/equatable.dart';

import '../../domain/entities/birthday_wish_entity.dart';

class BirthdayWishResponseModel extends Equatable {
  final bool? success;
  final List<BirthdayWishModel>? data;
  final String? message;

  const BirthdayWishResponseModel({this.success, this.data, this.message});

  factory BirthdayWishResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return BirthdayWishResponseModel(
        success: json["success"] as bool?,
        data: json["data"] != null
            ? List<BirthdayWishModel>.from(
                (json["data"] as List).map(
                  (x) => BirthdayWishModel.fromJson(x),
                ),
              )
            : null,
        message: json["message"] as String?,
      );
    } catch (e) {
      return const BirthdayWishResponseModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.map((x) => x.toJson()).toList(),
    "message": message,
  };

  @override
  List<Object?> get props => [success, data, message];
}

class BirthdayWishModel extends Equatable {
  final String? id;
  final String? friendId;
  final String? friendName;
  final String? friendAvatar;
  final DateTime? birthday;
  final bool? hasWished;
  final String? wishMessage;
  final DateTime? wishedAt;

  const BirthdayWishModel({
    this.id,
    this.friendId,
    this.friendName,
    this.friendAvatar,
    this.birthday,
    this.hasWished,
    this.wishMessage,
    this.wishedAt,
  });

  factory BirthdayWishModel.fromJson(Map<String, dynamic> json) {
    try {
      return BirthdayWishModel(
        id: json["_id"] as String? ?? json["id"] as String?,
        friendId: json["friendId"] as String?,
        friendName: json["friendName"] as String?,
        friendAvatar: json["friendAvatar"] as String?,
        birthday: json["birthday"] != null
            ? DateTime.tryParse(json["birthday"])
            : null,
        hasWished: json["hasWished"] as bool?,
        wishMessage: json["wishMessage"] as String?,
        wishedAt: json["wishedAt"] != null
            ? DateTime.tryParse(json["wishedAt"])
            : null,
      );
    } catch (e) {
      return const BirthdayWishModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "friendId": friendId,
    "friendName": friendName,
    "friendAvatar": friendAvatar,
    "birthday": birthday?.toIso8601String(),
    "hasWished": hasWished,
    "wishMessage": wishMessage,
    "wishedAt": wishedAt?.toIso8601String(),
  };

  // Convert to Entity
  BirthdayWishEntity toEntity() {
    return BirthdayWishEntity(
      id: id ?? '',
      friendId: friendId ?? '',
      friendName: friendName ?? '',
      friendAvatar: friendAvatar,
      birthday: birthday ?? DateTime.now(),
      hasWished: hasWished ?? false,
      wishMessage: wishMessage,
      wishedAt: wishedAt,
    );
  }

  // Create from Entity
  factory BirthdayWishModel.fromEntity(BirthdayWishEntity entity) {
    return BirthdayWishModel(
      id: entity.id,
      friendId: entity.friendId,
      friendName: entity.friendName,
      friendAvatar: entity.friendAvatar,
      birthday: entity.birthday,
      hasWished: entity.hasWished,
      wishMessage: entity.wishMessage,
      wishedAt: entity.wishedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    friendId,
    friendName,
    friendAvatar,
    birthday,
    hasWished,
    wishMessage,
    wishedAt,
  ];
}
