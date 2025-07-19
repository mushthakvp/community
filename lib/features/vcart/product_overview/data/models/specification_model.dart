import '../../domain/entities/specification.dart';

class SpecificationModel extends Specification {
  const SpecificationModel({
    required super.id,
    required super.title,
    required super.solution,
  });

  factory SpecificationModel.fromJson(Map<String, dynamic> json) {
    return SpecificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      solution: json['solution'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'title': title, 'solution': solution};
  }
}
