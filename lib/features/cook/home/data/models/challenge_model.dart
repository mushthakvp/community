import '../../domain/entities/challenge.dart';

class ChallengeModel extends Challenge {
  const ChallengeModel({
    required super.id,
    super.image,
    required super.title,
    required super.joinedUsers,
    super.startDate,
    super.endDate,
    required super.maximumParticipants,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['_id'] ?? '',
      image: json['image'],
      title: json['title'] ?? '',
      joinedUsers: (json['joinedUsers'] ?? 0).toInt(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      maximumParticipants: (json['maximumParticipants'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image,
      'title': title,
      'joinedUsers': joinedUsers,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'maximumParticipants': maximumParticipants,
    };
  }

  factory ChallengeModel.fromEntity(Challenge challenge) {
    return ChallengeModel(
      id: challenge.id,
      image: challenge.image,
      title: challenge.title,
      joinedUsers: challenge.joinedUsers,
      startDate: challenge.startDate,
      endDate: challenge.endDate,
      maximumParticipants: challenge.maximumParticipants,
    );
  }
}
