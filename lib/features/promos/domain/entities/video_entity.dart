import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String title;
  final String coverImage;
  final String viewCount;
  final String videoUrl;
  final int loyaltyPoints;

  const VideoEntity({
    required this.title,
    required this.coverImage,
    required this.viewCount,
    required this.videoUrl,
    required this.loyaltyPoints,
  });

  VideoEntity copyWith({
    String? title,
    String? coverImage,
    String? viewCount,
    String? videoUrl,
    int? loyaltyPoints,
  }) {
    return VideoEntity(
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      viewCount: viewCount ?? this.viewCount,
      videoUrl: videoUrl ?? this.videoUrl,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
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

  @override
  String toString() {
    return 'VideoEntity(title: $title, loyaltyPoints: $loyaltyPoints)';
  }
}
