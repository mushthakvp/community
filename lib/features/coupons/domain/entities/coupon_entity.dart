// lib/features/coupons/domain/entities/coupon_entity.dart
import 'package:equatable/equatable.dart';

class CouponEntity extends Equatable {
  final String id;
  final String description;
  final String couponCode;
  final String? websiteLink;
  final AppEntity app;
  final CategoryEntity category;
  final int likes;
  final int dislikes;
  final bool isLiked;
  final bool isDisliked;
  final int usageCount;
  final DateTime? lastUsed;
  final DateTime createdAt;

  const CouponEntity({
    required this.id,
    required this.description,
    required this.couponCode,
    this.websiteLink,
    required this.app,
    required this.category,
    this.likes = 0,
    this.dislikes = 0,
    this.isLiked = false,
    this.isDisliked = false,
    this.usageCount = 0,
    this.lastUsed,
    required this.createdAt,
  });

  CouponEntity copyWith({
    String? id,
    String? description,
    String? couponCode,
    String? websiteLink,
    AppEntity? app,
    CategoryEntity? category,
    int? likes,
    int? dislikes,
    bool? isLiked,
    bool? isDisliked,
    int? usageCount,
    DateTime? lastUsed,
    DateTime? createdAt,
  }) {
    return CouponEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      couponCode: couponCode ?? this.couponCode,
      websiteLink: websiteLink ?? this.websiteLink,
      app: app ?? this.app,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      usageCount: usageCount ?? this.usageCount,
      lastUsed: lastUsed ?? this.lastUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper methods
  bool get hasBeenUsed => usageCount > 0;

  String get displayDescription =>
      description.isNotEmpty ? description : 'No description available';

  String get displayCouponCode => couponCode.isNotEmpty ? couponCode : '';

  String get effectiveWebsiteLink => websiteLink ?? app.websiteLink ?? '';

  bool get isValid => id.isNotEmpty && couponCode.isNotEmpty;

  bool get hasValidApp => app.isValid;

  bool get hasValidCategory => category.isValid;

  @override
  List<Object?> get props => [
    id,
    description,
    couponCode,
    websiteLink,
    app,
    category,
    likes,
    dislikes,
    isLiked,
    isDisliked,
    usageCount,
    lastUsed,
    createdAt,
  ];

  @override
  String toString() {
    return 'CouponEntity(id: $id, description: $description, couponCode: $couponCode, likes: $likes, dislikes: $dislikes, usageCount: $usageCount)';
  }
}

class AppEntity extends Equatable {
  final String id;
  final String name;
  final String logo;
  final String? websiteLink;

  const AppEntity({
    required this.id,
    required this.name,
    required this.logo,
    this.websiteLink,
  });

  AppEntity copyWith({
    String? id,
    String? name,
    String? logo,
    String? websiteLink,
  }) {
    return AppEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      websiteLink: websiteLink ?? this.websiteLink,
    );
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown App';

  String get safeLogoUrl => logo.isNotEmpty ? logo : '';

  String get safeWebsiteUrl => websiteLink ?? '';

  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [id, name, logo, websiteLink];

  @override
  String toString() {
    return 'AppEntity(id: $id, name: $name, logo: $logo, websiteLink: $websiteLink)';
  }
}

class CategoryEntity extends Equatable {
  final String id;
  final String name;

  const CategoryEntity({required this.id, required this.name});

  CategoryEntity copyWith({String? id, String? name}) {
    return CategoryEntity(id: id ?? this.id, name: name ?? this.name);
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown Category';

  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name)';
  }
}
