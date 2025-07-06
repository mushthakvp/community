import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/create_job_entity.dart';
import '../../domain/entities/job_title_entity.dart';
import '../../domain/usecases/create_job_title_usecase.dart';
import '../../domain/usecases/create_job_usecase.dart';
import '../../domain/usecases/get_job_titles_usecase.dart';
import '../../domain/usecases/update_job_usecase.dart';

enum CreateJobStatus { initial, loading, loaded, error, creating, created }

class CreateJobProvider extends ChangeNotifier {
  final GetJobTitlesUseCase _getJobTitlesUseCase;
  final CreateJobTitleUseCase _createJobTitleUseCase;
  final CreateJobUseCase _createJobUseCase;
  final UpdateJobUseCase _updateJobUseCase;

  CreateJobProvider({
    required GetJobTitlesUseCase getJobTitlesUseCase,
    required CreateJobTitleUseCase createJobTitleUseCase,
    required CreateJobUseCase createJobUseCase,
    required UpdateJobUseCase updateJobUseCase,
  }) : _getJobTitlesUseCase = getJobTitlesUseCase,
       _createJobTitleUseCase = createJobTitleUseCase,
       _createJobUseCase = createJobUseCase,
       _updateJobUseCase = updateJobUseCase;

  // State
  CreateJobStatus _status = CreateJobStatus.initial;
  List<JobTitleEntity> _jobTitles = [];
  String _errorMessage = '';
  int _currentTabIndex = 0;
  bool _isEditMode = false;

  // Form data
  String _selectedTitle = '';
  String _companyId = '';
  String _selectedState = '';
  String _selectedCity = '';
  String _selectedWorkStyle = '';
  String _selectedEducation = '';
  String _description = '';
  int _minimumSalary = 0;
  List<String> _selectedPositions = [];
  List<String> _selectedSchedule = [];
  List<String> _selectedBenefits = [];
  List<String> _selectedLanguages = [];
  List<String> _skills = [];
  List<String> _responsibilities = [];

  // Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController responsibilityController =
      TextEditingController();

  // Getters
  CreateJobStatus get status => _status;
  List<JobTitleEntity> get jobTitles => _jobTitles;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == CreateJobStatus.loading;
  bool get isCreating => _status == CreateJobStatus.creating;
  int get currentTabIndex => _currentTabIndex;
  bool get isEditMode => _isEditMode;

  String get selectedTitle => _selectedTitle;
  String get companyId => _companyId;
  String get selectedState => _selectedState;
  String get selectedCity => _selectedCity;
  String get selectedWorkStyle => _selectedWorkStyle;
  String get selectedEducation => _selectedEducation;
  String get description => _description;
  int get minimumSalary => _minimumSalary;
  List<String> get selectedPositions => _selectedPositions;
  List<String> get selectedSchedule => _selectedSchedule;
  List<String> get selectedBenefits => _selectedBenefits;
  List<String> get selectedLanguages => _selectedLanguages;
  List<String> get skills => _skills;
  List<String> get responsibilities => _responsibilities;

  // Static data
  static const List<String> positions = [
    'Full Time',
    'Permanent',
    'Fresher',
    'Internship',
    'Temporary',
    'Freelance',
    'Volunteer',
  ];

  static const List<String> schedules = [
    'Day Shift',
    'Morning Shift',
    'Night Shift',
    'Rotational shift',
    'Evening Shift',
    'Weekend Availability',
    'Fixed Shift',
    'Weekend only',
    'UK Shift',
    'Other',
  ];

  static const List<String> benefits = [
    'Health insurance',
    'Provident Fund',
    'Cell phone reimbursement',
    'Paid sick time',
    'Work from home',
    'Paid time off',
    'Food Provided',
    'Life Insurance',
    'Internet reimbursement',
    'Commuter assistance',
    'Leave encasement',
    'Flexible schedule',
    'Other',
  ];

  static const List<String> languages = [
    'English',
    'Malayalam',
    'Kannada',
    'Tamil',
    'Hindi',
    'Marathi',
    'Telugu',
  ];

  static const List<String> workStyles = ['Onsite', 'Hybrid', 'Work from Home'];

  static const List<String> educationLevels = [
    'Bachelors Degree',
    'Post Graduation',
    '+2',
    'SSLC',
    'Any',
  ];

  // Methods
  Future<void> getJobTitles() async {
    _status = CreateJobStatus.loading;
    notifyListeners();

    final result = await _getJobTitlesUseCase(NoParams());
    result.fold(
      (failure) {
        _status = CreateJobStatus.error;
        _errorMessage = _getFailureMessage(failure);
      },
      (titles) {
        _status = CreateJobStatus.loaded;
        _jobTitles = titles;
        if (titles.isNotEmpty && _selectedTitle.isEmpty) {
          setTitle(titles.first.name);
        }
      },
    );
    notifyListeners();
  }

  Future<bool> createJobTitle(String title) async {
    if (title.trim().isEmpty) return false;

    // Check if title already exists
    if (_jobTitles.any((t) => t.name.toLowerCase() == title.toLowerCase())) {
      _errorMessage = 'Title already exists';
      return false;
    }

    final result = await _createJobTitleUseCase(
      CreateJobTitleParams(title: title),
    );
    return result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        return false;
      },
      (success) {
        if (success) {
          getJobTitles(); // Refresh titles
        }
        return success;
      },
    );
  }

  Future<bool> createJob() async {
    if (!_validateForm()) return false;

    _status = CreateJobStatus.creating;
    notifyListeners();

    final job = CreateJobEntity(
      title: _selectedTitle,
      companyId: _companyId,
      state: _selectedState,
      city: _selectedCity,
      workStyle: _selectedWorkStyle,
      description: _description,
      position: _selectedPositions,
      schedule: _selectedSchedule,
      benefits: _selectedBenefits,
      minimumSalary: _minimumSalary,
      education: _selectedEducation,
      skills: _skills,
      languages: _selectedLanguages,
      responsibilities: _responsibilities,
    );

    final result = _isEditMode
        ? await _updateJobUseCase(UpdateJobParams(job: job))
        : await _createJobUseCase(CreateJobParams(job: job));

    return result.fold(
      (failure) {
        _status = CreateJobStatus.error;
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
        return false;
      },
      (success) {
        _status = CreateJobStatus.created;
        notifyListeners();
        return success;
      },
    );
  }

  // Form setters
  void setTitle(String title) {
    _selectedTitle = title;
    titleController.text = title;
    notifyListeners();
  }

  void setCompanyId(String id) {
    _companyId = id;
    notifyListeners();
  }

  void setLocation(String state, String city) {
    _selectedState = state;
    _selectedCity = city;
    notifyListeners();
  }

  void setWorkStyle(String workStyle) {
    _selectedWorkStyle = workStyle;
    notifyListeners();
  }

  void setEducation(String education) {
    _selectedEducation = education;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    descriptionController.text = description;
    notifyListeners();
  }

  void setSalary(int salary) {
    _minimumSalary = salary;
    salaryController.text = salary.toString();
    notifyListeners();
  }

  void togglePosition(String position) {
    if (_selectedPositions.contains(position)) {
      _selectedPositions.remove(position);
    } else {
      _selectedPositions.add(position);
    }
    notifyListeners();
  }

  void toggleSchedule(String schedule) {
    if (_selectedSchedule.contains(schedule)) {
      _selectedSchedule.remove(schedule);
    } else {
      _selectedSchedule.add(schedule);
    }
    notifyListeners();
  }

  void toggleBenefit(String benefit) {
    if (_selectedBenefits.contains(benefit)) {
      _selectedBenefits.remove(benefit);
    } else {
      _selectedBenefits.add(benefit);
    }
    notifyListeners();
  }

  void toggleLanguage(String language) {
    if (_selectedLanguages.contains(language)) {
      _selectedLanguages.remove(language);
    } else {
      _selectedLanguages.add(language);
    }
    notifyListeners();
  }

  void addSkill(String skill) {
    if (skill.trim().isNotEmpty && !_skills.contains(skill.trim())) {
      _skills.add(skill.trim());
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _skills.remove(skill);
    notifyListeners();
  }

  void addResponsibility() {
    final text = responsibilityController.text.trim();
    if (text.isNotEmpty && !_responsibilities.contains(text)) {
      _responsibilities.add(text);
      responsibilityController.clear();
      notifyListeners();
    }
  }

  void removeResponsibility(String responsibility) {
    _responsibilities.remove(responsibility);
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void setEditMode(bool isEdit) {
    _isEditMode = isEdit;
    notifyListeners();
  }

  void populateForEdit(CreateJobEntity job) {
    _isEditMode = true;
    _selectedTitle = job.title;
    _companyId = job.companyId;
    _selectedState = job.state;
    _selectedCity = job.city;
    _selectedWorkStyle = job.workStyle;
    _selectedEducation = job.education;
    _description = job.description;
    _minimumSalary = job.minimumSalary;
    _selectedPositions = List.from(job.position);
    _selectedSchedule = List.from(job.schedule);
    _selectedBenefits = List.from(job.benefits);
    _selectedLanguages = List.from(job.languages);
    _skills = List.from(job.skills);
    _responsibilities = List.from(job.responsibilities);

    // Update controllers
    titleController.text = job.title;
    descriptionController.text = job.description;
    salaryController.text = job.minimumSalary.toString();

    notifyListeners();
  }

  void clearForm() {
    _selectedTitle = '';
    _companyId = '';
    _selectedState = '';
    _selectedCity = '';
    _selectedWorkStyle = '';
    _selectedEducation = '';
    _description = '';
    _minimumSalary = 0;
    _selectedPositions.clear();
    _selectedSchedule.clear();
    _selectedBenefits.clear();
    _selectedLanguages.clear();
    _skills.clear();
    _responsibilities.clear();
    _currentTabIndex = 0;
    _isEditMode = false;

    // Clear controllers
    titleController.clear();
    descriptionController.clear();
    salaryController.clear();
    responsibilityController.clear();

    notifyListeners();
  }

  bool _validateForm() {
    if (_selectedTitle.isEmpty) {
      _errorMessage = 'Title is required';
      return false;
    }
    if (_companyId.isEmpty) {
      _errorMessage = 'Company is required';
      return false;
    }
    if (_selectedWorkStyle.isEmpty) {
      _errorMessage = 'Work style is required';
      return false;
    }
    if (_selectedEducation.isEmpty) {
      _errorMessage = 'Education requirement is required';
      return false;
    }
    if (_description.trim().split(' ').length < 50) {
      _errorMessage = 'Description must be at least 50 words';
      return false;
    }
    if (_selectedPositions.isEmpty) {
      _errorMessage = 'Select at least one position';
      return false;
    }
    if (_selectedSchedule.isEmpty) {
      _errorMessage = 'Select at least one schedule';
      return false;
    }
    if (_selectedBenefits.isEmpty) {
      _errorMessage = 'Select at least one benefit';
      return false;
    }
    if (_selectedLanguages.isEmpty) {
      _errorMessage = 'Select at least one language';
      return false;
    }
    return true;
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error occurred';
      case NetworkFailure _:
        return 'No internet connection';
      case CacheFailure _:
        return 'Cache error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    salaryController.dispose();
    responsibilityController.dispose();
    super.dispose();
  }
}
