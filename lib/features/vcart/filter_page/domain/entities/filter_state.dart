import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final double? minPrice;
  final double? maxPrice;
  final List<String> selectedBrands;
  final List<String> selectedSizes;
  final List<String> selectedColors;
  final List<String> selectedOffers;
  final int selectedFilterIndex;

  const FilterState({
    this.minPrice,
    this.maxPrice,
    this.selectedBrands = const [],
    this.selectedSizes = const [],
    this.selectedColors = const [],
    this.selectedOffers = const [],
    this.selectedFilterIndex = 0,
  });

  FilterState copyWith({
    double? minPrice,
    double? maxPrice,
    List<String>? selectedBrands,
    List<String>? selectedSizes,
    List<String>? selectedColors,
    List<String>? selectedOffers,
    int? selectedFilterIndex,
  }) {
    return FilterState(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedBrands: selectedBrands ?? this.selectedBrands,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      selectedColors: selectedColors ?? this.selectedColors,
      selectedOffers: selectedOffers ?? this.selectedOffers,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
    );
  }

  bool get hasActiveFilters {
    return minPrice != null ||
        maxPrice != null ||
        selectedBrands.isNotEmpty ||
        selectedSizes.isNotEmpty ||
        selectedColors.isNotEmpty ||
        selectedOffers.isNotEmpty;
  }

  @override
  List<Object?> get props => [
    minPrice,
    maxPrice,
    selectedBrands,
    selectedSizes,
    selectedColors,
    selectedOffers,
    selectedFilterIndex,
  ];
}
