import '../../domain/entities/create_job_entity.dart';

class CreateJobRequestModel extends CreateJobEntity {
  const CreateJobRequestModel({
    required super.companyId,
    required super.title,
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

  factory CreateJobRequestModel.fromEntity(CreateJobEntity entity) {
    return CreateJobRequestModel(
      companyId: entity.companyId,
      title: entity.title,
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

  Map<String, dynamic> toJson() {
    return {
      "action": "create",
      "company": companyId,
      "title": title,
      "state": state,
      "city": city,
      "workStyle": workStyle,
      "description": description,
      "position": position,
      "schedule": schedule,
      "benefits": benefits,
      "minimumSalary": minimumSalary,
      "education": education,
      "skills": skills,
      "languages": languages,
      "responsibilities": responsibilities,
    };
  }

  Map<String, dynamic> toUpdateJson(String jobId) {
    return {
      "action": "update",
      "id": jobId,
      "company": companyId,
      "title": title,
      "state": state,
      "city": city,
      "workStyle": workStyle,
      "description": description,
      "position": position,
      "schedule": schedule,
      "benefits": benefits,
      "minimumSalary": minimumSalary,
      "education": education,
      "skills": skills,
      "languages": languages,
      "responsibilities": responsibilities,
    };
  }
}
