import 'package:equatable/equatable.dart';

class MyJobsEntity extends Equatable {
  final String id;
  final String title;
  final String companyName;
  final String companyImage;
  final String location;
  final String status;
  final DateTime appliedDate;
  final String? resume;
  final int minimumSalary;

  const MyJobsEntity({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyImage,
    required this.location,
    required this.status,
    required this.appliedDate,
    this.resume,
    required this.minimumSalary,
  });

  MyJobsEntity copyWith({
    String? id,
    String? title,
    String? companyName,
    String? companyImage,
    String? location,
    String? status,
    DateTime? appliedDate,
    String? resume,
    int? minimumSalary,
  }) {
    return MyJobsEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      companyImage: companyImage ?? this.companyImage,
      location: location ?? this.location,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      resume: resume ?? this.resume,
      minimumSalary: minimumSalary ?? this.minimumSalary,
    );
  }

  // Helper methods
  bool get isApplied => status.toLowerCase() == 'applied';
  bool get isSaved => status.toLowerCase() == 'saved';
  bool get isRejected => status.toLowerCase() == 'rejected';
  bool get isAccepted => status.toLowerCase() == 'accepted';

  @override
  List<Object?> get props => [
    id,
    title,
    companyName,
    companyImage,
    location,
    status,
    appliedDate,
    resume,
    minimumSalary,
  ];
}
