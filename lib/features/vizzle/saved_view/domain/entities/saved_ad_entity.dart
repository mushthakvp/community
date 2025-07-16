import 'package:equatable/equatable.dart';

class SavedAdEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final String currencyCode;
  final String district;
  final String brand;
  final String model;
  final List<String> images;
  final bool isSaved;
  final int? year;
  final int? kilometers;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? shareLink;

  const SavedAdEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.currencyCode,
    required this.district,
    required this.brand,
    required this.model,
    required this.images,
    required this.isSaved,
    this.year,
    this.kilometers,
    this.address,
    this.latitude,
    this.longitude,
    this.shareLink,
  });

  String get formattedPrice => '$currencyCode ${price.toStringAsFixed(2)}';

  String get primaryImage => images.isNotEmpty ? images.first : '';

  String get ageDisplay => year != null ? 'Age: $year' : '';

  String get brandModel => '$brand ${model.isNotEmpty ? model : ''}'.trim();

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    currencyCode,
    district,
    brand,
    model,
    images,
    isSaved,
    year,
    kilometers,
    address,
    latitude,
    longitude,
    shareLink,
  ];
}
