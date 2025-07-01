import 'package:equatable/equatable.dart';

class RecentlyViewedAdEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final String currencyCode;
  final String district;
  final String brand;
  final String model;
  final List<String> images;
  final bool isSaved;
  final DateTime viewedAt;
  final int? year;
  final int? kilometers;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? shareLink;

  const RecentlyViewedAdEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.currencyCode,
    required this.district,
    required this.brand,
    required this.model,
    required this.images,
    required this.isSaved,
    required this.viewedAt,
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

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(viewedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${viewedAt.day}/${viewedAt.month}/${viewedAt.year}';
    }
  }

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
    viewedAt,
    year,
    kilometers,
    address,
    latitude,
    longitude,
    shareLink,
  ];
}
