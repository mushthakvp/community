import 'package:equatable/equatable.dart';

class FriendEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final String? district;
  final bool isOnline;

  const FriendEntity({
    required this.id,
    required this.name,
    this.profileImage,
    this.district,
    required this.isOnline,
  });

  @override
  List<Object?> get props => [id, name, profileImage, district, isOnline];
}
