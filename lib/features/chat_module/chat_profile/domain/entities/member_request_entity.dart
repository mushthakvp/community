import 'package:equatable/equatable.dart';

class MemberRequestEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const MemberRequestEntity({
    required this.id,
    required this.name,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, profileImage];
}

class MemberRequestsEntity extends Equatable {
  final String id;
  final String creator;
  final List<MemberRequestEntity> requests;

  const MemberRequestsEntity({
    required this.id,
    required this.creator,
    required this.requests,
  });

  @override
  List<Object?> get props => [id, creator, requests];
}
