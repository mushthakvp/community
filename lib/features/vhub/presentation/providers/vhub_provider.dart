import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/idea_entity.dart';
import '../../domain/repositories/vhub_repository.dart';
import '../../domain/usecases/create_idea_usecase.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import '../../domain/usecases/get_ideas_usecase.dart';

enum VHubStatus { initial, loading, loaded, error, creating, deleting }

class VHubProvider extends ChangeNotifier {
  final GetIdeasUseCase _getIdeasUseCase;
  final CreateIdeaUseCase _createIdeaUseCase;
  final GetFaqsUseCase _getFaqsUseCase;
  final VHubRepository _repository;

  VHubProvider({
    required GetIdeasUseCase getIdeasUseCase,
    required CreateIdeaUseCase createIdeaUseCase,
    required GetFaqsUseCase getFaqsUseCase,
    required VHubRepository repository,
  }) : _getIdeasUseCase = getIdeasUseCase,
       _createIdeaUseCase = createIdeaUseCase,
       _getFaqsUseCase = getFaqsUseCase,
       _repository = repository;

  // State
  VHubStatus _status = VHubStatus.initial;
  List<IdeaEntity> _allIdeas = [];
  List<IdeaEntity> _filteredIdeas = [];
  List<FaqEntity> _faqs = [];
  IdeaEntity? _selectedIdea;
  String? _errorMessage;

  // Pagination
  int _currentPage = 1;
  bool _hasMoreData = true;
  final int _itemsPerPage = 10;

  // Filters
  String _selectedStatus = 'all';
  String _searchQuery = '';

  // Controllers
  final searchController = TextEditingController();
  Timer? _searchDebounce;

  // Getters
  VHubStatus get status => _status;
  List<IdeaEntity> get ideas => _filteredIdeas;
  List<FaqEntity> get faqs => _faqs;
  IdeaEntity? get selectedIdea => _selectedIdea;
  String? get errorMessage => _errorMessage;
  String get selectedStatus => _selectedStatus;
  bool get isLoading => _status == VHubStatus.loading;
  bool get isCreating => _status == VHubStatus.creating;
  bool get isDeleting => _status == VHubStatus.deleting;
  bool get hasError => _status == VHubStatus.error;
  bool get hasMoreData => _hasMoreData;

  @override
  void dispose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // Ideas Management
  Future<void> loadIdeas({bool forceRefresh = false}) async {
    if (_status == VHubStatus.loading) return;

    try {
      if (forceRefresh) {
        _currentPage = 1;
        _allIdeas.clear();
        _hasMoreData = true;
      }

      _setLoading();
      await _fetchIdeas();
    } catch (e) {
      dev.log('Error in loadIdeas: $e');
      _setError('Failed to load ideas. Please try again.');
    }
  }

  Future<void> loadMoreIdeas() async {
    if (!_hasMoreData || _status == VHubStatus.loading) return;

    try {
      _currentPage++;
      await _fetchIdeas(isLoadMore: true);
    } catch (e) {
      dev.log('Error in loadMoreIdeas: $e');
      _setError('Failed to load more ideas.');
    }
  }

  Future<void> _fetchIdeas({bool isLoadMore = false}) async {
    try {
      final result = await _getIdeasUseCase(
        status: _selectedStatus != 'all' ? _selectedStatus : null,
        page: _currentPage,
        limit: _itemsPerPage,
      );

      result.fold((failure) => _setError(_getErrorMessage(failure)), (ideas) {
        if (isLoadMore) {
          _allIdeas.addAll(ideas);
        } else {
          _allIdeas = ideas;
        }

        _hasMoreData = ideas.length >= _itemsPerPage;
        _applyFilters();
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error fetching ideas: $e');
      _setError('Failed to load ideas. Please try again.');
    }
  }

  void filterByStatus(String status) {
    if (_selectedStatus != status) {
      _selectedStatus = status;
      _currentPage = 1;
      _allIdeas.clear();
      _hasMoreData = true;
      loadIdeas();
    }
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredIdeas = _allIdeas.where((idea) {
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final projectName = idea.projectName.toLowerCase();
        final foundersNames = idea.founders
            .map((f) => f.name.toLowerCase())
            .join(' ');

        if (!projectName.contains(searchLower) &&
            !foundersNames.contains(searchLower)) {
          return false;
        }
      }
      return true;
    }).toList();

    // Sort by creation date (newest first)
    _filteredIdeas.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // Idea Details
  Future<void> loadIdeaDetails(String ideaId) async {
    try {
      _setLoading();
      final result = await _repository.getIdeaDetails(ideaId);

      result.fold((failure) => _setError(_getErrorMessage(failure)), (idea) {
        _selectedIdea = idea;
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error loading idea details: $e');
      _setError('Failed to load idea details. Please try again.');
    }
  }

  // Create/Update Idea
  Future<bool> createIdea(CreateIdeaParams params) async {
    try {
      _setCreating();

      // Validate params before sending
      if (!_validateCreateIdeaParams(params)) {
        _setError('Please fill in all required fields correctly.');
        return false;
      }

      final result = await _createIdeaUseCase(params);

      return result.fold(
        (failure) {
          _setError(_getErrorMessage(failure));
          return false;
        },
        (idea) {
          _allIdeas.insert(0, idea);
          _applyFilters();
          _setLoaded();
          dev.log('Idea created successfully: ${idea.id}');
          return true;
        },
      );
    } catch (e) {
      dev.log('Error creating idea: $e');
      _setError('Failed to create idea. Please try again.');
      return false;
    }
  }

  Future<bool> updateIdea(UpdateIdeaParams params) async {
    try {
      _setCreating();

      // Validate params before sending
      if (!_validateUpdateIdeaParams(params)) {
        _setError('Please fill in all required fields correctly.');
        return false;
      }

      final result = await _repository.updateIdea(params);

      return result.fold(
        (failure) {
          _setError(_getErrorMessage(failure));
          return false;
        },
        (idea) {
          final index = _allIdeas.indexWhere((i) => i.id == idea.id);
          if (index != -1) {
            _allIdeas[index] = idea;
            _applyFilters();
          }
          _selectedIdea = idea;
          _setLoaded();
          dev.log('Idea updated successfully: ${idea.id}');
          return true;
        },
      );
    } catch (e) {
      dev.log('Error updating idea: $e');
      _setError('Failed to update idea. Please try again.');
      return false;
    }
  }

  Future<bool> deleteIdea(String ideaId) async {
    try {
      _setDeleting();
      final result = await _repository.deleteIdea(ideaId);

      return result.fold(
        (failure) {
          _setError(_getErrorMessage(failure));
          return false;
        },
        (success) {
          _allIdeas.removeWhere((idea) => idea.id == ideaId);
          _applyFilters();
          _setLoaded();
          dev.log('Idea deleted successfully: $ideaId');
          return true;
        },
      );
    } catch (e) {
      dev.log('Error deleting idea: $e');
      _setError('Failed to delete idea. Please try again.');
      return false;
    }
  }

  // FAQ Management
  Future<void> loadFaqs({String? search, bool forceRefresh = false}) async {
    try {
      if (forceRefresh || _faqs.isEmpty) {
        _setLoading();
      }

      final result = await _getFaqsUseCase(search: search);

      result.fold((failure) => _setError(_getErrorMessage(failure)), (faqs) {
        _faqs = faqs;
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error loading FAQs: $e');
      _setError('Failed to load FAQs. Please try again.');
    }
  }

  // Validation Methods
  bool _validateCreateIdeaParams(CreateIdeaParams params) {
    if (params.projectName.trim().isEmpty) {
      dev.log('Validation failed: Project name is empty');
      return false;
    }

    if (params.founders.isEmpty) {
      dev.log('Validation failed: No founders provided');
      return false;
    }

    for (final founder in params.founders) {
      if (founder.name.trim().isEmpty ||
          founder.email.trim().isEmpty ||
          founder.contact.trim().isEmpty ||
          founder.affiliation.trim().isEmpty) {
        dev.log('Validation failed: Founder data incomplete');
        return false;
      }

      // Basic email validation
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(founder.email)) {
        dev.log('Validation failed: Invalid email format');
        return false;
      }
    }

    if (params.summaryOfIdea.trim().isEmpty ||
        params.longOfDevelopmentProgress.trim().isEmpty ||
        params.helpNeed.trim().isEmpty ||
        params.aboutProject.trim().isEmpty ||
        params.reasonForDoingProject.trim().isEmpty ||
        params.whoWillBuy.trim().isEmpty) {
      dev.log('Validation failed: Required fields are empty');
      return false;
    }

    if (params.foundersSignature.isEmpty) {
      dev.log('Validation failed: No signatures provided');
      return false;
    }

    for (final signature in params.foundersSignature) {
      if (signature.name.trim().isEmpty || signature.signature.trim().isEmpty) {
        dev.log('Validation failed: Signature data incomplete');
        return false;
      }
    }

    return true;
  }

  bool _validateUpdateIdeaParams(UpdateIdeaParams params) {
    if (params.id.trim().isEmpty) {
      dev.log('Validation failed: Idea ID is empty');
      return false;
    }

    return _validateCreateIdeaParams(params);
  }

  // State Management
  void _setLoading() {
    _status = VHubStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setCreating() {
    _status = VHubStatus.creating;
    _errorMessage = null;
    notifyListeners();
  }

  void _setDeleting() {
    _status = VHubStatus.deleting;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = VHubStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = VHubStatus.error;
    _errorMessage = message;
    dev.log('VHub provider error: $message');
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return 'Network error. Please check your connection.';
      case ServerFailure _:
        return failure.message;
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  void clearError() {
    _errorMessage = null;
    _status = VHubStatus.loaded;
    notifyListeners();
  }

  // Reset state
  void reset() {
    _status = VHubStatus.initial;
    _allIdeas.clear();
    _filteredIdeas.clear();
    _faqs.clear();
    _selectedIdea = null;
    _errorMessage = null;
    _currentPage = 1;
    _hasMoreData = true;
    _selectedStatus = 'all';
    _searchQuery = '';
    searchController.clear();
    notifyListeners();
  }
}
