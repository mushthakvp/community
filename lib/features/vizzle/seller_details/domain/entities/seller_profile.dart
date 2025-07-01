class SellerProfile {
  final String id;
  final String name;
  final String? profileImage;
  final DateTime joinedDate;
  final List<Advertisement> advertisements;

  const SellerProfile({
    required this.id,
    required this.name,
    this.profileImage,
    required this.joinedDate,
    required this.advertisements,
  });
}

class Advertisement {
  final String id;
  final String title;
  final double price;
  final String? brand;
  final int? year;
  final List<String> images;
  final String location;

  const Advertisement({
    required this.id,
    required this.title,
    required this.price,
    this.brand,
    this.year,
    required this.images,
    required this.location,
  });
}
