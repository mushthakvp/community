import '../../domain/entities/prize_user.dart';

class PrizeUserModel extends PrizeUser {
  const PrizeUserModel({
    required super.id,
    required super.name,
    super.profileImage,
  });

  factory PrizeUserModel.fromJson(Map<String, dynamic> json) {
    return PrizeUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }

  factory PrizeUserModel.fromEntity(PrizeUser user) {
    return PrizeUserModel(
      id: user.id,
      name: user.name,
      profileImage: user.profileImage,
    );
  }
}
