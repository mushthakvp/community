import 'package:equatable/equatable.dart';

class FriendEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final bool isOnline;
  final DateTime? lastSeen;
  final FriendStatus status;
  final DateTime createdAt;

  const FriendEntity({
    required this.id,
    required this.name,
    this.profileImage,
    this.isOnline = false,
    this.lastSeen,
    this.status = FriendStatus.accepted,
    required this.createdAt,
  });

  FriendEntity copyWith({
    String? id,
    String? name,
    String? profileImage,
    bool? isOnline,
    DateTime? lastSeen,
    FriendStatus? status,
    DateTime? createdAt,
  }) {
    return FriendEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get displayName => name.isNotEmpty ? name : 'Unknown User';
  String get safeProfileImage => profileImage ?? '';
  bool get isPending => status == FriendStatus.pending;
  bool get isBlocked => status == FriendStatus.blocked;
  String get onlineStatus => isOnline ? 'Online' : 'Offline';

  @override
  List<Object?> get props => [
    id,
    name,
    profileImage,
    isOnline,
    lastSeen,
    status,
    createdAt,
  ];
}

enum FriendStatus { pending, accepted, blocked, removed }
