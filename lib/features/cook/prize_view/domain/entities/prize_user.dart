import 'package:equatable/equatable.dart';

class PrizeUser extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const PrizeUser({required this.id, required this.name, this.profileImage});

  @override
  List<Object?> get props => [id, name, profileImage];
}
