import 'package:equatable/equatable.dart';

// Main Vizzle Home Entity
class VizzleHomeEntity extends Equatable {
  final bool success;
  final String message;
  final String currencyCode;
  final List<AdEntity> motors;
  final List<AdEntity> classifieds;
  final List<AdEntity> furnitureGarden;
  final List<AdEntity> propertyForSale;

  const VizzleHomeEntity({
    required this.success,
    required this.message,
    required this.currencyCode,
    required this.motors,
    required this.classifieds,
    required this.furnitureGarden,
    required this.propertyForSale,
  });

  VizzleHomeEntity copyWith({
    bool? success,
    String? message,
    String? currencyCode,
    List<AdEntity>? motors,
    List<AdEntity>? classifieds,
    List<AdEntity>? furnitureGarden,
    List<AdEntity>? propertyForSale,
  }) {
    return VizzleHomeEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      currencyCode: currencyCode ?? this.currencyCode,
      motors: motors ?? this.motors,
      classifieds: classifieds ?? this.classifieds,
      furnitureGarden: furnitureGarden ?? this.furnitureGarden,
      propertyForSale: propertyForSale ?? this.propertyForSale,
    );
  }

  // Helper methods
  List<AdEntity> getAllAds() {
    return [...motors, ...classifieds, ...furnitureGarden, ...propertyForSale];
  }

  bool get hasAnyAds => getAllAds().isNotEmpty;

  @override
  List<Object?> get props => [
    success,
    message,
    currencyCode,
    motors,
    classifieds,
    furnitureGarden,
    propertyForSale,
  ];
}

// Ad Entity
class AdEntity extends Equatable {
  final String id;
  final String title;
  final String shareLink;
  final List<String> images;
  final int? year;
  final int? kilometers;
  final double? price;
  final String? brand;
  final String? model;

  const AdEntity({
    required this.id,
    required this.title,
    required this.shareLink,
    required this.images,
    this.year,
    this.kilometers,
    this.price,
    this.brand,
    this.model,
  });

  AdEntity copyWith({
    String? id,
    String? title,
    String? shareLink,
    List<String>? images,
    int? year,
    int? kilometers,
    double? price,
    String? brand,
    String? model,
  }) {
    return AdEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      shareLink: shareLink ?? this.shareLink,
      images: images ?? this.images,
      year: year ?? this.year,
      kilometers: kilometers ?? this.kilometers,
      price: price ?? this.price,
      brand: brand ?? this.brand,
      model: model ?? this.model,
    );
  }

  // Helper methods
  String get displayTitle => title.isNotEmpty ? title : 'No Title';
  String get primaryImage => images.isNotEmpty ? images.first : '';
  String get formattedPrice =>
      price != null ? price!.toStringAsFixed(2) : '0.00';
  bool get hasValidImage => images.isNotEmpty && images.first.isNotEmpty;
  bool get isMotorAd => year != null && kilometers != null;

  @override
  List<Object?> get props => [
    id,
    title,
    shareLink,
    images,
    year,
    kilometers,
    price,
    brand,
    model,
  ];
}

// Category Entity
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final List<SubCategoryEntity> subcategories;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    List<SubCategoryEntity>? subcategories,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      subcategories: subcategories ?? this.subcategories,
    );
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown Category';
  bool get hasSubcategories => subcategories.isNotEmpty;
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [id, name, subcategories];
}

// Sub Category Entity
class SubCategoryEntity extends Equatable {
  final String id;
  final String name;
  final List<SubSubCategoryEntity> subSubCategories;

  const SubCategoryEntity({
    required this.id,
    required this.name,
    required this.subSubCategories,
  });

  SubCategoryEntity copyWith({
    String? id,
    String? name,
    List<SubSubCategoryEntity>? subSubCategories,
  }) {
    return SubCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      subSubCategories: subSubCategories ?? this.subSubCategories,
    );
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown Subcategory';
  bool get hasSubSubCategories => subSubCategories.isNotEmpty;
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [id, name, subSubCategories];
}

// Sub Sub Category Entity
class SubSubCategoryEntity extends Equatable {
  final String id;
  final String name;
  final List<SubItemEntity> subItems;

  const SubSubCategoryEntity({
    required this.id,
    required this.name,
    required this.subItems,
  });

  SubSubCategoryEntity copyWith({
    String? id,
    String? name,
    List<SubItemEntity>? subItems,
  }) {
    return SubSubCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      subItems: subItems ?? this.subItems,
    );
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown Sub-subcategory';
  bool get hasSubItems => subItems.isNotEmpty;
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [id, name, subItems];
}

// Sub Item Entity
class SubItemEntity extends Equatable {
  final String id;
  final String name;

  const SubItemEntity({required this.id, required this.name});

  SubItemEntity copyWith({String? id, String? name}) {
    return SubItemEntity(id: id ?? this.id, name: name ?? this.name);
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown Item';
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [id, name];
}

// Filter Entity for managing filters
class VizzleFilterEntity extends Equatable {
  final String? selectedCategoryId;
  final String? selectedSubCategoryId;
  final String? selectedSubSubCategoryId;
  final String? searchQuery;
  final double? minPrice;
  final double? maxPrice;

  const VizzleFilterEntity({
    this.selectedCategoryId,
    this.selectedSubCategoryId,
    this.selectedSubSubCategoryId,
    this.searchQuery,
    this.minPrice,
    this.maxPrice,
  });

  VizzleFilterEntity copyWith({
    String? selectedCategoryId,
    String? selectedSubCategoryId,
    String? selectedSubSubCategoryId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
  }) {
    return VizzleFilterEntity(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedSubCategoryId:
          selectedSubCategoryId ?? this.selectedSubCategoryId,
      selectedSubSubCategoryId:
          selectedSubSubCategoryId ?? this.selectedSubSubCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  VizzleFilterEntity clearAll() {
    return const VizzleFilterEntity();
  }

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      selectedSubCategoryId != null ||
      selectedSubSubCategoryId != null ||
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      minPrice != null ||
      maxPrice != null;

  @override
  List<Object?> get props => [
    selectedCategoryId,
    selectedSubCategoryId,
    selectedSubSubCategoryId,
    searchQuery,
    minPrice,
    maxPrice,
  ];
}
