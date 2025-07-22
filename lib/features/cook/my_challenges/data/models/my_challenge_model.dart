import '../../domain/entities/my_challenge.dart';

class MyChallengeModel extends MyChallenge {
  const MyChallengeModel({
    required super.id,
    super.image,
    required super.title,
    super.description,
    required super.status,
    super.createdAt,
    required super.isResultAdded,
  });

  factory MyChallengeModel.fromJson(Map<String, dynamic> json) {
    return MyChallengeModel(
      id: json['_id'] ?? '',
      image: json['image'],
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      isResultAdded: json['isResultAdded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'isResultAdded': isResultAdded,
    };
  }

  factory MyChallengeModel.fromEntity(MyChallenge challenge) {
    return MyChallengeModel(
      id: challenge.id,
      image: challenge.image,
      title: challenge.title,
      description: challenge.description,
      status: challenge.status,
      createdAt: challenge.createdAt,
      isResultAdded: challenge.isResultAdded,
    );
  }
}
