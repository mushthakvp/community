import '../../domain/entities/cooking_home.dart';
import 'challenge_model.dart';

class CookingHomeModel extends CookingHome {
  const CookingHomeModel({
    super.message,
    required super.currentChallenges,
    required super.upcomingChallenges,
    required super.totalCurrentPages,
    required super.totalUpcomingPages,
    required super.totalCurrentChallenges,
    required super.totalUpcomingChallenges,
  });

  factory CookingHomeModel.fromJson(Map<String, dynamic> json) {
    return CookingHomeModel(
      message: json['message'],
      currentChallenges: json['current'] == null
          ? []
          : (json['current'] as List)
                .map((x) => ChallengeModel.fromJson(x))
                .toList(),
      upcomingChallenges: json['upcoming'] == null
          ? []
          : (json['upcoming'] as List)
                .map((x) => ChallengeModel.fromJson(x))
                .toList(),
      totalCurrentPages: (json['totalCurrentPages'] ?? 0).toInt(),
      totalUpcomingPages: (json['totalUpcomingPages'] ?? 0).toInt(),
      totalCurrentChallenges: (json['totalCurrentChallenges'] ?? 0).toInt(),
      totalUpcomingChallenges: (json['totalUpcomingChallenges'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'current': currentChallenges
          .map((x) => ChallengeModel.fromEntity(x).toJson())
          .toList(),
      'upcoming': upcomingChallenges
          .map((x) => ChallengeModel.fromEntity(x).toJson())
          .toList(),
      'totalCurrentPages': totalCurrentPages,
      'totalUpcomingPages': totalUpcomingPages,
      'totalCurrentChallenges': totalCurrentChallenges,
      'totalUpcomingChallenges': totalUpcomingChallenges,
    };
  }
}
