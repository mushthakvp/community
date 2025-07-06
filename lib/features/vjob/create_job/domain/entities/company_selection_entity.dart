import 'package:equatable/equatable.dart';

class CompanySelectionEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String? email;
  final String? website;

  const CompanySelectionEntity({
    required this.id,
    required this.name,
    required this.image,
    this.email,
    this.website,
  });

  CompanySelectionEntity copyWith({
    String? id,
    String? name,
    String? image,
    String? email,
    String? website,
  }) {
    return CompanySelectionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }

  @override
  List<Object?> get props => [id, name, image, email, website];
}
