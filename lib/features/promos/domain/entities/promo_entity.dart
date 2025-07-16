import 'package:equatable/equatable.dart';

class PromoEntity extends Equatable {
  final String id;
  final String coverImage;
  final String videoUrl;
  final int loyaltyPoints;
  final bool isYoutube;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PromoEntity({
    required this.id,
    required this.coverImage,
    required this.videoUrl,
    required this.loyaltyPoints,
    required this.isYoutube,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  PromoEntity copyWith({
    String? id,
    String? coverImage,
    String? videoUrl,
    int? loyaltyPoints,
    bool? isYoutube,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PromoEntity(
      id: id ?? this.id,
      coverImage: coverImage ?? this.coverImage,
      videoUrl: videoUrl ?? this.videoUrl,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      isYoutube: isYoutube ?? this.isYoutube,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

  @override
  String toString() {
    return 'PromoEntity(id: $id, loyaltyPoints: $loyaltyPoints, isYoutube: $isYoutube)';
  }
}
