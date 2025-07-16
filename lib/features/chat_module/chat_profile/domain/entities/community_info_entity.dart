import 'package:equatable/equatable.dart';

class CommunityInfoEntity extends Equatable {
  final String id;
  final String name;
  final String? image;
  final String communityId;
  final bool isCreator;
  final bool isUserInGroup;
  final int memberCount;

  const CommunityInfoEntity({
    required this.id,
    required this.name,
    this.image,
    required this.communityId,
    required this.isCreator,
    required this.isUserInGroup,
    required this.memberCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    communityId,
    isCreator,
    isUserInGroup,
    memberCount,
  ];
}
