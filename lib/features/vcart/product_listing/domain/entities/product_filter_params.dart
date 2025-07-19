import 'package:equatable/equatable.dart';

class ProductFilterParams extends Equatable {
  final String? sectionId;
  final String? categoryId;
  final String? subCategoryId;
  final String? brandId;
  final double? minPrice;
  final double? maxPrice;
  final List<String> colors;
  final List<String> sizes;
  final List<String> offers;
  final String sortBy;
  final int page;
  final int limit;

  const ProductFilterParams({
    this.sectionId,
    this.categoryId,
    this.subCategoryId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.colors = const [],
    this.sizes = const [],
    this.offers = const [],
    this.sortBy = 'high-to-low',
    this.page = 1,
    this.limit = 10,
  });

  ProductFilterParams copyWith({
    String? sectionId,
    String? categoryId,
    String? subCategoryId,
    String? brandId,
    double? minPrice,
    double? maxPrice,
    List<String>? colors,
    List<String>? sizes,
    List<String>? offers,
    String? sortBy,
    int? page,
    int? limit,
  }) {
    return ProductFilterParams(
      sectionId: sectionId ?? this.sectionId,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      brandId: brandId ?? this.brandId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      offers: offers ?? this.offers,
      sortBy: sortBy ?? this.sortBy,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  bool get hasFilters {
    return sectionId != null ||
        categoryId != null ||
        subCategoryId != null ||
        brandId != null ||
        minPrice != null ||
        maxPrice != null ||
        colors.isNotEmpty ||
        sizes.isNotEmpty ||
        offers.isNotEmpty;
  }

  @override
  List<Object?> get props => [
    sectionId,
    categoryId,
    subCategoryId,
    brandId,
    minPrice,
    maxPrice,
    colors,
    sizes,
    offers,
    sortBy,
    page,
    limit,
  ];
}
