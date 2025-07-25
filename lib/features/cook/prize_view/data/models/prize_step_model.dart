import '../../domain/entities/prize_step.dart';

class PrizeStepModel extends PrizeStep {
  const PrizeStepModel({
    super.image,
    required super.title,
    required super.description,
    required super.id,
  });

  factory PrizeStepModel.fromJson(Map<String, dynamic> json) {
    return PrizeStepModel(
      image: json['image'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'description': description,
      '_id': id,
    };
  }

  factory PrizeStepModel.fromEntity(PrizeStep step) {
    return PrizeStepModel(
      image: step.image,
      title: step.title,
      description: step.description,
      id: step.id,
    );
  }
}
