import 'dart:developer';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/router/core_router.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/section.dart';
import '../../domain/entities/subcategory.dart';
import '../../domain/usecases/get_categories_by_section.dart';
import '../../domain/usecases/get_sections.dart';
import '../../domain/usecases/get_subcategories_by_category.dart';

class VCartCategoriesController extends GetxController {
  final GetSections getSectionsUseCase;
  final GetCategoriesBySection getCategoriesBySectionUseCase;
  final GetSubCategoriesByCategory getSubCategoriesByCategoryUseCase;

  VCartCategoriesController({
    required this.getSectionsUseCase,
    required this.getCategoriesBySectionUseCase,
    required this.getSubCategoriesByCategoryUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _isCategoryLoading = false.obs;
  final _isSubCategoryLoading = false.obs;
  final _sections = <Section>[].obs;
  final _categories = <CategoryItem>[].obs;
  final _subCategories = <SubCategory>[].obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;
  final _selectedSectionIndex = 0.obs;
  final _selectedCategoryName = ''.obs;

  // Pagination variables
  final _hasMoreSubCategories = true.obs;
  final _currentSubCategoryPage = 1.obs;
  final _itemsPerPage = 10;
  final _isPageDataEmpty = false.obs;

  // Filter variables
  final _filterSectionId = ''.obs;
  final _filterCategoryId = ''.obs;
  final _filterSubCategoryId = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isCategoryLoading => _isCategoryLoading.value;
  bool get isSubCategoryLoading => _isSubCategoryLoading.value;
  List<Section> get sections => _sections;
  List<CategoryItem> get categories => _categories;
  List<SubCategory> get subCategories => _subCategories;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  int get selectedSectionIndex => _selectedSectionIndex.value;
  String get selectedCategoryName => _selectedCategoryName.value;
  bool get hasMoreSubCategories => _hasMoreSubCategories.value;
  bool get isPageDataEmpty => _isPageDataEmpty.value;
  String get filterSectionId => _filterSectionId.value;
  String get filterCategoryId => _filterCategoryId.value;
  String get filterSubCategoryId => _filterSubCategoryId.value;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await getSections();
  }

  Future<void> getSections() async {
    try {
      _setLoading(true);
      _setCategoryLoading(true);
      _setSubCategoryLoading(true);
      _clearError();
      final result = await getSectionsUseCase(const GetSectionsParams());
      result.fold((failure) => _handleFailure(failure), (sections) async {
        _sections.value = sections;
        _setLoading(false);
        if (sections.isNotEmpty) {
          await getCategoriesBySection(
            sectionId: sections[0].id,
            sectionIndex: 0,
          );
        } else {
          _setCategoryLoading(false);
          _setSubCategoryLoading(false);
        }
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> getCategoriesBySection({
    required String sectionId,
    required int sectionIndex,
  }) async {
    try {
      _setCategoryLoading(true);
      _setSubCategoryLoading(true);
      _filterSectionId.value = sectionId;
      final result = await getCategoriesBySectionUseCase(
        GetCategoriesBySectionParams(sectionId: sectionId),
      );
      result.fold((failure) => _handleFailure(failure), (categories) async {
        _categories.value = categories;
        _setCategoryLoading(false);
        clearSubCategoryVariables();
        if (categories.isNotEmpty) {
          _selectedCategoryName.value = categories[0].name;
          await getSubCategoriesByCategory(categoryId: categories[0].id);
        } else {
          _setSubCategoryLoading(false);
        }
      });
    } catch (e) {
      _handleError('Failed to load categories: $e');
    }
  }

  Future<void> getSubCategoriesByCategory({
    required String categoryId,
    bool isLoadMore = false,
  }) async {
    try {
      if (!isLoadMore) {
        _currentSubCategoryPage.value = 1;
        _subCategories.clear();
        _hasMoreSubCategories.value = true;
        _isPageDataEmpty.value = false;
      }
      if (!_hasMoreSubCategories.value) return;
      _setSubCategoryLoading(true);
      _filterCategoryId.value = categoryId;
      final result = await getSubCategoriesByCategoryUseCase(
        GetSubCategoriesByCategoryParams(
          categoryId: categoryId,
          page: _currentSubCategoryPage.value,
          limit: _itemsPerPage,
        ),
      );
      result.fold((failure) => _handleFailure(failure), (newSubCategories) {
        if (newSubCategories.isEmpty) {
          _isPageDataEmpty.value = true;
          _hasMoreSubCategories.value = false;
        } else {
          _subCategories.addAll(newSubCategories);
          _isPageDataEmpty.value = false;
          if (newSubCategories.length < _itemsPerPage) {
            _hasMoreSubCategories.value = false;
          } else {
            _currentSubCategoryPage.value++;
          }
        }
        _setSubCategoryLoading(false);
      });
    } catch (e) {
      _handleError('Failed to load subcategories: $e');
    }
  }

  void onSectionTap(int index) {
    if (index >= sections.length) return;
    _selectedSectionIndex.value = index;
    final section = sections[index];
    getCategoriesBySection(sectionId: section.id, sectionIndex: index);
  }

  void onCategoryTap(CategoryItem category) {
    clearSubCategoryVariables();
    _selectedCategoryName.value = category.name;
    getSubCategoriesByCategory(categoryId: category.id);
  }

  void onSubCategoryTap(SubCategory subCategory) {
    log("SubCategory tapped: ${subCategory.name}");
    _filterSubCategoryId.value = subCategory.id;

    // Get the current context and navigate using GoRouter
    final context = CoreRouter.rootNavigatorKey.currentContext;
    if (context != null) {
      // Build the URI with query parameters as expected by the router
      final uri = Uri(
        path: '/vcart/product-listing',
        queryParameters: {
          'title': subCategory.name,
          'sectionId': _filterSectionId.value.isNotEmpty
              ? _filterSectionId.value
              : null,
          'categoryId': _filterCategoryId.value.isNotEmpty
              ? _filterCategoryId.value
              : null,
          'subCategoryId': subCategory.id,
        }..removeWhere((key, value) => value == null),
      );

      // Navigate using GoRouter
      GoRouter.of(context).push(uri.toString());
    } else {
      // Fallback: Log error and show message to user
      log("Error: No context available for navigation");
      _handleError('Navigation error: Unable to navigate to products');
    }
  }

  void clearSubCategoryVariables() {
    _subCategories.clear();
    _isSubCategoryLoading.value = false;
    _hasMoreSubCategories.value = true;
    _currentSubCategoryPage.value = 1;
    _isPageDataEmpty.value = false;
  }

  void clearAllFilters() {
    _filterSectionId.value = '';
    _filterCategoryId.value = '';
    _filterSubCategoryId.value = '';
  }

  Future<void> refreshData() async {
    await getSections();
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setCategoryLoading(bool value) {
    _isCategoryLoading.value = value;
  }

  void _setSubCategoryLoading(bool value) {
    _isSubCategoryLoading.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _setCategoryLoading(false);
    _setSubCategoryLoading(false);
    _handleError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
    _setCategoryLoading(false);
    _setSubCategoryLoading(false);
  }
}
