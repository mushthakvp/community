import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

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

    if (forceRefresh) {
      _currentPage = 1;
      _allIdeas.clear();
      _hasMoreData = true;
    }

    _setLoading();
    await _fetchIdeas();
  }

  Future<void> loadMoreIdeas() async {
    if (!_hasMoreData || _status == VHubStatus.loading) return;

    _currentPage++;
    await _fetchIdeas(isLoadMore: true);
  }

  Future<void> _fetchIdeas({bool isLoadMore = false}) async {
    try {
      final result = await _getIdeasUseCase(
        status: _selectedStatus != 'all' ? _selectedStatus : null,
        page: _currentPage,
        limit: _itemsPerPage,
      );

      result.fold((failure) => _setError(failure.message), (ideas) {
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

      result.fold((failure) => _setError(failure.message), (idea) {
        _selectedIdea = idea;
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error loading idea details: $e');
      _setError('Failed to load idea details. Please try again.');
    }
  }

  // Create/Update Idea
  Future<void> createIdea(CreateIdeaParams params) async {
    try {
      _setCreating();
      final result = await _createIdeaUseCase(params);

      result.fold((failure) => _setError(failure.message), (idea) {
        _allIdeas.insert(0, idea);
        _applyFilters();
        _setLoaded();
        _showSuccessMessage('Idea submitted successfully!');
      });
    } catch (e) {
      dev.log('Error creating idea: $e');
      _setError('Failed to create idea. Please try again.');
    }
  }

  Future<void> updateIdea(UpdateIdeaParams params) async {
    try {
      _setCreating();
      final result = await _repository.updateIdea(params);

      result.fold((failure) => _setError(failure.message), (idea) {
        final index = _allIdeas.indexWhere((i) => i.id == idea.id);
        if (index != -1) {
          _allIdeas[index] = idea;
          _applyFilters();
        }
        _selectedIdea = idea;
        _setLoaded();
        _showSuccessMessage('Idea updated successfully!');
      });
    } catch (e) {
      dev.log('Error updating idea: $e');
      _setError('Failed to update idea. Please try again.');
    }
  }

  Future<void> deleteIdea(String ideaId) async {
    try {
      _setDeleting();
      final result = await _repository.deleteIdea(ideaId);

      result.fold((failure) => _setError(failure.message), (success) {
        _allIdeas.removeWhere((idea) => idea.id == ideaId);
        _applyFilters();
        _setLoaded();
        _showSuccessMessage('Idea deleted successfully!');
      });
    } catch (e) {
      dev.log('Error deleting idea: $e');
      _setError('Failed to delete idea. Please try again.');
    }
  }

  // FAQ Management
  Future<void> loadFaqs({String? search, bool forceRefresh = false}) async {
    try {
      if (forceRefresh || _faqs.isEmpty) {
        _setLoading();
      }

      final result = await _getFaqsUseCase(search: search);

      result.fold((failure) => _setError(failure.message), (faqs) {
        _faqs = faqs;
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error loading FAQs: $e');
      _setError('Failed to load FAQs. Please try again.');
    }
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

  void _showSuccessMessage(String message) {
    // This could be handled by a separate notification system
    dev.log('VHub success: $message');
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
