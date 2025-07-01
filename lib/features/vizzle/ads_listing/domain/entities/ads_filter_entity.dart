import 'package:equatable/equatable.dart';

class AdsFilterEntity extends Equatable {
  final String? categoryId;
  final String? subCategoryId;
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final String? keyword;
  final AdsFilterSort sortBy;
  final List<String> amenities;
  final AdVehicleFilter? vehicleFilter;
  final AdPropertyFilter? propertyFilter;

  const AdsFilterEntity({
    this.categoryId,
    this.subCategoryId,
    this.location,
    this.minPrice,
    this.maxPrice,
    this.keyword,
    this.sortBy = AdsFilterSort.newest,
    this.amenities = const [],
    this.vehicleFilter,
    this.propertyFilter,
  });

  AdsFilterEntity copyWith({
    String? categoryId,
    String? subCategoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? keyword,
    AdsFilterSort? sortBy,
    List<String>? amenities,
    AdVehicleFilter? vehicleFilter,
    AdPropertyFilter? propertyFilter,
  }) {
    return AdsFilterEntity(
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      keyword: keyword ?? this.keyword,
      sortBy: sortBy ?? this.sortBy,
      amenities: amenities ?? this.amenities,
      vehicleFilter: vehicleFilter ?? this.vehicleFilter,
      propertyFilter: propertyFilter ?? this.propertyFilter,
    );
  }

  AdsFilterEntity clearAll() {
    return const AdsFilterEntity();
  }

  bool get hasActiveFilters =>
      categoryId != null ||
      subCategoryId != null ||
      location != null ||
      minPrice != null ||
      maxPrice != null ||
      (keyword != null && keyword!.isNotEmpty) ||
      amenities.isNotEmpty ||
      vehicleFilter?.hasActiveFilters == true ||
      propertyFilter?.hasActiveFilters == true;

  @override
  List<Object?> get props => [
    categoryId,
    subCategoryId,
    location,
    minPrice,
    maxPrice,
    keyword,
    sortBy,
    amenities,
    vehicleFilter,
    propertyFilter,
  ];
}

enum AdsFilterSort { newest, oldest, priceLowToHigh, priceHighToLow, featured }

class AdVehicleFilter extends Equatable {
  final List<String> brands;
  final int? minYear;
  final int? maxYear;
  final int? minKilometers;
  final int? maxKilometers;
  final List<String> fuelTypes;
  final List<String> transmissions;
  final List<String> colors;

  const AdVehicleFilter({
    this.brands = const [],
    this.minYear,
    this.maxYear,
    this.minKilometers,
    this.maxKilometers,
    this.fuelTypes = const [],
    this.transmissions = const [],
    this.colors = const [],
  });

  bool get hasActiveFilters =>
      brands.isNotEmpty ||
      minYear != null ||
      maxYear != null ||
      minKilometers != null ||
      maxKilometers != null ||
      fuelTypes.isNotEmpty ||
      transmissions.isNotEmpty ||
      colors.isNotEmpty;

  @override
  List<Object?> get props => [
    brands,
    minYear,
    maxYear,
    minKilometers,
    maxKilometers,
    fuelTypes,
    transmissions,
    colors,
  ];
}

class AdPropertyFilter extends Equatable {
  final List<String> propertyTypes;
  final int? minBedrooms;
  final int? maxBedrooms;
  final int? minBathrooms;
  final int? maxBathrooms;
  final double? minArea;
  final double? maxArea;

  const AdPropertyFilter({
    this.propertyTypes = const [],
    this.minBedrooms,
    this.maxBedrooms,
    this.minBathrooms,
    this.maxBathrooms,
    this.minArea,
    this.maxArea,
  });

  bool get hasActiveFilters =>
      propertyTypes.isNotEmpty ||
      minBedrooms != null ||
      maxBedrooms != null ||
      minBathrooms != null ||
      maxBathrooms != null ||
      minArea != null ||
      maxArea != null;

  @override
  List<Object?> get props => [
    propertyTypes,
    minBedrooms,
    maxBedrooms,
    minBathrooms,
    maxBathrooms,
    minArea,
    maxArea,
  ];
}
