import 'dart:convert';

import '../../domain/entities/spin_data_entity.dart';
import '../../domain/entities/spin_entity.dart';

// Main response model
GetSpinDataModel getSpinDataModelFromJson(String str) =>
    GetSpinDataModel.fromJson(json.decode(str));

String getSpinDataModelToJson(GetSpinDataModel data) =>
    json.encode(data.toJson());

class GetSpinDataModel {
  final bool? success;
  final List<SpinItemModel>? data;
  final int? userLoyaltyPoints;
  final bool? canSpin;
  final String? message;
  final int? requiredPoints;

  const GetSpinDataModel({
    this.success,
    this.data,
    this.userLoyaltyPoints,
    this.canSpin,
    this.message,
    this.requiredPoints,
  });

  factory GetSpinDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return GetSpinDataModel(
        success: json["success"] as bool?,
        data: json["data"] != null
            ? List<SpinItemModel>.from(
                (json["data"] as List).map((x) => SpinItemModel.fromJson(x)),
              )
            : null,
        userLoyaltyPoints: json["userLoyaltyPoints"] as int?,
        canSpin: json["canSpin"] as bool?,
        message: json["message"] as String?,
        requiredPoints: json["requiredPoints"] as int?,
      );
    } catch (e) {
      return const GetSpinDataModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.map((x) => x.toJson()).toList(),
    "userLoyaltyPoints": userLoyaltyPoints,
    "canSpin": canSpin,
    "message": message,
    "requiredPoints": requiredPoints,
  };

  // Convert to entity
  SpinDataEntity toEntity() {
    return SpinDataEntity(
      success: success ?? false,
      options: data?.map((item) => item.toEntity()).toList() ?? [],
      userLoyaltyPoints: userLoyaltyPoints ?? 0,
      canSpin: canSpin ?? false,
      message: message,
      requiredPoints: requiredPoints ?? 0,
    );
  }
}

// Individual spin item model
class SpinItemModel {
  final String? id;
  final String? type;
  final String? title;
  final bool? isBetterLuck;
  final bool? isSpinAgain;
  final String? image;
  final String? couponCode;
  final int? loyaltyPoint;

  const SpinItemModel({
    this.id,
    this.type,
    this.title,
    this.isBetterLuck,
    this.isSpinAgain,
    this.image,
    this.couponCode,
    this.loyaltyPoint,
  });

  factory SpinItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return SpinItemModel(
        id: json["_id"] as String?,
        type: json["type"] as String?,
        title: json["title"] as String?,
        isBetterLuck: json["isBetterLuck"] as bool?,
        isSpinAgain: json["isSpinAgain"] as bool?,
        image: json["image"] as String?,
        couponCode: json["couponCode"] as String?,
        loyaltyPoint: json["loyaltyPoint"] as int?,
      );
    } catch (e) {
      return const SpinItemModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "title": title,
    "isBetterLuck": isBetterLuck,
    "isSpinAgain": isSpinAgain,
    "image": image,
    "couponCode": couponCode,
    "loyaltyPoint": loyaltyPoint,
  };

  // Convert to entity
  SpinEntity toEntity() {
    return SpinEntity(
      id: id ?? '',
      type: type ?? '',
      title: title ?? 'Better Luck',
      isBetterLuck: isBetterLuck ?? false,
      isSpinAgain: isSpinAgain ?? false,
      image: image,
      couponCode: couponCode,
      loyaltyPoint: loyaltyPoint,
    );
  }
}
