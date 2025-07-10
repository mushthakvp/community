import 'package:equatable/equatable.dart';

class CommunityEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final String? description;
  final int memberCount;
  final List<String> profileImages;
  final bool isJoined;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CommunityEntity({
    required this.id,
    required this.name,
    this.profileImage,
    this.description,
    required this.memberCount,
    this.profileImages = const [],
    this.isJoined = false,
    this.isAdmin = false,
    required this.createdAt,
    this.updatedAt,
  });

  CommunityEntity copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? description,
    int? memberCount,
    List<String>? profileImages,
    bool? isJoined,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      profileImages: profileImages ?? this.profileImages,
      isJoined: isJoined ?? this.isJoined,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => name.isNotEmpty ? name : 'Unknown Community';
  String get safeProfileImage => profileImage ?? '';
  bool get hasMultipleMembers => memberCount > 1;
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    profileImage,
    description,
    memberCount,
    profileImages,
    isJoined,
    isAdmin,
    createdAt,
    updatedAt,
  ];
}
