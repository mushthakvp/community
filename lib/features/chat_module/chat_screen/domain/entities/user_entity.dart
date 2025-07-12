import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final String? district;
  final bool isOnline;

  const UserEntity({
    required this.id,
    required this.name,
    this.profileImage,
    this.district,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [id, name, profileImage, district, isOnline];
}
