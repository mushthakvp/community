class FilterOptionsModel {
  final List<String> categories;
  final List<String> locations;
  final List<String> brands;
  final List<String> fuelTypes;
  final List<String> transmissions;
  final List<String> colors;
  final List<String> propertyTypes;
  final List<String> amenities;
  final PriceRange priceRange;
  final YearRange yearRange;

  FilterOptionsModel({
    required this.categories,
    required this.locations,
    required this.brands,
    required this.fuelTypes,
    required this.transmissions,
    required this.colors,
    required this.propertyTypes,
    required this.amenities,
    required this.priceRange,
    required this.yearRange,
  });

  factory FilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionsModel(
      categories: List<String>.from(json['categories'] ?? []),
      locations: List<String>.from(json['locations'] ?? []),
      brands: List<String>.from(json['brands'] ?? []),
      fuelTypes: List<String>.from(json['fuelTypes'] ?? []),
      transmissions: List<String>.from(json['transmissions'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      propertyTypes: List<String>.from(json['propertyTypes'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      priceRange: PriceRange.fromJson(json['priceRange'] ?? {}),
      yearRange: YearRange.fromJson(json['yearRange'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'locations': locations,
      'brands': brands,
      'fuelTypes': fuelTypes,
      'transmissions': transmissions,
      'colors': colors,
      'propertyTypes': propertyTypes,
      'amenities': amenities,
      'priceRange': priceRange.toJson(),
      'yearRange': yearRange.toJson(),
    };
  }
}

class PriceRange {
  final double min;
  final double max;

  PriceRange({required this.min, required this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: (json['min'] ?? 0).toDouble(),
      max: (json['max'] ?? 1000000).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'min': min, 'max': max};
  }
}

class YearRange {
  final int min;
  final int max;

  YearRange({required this.min, required this.max});

  factory YearRange.fromJson(Map<String, dynamic> json) {
    final currentYear = DateTime.now().year;
    return YearRange(min: json['min'] ?? 1990, max: json['max'] ?? currentYear);
  }

  Map<String, dynamic> toJson() {
    return {'min': min, 'max': max};
  }
}
