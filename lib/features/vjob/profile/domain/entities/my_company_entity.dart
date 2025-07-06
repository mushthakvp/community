import 'package:equatable/equatable.dart';

class MyCompanyEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String email;
  final String? phone;
  final String? website;
  final String description;
  final String location;
  final int totalJobsPosted;
  final int totalApplicationsReceived;
  final DateTime createdAt;

  const MyCompanyEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    this.phone,
    this.website,
    required this.description,
    required this.location,
    this.totalJobsPosted = 0,
    this.totalApplicationsReceived = 0,
    required this.createdAt,
  });

  MyCompanyEntity copyWith({
    String? id,
    String? name,
    String? image,
    String? email,
    String? phone,
    String? website,
    String? description,
    String? location,
    int? totalJobsPosted,
    int? totalApplicationsReceived,
    DateTime? createdAt,
  }) {
    return MyCompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      description: description ?? this.description,
      location: location ?? this.location,
      totalJobsPosted: totalJobsPosted ?? this.totalJobsPosted,
      totalApplicationsReceived:
          totalApplicationsReceived ?? this.totalApplicationsReceived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown Company';
  String get safeImage => image.isNotEmpty ? image : '';
  bool get hasWebsite => website != null && website!.isNotEmpty;
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    email,
    phone,
    website,
    description,
    location,
    totalJobsPosted,
    totalApplicationsReceived,
    createdAt,
  ];
}
