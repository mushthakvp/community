import 'package:equatable/equatable.dart';

class CommunityEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? profileImage;
  final String? shareLink;
  final List<MemberEntity> members;
  final bool isCreator;
  final bool isUserInGroup;
  final bool isUserRequested;
  final bool isUserAccepted;
  final bool isBot;
  final String? role;
  final String? userWallpaper;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommunityEntity({
    required this.id,
    required this.name,
    this.description,
    this.profileImage,
    this.shareLink,
    this.members = const [],
    this.isCreator = false,
    this.isUserInGroup = false,
    this.isUserRequested = false,
    this.isUserAccepted = false,
    this.isBot = false,
    this.role,
    this.userWallpaper,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    profileImage,
    shareLink,
    members,
    isCreator,
    isUserInGroup,
    isUserRequested,
    isUserAccepted,
    isBot,
    role,
    userWallpaper,
    createdAt,
    updatedAt,
  ];

  CommunityEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? profileImage,
    String? shareLink,
    List<MemberEntity>? members,
    bool? isCreator,
    bool? isUserInGroup,
    bool? isUserRequested,
    bool? isUserAccepted,
    bool? isBot,
    String? role,
    String? userWallpaper,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      shareLink: shareLink ?? this.shareLink,
      members: members ?? this.members,
      isCreator: isCreator ?? this.isCreator,
      isUserInGroup: isUserInGroup ?? this.isUserInGroup,
      isUserRequested: isUserRequested ?? this.isUserRequested,
      isUserAccepted: isUserAccepted ?? this.isUserAccepted,
      isBot: isBot ?? this.isBot,
      role: role ?? this.role,
      userWallpaper: userWallpaper ?? this.userWallpaper,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MemberEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final String? role;
  final bool isOnline;
  final DateTime? lastSeen;

  const MemberEntity({
    required this.id,
    required this.name,
    this.profileImage,
    this.role,
    this.isOnline = false,
    this.lastSeen,
  });

  @override
  List<Object?> get props => [id, name, profileImage, role, isOnline, lastSeen];

  MemberEntity copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? role,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return MemberEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
