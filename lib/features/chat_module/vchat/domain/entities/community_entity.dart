import 'package:equatable/equatable.dart';

class CommunityEntity extends Equatable {
  final String id;
  final String name;
  final String? image;
  final int memberCount;
  final List<String> profileImages;
  final bool isJoined;
  final bool isCreated;

  const CommunityEntity({
    required this.id,
    required this.name,
    this.image,
    required this.memberCount,
    this.profileImages = const [],
    this.isJoined = false,
    this.isCreated = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    memberCount,
    profileImages,
    isJoined,
    isCreated,
  ];
}
