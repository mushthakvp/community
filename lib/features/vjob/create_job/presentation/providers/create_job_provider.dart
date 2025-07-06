import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../domain/entities/company_selection_entity.dart';
import '../../domain/entities/create_job_entity.dart';
import '../../domain/entities/job_title_entity.dart';
import '../../domain/entities/job_validation_entity.dart';
import '../../domain/usecases/create_job_title_usecase.dart';
import '../../domain/usecases/create_job_usecase.dart';
import '../../domain/usecases/get_companies_usecase.dart';
import '../../domain/usecases/get_job_titles_usecase.dart';
import '../../domain/usecases/update_job_usecase.dart';
import '../../domain/usecases/validate_job_usecase.dart';

enum CreateJobStatus { initial, loading, success, error }

class CreateJobProvider extends ChangeNotifier {
  final CreateJobUseCase _createJobUseCase;
  final UpdateJobUseCase _updateJobUseCase;
  final GetJobTitlesUseCase _getJobTitlesUseCase;
  final CreateJobTitleUseCase _createJobTitleUseCase;
  final GetCompaniesUseCase _getCompaniesUseCase;
  final ValidateJobUseCase _validateJobUseCase;

  CreateJobProvider({
    required CreateJobUseCase createJobUseCase,
    required UpdateJobUseCase updateJobUseCase,
    required GetJobTitlesUseCase getJobTitlesUseCase,
    required CreateJobTitleUseCase createJobTitleUseCase,
    required GetCompaniesUseCase getCompaniesUseCase,
    required ValidateJobUseCase validateJobUseCase,
  }) : _createJobUseCase = createJobUseCase,
       _updateJobUseCase = updateJobUseCase,
       _getJobTitlesUseCase = getJobTitlesUseCase,
       _createJobTitleUseCase = createJobTitleUseCase,
       _getCompaniesUseCase = getCompaniesUseCase,
       _validateJobUseCase = validateJobUseCase;

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final minimumSalaryController = TextEditingController();
  final responsibilityController = TextEditingController();
  final skillController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // State
  CreateJobStatus _status = CreateJobStatus.initial;
  String? _errorMessage;
  String? _successMessage;
  int _currentStep = 0;
  bool _isUpdate = false;
  String? _jobIdForUpdate;

  // Job Data
  String _selectedCompanyId = '';
  String _selectedTitle = '';
  String _selectedState = '';
  String _selectedCity = '';
  String _selectedWorkStyle = '';
  String _selectedEducation = '';

  List<String> _selectedPositions = [];
  List<String> _selectedSchedule = [];
  List<String> _selectedBenefits = [];
  List<String> _selectedLanguages = [];
  List<String> _skills = [];
  List<String> _responsibilities = [];

  // Options
  List<JobTitleEntity> _jobTitles = [];
  List<CompanySelectionEntity> _companies = [];

  // Validation
  JobValidationEntity? _validation;

  // Pre-defined options
  final List<String> _workStyleOptions = ['Onsite', 'Hybrid', 'Work from Home'];
  final List<String> _educationOptions = [
    'Bachelors Degree',
    'Post Graduation',
    '+2',
    'SSLC',
    'Any',
  ];
  final List<String> _positionOptions = [
    'Full Time',
    'Permanent',
    'Fresher',
    'Internship',
    'Temporary',
    'Freelance',
    'Volunteer',
  ];
  final List<String> _scheduleOptions = [
    'Day Shift',
    'Morning Shift',
    'Night Shift',
    'Rotational shift',
    'Evening Shift',
    'Weekend Availability',
    'Fixed Shift',
    'Weekend only',
    'Uk Shift',
    'Other',
  ];
  final List<String> _benefitsOptions = [
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
  final List<String> _languageOptions = [
    'English',
    'Malayalam',
    'Kannada',
    'Tamil',
    'Hindi',
    'Marathi',
    'Telugu',
  ];

  // Getters
  CreateJobStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  int get currentStep => _currentStep;
  bool get isUpdate => _isUpdate;
  bool get isLoading => _status == CreateJobStatus.loading;

  String get selectedCompanyId => _selectedCompanyId;
  String get selectedTitle => _selectedTitle;
  String get selectedState => _selectedState;
  String get selectedCity => _selectedCity;
  String get selectedWorkStyle => _selectedWorkStyle;
  String get selectedEducation => _selectedEducation;

  List<String> get selectedPositions => _selectedPositions;
  List<String> get selectedSchedule => _selectedSchedule;
  List<String> get selectedBenefits => _selectedBenefits;
  List<String> get selectedLanguages => _selectedLanguages;
  List<String> get skills => _skills;
  List<String> get responsibilities => _responsibilities;

  List<JobTitleEntity> get jobTitles => _jobTitles;
  List<CompanySelectionEntity> get companies => _companies;
  JobValidationEntity? get validation => _validation;

  List<String> get workStyleOptions => _workStyleOptions;
  List<String> get educationOptions => _educationOptions;
  List<String> get positionOptions => _positionOptions;
  List<String> get scheduleOptions => _scheduleOptions;
  List<String> get benefitsOptions => _benefitsOptions;
  List<String> get languageOptions => _languageOptions;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    minimumSalaryController.dispose();
    responsibilityController.dispose();
    skillController.dispose();
    super.dispose();
  }

  // Public Methods
  Future<void> initialize() async {
    await loadJobTitles();
    await loadCompanies();
  }

  Future<void> loadJobTitles() async {
    try {
      final result = await _getJobTitlesUseCase();
      result.fold(
        (failure) => dev.log('Failed to load job titles: ${failure.message}'),
        (titles) {
          _jobTitles = titles;
          if (titles.isNotEmpty && _selectedTitle.isEmpty) {
            _selectedTitle = titles.first.name;
            titleController.text = _selectedTitle;
          }
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading job titles: $e');
    }
  }

  Future<void> loadCompanies() async {
    try {
      final result = await _getCompaniesUseCase();
      result.fold(
        (failure) => dev.log('Failed to load companies: ${failure.message}'),
        (companies) {
          _companies = companies;
          if (companies.isNotEmpty && _selectedCompanyId.isEmpty) {
            _selectedCompanyId = companies.first.id;
          }
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading companies: $e');
    }
  }

  Future<void> createJobTitle(String title) async {
    try {
      final result = await _createJobTitleUseCase(title);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _showSuccess('Job title created successfully');
          loadJobTitles(); // Refresh job titles
        }
      });
    } catch (e) {
      dev.log('Error creating job title: $e');
      _showError('Failed to create job title');
    }
  }

  void setJobTitle(String title) {
    _selectedTitle = title;
    titleController.text = title;
    notifyListeners();
  }

  void setCompanyId(String companyId) {
    _selectedCompanyId = companyId;
    notifyListeners();
  }

  void setLocation({String? state, String? city}) {
    if (state != null) _selectedState = state;
    if (city != null) _selectedCity = city;
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
      skillController.clear();
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _skills.remove(skill);
    notifyListeners();
  }

  void addResponsibility() {
    final responsibility = responsibilityController.text.trim();
    if (responsibility.isNotEmpty &&
        !_responsibilities.contains(responsibility)) {
      _responsibilities.add(responsibility);
      responsibilityController.clear();
      notifyListeners();
    }
  }

  void removeResponsibility(String responsibility) {
    _responsibilities.remove(responsibility);
    notifyListeners();
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void validateCurrentJob() {
    final job = _createJobEntity();
    final result = _validateJobUseCase(job);

    result.fold(
      (failure) => _validation = null,
      (validation) => _validation = validation,
    );

    notifyListeners();
  }

  Future<void> submitJob() async {
    if (!_validateForm()) return;

    _setLoading();

    try {
      final job = _createJobEntity();

      if (_isUpdate && _jobIdForUpdate != null) {
        final result = await _updateJobUseCase(
          jobId: _jobIdForUpdate!,
          job: job,
        );

        result.fold((failure) => _setError(failure.userFriendlyMessage), (
          success,
        ) {
          if (success) {
            _setSuccess('Job updated successfully');
            clearForm();
          }
        });
      } else {
        final result = await _createJobUseCase(job);

        result.fold((failure) => _setError(failure.userFriendlyMessage), (
          success,
        ) {
          if (success) {
            _setSuccess('Job created successfully');
            clearForm();
          }
        });
      }
    } catch (e) {
      dev.log('Error submitting job: $e');
      _setError('An unexpected error occurred');
    }
  }

  void setUpdateMode({required String jobId, required CreateJobEntity job}) {
    _isUpdate = true;
    _jobIdForUpdate = jobId;

    // Populate form with existing data
    _selectedCompanyId = job.companyId;
    _selectedTitle = job.title;
    _selectedState = job.state;
    _selectedCity = job.city;
    _selectedWorkStyle = job.workStyle;
    _selectedEducation = job.education;
    _selectedPositions = List.from(job.position);
    _selectedSchedule = List.from(job.schedule);
    _selectedBenefits = List.from(job.benefits);
    _selectedLanguages = List.from(job.languages);
    _skills = List.from(job.skills);
    _responsibilities = List.from(job.responsibilities);

    titleController.text = job.title;
    descriptionController.text = job.description;
    minimumSalaryController.text = job.minimumSalary.toString();

    notifyListeners();
  }

  void clearForm() {
    _isUpdate = false;
    _jobIdForUpdate = null;
    _currentStep = 0;

    _selectedCompanyId = _companies.isNotEmpty ? _companies.first.id : '';
    _selectedTitle = _jobTitles.isNotEmpty ? _jobTitles.first.name : '';
    _selectedState = '';
    _selectedCity = '';
    _selectedWorkStyle = '';
    _selectedEducation = '';

    _selectedPositions.clear();
    _selectedSchedule.clear();
    _selectedBenefits.clear();
    _selectedLanguages.clear();
    _skills.clear();
    _responsibilities.clear();

    titleController.clear();
    descriptionController.clear();
    minimumSalaryController.clear();
    responsibilityController.clear();
    skillController.clear();

    _validation = null;
    _status = CreateJobStatus.initial;
    _errorMessage = null;
    _successMessage = null;

    notifyListeners();
  }

  // Private Methods
  CreateJobEntity _createJobEntity() {
    return CreateJobEntity(
      companyId: _selectedCompanyId,
      title: _selectedTitle,
      state: _selectedState,
      city: _selectedCity,
      workStyle: _selectedWorkStyle,
      description: descriptionController.text.trim(),
      position: _selectedPositions,
      schedule: _selectedSchedule,
      benefits: _selectedBenefits,
      minimumSalary: int.tryParse(minimumSalaryController.text) ?? 0,
      education: _selectedEducation,
      skills: _skills,
      languages: _selectedLanguages,
      responsibilities: _responsibilities,
    );
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final job = _createJobEntity();
    final validation = JobValidationEntity.fromJob(job);

    if (!validation.isValid) {
      _setError(validation.errors.first);
      return false;
    }

    return true;
  }

  void _setLoading() {
    _status = CreateJobStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String message) {
    _status = CreateJobStatus.success;
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = CreateJobStatus.error;
    _errorMessage = message;
    _successMessage = null;
    dev.log('Create job provider error: $message');
    notifyListeners();
  }

  void _showError(String message) {
    _errorMessage = message;
    notifyListeners();

    // Clear error after some time
    Timer(const Duration(seconds: 3), () {
      if (_errorMessage == message) {
        _errorMessage = null;
        notifyListeners();
      }
    });
  }

  void _showSuccess(String message) {
    _successMessage = message;
    notifyListeners();

    // Clear success message after some time
    Timer(const Duration(seconds: 3), () {
      if (_successMessage == message) {
        _successMessage = null;
        notifyListeners();
      }
    });
  }

  // Form validation methods
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Job title is required';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Job description is required';
    }
    if (value.trim().split(' ').length < 50) {
      return 'Description must be at least 50 words';
    }
    return null;
  }

  String? validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Minimum salary is required';
    }
    final salary = int.tryParse(value);
    if (salary == null || salary <= 0) {
      return 'Please enter a valid salary amount';
    }
    return null;
  }
}
