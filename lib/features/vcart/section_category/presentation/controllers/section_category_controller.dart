import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/section_category_data.dart';
import '../../domain/entities/section_category_item.dart';
import '../../domain/usecases/get_categories_by_section.dart';

class VCartSectionCategoryController extends GetxController {
  final GetCategoriesBySection getCategoriesBySectionUseCase;

  VCartSectionCategoryController({required this.getCategoriesBySectionUseCase});

  final _isLoading = false.obs;
  final _sectionCategoryData = Rxn<SectionCategoryData>();
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  bool get isLoading => _isLoading.value;
  SectionCategoryData? get sectionCategoryData => _sectionCategoryData.value;
  List<SectionCategoryItem> get categories =>
      sectionCategoryData?.categories ?? [];
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get isEmpty => categories.isEmpty && !isLoading;

  Future<void> getCategoriesBySection({
    required String sectionId,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      final result = await getCategoriesBySectionUseCase(
        GetCategoriesBySectionParams(sectionId: sectionId),
      );
      result.fold((failure) => _handleFailure(failure), (data) {
        _sectionCategoryData.value = data;
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> refreshData(String sectionId, BuildContext context) async {
    await getCategoriesBySection(sectionId: sectionId, context: context);
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
    _sectionCategoryData.close();
    _errorMessage.close();
    _hasError.close();
    _isLoading.close();
    super.onClose();
  }
}
