import '../../domain/entities/job_details_entity.dart';

class JobDetailsModel extends JobDetailsEntity {
  const JobDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.state,
    required super.city,
    required super.workStyle,
    required super.position,
    required super.schedule,
    required super.benefits,
    required super.minimumSalary,
    required super.education,
    required super.skills,
    required super.languages,
    required super.responsibilities,
    required super.isApplied,
    required super.isSaved,
    required super.totalApplication,
    required super.totalSave,
    required super.totalView,
    required super.company,
    required super.createdAt,
    required super.updatedAt,
  });

  factory JobDetailsModel.fromJson(Map<String, dynamic> json) {
    return JobDetailsModel(
      id: json['job']['_id'] ?? '',
      title: json['job']['title'] ?? '',
      description: json['job']['description'] ?? '',
      state: json['job']['state'] ?? '',
      city: json['job']['city'] ?? '',
      workStyle: json['job']['workStyle'] ?? '',
      position: List<String>.from(json['job']['position'] ?? []),
      schedule: List<String>.from(json['job']['schedule'] ?? []),
      benefits: List<String>.from(json['job']['benefits'] ?? []),
      minimumSalary: json['job']['minimumSalary'] ?? 0,
      education: json['job']['education'] ?? '',
      skills: List<String>.from(json['job']['skills'] ?? []),
      languages: List<String>.from(json['job']['languages'] ?? []),
      responsibilities: List<String>.from(
        json['job']['responsibilities'] ?? [],
      ),
      isApplied: json['isApplied'] ?? false,
      isSaved: json['isSaved'] ?? false,
      totalApplication: json['totalApplication'] ?? 0,
      totalSave: json['totalSave'] ?? 0,
      totalView: json['totalView'] ?? 0,
      company: CompanyDetailsModel.fromJson(json['job']['company'] ?? {}),
      createdAt: DateTime.parse(
        json['job']['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['job']['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job': {
        '_id': id,
        'title': title,
        'description': description,
        'state': state,
        'city': city,
        'workStyle': workStyle,
        'position': position,
        'schedule': schedule,
        'benefits': benefits,
        'minimumSalary': minimumSalary,
        'education': education,
        'skills': skills,
        'languages': languages,
        'responsibilities': responsibilities,
        'company': (company as CompanyDetailsModel).toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      },
      'isApplied': isApplied,
      'isSaved': isSaved,
      'totalApplication': totalApplication,
      'totalSave': totalSave,
      'totalView': totalView,
    };
  }
}

class CompanyDetailsModel extends CompanyDetailsEntity {
  const CompanyDetailsModel({
    required super.id,
    required super.name,
    required super.email,
    required super.website,
    required super.description,
    super.image,
    required super.location,
  });

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      location: LocationModel.fromJson(json['location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'website': website,
      'description': description,
      'image': image,
      'location': (location as LocationModel).toJson(),
    };
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({required super.lat, required super.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(lat: json['lat'] ?? '', lng: json['lng'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}
