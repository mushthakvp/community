import 'package:equatable/equatable.dart';

import 'promo_entity.dart';
import 'social_links_entity.dart';
import 'video_entity.dart';

class PromosData extends Equatable {
  final List<VideoEntity> videos;
  final List<PromoEntity> promos;
  final SocialLinksEntity? socialLinks;

  const PromosData({
    required this.videos,
    required this.promos,
    this.socialLinks,
  });

  PromosData copyWith({
    List<VideoEntity>? videos,
    List<PromoEntity>? promos,
    SocialLinksEntity? socialLinks,
  }) {
    return PromosData(
      videos: videos ?? this.videos,
      promos: promos ?? this.promos,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }

  bool get isEmpty => videos.isEmpty && promos.isEmpty;
  bool get hasVideos => videos.isNotEmpty;
  bool get hasPromos => promos.isNotEmpty;
  bool get hasSocialLinks => socialLinks != null;

  @override
  List<Object?> get props => [videos, promos, socialLinks];

  @override
  String toString() {
    return 'PromosData(videos: ${videos.length}, promos: ${promos.length})';
  }
}
