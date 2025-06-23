// lib/features/coupons/data/models/coupon_model.dart

import 'dart:convert';

import 'package:equatable/equatable.dart';

// Main response model
GetCouponsModel getCouponsModelFromJson(String str) =>
    GetCouponsModel.fromJson(json.decode(str));

String getCouponsModelToJson(GetCouponsModel data) =>
    json.encode(data.toJson());

class GetCouponsModel extends Equatable {
  final bool? success;
  final CouponData? data;
  final String? message;
  final List<BannerModel>? banners;

  const GetCouponsModel({this.success, this.data, this.message, this.banners});

  factory GetCouponsModel.fromJson(Map<String, dynamic> json) {
    try {
      return GetCouponsModel(
        success: json["success"] as bool?,
        data: json["data"] != null ? CouponData.fromJson(json["data"]) : null,
        message: json["message"] as String?,
        banners: json["banners"] != null
            ? List<BannerModel>.from(
                (json["banners"] as List).map((x) => BannerModel.fromJson(x)),
              )
            : null,
      );
    } catch (e) {
      // Return empty model if parsing fails
      return const GetCouponsModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
    "banners": banners?.map((x) => x.toJson()).toList(),
  };

  GetCouponsModel copyWith({
    bool? success,
    CouponData? data,
    String? message,
    List<BannerModel>? banners,
  }) {
    return GetCouponsModel(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
      banners: banners ?? this.banners,
    );
  }

  @override
  List<Object?> get props => [success, data, message, banners];

  @override
  String toString() {
    return 'GetCouponsModel(success: $success, data: $data, message: $message, banners: $banners)';
  }
}

// Banner model
class BannerModel extends Equatable {
  final String? id;
  final String? image;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const BannerModel({
    this.id,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    try {
      return BannerModel(
        id: json["_id"] as String?,
        image: json["image"] as String?,
        type: json["type"] as String?,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
        v: json["__v"] as int?,
      );
    } catch (e) {
      return const BannerModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "type": type,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  BannerModel copyWith({
    String? id,
    String? image,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return BannerModel(
      id: id ?? this.id,
      image: image ?? this.image,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  List<Object?> get props => [id, image, type, createdAt, updatedAt, v];

  @override
  String toString() {
    return 'BannerModel(id: $id, image: $image, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }
}

// Main data container
class CouponData extends Equatable {
  final List<CouponReward>? couponRewards;
  final List<CategoryElement>? categories;
  final List<AppElement>? apps;

  const CouponData({this.couponRewards, this.categories, this.apps});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    try {
      return CouponData(
        couponRewards: json["couponRewards"] != null
            ? List<CouponReward>.from(
                (json["couponRewards"] as List).map(
                  (x) => CouponReward.fromJson(x),
                ),
              )
            : null,
        categories: json["categories"] != null
            ? List<CategoryElement>.from(
                (json["categories"] as List).map(
                  (x) => CategoryElement.fromJson(x),
                ),
              )
            : null,
        apps: json["apps"] != null
            ? List<AppElement>.from(
                (json["apps"] as List).map((x) => AppElement.fromJson(x)),
              )
            : null,
      );
    } catch (e) {
      return const CouponData();
    }
  }

  Map<String, dynamic> toJson() => {
    "couponRewards": couponRewards?.map((x) => x.toJson()).toList(),
    "categories": categories?.map((x) => x.toJson()).toList(),
    "apps": apps?.map((x) => x.toJson()).toList(),
  };

  CouponData copyWith({
    List<CouponReward>? couponRewards,
    List<CategoryElement>? categories,
    List<AppElement>? apps,
  }) {
    return CouponData(
      couponRewards: couponRewards ?? this.couponRewards,
      categories: categories ?? this.categories,
      apps: apps ?? this.apps,
    );
  }

  @override
  List<Object?> get props => [couponRewards, categories, apps];

  @override
  String toString() {
    return 'CouponData(couponRewards: ${couponRewards?.length}, categories: ${categories?.length}, apps: ${apps?.length})';
  }
}

// App model
class AppElement extends Equatable {
  final String? id;
  final String? appName;
  final String? logo;
  final String? websiteLink;
  final bool? isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const AppElement({
    this.id,
    this.appName,
    this.logo,
    this.websiteLink,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AppElement.fromJson(Map<String, dynamic> json) {
    try {
      return AppElement(
        id: json["_id"] as String?,
        appName: json["appName"] as String?,
        logo: json["logo"] as String?,
        websiteLink: json["websiteLink"] as String?,
        isDelete: json["isDelete"] as bool?,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
        v: json["__v"] as int?,
      );
    } catch (e) {
      return const AppElement();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "appName": appName,
    "logo": logo,
    "websiteLink": websiteLink,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  AppElement copyWith({
    String? id,
    String? appName,
    String? logo,
    String? websiteLink,
    bool? isDelete,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return AppElement(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      logo: logo ?? this.logo,
      websiteLink: websiteLink ?? this.websiteLink,
      isDelete: isDelete ?? this.isDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  // Helper methods
  bool get isActive => isDelete != true;

  String get displayName => appName ?? 'Unknown App';

  String get safeLogoUrl => logo ?? '';

  String get safeWebsiteUrl => websiteLink ?? '';

  @override
  List<Object?> get props => [
    id,
    appName,
    logo,
    websiteLink,
    isDelete,
    createdAt,
    updatedAt,
    v,
  ];

  @override
  String toString() {
    return 'AppElement(id: $id, appName: $appName, logo: $logo, websiteLink: $websiteLink, isDelete: $isDelete)';
  }
}

// Category model
class CategoryElement extends Equatable {
  final String? id;
  final String? name;
  final bool? isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const CategoryElement({
    this.id,
    this.name,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryElement(
        id: json["_id"] as String?,
        name: json["name"] as String?,
        isDelete: json["isDelete"] as bool?,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
        v: json["__v"] as int?,
      );
    } catch (e) {
      return const CategoryElement();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "isDelete": isDelete,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  CategoryElement copyWith({
    String? id,
    String? name,
    bool? isDelete,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return CategoryElement(
      id: id ?? this.id,
      name: name ?? this.name,
      isDelete: isDelete ?? this.isDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  // Helper methods
  bool get isActive => isDelete != true;

  String get displayName => name ?? 'Unknown Category';

  @override
  List<Object?> get props => [id, name, isDelete, createdAt, updatedAt, v];

  @override
  String toString() {
    return 'CategoryElement(id: $id, name: $name, isDelete: $isDelete)';
  }
}

// Main coupon reward model
class CouponReward extends Equatable {
  final String? id;
  final CouponRewardApp? app;
  final String? description;
  final CouponRewardCategory? category;
  final String? couponCode;
  final bool? isDelete;
  final String? websiteLink;
  final int? likes;
  final int? dislikes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final UsageByUsers? usageByUsers;
  final bool? isLiked;
  final bool? isDisliked;

  const CouponReward({
    this.id,
    this.app,
    this.description,
    this.category,
    this.couponCode,
    this.isDelete,
    this.likes,
    this.dislikes,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.usageByUsers,
    this.isLiked,
    this.isDisliked,
    this.websiteLink,
  });

  factory CouponReward.fromJson(Map<String, dynamic> json) {
    try {
      return CouponReward(
        id: json["_id"] as String?,
        app: json["app"] != null ? CouponRewardApp.fromJson(json["app"]) : null,
        description: json["description"] as String?,
        category: json["category"] != null
            ? CouponRewardCategory.fromJson(json["category"])
            : null,
        couponCode: json["couponCode"] as String?,
        isDelete: json["isDelete"] as bool?,
        likes: json["likes"] as int?,
        dislikes: json["dislikes"] as int?,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
        v: json["__v"] as int?,
        usageByUsers: json["usageByUsers"] != null
            ? UsageByUsers.fromJson(json["usageByUsers"])
            : null,
        isLiked: json["isLiked"] as bool?,
        isDisliked: json["isDisliked"] as bool?,
        websiteLink: json["websiteLink"] as String?,
      );
    } catch (e) {
      return const CouponReward();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "app": app?.toJson(),
    "description": description,
    "category": category?.toJson(),
    "couponCode": couponCode,
    "isDelete": isDelete,
    "likes": likes,
    "dislikes": dislikes,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "usageByUsers": usageByUsers?.toJson(),
    "isLiked": isLiked,
    "isDisliked": isDisliked,
    "websiteLink": websiteLink,
  };

  CouponReward copyWith({
    String? id,
    CouponRewardApp? app,
    String? description,
    CouponRewardCategory? category,
    String? couponCode,
    bool? isDelete,
    String? websiteLink,
    int? likes,
    int? dislikes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    UsageByUsers? usageByUsers,
    bool? isLiked,
    bool? isDisliked,
  }) {
    return CouponReward(
      id: id ?? this.id,
      app: app ?? this.app,
      description: description ?? this.description,
      category: category ?? this.category,
      couponCode: couponCode ?? this.couponCode,
      isDelete: isDelete ?? this.isDelete,
      websiteLink: websiteLink ?? this.websiteLink,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      usageByUsers: usageByUsers ?? this.usageByUsers,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
    );
  }

  // Helper methods
  bool get isActive => isDelete != true;

  String get displayDescription => description ?? 'No description available';

  String get displayCouponCode => couponCode ?? '';

  int get totalLikes => likes ?? 0;

  int get totalDislikes => dislikes ?? 0;

  int get usageCount => usageByUsers?.count ?? 0;

  bool get hasBeenUsed =>
      usageByUsers?.count != null && usageByUsers!.count! > 0;

  bool get userHasLiked => isLiked ?? false;

  bool get userHasDisliked => isDisliked ?? false;

  String get effectiveWebsiteLink => websiteLink ?? app?.websiteLink ?? '';

  // Validation methods
  bool get isValid =>
      id != null &&
      id!.isNotEmpty &&
      couponCode != null &&
      couponCode!.isNotEmpty &&
      isActive;

  bool get hasValidApp => app != null && app!.isValid;

  bool get hasValidCategory => category != null && category!.isValid;

  @override
  List<Object?> get props => [
    id,
    app,
    description,
    category,
    couponCode,
    isDelete,
    websiteLink,
    likes,
    dislikes,
    createdAt,
    updatedAt,
    v,
    usageByUsers,
    isLiked,
    isDisliked,
  ];

  @override
  String toString() {
    return 'CouponReward(id: $id, description: $description, couponCode: $couponCode, likes: $likes, dislikes: $dislikes)';
  }
}

// Coupon reward app model
class CouponRewardApp extends Equatable {
  final String? id;
  final String? appName;
  final String? logo;
  final String? websiteLink;

  const CouponRewardApp({this.id, this.appName, this.logo, this.websiteLink});

  factory CouponRewardApp.fromJson(Map<String, dynamic> json) {
    try {
      return CouponRewardApp(
        id: json["_id"] as String?,
        appName: json["appName"] as String?,
        logo: json["logo"] as String?,
        websiteLink: json["websiteLink"] as String?,
      );
    } catch (e) {
      return const CouponRewardApp();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "appName": appName,
    "logo": logo,
    "websiteLink": websiteLink,
  };

  CouponRewardApp copyWith({
    String? id,
    String? appName,
    String? logo,
    String? websiteLink,
  }) {
    return CouponRewardApp(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      logo: logo ?? this.logo,
      websiteLink: websiteLink ?? this.websiteLink,
    );
  }

  // Helper methods
  String get displayName => appName ?? 'Unknown App';

  String get safeLogoUrl => logo ?? '';

  String get safeWebsiteUrl => websiteLink ?? '';

  bool get isValid =>
      id != null && id!.isNotEmpty && appName != null && appName!.isNotEmpty;

  @override
  List<Object?> get props => [id, appName, logo, websiteLink];

  @override
  String toString() {
    return 'CouponRewardApp(id: $id, appName: $appName, logo: $logo, websiteLink: $websiteLink)';
  }
}

// Coupon reward category model
class CouponRewardCategory extends Equatable {
  final String? id;
  final String? name;

  const CouponRewardCategory({this.id, this.name});

  factory CouponRewardCategory.fromJson(Map<String, dynamic> json) {
    try {
      return CouponRewardCategory(
        id: json["_id"] as String?,
        name: json["name"] as String?,
      );
    } catch (e) {
      return const CouponRewardCategory();
    }
  }

  Map<String, dynamic> toJson() => {"_id": id, "name": name};

  CouponRewardCategory copyWith({String? id, String? name}) {
    return CouponRewardCategory(id: id ?? this.id, name: name ?? this.name);
  }

  // Helper methods
  String get displayName => name ?? 'Unknown Category';

  bool get isValid =>
      id != null && id!.isNotEmpty && name != null && name!.isNotEmpty;

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() {
    return 'CouponRewardCategory(id: $id, name: $name)';
  }
}

// Usage by users model
class UsageByUsers extends Equatable {
  final int? count;
  final DateTime? lastUsed;

  const UsageByUsers({this.count, this.lastUsed});

  factory UsageByUsers.fromJson(Map<String, dynamic> json) {
    try {
      return UsageByUsers(
        count: json["count"] as int?,
        lastUsed: json["lastUsed"] != null
            ? DateTime.tryParse(json["lastUsed"])
            : null,
      );
    } catch (e) {
      return const UsageByUsers();
    }
  }

  Map<String, dynamic> toJson() => {
    "count": count,
    "lastUsed": lastUsed?.toIso8601String(),
  };

  UsageByUsers copyWith({int? count, DateTime? lastUsed}) {
    return UsageByUsers(
      count: count ?? this.count,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  // Helper methods
  int get safeCount => count ?? 0;

  bool get hasBeenUsed => safeCount > 0;

  String get usageText {
    if (safeCount == 0) return 'Never used';
    if (safeCount == 1) return 'Used once';
    return 'Used $safeCount times';
  }

  @override
  List<Object?> get props => [count, lastUsed];

  @override
  String toString() {
    return 'UsageByUsers(count: $count, lastUsed: $lastUsed)';
  }
}

// Export alias for backward compatibility
typedef Banners = BannerModel;
typedef Data = CouponData;
