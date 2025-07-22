import '../../domain/entities/challenge_details.dart';

class ChallengeDetailsModel extends ChallengeDetails {
  const ChallengeDetailsModel({
    required super.id,
    super.createdBy,
    required super.title,
    super.description,
    super.startDate,
    super.endDate,
    super.image,
    required super.firstPrizeLoyaltyPoints,
    required super.secondPrizeLoyaltyPoints,
    required super.thirdPrizeLoyaltyPoints,
    required super.maximumParticipants,
    required super.joinedUsers,
    required super.isAlreadyJoined,
    required super.isResultAdded,
    super.createdAt,
    super.updatedAt,
  });

  factory ChallengeDetailsModel.fromJson(Map<String, dynamic> json) {
    final challenge = json['challenge'] as Map<String, dynamic>?;

    return ChallengeDetailsModel(
      id: challenge?['_id'] ?? '',
      createdBy: challenge?['createdBy'],
      title: challenge?['title'] ?? '',
      description: challenge?['description'],
      startDate: challenge?['startDate'] != null
          ? DateTime.parse(challenge!['startDate'])
          : null,
      endDate: challenge?['endDate'] != null
          ? DateTime.parse(challenge!['endDate'])
          : null,
      image: challenge?['image'],
      firstPrizeLoyaltyPoints: challenge?['firstPrizeLoyaltyPoints'] ?? 0,
      secondPrizeLoyaltyPoints: challenge?['secondPrizeLoyaltyPoints'] ?? 0,
      thirdPrizeLoyaltyPoints: challenge?['thirdPrizeLoyaltyPoints'] ?? 0,
      maximumParticipants: challenge?['maximumParticipants'] ?? 0,
      joinedUsers: json['joinedUsers'] ?? 0,
      isAlreadyJoined: json['isAlreadyJoined'] ?? false,
      isResultAdded: challenge?['isResultAdded'] ?? false,
      createdAt: challenge?['createdAt'] != null
          ? DateTime.parse(challenge!['createdAt'])
          : null,
      updatedAt: challenge?['updatedAt'] != null
          ? DateTime.parse(challenge!['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge': {
        '_id': id,
        'createdBy': createdBy,
        'title': title,
        'description': description,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'image': image,
        'firstPrizeLoyaltyPoints': firstPrizeLoyaltyPoints,
        'secondPrizeLoyaltyPoints': secondPrizeLoyaltyPoints,
        'thirdPrizeLoyaltyPoints': thirdPrizeLoyaltyPoints,
        'maximumParticipants': maximumParticipants,
        'isResultAdded': isResultAdded,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      },
      'joinedUsers': joinedUsers,
      'isAlreadyJoined': isAlreadyJoined,
    };
  }
}
