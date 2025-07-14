import 'package:equatable/equatable.dart';

class CommunityMemberEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final bool isAdmin;
  final bool isFriend;
  final bool isRequested;
  final bool isCurrentUser;

  const CommunityMemberEntity({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isAdmin,
    required this.isFriend,
    required this.isRequested,
    required this.isCurrentUser,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    profileImage,
    isAdmin,
    isFriend,
    isRequested,
    isCurrentUser,
  ];

  CommunityMemberEntity copyWith({
    String? id,
    String? name,
    String? profileImage,
    bool? isAdmin,
    bool? isFriend,
    bool? isRequested,
    bool? isCurrentUser,
  }) {
    return CommunityMemberEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isAdmin: isAdmin ?? this.isAdmin,
      isFriend: isFriend ?? this.isFriend,
      isRequested: isRequested ?? this.isRequested,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
