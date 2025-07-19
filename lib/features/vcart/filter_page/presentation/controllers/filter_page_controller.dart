import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/filter_brand.dart';
import '../../domain/entities/filter_color.dart';
import '../../domain/entities/filter_data.dart';
import '../../domain/entities/filter_state.dart';
import '../../domain/usecases/get_filter_data.dart';

class VCartFilterPageController extends GetxController {
  final GetFilterData getFilterDataUseCase;

  VCartFilterPageController({required this.getFilterDataUseCase});

  // Controllers
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController brandSearchController = TextEditingController();

  // Observable variables
  final _isLoading = false.obs;
  final _filterData = Rxn<FilterData>();
  final _filterState = FilterState().obs;
  final _priceRange = const RangeValues(10.0, 499999.0).obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Available offers
  final List<String> availableOffers = [
    "10",
    "20",
    "30",
    "40",
    "50",
    "60",
    "70",
    "80",
  ];

  // Getters
  bool get isLoading => _isLoading.value;
  FilterData? get filterData => _filterData.value;
  FilterState get filterState => _filterState.value;
  RangeValues get priceRange => _priceRange.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;

  // Computed properties
  List<FilterBrand> get brands => filterData?.brands ?? [];
  List<String> get sizes => filterData?.sizes ?? [];
  List<FilterColor> get colors => filterData?.colors ?? [];
  int get selectedFilterIndex => filterState.selectedFilterIndex;

  Future<void> getFilterData({String? sectionId, String? brandId}) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await getFilterDataUseCase(
        GetFilterDataParams(sectionId: sectionId, brandId: brandId),
      );

      result.fold((failure) => _handleFailure(failure), (data) {
        _filterData.value = data;
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  void changeFilterIndex(int index) {
    _filterState.value = filterState.copyWith(selectedFilterIndex: index);
  }

  void updatePriceRange(RangeValues values) {
    _priceRange.value = values;
    minPriceController.text = values.start.toInt().toString();
    maxPriceController.text = values.end.toInt().toString();
    _filterState.value = filterState.copyWith(
      minPrice: values.start,
      maxPrice: values.end,
    );
  }

  void toggleBrand(String brandId) {
    final selectedBrands = List<String>.from(filterState.selectedBrands);
    if (selectedBrands.contains(brandId)) {
      selectedBrands.remove(brandId);
    } else {
      selectedBrands.add(brandId);
    }
    _filterState.value = filterState.copyWith(selectedBrands: selectedBrands);
  }

  void toggleSize(String size) {
    final selectedSizes = List<String>.from(filterState.selectedSizes);
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }
    _filterState.value = filterState.copyWith(selectedSizes: selectedSizes);
  }

  void toggleColor(String colorName) {
    final selectedColors = List<String>.from(filterState.selectedColors);
    if (selectedColors.contains(colorName)) {
      selectedColors.remove(colorName);
    } else {
      selectedColors.add(colorName);
    }
    _filterState.value = filterState.copyWith(selectedColors: selectedColors);
  }

  void toggleOffer(String offer) {
    final selectedOffers = List<String>.from(filterState.selectedOffers);
    if (selectedOffers.contains(offer)) {
      selectedOffers.remove(offer);
    } else {
      selectedOffers.add(offer);
    }
    _filterState.value = filterState.copyWith(selectedOffers: selectedOffers);
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  void clearAllFilters() {
    minPriceController.clear();
    maxPriceController.clear();
    brandSearchController.clear();
    _priceRange.value = const RangeValues(10.0, 499999.0);
    _filterState.value = const FilterState();
  }

  void applyFilters(BuildContext context) {
    // Return filter results to previous screen
    Get.back(result: filterState);
  }

  Future<void> refreshData({String? sectionId, String? brandId}) async {
    await getFilterData(sectionId: sectionId, brandId: brandId);
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }

  @override
  void onClose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    brandSearchController.dispose();
    _filterData.close();
    _filterState.close();
    _priceRange.close();
    _errorMessage.close();
    _hasError.close();
    _isLoading.close();
    super.onClose();
  }
}
