import 'package:equatable/equatable.dart';

class CreatedJobEntity extends Equatable {
  final String id;
  final String userId;
  final String companyId;
  final String title;
  final String description;
  final String state;
  final String city;
  final String workStyle;
  final List<String> position;
  final List<String> schedule;
  final List<String> benefits;
  final int minimumSalary;
  final String education;
  final List<String> skills;
  final List<String> languages;
  final List<String> responsibilities;
  final bool isAccepted;
  final bool isRejected;
  final String? rejectReason;
  final int rejectCount;
  final int reAppliedCount;
  final bool isActive;
  final String status;
  final int totalSave;
  final int totalApply;
  final int totalView;
  final JobCompanyEntity company;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CreatedJobEntity({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.title,
    required this.description,
    required this.state,
    required this.city,
    required this.workStyle,
    required this.position,
    required this.schedule,
    required this.benefits,
    required this.minimumSalary,
    required this.education,
    required this.skills,
    required this.languages,
    required this.responsibilities,
    required this.isAccepted,
    required this.isRejected,
    this.rejectReason,
    required this.rejectCount,
    required this.reAppliedCount,
    required this.isActive,
    required this.status,
    required this.totalSave,
    required this.totalApply,
    required this.totalView,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  CreatedJobEntity copyWith({String? status, bool? isActive}) {
    return CreatedJobEntity(
      id: id,
      userId: userId,
      companyId: companyId,
      title: title,
      description: description,
      state: state,
      city: city,
      workStyle: workStyle,
      position: position,
      schedule: schedule,
      benefits: benefits,
      minimumSalary: minimumSalary,
      education: education,
      skills: skills,
      languages: languages,
      responsibilities: responsibilities,
      isAccepted: isAccepted,
      isRejected: isRejected,
      rejectReason: rejectReason,
      rejectCount: rejectCount,
      reAppliedCount: reAppliedCount,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      totalSave: totalSave,
      totalApply: totalApply,
      totalView: totalView,
      company: company,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    companyId,
    title,
    description,
    state,
    city,
    workStyle,
    position,
    schedule,
    benefits,
    minimumSalary,
    education,
    skills,
    languages,
    responsibilities,
    isAccepted,
    isRejected,
    rejectReason,
    rejectCount,
    reAppliedCount,
    isActive,
    status,
    totalSave,
    totalApply,
    totalView,
    company,
    createdAt,
    updatedAt,
  ];
}

class JobCompanyEntity extends Equatable {
  final String id;
  final String name;
  final String? image;

  const JobCompanyEntity({required this.id, required this.name, this.image});

  @override
  List<Object?> get props => [id, name, image];
}
