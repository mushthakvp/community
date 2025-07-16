import 'package:equatable/equatable.dart';

import '../../domain/entities/promo_entity.dart';
import '../../domain/entities/social_links_entity.dart';
import '../../domain/entities/video_entity.dart';

class GetPromosModel extends Equatable {
  final bool? success;
  final String? message;
  final List<VideoModel>? videos;
  final List<PromoModel>? promos;
  final SocialLinksModel? socialLinks;

  const GetPromosModel({
    this.success,
    this.message,
    this.videos,
    this.promos,
    this.socialLinks,
  });

  factory GetPromosModel.fromJson(Map<String, dynamic> json) {
    return GetPromosModel(
      success: json["success"] as bool?,
      message: json["message"] as String?,
      videos: json["videos"] == null
          ? []
          : List<VideoModel>.from(
              (json["videos"] as List).map((x) => VideoModel.fromJson(x)),
            ),
      promos: json["promos"] == null
          ? []
          : List<PromoModel>.from(
              (json["promos"] as List).map((x) => PromoModel.fromJson(x)),
            ),
      socialLinks: json["socialLinks"] == null
          ? null
          : SocialLinksModel.fromJson(json["socialLinks"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "videos": videos?.map((x) => x.toJson()).toList() ?? [],
    "promos": promos?.map((x) => x.toJson()).toList() ?? [],
    "socialLinks": socialLinks?.toJson(),
  };

  @override
  List<Object?> get props => [success, message, videos, promos, socialLinks];
}

class PromoModel extends Equatable {
  final String? id;
  final String? coverImage;
  final String? videoUrl;
  final int? loyaltyPoints;
  final bool? isYoutube;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PromoModel({
    this.id,
    this.coverImage,
    this.videoUrl,
    this.loyaltyPoints,
    this.isYoutube,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json["_id"] as String?,
      coverImage: json["coverImage"] as String?,
      videoUrl: json["videoUrl"] as String?,
      loyaltyPoints: json["loyalityPoints"] as int?,
      isYoutube: json["isYoutube"] as bool?,
      isDeleted: json["isDeleted"] as bool?,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "coverImage": coverImage,
    "videoUrl": videoUrl,
    "loyalityPoints": loyaltyPoints,
    "isYoutube": isYoutube,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  PromoEntity toEntity() {
    return PromoEntity(
      id: id ?? '',
      coverImage: coverImage ?? '',
      videoUrl: videoUrl ?? '',
      loyaltyPoints: loyaltyPoints ?? 0,
      isYoutube: isYoutube ?? false,
      isDeleted: isDeleted ?? false,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    coverImage,
    videoUrl,
    loyaltyPoints,
    isYoutube,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class VideoModel extends Equatable {
  final String? title;
  final String? coverImage;
  final String? viewCount;
  final String? videoUrl;
  final int? loyaltyPoints;

  const VideoModel({
    this.title,
    this.coverImage,
    this.viewCount,
    this.videoUrl,
    this.loyaltyPoints,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json["title"] as String?,
      coverImage: json["coverImage"] as String?,
      viewCount: json["viewCount"] as String?,
      videoUrl: json["videoUrl"] as String?,
      loyaltyPoints: json["loyalityPoints"] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "coverImage": coverImage,
    "viewCount": viewCount,
    "videoUrl": videoUrl,
    "loyalityPoints": loyaltyPoints,
  };

  VideoEntity toEntity() {
    return VideoEntity(
      title: title ?? '',
      coverImage: coverImage ?? '',
      viewCount: viewCount ?? '0',
      videoUrl: videoUrl ?? '',
      loyaltyPoints: loyaltyPoints ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    title,
    coverImage,
    viewCount,
    videoUrl,
    loyaltyPoints,
  ];
}

class SocialLinksModel extends Equatable {
  final String? youtubeChannel;
  final String? instagram;
  final String? facebook;
  final String? twitter;

  const SocialLinksModel({
    this.youtubeChannel,
    this.instagram,
    this.facebook,
    this.twitter,
  });

  factory SocialLinksModel.fromJson(Map<String, dynamic> json) {
    return SocialLinksModel(
      youtubeChannel: json["youtubeChannel"] as String?,
      instagram: json["instagram"] as String?,
      facebook: json["facebook"] as String?,
      twitter: json["twitter"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "youtubeChannel": youtubeChannel,
    "instagram": instagram,
    "facebook": facebook,
    "twitter": twitter,
  };

  SocialLinksEntity toEntity() {
    return SocialLinksEntity(
      youtubeChannel: youtubeChannel ?? '',
      instagram: instagram ?? '',
      facebook: facebook ?? '',
      twitter: twitter ?? '',
    );
  }

  @override
  List<Object?> get props => [youtubeChannel, instagram, facebook, twitter];
}
