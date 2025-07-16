import '../../domain/entities/create_job_entity.dart';

class CreateJobModel extends CreateJobEntity {
  const CreateJobModel({
    super.id,
    required super.title,
    required super.companyId,
    required super.state,
    required super.city,
    required super.workStyle,
    required super.description,
    required super.position,
    required super.schedule,
    required super.benefits,
    required super.minimumSalary,
    required super.education,
    required super.skills,
    required super.languages,
    required super.responsibilities,
  });

  factory CreateJobModel.fromEntity(CreateJobEntity entity) {
    return CreateJobModel(
      id: entity.id,
      title: entity.title,
      companyId: entity.companyId,
      state: entity.state,
      city: entity.city,
      workStyle: entity.workStyle,
      description: entity.description,
      position: entity.position,
      schedule: entity.schedule,
      benefits: entity.benefits,
      minimumSalary: entity.minimumSalary,
      education: entity.education,
      skills: entity.skills,
      languages: entity.languages,
      responsibilities: entity.responsibilities,
    );
  }

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'action': isUpdate ? 'update' : 'create',
      'company': companyId,
      'title': title,
      'state': state,
      'city': city,
      'workStyle': workStyle,
      'description': description,
      'position': position,
      'schedule': schedule,
      'benefits': benefits,
      'minimumSalary': minimumSalary,
      'education': education,
      'skills': skills,
      'languages': languages,
      'responsibilities': responsibilities,
    };

    if (isUpdate && id != null) {
      data['id'] = id;
    }

    return data;
  }

  factory CreateJobModel.fromJson(Map<String, dynamic> json) {
    return CreateJobModel(
      id: json['_id'],
      title: json['title'] ?? '',
      companyId: json['company'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      workStyle: json['workStyle'] ?? '',
      description: json['description'] ?? '',
      position: List<String>.from(json['position'] ?? []),
      schedule: List<String>.from(json['schedule'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      minimumSalary: json['minimumSalary'] ?? 0,
      education: json['education'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
    );
  }
}
